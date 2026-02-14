--[[
	Metrics - Measurement and analysis utilities for ForgeAI
	Tracks performance metrics, object counts, and system health
]]

local Metrics = {}

-- Constants
local METRIC_TYPES = {
	PART_COUNT = "part_count",
	MESH_DENSITY = "mesh_density",
	LIGHTING_COST = "lighting_cost",
	PHYSICS_LOAD = "physics_load",
	MEMORY_USAGE = "memory_usage",
	PARTICLE_OVERDRAW = "particle_overdraw"
}

--[[
	Analyze all parts in a region and return metrics
]]
function Metrics.analyzeRegion(region)
	local metrics = {
		partCount = 0,
		meshPartCount = 0,
		partTypes = {},
		totalSize = Vector3.new(),
		lightingCost = 0,
		physicsLoad = 0,
		particleCount = 0,
		timestamp = tick()
	}
	
	if not region or not region:IsDescendantOf(workspace) then
		return metrics
	end
	
	local descendants = region:GetDescendants()
	
	for _, object in ipairs(descendants) do
		if object:IsA("BasePart") then
			metrics.partCount += 1
			
			-- Track mesh parts separately
			if object:IsA("MeshPart") then
				metrics.meshPartCount += 1
			end
			
			-- Track part types
			local className = object.ClassName
			metrics.partTypes[className] = (metrics.partTypes[className] or 0) + 1
			
			-- Accumulate size
			metrics.totalSize = metrics.totalSize + object.Size
			
			-- Calculate physics load (simple estimation)
			if object.CanCollide and not object.CanQuery == false then
				metrics.physicsLoad += object.Size.X * object.Size.Y * object.Size.Z
			end
			
			-- Lighting cost (if CanCastShadow)
			if object.CanCastShadow then
				metrics.lightingCost += 1
			end
		elseif object:IsA("ParticleEmitter") then
			metrics.particleCount += 1
		end
	end
	
	-- Calculate complexity score
	metrics.complexityScore = Metrics.calculateComplexity(metrics)
	metrics.performanceRisk = Metrics.calculatePerformanceRisk(metrics)
	
	return metrics
end

--[[
	Calculate a complexity score based on metrics (0-100)
]]
function Metrics.calculateComplexity(metrics)
	local score = 0
	
	-- Part count factor (0-40 points)
	local partRatio = math.min(metrics.partCount / 10000, 1)
	score += partRatio * 40
	
	-- Mesh density factor (0-30 points)
	local meshRatio = metrics.meshPartCount / math.max(metrics.partCount, 1)
	score += meshRatio * 30
	
	-- Physics load factor (0-20 points)
	local physicsRatio = math.min(metrics.physicsLoad / 100000, 1)
	score += physicsRatio * 20
	
	-- Lighting cost factor (0-10 points)
	local lightingRatio = math.min(metrics.lightingCost / 500, 1)
	score += lightingRatio * 10
	
	return math.floor(score)
end

--[[
	Calculate performance risk level
	Returns: "low", "medium", "high", "critical"
]]
function Metrics.calculatePerformanceRisk(metrics)
	local complexity = metrics.complexityScore or 0
	
	if complexity >= 85 then
		return "critical"
	elseif complexity >= 70 then
		return "high"
	elseif complexity >= 50 then
		return "medium"
	else
		return "low"
	end
end

--[[
	Estimate mobile vs PC impact
]]
function Metrics.estimateDeviceImpact(metrics)
	return {
		mobile = {
			impact = "high",
			recommendation = "Consider reducing part count and mesh complexity"
		},
		pc = {
			impact = "medium",
			recommendation = "Monitor physics load and particle count"
		}
	}
end

--[[
	Get detailed breakdown of metric types
]]
function Metrics.getBreakdown(metrics)
	return {
		partTypes = metrics.partTypes,
		meshDensity = (metrics.meshPartCount / math.max(metrics.partCount, 1)) * 100,
		averagePartSize = metrics.totalSize / math.max(metrics.partCount, 1),
		lightingShadowCasters = metrics.lightingCost,
		particleEmitters = metrics.particleCount
	}
end

return Metrics
