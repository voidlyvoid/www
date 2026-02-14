--[[
	PerformanceAnalyzer - Analyzes and optimizes scene performance
	Core responsibility: Identify bottlenecks, scan metrics, provide recommendations
]]

local PerformanceAnalyzer = {}
local Metrics = require(script.Parent.Parent.Utils.Metrics)
local Validator = require(script.Parent.Parent.Utils.Validator)
local SceneScanner = require(script.Parent.Parent.Utils.SceneScanner)

--[[
	Comprehensive scene performance analysis
]]
function PerformanceAnalyzer.analyzeScene(region)
	Validator.assertInWorkspace(region, "region")
	
	local analysis = {
		timestamp = tick(),
		region = region,
		metrics = {},
		bottlenecks = {},
		recommendations = {},
		deviceImpact = {}
	}
	
	-- Gather metrics
	analysis.metrics = Metrics.analyzeRegion(region)
	
	-- Identify bottlenecks
	analysis.bottlenecks = PerformanceAnalyzer.identifyBottlenecks(analysis.metrics)
	
	-- Generate recommendations
	analysis.recommendations = PerformanceAnalyzer.generateRecommendations(analysis.metrics, analysis.bottlenecks)
	
	-- Assess device impact
	analysis.deviceImpact = Metrics.estimateDeviceImpact(analysis.metrics)
	
	return analysis
end

--[[
	Identify specific performance bottlenecks
]]
function PerformanceAnalyzer.identifyBottlenecks(metrics)
	local bottlenecks = {}
	
	-- High part count
	if metrics.partCount > 5000 then
		table.insert(bottlenecks, {
			type = "high_part_count",
			severity = "high",
			value = metrics.partCount,
			message = "Scene contains " .. metrics.partCount .. " parts. Consider merging or using LOD."
		})
	end
	
	-- High mesh density
	local meshRatio = metrics.meshPartCount / math.max(metrics.partCount, 1)
	if meshRatio > 0.7 then
		table.insert(bottlenecks, {
			type = "high_mesh_density",
			severity = "medium",
			value = meshRatio,
			message = "High proportion of mesh parts. Consider converting some to primitives."
		})
	end
	
	-- High lighting cost
	if metrics.lightingCost > 500 then
		table.insert(bottlenecks, {
			type = "high_lighting_cost",
			severity = "medium",
			value = metrics.lightingCost,
			message = metrics.lightingCost .. " shadow-casting objects. Consider disabling CanCastShadow on non-critical parts."
		})
	end
	
	-- High physics load
	if metrics.physicsLoad > 100000 then
		table.insert(bottlenecks, {
			type = "high_physics_load",
			severity = "high",
			value = metrics.physicsLoad,
			message = "High physics load detected. Consider using CanCollide = false where possible."
		})
	end
	
	-- Particle overdraw
	if metrics.particleCount > 100 then
		table.insert(bottlenecks, {
			type = "particle_overdraw",
			severity = "medium",
			value = metrics.particleCount,
			message = "Many particle emitters. Reduce rate or lifetime for performance."
		})
	end
	
	return bottlenecks
end

--[[
	Generate optimization recommendations
]]
function PerformanceAnalyzer.generateRecommendations(metrics, bottlenecks)
	local recommendations = {}
	
	for _, bottleneck in ipairs(bottlenecks) do
		if bottleneck.type == "high_part_count" then
			table.insert(recommendations, {
				priority = "high",
				action = "Use LayoutEngine to optimize part distribution",
				expectedImprovement = "10-30% FPS improvement"
			})
			table.insert(recommendations, {
				priority = "high",
				action = "Consider using Level-of-Detail (LOD) systems",
				expectedImprovement = "20-40% FPS improvement in distance"
			})
		elseif bottleneck.type == "high_mesh_density" then
			table.insert(recommendations, {
				priority = "medium",
				action = "Use OptimizationEngine to convert meshes to primitives where possible",
				expectedImprovement = "15-25% FPS improvement"
			})
		elseif bottleneck.type == "high_lighting_cost" then
			table.insert(recommendations, {
				priority = "medium",
				action = "Use OptimizationEngine to disable CanCastShadow on non-critical parts",
				expectedImprovement = "10-20% FPS improvement"
			})
		elseif bottleneck.type == "high_physics_load" then
			table.insert(recommendations, {
				priority = "high",
				action = "Use OptimizationEngine to disable physics on decorative parts",
				expectedImprovement = "25-50% FPS improvement"
			})
		elseif bottleneck.type == "particle_overdraw" then
			table.insert(recommendations, {
				priority = "medium",
				action = "Reduce particle emitter emission rates and lifetimes",
				expectedImprovement = "10-15% FPS improvement"
			})
		end
	end
	
	return recommendations
end

--[[
	Get simple performance score (0-100)
]]
function PerformanceAnalyzer.getPerformanceScore(metrics)
	local complexity = metrics.complexityScore or 0
	return math.max(0, 100 - complexity)
end

--[[
	Compare two regions' performance
]]
function PerformanceAnalyzer.compareRegions(region1, region2)
	local metrics1 = Metrics.analyzeRegion(region1)
	local metrics2 = Metrics.analyzeRegion(region2)
	
	return {
		region1 = {
			metrics = metrics1,
			score = PerformanceAnalyzer.getPerformanceScore(metrics1)
		},
		region2 = {
			metrics = metrics2,
			score = PerformanceAnalyzer.getPerformanceScore(metrics2)
		},
		difference = math.abs(
			PerformanceAnalyzer.getPerformanceScore(metrics1) -
			PerformanceAnalyzer.getPerformanceScore(metrics2)
		)
	}
end

return PerformanceAnalyzer
