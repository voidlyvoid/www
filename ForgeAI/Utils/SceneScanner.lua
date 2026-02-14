--[[
	SceneScanner - Analyzes workspace structure, hierarchy, and properties
	Fast, cached scene analysis with minimal performance impact
]]

local SceneScanner = {}
local Validator = require(script.Parent.Validator)

-- Cache for scene analysis (invalidated on changes)
local scanCache = {}
local cacheTimeout = 5 -- seconds

--[[
	Scan entire workspace and return analysis
]]
function SceneScanner.scanWorkspace()
	local cacheKey = "workspace_scan"
	local cached = scanCache[cacheKey]
	
	if cached and (tick() - cached.timestamp) < cacheTimeout then
		return cached.data
	end
	
	local analysis = {
		timestamp = tick(),
		totalParts = 0,
		totalModels = 0,
		totalGroups = 0,
		maxDepth = 0,
		materials = {},
		themes = {},
		potentialZones = {}
	}
	
	-- Scan using BFS to track depth and hierarchy
	local queue = {{workspace, 1}}
	local partsByLevel = {}
	
	for i = 1, 50 do
		partsByLevel[i] = 0
	end
	
	while #queue > 0 do
		local current, depth = queue[1][1], queue[1][2]
		table.remove(queue, 1)
		
		if depth > analysis.maxDepth then
			analysis.maxDepth = depth
		end
		
		if current:IsA("BasePart") then
			analysis.totalParts += 1
			partsByLevel[depth] = partsByLevel[depth] + 1
			
			-- Track materials
			local material = tostring(current.Material)
			analysis.materials[material] = (analysis.materials[material] or 0) + 1
		elseif current:IsA("Model") then
			analysis.totalModels += 1
		elseif current:IsA("Folder") then
			analysis.totalGroups += 1
			
			-- Detect potential zones by folder naming
			local name = current.Name:lower()
			if name:find("zone") or name:find("area") or name:find("region") then
				table.insert(analysis.potentialZones, current)
			end
		end
		
		-- Add children to queue
		for _, child in ipairs(current:GetChildren()) do
			table.insert(queue, {child, depth + 1})
		end
	end
	
	-- Cache result
	scanCache[cacheKey] = {
		data = analysis,
		timestamp = tick()
	}
	
	return analysis
end

--[[
	Scan a specific region for materials and themes
]]
function SceneScanner.scanRegionTheme(region)
	Validator.assertInWorkspace(region, "region")
	
	local theme = {
		dominantColors = {},
		materials = {},
		lighting = {
			brightness = workspace.Lighting.Brightness,
			ambient = workspace.Lighting.Ambient,
			outdoorAmbient = workspace.Lighting.OutdoorAmbient
		},
		assetTypes = {},
		style = "unknown"
	}
	
	-- Scan descendants for materials and colors
	local descendants = region:GetDescendants()
	local colorSamples = {}
	
	for _, object in ipairs(descendants) do
		if object:IsA("BasePart") then
			-- Track material
			local material = tostring(object.Material)
			theme.materials[material] = (theme.materials[material] or 0) + 1
			
			-- Sample colors
			if object:IsA("Part") or object:IsA("MeshPart") then
				table.insert(colorSamples, object.Color)
			end
		end
	end
	
	-- Classify style based on materials
	theme.style = SceneScanner.classifyTheme(theme.materials)
	
	return theme
end

--[[
	Classify a theme based on material composition
]]
function SceneScanner.classifyTheme(materials)
	local function getMaterial(name, weight)
		return (materials[name] or 0) * (weight or 1)
	end
	
	-- Material scoring
	local urban = getMaterial("Concrete") + getMaterial("Brick") + getMaterial("Metal")
	local nature = getMaterial("Grass") + getMaterial("LeafyGrass") + getMaterial("Wood") * 2
	local tech = getMaterial("Metal") * 2 + getMaterial("Neon") * 3
	local fantasy = getMaterial("Rock") + getMaterial("Ice") + getMaterial("Neon") * 2
	
	if tech > 50 then return "technological"
	elseif urban > 50 then return "urban"
	elseif nature > 50 then return "natural"
	elseif fantasy > 30 then return "fantasy"
	else return "mixed"
	end
end

--[[
	Find all walkable surfaces in a region
]]
function SceneScanner.findWalkableSurfaces(region)
	Validator.assertInWorkspace(region, "region")
	
	local walkableSurfaces = {}
	local descendants = region:GetDescendants()
	
	for _, object in ipairs(descendants) do
		if object:IsA("BasePart") then
			-- Consider parts with certain properties as walkable
			if object.CanCollide and object.Size.Y < 1 then
				table.insert(walkableSurfaces, object)
			end
		end
	end
	
	return walkableSurfaces
end

--[[
	Find structural elements (walls, floors, etc.)
]]
function SceneScanner.findStructural(region)
	Validator.assertInWorkspace(region, "region")
	
	local structural = {
		walls = {},
		floors = {},
		ceilings = {},
		supports = {}
	}
	
	local descendants = region:GetDescendants()
	
	for _, object in ipairs(descendants) do
		if object:IsA("BasePart") then
			local size = object.Size
			
			-- Classify by dimensions
			if size.X > size.Z and size.Y < 5 then
				table.insert(structural.walls, object)
			elseif size.Y < 1 and (size.X > 5 or size.Z > 5) then
				table.insert(structural.floors, object)
			elseif size.Y > 10 and size.X < 2 and size.Z < 2 then
				table.insert(structural.supports, object)
			end
		end
	end
	
	return structural
end

--[[
	Clear cache (call when workspace changes)
]]
function SceneScanner.invalidateCache()
	scanCache = {}
end

return SceneScanner
