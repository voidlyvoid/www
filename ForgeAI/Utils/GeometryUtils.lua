--[[
	GeometryUtils - Geometry and spatial calculations
	Used by layout engine and pathfinding for collision detection and placement
]]

local GeometryUtils = {}

--[[
	Check if two axis-aligned bounding boxes overlap
]]
function GeometryUtils.checkAABBOverlap(box1, box2)
	-- box format: {min = Vector3, max = Vector3}
	return not (
		box1.max.X < box2.min.X or box1.min.X > box2.max.X or
		box1.max.Y < box2.min.Y or box1.min.Y > box2.max.Y or
		box1.max.Z < box2.min.Z or box1.min.Z > box2.max.Z
	)
end

--[[
	Get AABB for a part
]]
function GeometryUtils.getAABB(part)
	local size = part.Size
	local pos = part.Position
	local halfSize = size / 2
	
	return {
		min = pos - halfSize,
		max = pos + halfSize
	}
end

--[[
	Check if a point is inside a box
]]
function GeometryUtils.pointInBox(point, box)
	return point.X >= box.min.X and point.X <= box.max.X and
	       point.Y >= box.min.Y and point.Y <= box.max.Y and
	       point.Z >= box.min.Z and point.Z <= box.max.Z
end

--[[
	Calculate distance between two points
]]
function GeometryUtils.distance(p1, p2)
	local diff = p2 - p1
	return diff.Magnitude
end

--[[
	Calculate distance between two positions on XZ plane (ground)
]]
function GeometryUtils.horizontalDistance(p1, p2)
	local dx = p2.X - p1.X
	local dz = p2.Z - p1.Z
	return math.sqrt(dx * dx + dz * dz)
end

--[[
	Check if two spheres overlap
]]
function GeometryUtils.checkSphereOverlap(sphere1, sphere2)
	-- sphere format: {center = Vector3, radius = number}
	local dist = GeometryUtils.distance(sphere1.center, sphere2.center)
	return dist < (sphere1.radius + sphere2.radius)
end

--[[
	Find closest point on line segment to a given point
]]
function GeometryUtils.closestPointOnSegment(p, a, b)
	local ap = p - a
	local ab = b - a
	local abLengthSq = ab:Dot(ab)
	
	if abLengthSq == 0 then return a end
	
	local t = math.max(0, math.min(1, ap:Dot(ab) / abLengthSq))
	return a + (ab * t)
end

--[[
	Raycast from position in direction
	Simple grid-based collision check
]]
function GeometryUtils.raycast(origin, direction, maxDistance, ignoreList)
	ignoreList = ignoreList or {}
	
	local ray = Ray.new(origin, direction * maxDistance)
	local result = workspace:FindPartOnRay(ray, ignoreList)
	
	if result then
		local hitPoint = ray.Origin + ray.Direction.Unit * (result.Position - ray.Origin).Magnitude
		return {
			hit = true,
			part = result,
			position = hitPoint,
			distance = (hitPoint - origin).Magnitude
		}
	end
	
	return {
		hit = false,
		part = nil,
		position = origin + direction * maxDistance,
		distance = maxDistance
	}
end

--[[
	Generate grid points within a region
]]
function GeometryUtils.generateGridPoints(center, width, depth, spacing)
	local points = {}
	
	local startX = center.X - width / 2
	local startZ = center.Z - depth / 2
	
	for x = 0, width, spacing do
		for z = 0, depth, spacing do
			table.insert(points, {
				position = Vector3.new(startX + x, center.Y, startZ + z),
				gridX = x / spacing,
				gridZ = z / spacing
			})
		end
	end
	
	return points
end

--[[
	Calculate perpendicular distance from point to infinite line
]]
function GeometryUtils.pointToLineDistance(point, lineStart, lineEnd)
	local ap = point - lineStart
	local ab = lineEnd - lineStart
	local abLengthSq = ab:Dot(ab)
	
	if abLengthSq == 0 then
		return (point - lineStart).Magnitude
	end
	
	local t = ap:Dot(ab) / abLengthSq
	local closestPoint = lineStart + ab * t
	return (point - closestPoint).Magnitude
end

--[[
	Get random point within sphere
]]
function GeometryUtils.randomPointInSphere(center, radius)
	local randomAngle = math.rad(math.random(0, 360))
	local randomPitch = math.rad(math.random(-90, 90))
	local randomRadius = radius * math.pow(math.random(), 1/3)
	
	local x = randomRadius * math.cos(randomPitch) * math.cos(randomAngle)
	local y = randomRadius * math.sin(randomPitch)
	local z = randomRadius * math.cos(randomPitch) * math.sin(randomAngle)
	
	return center + Vector3.new(x, y, z)
end

--[[
	Find a clear ground position near a point
]]
function GeometryUtils.findGroundPosition(position, searchRadius, maxAttempts)
	searchRadius = searchRadius or 20
	maxAttempts = maxAttempts or 20
	
	for attempt = 1, maxAttempts do
		local testPos = GeometryUtils.randomPointInSphere(position, searchRadius)
		testPos = Vector3.new(testPos.X, position.Y, testPos.Z)
		
		-- Raycast down to find ground
		local ray = Ray.new(testPos + Vector3.new(0, 100, 0), Vector3.new(0, -1, 0) * 200)
		local hitPart = workspace:FindPartOnRay(ray)
		
		if hitPart and not hitPart:IsDescendantOf(workspace.Camera) then
			return testPos + Vector3.new(0, 5, 0) -- 5 studs above ground
		end
	end
	
	return position
end

return GeometryUtils
