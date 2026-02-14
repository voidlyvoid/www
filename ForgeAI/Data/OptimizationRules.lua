--[[
	OptimizationRules.lua
	Optimization rule sets and performance budgets
	Used by the optimization engine for intelligent optimization
]]

local OptimizationRules = {
	-- Performance budgets per region
	budgets = {
		mobile = {
			name = "Mobile",
			maxParts = 1000,
			maxMeshParts = 200,
			maxParticles = 50,
			maxLights = 5,
			targetFramerate = 30,
		},
		standard = {
			name = "Standard PC",
			maxParts = 5000,
			maxMeshParts = 1000,
			maxParticles = 200,
			maxLights = 20,
			targetFramerate = 60,
		},
		highEnd = {
			name = "High-End PC",
			maxParts = 20000,
			maxMeshParts = 5000,
			maxParticles = 500,
			maxLights = 50,
			targetFramerate = 120,
		},
	},

	-- Shadow optimization rules
	shadows = {
		aggressive = {
			name = "Aggressive Shadow Removal",
			disableDynamicShadows = true,
			disableStaticShadows = false,
			maxShadowDistance = 50,
			castShadow = function(part)
				return part.Name:lower():find("building") or part.Name:lower():find("structure")
			end,
		},
		balanced = {
			name = "Balanced Shadow Optimization",
			disableDynamicShadows = false,
			disableStaticShadows = false,
			maxShadowDistance = 100,
			castShadow = function(part)
				return part:IsA("Part") or part:IsA("MeshPart")
			end,
		},
		conservative = {
			name = "Conservative Shadow Settings",
			disableDynamicShadows = false,
			disableStaticShadows = false,
			maxShadowDistance = 150,
			castShadow = function(part)
				return true
			end,
		},
	},

	-- Physics optimization rules
	physics = {
		aggressive = {
			name = "Aggressive Physics Reduction",
			disablePhysicsSmall = true,
			disablePhysicsDecorative = true,
			mergeAdjacentParts = true,
			massThreshold = 0.1,
			description = "Disable physics on small and decorative parts",
		},
		balanced = {
			name = "Balanced Physics Settings",
			disablePhysicsSmall = false,
			disablePhysicsDecorative = true,
			mergeAdjacentParts = false,
			massThreshold = 0.05,
			description = "Only decorative parts lose physics",
		},
		conservative = {
			name = "Conservative Physics",
			disablePhysicsSmall = false,
			disablePhysicsDecorative = false,
			mergeAdjacentParts = false,
			massThreshold = 0.01,
			description = "Keep all physics enabled",
		},
	},

	-- LOD (Level of Detail) rules
	lod = {
		aggressive = {
			name = "Aggressive LOD",
			maxDistance = 100,
			mergeRadius = 20,
			targetTriangleCount = 500,
			stages = 4,
			description = "Aggressive mesh simplification and merging",
		},
		balanced = {
			name = "Balanced LOD",
			maxDistance = 150,
			mergeRadius = 30,
			targetTriangleCount = 1000,
			stages = 3,
			description = "Standard LOD implementation",
		},
		conservative = {
			name = "Conservative LOD",
			maxDistance = 200,
			mergeRadius = 50,
			targetTriangleCount = 2000,
			stages = 2,
			description = "Minimal LOD changes",
		},
	},

	-- Particle optimization
	particles = {
		aggressive = {
			name = "Aggressive Particle Reduction",
			maxEmissionRate = 50,
			maxLifetime = 5,
			disableFarAway = true,
			maxDistanceToPlayer = 50,
			description = "Heavy particle reduction",
		},
		balanced = {
			name = "Balanced Particles",
			maxEmissionRate = 100,
			maxLifetime = 10,
			disableFarAway = true,
			maxDistanceToPlayer = 100,
			description = "Standard particle limits",
		},
		conservative = {
			name = "Conservative Particles",
			maxEmissionRate = 200,
			maxLifetime = 20,
			disableFarAway = false,
			maxDistanceToPlayer = 200,
			description = "Keep most particles",
		},
	},

	-- Size-based rules
	sizeRules = {
		-- Parts smaller than this are candidates for optimization
		smallPartThreshold = Vector3.new(1, 1, 1),
		
		-- Parts larger than this may be merged
		largePartThreshold = Vector3.new(20, 20, 20),
		
		-- Mesh detail reduction
		meshSimplification = {
			high = 0.1,   -- Keep 10% of triangles
			medium = 0.3, -- Keep 30% of triangles
			low = 0.5,    -- Keep 50% of triangles
		},
	},

	-- Material optimization
	materials = {
		-- Materials ordered by performance cost (highest to lowest)
		costRanking = {
			Enum.Material.Neon,
			Enum.Material.Plastic,
			Enum.Material.SmoothPlastic,
			Enum.Material.Metal,
			Enum.Material.Concrete,
		},
		
		-- Recommended replacements
		replacements = {
			[Enum.Material.Neon] = Enum.Material.SmoothPlastic,
			[Enum.Material.Glass] = Enum.Material.Plastic,
		},
	},

	-- Presets combining multiple rules
	presets = {
		mobileOptimized = {
			name = "Mobile Optimized",
			budget = "mobile",
			shadows = "aggressive",
			physics = "aggressive",
			lod = "aggressive",
			particles = "aggressive",
			description = "Extreme optimization for mobile devices",
		},
		balancedQuality = {
			name = "Balanced Quality",
			budget = "standard",
			shadows = "balanced",
			physics = "balanced",
			lod = "balanced",
			particles = "balanced",
			description = "Good balance between quality and performance",
		},
		maxQuality = {
			name = "Maximum Quality",
			budget = "highEnd",
			shadows = "conservative",
			physics = "conservative",
			lod = "conservative",
			particles = "conservative",
			description = "Best visual quality with minimal optimization",
		},
	},

	-- Detection rules for decorative parts
	decorativePatterns = {
		names = {"decor", "deco", "ornament", "plant", "flower", "rock", "light", "lamp"},
		--  Small and complex parts are likely decorative
		sizeRange = {min = Vector3.new(0.1, 0.1, 0.1), max = Vector3.new(5, 5, 5)},
		triangleRange = {min = 100, max = 10000},
	},

	-- Part merging rules
	merging = {
		-- Can merge if parts are:
		canMerge = function(part1, part2)
			-- Same material
			if part1.Material ~= part2.Material then return false end
			-- Same color (or within threshold)
			local colorDist = (part1.Color.R - part2.Color.R)^2 + 
							 (part1.Color.G - part2.Color.G)^2 + 
							 (part1.Color.B - part2.Color.B)^2
			if colorDist > 0.1 then return false end
			-- No scripts attached
			if #part1:FindFirstChild("Script") > 0 or #part2:FindFirstChild("Script") > 0 then return false end
			return true
		end,
		
		-- Maximum merge size to avoid huge parts
		maxMergeSize = Vector3.new(100, 100, 100),
		
		-- Minimum merge benefit (% reduction)
		minBenefit = 0.1,
	},

	-- Region-based rules
	regions = {
		-- Different optimization for different region types
		outdoor = {
			shadowsAggressive = true,
			mergeAggressively = true,
			physicsLevel = "aggressive",
		},
		indoor = {
			shadowsAggressive = false,
			mergeAggressively = false,
			physicsLevel = "balanced",
		},
		ui = {
			disablePhysics = true,
			disableShadows = true,
			mergeFully = true,
		},
	},
}

-- Get preset by name
function OptimizationRules.getPreset(presetName)
	return OptimizationRules.presets[presetName]
end

-- List all optimization presets
function OptimizationRules.listPresets()
	local list = {}
	for name, preset in pairs(OptimizationRules.presets) do
		table.insert(list, {id = name, name = preset.name, description = preset.description})
	end
	return list
end

-- Calculate optimization score (0-100)
function OptimizationRules.calculateScore(stats)
	local score = 100
	local budget = OptimizationRules.budgets.standard
	
	-- Deduct for exceeding limits
	if stats.partCount > budget.maxParts then
		score = score - (stats.partCount - budget.maxParts) / budget.maxParts * 20
	end
	if stats.meshCount > budget.maxMeshParts then
		score = score - (stats.meshCount - budget.maxMeshParts) / budget.maxMeshParts * 20
	end
	if stats.lightCount > budget.maxLights then
		score = score - (stats.lightCount - budget.maxLights) / budget.maxLights * 15
	end
	
	return math.max(0, math.min(100, score))
end

return OptimizationRules
