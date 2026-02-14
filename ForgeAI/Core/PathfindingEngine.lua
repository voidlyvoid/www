--[[
	PathfindingEngine - Generates NPC paths, patrol routes, and walkable areas
	Core responsibility: Route generation, coverage calculation, interaction zones
]]

local PathfindingEngine = {}
local Validator = require(script.Parent.Parent.Utils.Validator)
local GeometryUtils = require(script.Parent.Parent.Utils.GeometryUtils)
local SceneScanner = require(script.Parent.Parent.Utils.SceneScanner)

--[[
	Generate patrol path for NPCs in a region
]]
function PathfindingEngine.generatePatrolPath(region, config)
	Validator.assertInWorkspace(region, "region")
	
	config = config or {
		pathType = "loop",
		waypoints = 5,
		smoothing = true
	}
	
	local path = {
		region = region,
		waypoints = {},
		segments = {},
		totalLength = 0,
		metadata = {}
	}
	
	-- Find walkable surfaces
	local walkableSurfaces = SceneScanner.findWalkableSurfaces(region)
	
	if #walkableSurfaces == 0 then
		-- Generate waypoints on ground level
		path.waypoints = PathfindingEngine.generateGroundWaypoints(region, config.waypoints)
	else
		-- Generate waypoints along walkable surfaces
		path.waypoints = PathfindingEngine.generateWalkableWaypoints(walkableSurfaces, config.waypoints)
	end
	
	-- Connect waypoints into segments
	if config.pathType == "loop" then
		path.segments = PathfindingEngine.createLoopPath(path.waypoints)
	elseif config.pathType == "linear" then
		path.segments = PathfindingEngine.createLinearPath(path.waypoints)
	end
	
	-- Calculate path statistics
	for _, segment in ipairs(path.segments) do
		path.totalLength += GeometryUtils.distance(segment.from, segment.to)
	end
	
	return path
end

--[[
	Generate waypoints on ground level
]]
function PathfindingEngine.generateGroundWaypoints(region, count)
	local waypoints = {}
	local bounds = region:FindFirstChild("Humanoid") and region or region
	local size = bounds:IsA("BasePart") and bounds.Size or Vector3.new(100, 1, 100)
	local position = bounds:IsA("BasePart") and bounds.Position or region.Position
	
	for i = 1, count do
		local angle = (i / count) * math.pi * 2
		local radius = (size.X + size.Z) / 4
		
		local x = position.X + math.cos(angle) * radius
		local z = position.Z + math.sin(angle) * radius
		
		-- Find ground height at this position
		local groundPos = GeometryUtils.findGroundPosition(Vector3.new(x, position.Y + 50, z), 10, 5)
		
		table.insert(waypoints, {
			position = groundPos,
			index = i,
			type = "ground"
		})
	end
	
	return waypoints
end

--[[
	Generate waypoints along walkable surfaces
]]
function PathfindingEngine.generateWalkableWaypoints(surfaces, count)
	local waypoints = {}
	
	-- Distribute waypoints across walkable surfaces
	local surfacesPerWaypoint = math.ceil(#surfaces / count)
	
	for i = 1, count do
		local surfaceIndex = ((i - 1) * surfacesPerWaypoint) % #surfaces + 1
		local surface = surfaces[surfaceIndex]
		
		-- Random point on surface
		local offsetX = (math.random() - 0.5) * surface.Size.X
		local offsetZ = (math.random() - 0.5) * surface.Size.Z
		
		table.insert(waypoints, {
			position = surface.Position + Vector3.new(offsetX, surface.Size.Y / 2 + 2, offsetZ),
			surface = surface,
			index = i,
			type = "walkable"
		})
	end
	
	return waypoints
end

--[[
	Create loop path connecting waypoints
]]
function PathfindingEngine.createLoopPath(waypoints)
	local segments = {}
	
	for i = 1, #waypoints do
		local currentWaypoint = waypoints[i]
		local nextWaypoint = waypoints[(i % #waypoints) + 1]
		
		table.insert(segments, {
			from = currentWaypoint.position,
			to = nextWaypoint.position,
			fromIndex = i,
			toIndex = (i % #waypoints) + 1,
			type = "loop",
			distance = GeometryUtils.distance(currentWaypoint.position, nextWaypoint.position)
		})
	end
	
	return segments
end

--[[
	Create linear path connecting waypoints
]]
function PathfindingEngine.createLinearPath(waypoints)
	local segments = {}
	
	for i = 1, #waypoints - 1 do
		local currentWaypoint = waypoints[i]
		local nextWaypoint = waypoints[i + 1]
		
		table.insert(segments, {
			from = currentWaypoint.position,
			to = nextWaypoint.position,
			fromIndex = i,
			toIndex = i + 1,
			type = "linear",
			distance = GeometryUtils.distance(currentWaypoint.position, nextWaypoint.position)
		})
	end
	
	return segments
end

--[[
	Find cover and hide points in a region
]]
function PathfindingEngine.findCoverPoints(region, config)
	Validator.assertInWorkspace(region, "region")
	
	config = config or {
		minHeight = 3,
		minWidth = 2,
		maxDistance = 50
	}
	
	local coverPoints = {}
	local descendants = region:GetDescendants()
	
	for _, object in ipairs(descendants) do
		if object:IsA("BasePart") then
			local size = object.Size
			
			-- Identify potential cover objects
			if size.Y >= config.minHeight and size.X >= config.minWidth then
				table.insert(coverPoints, {
					position = object.Position,
					object = object,
					size = size,
					effectiveness = (size.X * size.Y) / 100 -- Simple effectiveness metric
				})
			end
		end
	end
	
	-- Sort by effectiveness
	table.sort(coverPoints, function(a, b)
		return a.effectiveness > b.effectiveness
	end)
	
	return coverPoints
end

--[[
	Calculate region coverage for patrol paths
]]
function PathfindingEngine.calculateCoverage(path, region)
	local coverage = {
		path = path,
		region = region,
		totalArea = 0,
		coveredArea = 0,
		coveragePercent = 0,
		coverage_radius = 10 -- Distance from path that's considered covered
	}
	
	-- Estimate total area
	if region:IsA("BasePart") then
		coverage.totalArea = region.Size.X * region.Size.Z
	else
		local bounds = region:FindFirstChild("PrimaryPart") or region:FindFirstChildOfClass("BasePart")
		if bounds then
			coverage.totalArea = bounds.Size.X * bounds.Size.Z
		end
	end
	
	-- Estimate covered area from path
	local pathCoverage = 0
	for _, segment in ipairs(path.segments) do
		pathCoverage += segment.distance * (coverage.coverage_radius * 2)
	end
	
	coverage.coveredArea = math.min(pathCoverage, coverage.totalArea)
	coverage.coveragePercent = (coverage.coveredArea / math.max(coverage.totalArea, 1)) * 100
	
	return coverage
end

--[[
	Generate interaction zones (where NPCs should stop)
]]
function PathfindingEngine.generateInteractionZones(region, count)
	Validator.assertInWorkspace(region, "region")
	
	local zones = {}
	
	-- Find prominent features/objects to interact with
	local descendants = region:GetDescendants()
	local features = {}
	
	for _, object in ipairs(descendants) do
		if object:IsA("BasePart") and object:FindFirstChild("InteractPoint") then
			table.insert(features, object)
		end
	end
	
	-- If not enough features, create zones near large objects
	if #features < count then
		for _, object in ipairs(descendants) do
			if object:IsA("BasePart") and object.Size.Magnitude > 10 then
				table.insert(features, object)
				if #features >= count then break end
			end
		end
	end
	
	-- Create interaction zones
	for i = 1, math.min(#features, count) do
		local feature = features[i]
		local offset = Vector3.new(
			(math.random() - 0.5) * 10,
			0,
			(math.random() - 0.5) * 10
		)
		
		table.insert(zones, {
			id = i,
			position = feature.Position + offset,
			targetObject = feature,
			type = "interaction",
			duration = 2 + math.random() * 3 -- 2-5 seconds
		})
	end
	
	return zones
end

return PathfindingEngine
