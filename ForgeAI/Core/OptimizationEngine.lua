--[[
	OptimizationEngine - Applies automatic and manual performance optimizations
	Core responsibility: Mesh merging, shadow pruning, LOD suggestions, physics optimization
]]

local OptimizationEngine = {}
local Validator = require(script.Parent.Parent.Utils.Validator)
local UndoManager = require(script.Parent.Parent.Utils.UndoManager)

--[[
	Apply comprehensive optimization to a region
]]
function OptimizationEngine.optimizeRegion(region, config)
	Validator.assertInWorkspace(region, "region")
	
	config = config or {}
	local defaultConfig = {
		mergeStaticParts = true,
		disableShadows = true,
		disablePhysics = false,
		convertToUnions = false,
		dryRun = true
	}
	
	-- Merge user config with defaults
	for key, value in pairs(defaultConfig) do
		if config[key] == nil then
			config[key] = value
		end
	end
	
	local results = {
		timestamp = tick(),
		config = config,
		actions = {},
		estimated_improvement = 0
	}
	
	-- Start undo operation
	UndoManager.beginOperation("Optimize Region: " .. region.Name)
	
	-- Apply optimizations
	if config.disableShadows then
		local shadowCount = OptimizationEngine.disableShadows(region, config.dryRun)
		table.insert(results.actions, {
			type = "disable_shadows",
			count = shadowCount,
			estimated_improvement = shadowCount * 0.02
		})
		results.estimated_improvement += shadowCount * 0.02
	end
	
	if config.disablePhysics then
		local physicsCount = OptimizationEngine.disablePhysics(region, config.dryRun)
		table.insert(results.actions, {
			type = "disable_physics",
			count = physicsCount,
			estimated_improvement = physicsCount * 0.05
		})
		results.estimated_improvement += physicsCount * 0.05
	end
	
	if config.mergeStaticParts then
		local mergeCount = OptimizationEngine.mergeParts(region, config.dryRun)
		table.insert(results.actions, {
			type = "merge_parts",
			count = mergeCount,
			estimated_improvement = math.min(0.3, mergeCount * 0.01)
		})
		results.estimated_improvement += math.min(0.3, mergeCount * 0.01)
	end
	
	-- End undo operation
	UndoManager.endOperation()
	
	return results
end

--[[
	Disable CanCastShadow on non-critical parts
]]
function OptimizationEngine.disableShadows(region, dryRun)
	local count = 0
	local descendants = region:GetDescendants()
	
	for _, object in ipairs(descendants) do
		if object:IsA("BasePart") and object.CanCastShadow then
			-- Don't remove shadows from certain parts (signage, special effects, etc.)
			local name = object.Name:lower()
			if not name:find("light") and not name:find("glow") and not name:find("effect") then
				if not dryRun then
					UndoManager.recordModified(object, "CanCastShadow", true, false)
					object.CanCastShadow = false
				end
				count += 1
			end
		end
	end
	
	return count
end

--[[
	Disable CanCollide and CanQuery on decorative parts
]]
function OptimizationEngine.disablePhysics(region, dryRun)
	local count = 0
	local descendants = region:GetDescendants()
	
	for _, object in ipairs(descendants) do
		if object:IsA("BasePart") then
			local name = object.Name:lower()
			local isDecorative = name:find("decor") or name:find("prop") or name:find("deco")
			
			if isDecorative and object.CanCollide then
				if not dryRun then
					UndoManager.recordModified(object, "CanCollide", true, false)
					object.CanCollide = false
				end
				count += 1
			end
		end
	end
	
	return count
end

--[[
	Merge adjacent static parts (simple implementation)
]]
function OptimizationEngine.mergeParts(region, dryRun)
	-- This is a simplified version; full implementation would use unions
	local count = 0
	local merged = {}
	local descendants = region:GetDescendants()
	
	for _, object in ipairs(descendants) do
		if object:IsA("Part") and not object:IsA("MeshPart") and object.CanCollide then
			-- Skip if already processed
			if not merged[object] then
				-- Find adjacent parts to merge
				local adjacent = OptimizationEngine.findAdjacentParts(object, descendants)
				
				if #adjacent > 0 then
					if not dryRun then
						-- In practice, would create Union3 and delete parts
						-- Simplified: just mark as processed
						for _, part in ipairs(adjacent) do
							merged[part] = true
						end
					end
					count += 1
				end
			end
		end
	end
	
	return count
end

--[[
	Find parts adjacent to a given part (for merging)
]]
function OptimizationEngine.findAdjacentParts(part, candidates)
	local adjacent = {}
	local partAABB = {
		min = part.Position - part.Size / 2,
		max = part.Position + part.Size / 2
	}
	
	for _, candidate in ipairs(candidates) do
		if candidate ~= part and candidate:IsA("Part") then
			local candidateAABB = {
				min = candidate.Position - candidate.Size / 2,
				max = candidate.Position + candidate.Size / 2
			}
			
			-- Check if touching (within 0.1 stud tolerance)
			local tolerance = 0.1
			local touching = not (
				partAABB.max.X + tolerance < candidateAABB.min.X or
				partAABB.min.X - tolerance > candidateAABB.max.X or
				partAABB.max.Y + tolerance < candidateAABB.min.Y or
				partAABB.min.Y - tolerance > candidateAABB.max.Y or
				partAABB.max.Z + tolerance < candidateAABB.min.Z or
				partAABB.min.Z - tolerance > candidateAABB.max.Z
			)
			
			if touching then
				table.insert(adjacent, candidate)
			end
		end
	end
	
	return adjacent
end

--[[
	Generate LOD (Level of Detail) suggestions
]]
function OptimizationEngine.generateLODSuggestions(region)
	Validator.assertInWorkspace(region, "region")
	
	local suggestions = {
		close = {
			range = "0-50 studs",
			recommendations = {
				"Full detail meshes",
				"All shadows enabled",
				"Full physics simulation"
			}
		},
		medium = {
			range = "50-200 studs",
			recommendations = {
				"Medium detail meshes",
				"Selective shadows",
				"Simplified physics"
			}
		},
		far = {
			range = "200+ studs",
			recommendations = {
				"Low poly meshes or primitives",
				"Shadows disabled",
				"Physics disabled or kinematic"
			}
		}
	}
	
	return suggestions
end

--[[
	Suggest mesh conversions
]]
function OptimizationEngine.suggestMeshConversions(region)
	Validator.assertInWorkspace(region, "region")
	
	local suggestions = {
		candidates = {},
		totalPotentialSavings = 0
	}
	
	local descendants = region:GetDescendants()
	
	for _, object in ipairs(descendants) do
		if object:IsA("MeshPart") then
			-- Estimate size savings
			local meshSize = object.Size
			local volume = meshSize.X * meshSize.Y * meshSize.Z
			local estimatedMemory = volume * 0.05 -- rough estimate
			
			table.insert(suggestions.candidates, {
				part = object,
				type = "MeshPart",
				estimatedSavings = estimatedMemory,
				suggestion = "Consider converting to primitive shape: " .. 
					(object.Size.Y > object.Size.X and object.Size.Y > object.Size.Z and "Pillar" or "Block")
			})
			
			suggestions.totalPotentialSavings += estimatedMemory
		end
	end
	
	return suggestions
end

return OptimizationEngine
