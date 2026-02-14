--[[
	LayoutEngine - Procedural layout and structure generation
	Core responsibility: Grid generation, organic layouts, collision-aware placement, semantic zones
]]

local LayoutEngine = {}
local Validator = require(script.Parent.Parent.Utils.Validator)
local GeometryUtils = require(script.Parent.Parent.Utils.GeometryUtils)
local UndoManager = require(script.Parent.Parent.Utils.UndoManager)

--[[
	Generate a structured layout based on specification
]]
function LayoutEngine.generateLayout(spec)
	Validator.assertTableKeys(spec, {"center", "width", "depth", "type"}, "spec")
	
	local layout = {
		timestamp = tick(),
		specification = spec,
		zones = {},
		paths = {},
		placedObjects = {}
	}
	
	-- Start undo operation
	UndoManager.beginOperation("Generate Layout: " .. spec.type)
	
	-- Generate based on type
	if spec.type == "grid" then
		layout.zones = LayoutEngine.generateGridLayout(spec)
	elseif spec.type == "organic" then
		layout.zones = LayoutEngine.generateOrganicLayout(spec)
	elseif spec.type == "modular" then
		layout.zones = LayoutEngine.generateModularLayout(spec)
	end
	
	-- Generate connecting paths
	layout.paths = LayoutEngine.generatePaths(layout.zones, spec.center)
	
	-- End undo operation
	UndoManager.endOperation()
	
	return layout
end

--[[
	Generate grid-based layout
]]
function LayoutEngine.generateGridLayout(spec)
	local zones = {}
	
	-- Calculate grid dimensions
	local spacing = spec.spacing or 50
	local rows = math.ceil(spec.depth / spacing)
	local cols = math.ceil(spec.width / spacing)
	
	-- Generate grid cells
	for row = 0, rows - 1 do
		for col = 0, cols - 1 do
			local zoneCenter = spec.center + Vector3.new(
				(col * spacing) - (spec.width / 2) + (spacing / 2),
				0,
				(row * spacing) - (spec.depth / 2) + (spacing / 2)
			)
			
			table.insert(zones, {
				id = row * cols + col,
				center = zoneCenter,
				size = Vector3.new(spacing - 2, 0, spacing - 2),
				type = "grid_cell",
				purposes = {"market", "residential", "industrial"}[((row + col) % 3) + 1],
				density = spec.density or 0.5
			})
		end
	end
	
	return zones
end

--[[
	Generate organic (natural) layout
]]
function LayoutEngine.generateOrganicLayout(spec)
	local zones = {}
	local density = spec.density or 0.5
	local maxZones = math.ceil((spec.width * spec.depth) / 2500 * density)
	
	-- Generate random but spatially coherent zones
	for i = 1, maxZones do
		-- Use Perlin-like noise for coherent randomness
		local angle = (i / maxZones) * math.pi * 2
		local distance = (i / maxZones) ^ 0.5 * math.sqrt(spec.width ^ 2 + spec.depth ^ 2) / 2
		
		local offset = Vector3.new(
			math.cos(angle) * distance,
			0,
			math.sin(angle) * distance
		)
		
		local zoneSize = 30 + (i % 20)
		
		table.insert(zones, {
			id = i,
			center = spec.center + offset,
			size = Vector3.new(zoneSize, 0, zoneSize),
			type = "organic_zone",
			purposes = {"nature", "marketplace", "settlement"}[((i % 3) + 1)],
			density = density
		})
	end
	
	return zones
end

--[[
	Generate modular (building block) layout
]]
function LayoutEngine.generateModularLayout(spec)
	local zones = {}
	
	local moduleSize = spec.moduleSize or 40
	local rows = math.ceil(spec.depth / moduleSize)
	local cols = math.ceil(spec.width / moduleSize)
	
	for row = 0, rows - 1 do
		for col = 0, cols - 1 do
			-- Skip some modules for variety
			if (row + col) % 3 ~= 0 or math.random() > 0.3 then
				local moduleCenter = spec.center + Vector3.new(
					(col * moduleSize) - (spec.width / 2) + (moduleSize / 2),
					0,
					(row * moduleSize) - (spec.depth / 2) + (moduleSize / 2)
				)
				
				table.insert(zones, {
					id = row * cols + col,
					center = moduleCenter,
					size = Vector3.new(moduleSize - 2, 0, moduleSize - 2),
					type = "module",
					purposes = {"building", "plaza", "garden"}[((row * col + row + col) % 3) + 1],
					density = spec.density or 0.6
				})
			end
		end
	end
	
	return zones
end

--[[
	Generate connecting paths between zones
]]
function LayoutEngine.generatePaths(zones, center)
	local paths = {}
	
	if #zones == 0 then return paths end
	
	-- Create paths between adjacent zones (simple MST-like approach)
	local visited = {}
	local toVisit = {zones[1]}
	
	while #toVisit > 0 do
		local current = toVisit[1]
		table.remove(toVisit, 1)
		
		if not visited[current.id] then
			visited[current.id] = true
			
			-- Find nearest unvisited zone
			local nearest = nil
			local minDist = math.huge
			
			for _, zone in ipairs(zones) do
				if not visited[zone.id] then
					local dist = GeometryUtils.distance(current.center, zone.center)
					if dist < minDist then
						minDist = dist
						nearest = zone
					end
				end
			end
			
			if nearest then
				table.insert(paths, {
					from = current.center,
					to = nearest.center,
					width = 8,
					type = "main_path"
				})
				table.insert(toVisit, nearest)
			end
		end
	end
	
	return paths
end

--[[
	Place objects within layout with collision awareness
]]
function LayoutEngine.placeObjectsInLayout(layout, spec)
	spec = spec or {}
	local results = {
		placed = 0,
		failed = 0,
		objects = {}
	}
	
	for _, zone in ipairs(layout.zones) do
		-- Calculate objects to place in this zone
		local count = math.ceil(zone.density * (zone.size.X * zone.size.Z) / 100)
		
		for i = 1, count do
			-- Try to find valid placement position
			local maxAttempts = 5
			local placed = false
			
			for attempt = 1, maxAttempts do
				-- Random position within zone
				local offsetX = (math.random() - 0.5) * zone.size.X
				local offsetZ = (math.random() - 0.5) * zone.size.Z
				
				local position = zone.center + Vector3.new(offsetX, 0, offsetZ)
				
				-- Check collision with existing objects
				local collision = false
				local minDist = 5 -- Minimum distance between objects
				
				for _, existingObj in ipairs(results.objects) do
					if GeometryUtils.distance(position, existingObj.position) < minDist then
						collision = true
						break
					end
				end
				
				if not collision then
					table.insert(results.objects, {
						position = position,
						zone = zone.id,
						type = zone.purposes,
						size = Vector3.new(math.random(3, 8), math.random(5, 15), math.random(3, 8))
					})
					results.placed += 1
					placed = true
					break
				end
			end
			
			if not placed then
				results.failed += 1
			end
		end
	end
	
	return results
end

--[[
	Classify zones by semantic purpose
]]
function LayoutEngine.classifyZones(zones)
	local classified = {
		markets = {},
		residential = {},
		industrial = {},
		nature = {},
		plazas = {}
	}
	
	for _, zone in ipairs(zones) do
		local purpose = zone.purposes
		
		if purpose == "market" or purpose == "marketplace" then
			table.insert(classified.markets, zone)
		elseif purpose == "residential" then
			table.insert(classified.residential, zone)
		elseif purpose == "industrial" then
			table.insert(classified.industrial, zone)
		elseif purpose == "nature" then
			table.insert(classified.nature, zone)
		elseif purpose == "plaza" then
			table.insert(classified.plazas, zone)
		end
	end
	
	return classified
end

--[[
	Get deterministic seed for reproducible generation
]]
function LayoutEngine.setSeed(seed)
	math.randomseed(seed or tick())
end

return LayoutEngine
