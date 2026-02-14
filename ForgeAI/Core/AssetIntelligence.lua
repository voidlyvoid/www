--[[
	AssetIntelligence - Intelligent asset placement and analysis
	Core responsibility: Zone classification, context-aware placement, performance budgeting
]]

local AssetIntelligence = {}
local Validator = require(script.Parent.Parent.Utils.Validator)
local SceneScanner = require(script.Parent.Parent.Utils.SceneScanner)
local GeometryUtils = require(script.Parent.Parent.Utils.GeometryUtils)

--[[
	Analyze a region and suggest asset placement
]]
function AssetIntelligence.analyzePlacementOpportunities(region)
	Validator.assertInWorkspace(region, "region")
	
	local analysis = {
		timestamp = tick(),
		region = region,
		zones = {},
		opportunities = {},
		recommendations = {}
	}
	
	-- Scan for structural elements
	local structural = SceneScanner.findStructural(region)
	
	-- Identify open areas
	analysis.zones = AssetIntelligence.identifyZones(region, structural)
	
	-- Find placement opportunities
	analysis.opportunities = AssetIntelligence.findPlacementOpportunities(analysis.zones)
	
	-- Generate recommendations
	analysis.recommendations = AssetIntelligence.generatePlacementRecommendations(analysis.opportunities)
	
	return analysis
end

--[[
	Identify distinct zones in a region
]]
function AssetIntelligence.identifyZones(region, structural)
	local zones = {}
	
	-- Create zones based on structural layout
	if structural.floors and #structural.floors > 0 then
		for i, floor in ipairs(structural.floors) do
			local zoneSize = floor.Size
			table.insert(zones, {
				id = "floor_" .. i,
				position = floor.Position,
				size = zoneSize,
				type = "floor_zone",
				capacity = math.floor((zoneSize.X * zoneSize.Z) / 100),
				walkable = true
			})
		end
	end
	
	-- Create zones around walls (for wall-adjacent assets)
	if structural.walls and #structural.walls > 0 then
		for i, wall in ipairs(structural.walls) do
			local zoneSize = wall.Size
			table.insert(zones, {
				id = "wall_" .. i,
				position = wall.Position,
				size = zoneSize,
				type = "wall_zone",
				capacity = math.floor(zoneSize.Y / 5), -- Wall-mounted items
				walkable = false
			})
		end
	end
	
	return zones
end

--[[
	Find specific placement opportunities in zones
]]
function AssetIntelligence.findPlacementOpportunities(zones)
	local opportunities = {}
	local performanceBudget = {
		total = 500, -- Total parts we can afford
		used = 0
	}
	
	for _, zone in ipairs(zones) do
		if zone.walkable then
			-- Floor-based placements
			local floorOpportunities = {
				{
					type = "decoration",
					count = math.floor(zone.capacity * 0.3),
					budget = 1,
					spacing = 5
				},
				{
					type = "furniture",
					count = math.floor(zone.capacity * 0.15),
					budget = 2,
					spacing = 10
				},
				{
					type = "light_source",
					count = math.floor(zone.capacity * 0.1),
					budget = 1,
					spacing = 15
				}
			}
			
			for _, opp in ipairs(floorOpportunities) do
				if performanceBudget.used + (opp.count * opp.budget) <= performanceBudget.total then
					table.insert(opportunities, {
						zone = zone.id,
						type = opp.type,
						count = opp.count,
						position = zone.position,
						budget = opp.count * opp.budget
					})
					performanceBudget.used += opp.count * opp.budget
				end
			end
		else
			-- Wall-based placements
			local wallOpportunities = {
				{
					type = "wall_decor",
					count = zone.capacity,
					budget = 1,
					spacing = 3
				}
			}
			
			for _, opp in ipairs(wallOpportunities) do
				if performanceBudget.used + (opp.count * opp.budget) <= performanceBudget.total then
					table.insert(opportunities, {
						zone = zone.id,
						type = opp.type,
						count = opp.count,
						position = zone.position,
						budget = opp.count * opp.budget
					})
					performanceBudget.used += opp.count * opp.budget
				end
			end
		end
	end
	
	return opportunities
end

--[[
	Generate placement recommendations
]]
function AssetIntelligence.generatePlacementRecommendations(opportunities)
	local recommendations = {}
	
	local typeCount = {}
	for _, opp in ipairs(opportunities) do
		typeCount[opp.type] = (typeCount[opp.type] or 0) + opp.count
	end
	
	for assetType, count in pairs(typeCount) do
		table.insert(recommendations, {
			type = assetType,
			quantity = count,
			priority = "medium",
			reason = "Identified " .. count .. " placement opportunities for " .. assetType
		})
	end
	
	return recommendations
end

--[[
	Calculate performance budget for a region
]]
function AssetIntelligence.calculatePerformanceBudget(region, targetFPS)
	targetFPS = targetFPS or 60
	
	local budget = {
		maxParts = 5000,
		maxMeshDensity = 0.5,
		maxLightingCost = 500,
		maxPhysicsLoad = 100000,
		maxParticles = 50
	}
	
	-- Adjust based on target FPS
	if targetFPS < 30 then
		budget.maxParts = 2000
		budget.maxMeshDensity = 0.3
	elseif targetFPS < 60 then
		budget.maxParts = 3500
		budget.maxMeshDensity = 0.4
	end
	
	return budget
end

--[[
	Suggest asset types for a zone
]]
function AssetIntelligence.suggestAssetsForZone(zone, theme)
	local suggestions = {}
	
	theme = theme or "neutral"
	
	local assetLibrary = {
		urban = {
			decoration = {"lamp", "bench", "trash_can", "sign"},
			furniture = {"table", "chair", "desk"},
			structure = {"wall", "railing", "door"}
		},
		nature = {
			decoration = {"tree", "bush", "rock", "grass"},
			furniture = {"log_seat", "picnic_table"},
			structure = {"fence", "bridge"}
		},
		industrial = {
			decoration = {"barrel", "crate", "pipe", "bolt"},
			furniture = {"machinery", "control_panel"},
			structure = {"metal_beam", "industrial_door"}
		}
	}
	
	local themeAssets = assetLibrary[theme] or assetLibrary.neutral
	
	for assetCategory, assetList in pairs(themeAssets) do
		table.insert(suggestions, {
			category = assetCategory,
			assets = assetList,
			recommended = true
		})
	end
	
	return suggestions
end

--[[
	Plan asset distribution across zone
]]
function AssetIntelligence.planDistribution(zone, assetCount, spacingRule)
	spacingRule = spacingRule or "even"
	
	local distribution = {
		zone = zone.id,
		totalAssets = assetCount,
		positions = {},
		spacing = {}
	}
	
	if spacingRule == "even" then
		-- Distribute evenly across zone
		local cols = math.ceil(math.sqrt(assetCount))
		local rows = math.ceil(assetCount / cols)
		local cellWidth = zone.size.X / cols
		local cellDepth = zone.size.Z / rows
		
		local index = 1
		for row = 0, rows - 1 do
			for col = 0, cols - 1 do
				if index <= assetCount then
					local x = zone.position.X - (zone.size.X / 2) + (col * cellWidth) + (cellWidth / 2)
					local z = zone.position.Z - (zone.size.Z / 2) + (row * cellDepth) + (cellDepth / 2)
					
					table.insert(distribution.positions, Vector3.new(x, zone.position.Y, z))
					index += 1
				end
			end
		end
	elseif spacingRule == "random" then
		-- Random distribution with minimum spacing
		local minDistance = zone.size.X / 10
		for i = 1, assetCount do
			local pos = GeometryUtils.randomPointInSphere(zone.position, math.min(zone.size.X, zone.size.Z) / 2)
			table.insert(distribution.positions, pos)
		end
	end
	
	return distribution
end

return AssetIntelligence
