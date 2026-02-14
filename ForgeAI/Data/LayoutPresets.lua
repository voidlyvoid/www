--[[
	LayoutPresets.lua
	Preset configurations for layout generation
	Contains grid patterns, organic shapes, and modular layouts
]]

local LayoutPresets = {
	-- Grid-based layouts
	grid = {
		small = {
			name = "Small Grid",
			description = "5x5 grid layout, compact",
			spacing = 10,
			columns = 5,
			rows = 5,
			cellSize = 20,
		},
		medium = {
			name = "Medium Grid",
			description = "10x10 grid layout, standard",
			spacing = 15,
			columns = 10,
			rows = 10,
			cellSize = 30,
		},
		large = {
			name = "Large Grid",
			description = "20x20 grid layout, expansive",
			spacing = 20,
			columns = 20,
			rows = 20,
			cellSize = 40,
		},
	},

	-- Organic layouts
	organic = {
		clustered = {
			name = "Clustered",
			description = "Objects grouped in natural clusters",
			clusterSize = 30,
			clusterSpacing = 50,
			distribution = "gaussian",
			density = 0.7,
		},
		scattered = {
			name = "Scattered",
			description = "Randomly distributed, sparse",
			clusterSize = 5,
			clusterSpacing = 100,
			distribution = "uniform",
			density = 0.3,
		},
		dense = {
			name = "Dense Forest",
			description = "Heavy concentration, high density",
			clusterSize = 20,
			clusterSpacing = 25,
			distribution = "poisson",
			density = 0.9,
		},
	},

	-- Modular layouts
	modular = {
		marketplace = {
			name = "Marketplace",
			description = "Vendor stalls arranged in rows with central plaza",
			stallWidth = 12,
			stallDepth = 8,
			stallSpacing = 2,
			plazaRadius = 40,
			rows = 4,
			stallsPerRow = 8,
		},
		cityBlock = {
			name = "City Block",
			description = "Buildings arranged in city grid pattern",
			blockSize = 50,
			roadWidth = 8,
			buildingSize = 30,
			buildingSpacing = 5,
		},
		arena = {
			name = "Arena",
			description = "Circular seating and central stage",
			radius = 100,
			stageRadius = 20,
			rows = 8,
			seatsPerRow = 12,
		},
	},

	-- Path patterns
	paths = {
		radial = {
			name = "Radial Paths",
			description = "Paths emanating from center",
			center = Vector3.new(0, 0, 0),
			arms = 6,
			length = 100,
		},
		grid = {
			name = "Grid Roads",
			description = "Regular grid of roads",
			width = 4,
			spacing = 50,
			extent = 200,
		},
		winding = {
			name = "Winding Path",
			description = "Organic winding pathways",
			width = 3,
			curviness = 0.5,
			length = 300,
		},
	},

	-- Density configurations
	density = {
		sparse = {
			name = "Sparse",
			multiplier = 0.3,
			minSpacing = 30,
			description = "Very few objects, spacious feel",
		},
		normal = {
			name = "Normal",
			multiplier = 0.6,
			minSpacing = 15,
			description = "Balanced object distribution",
		},
		dense = {
			name = "Dense",
			multiplier = 0.9,
			minSpacing = 5,
			description = "Many objects, crowded feel",
		},
	},

	-- Scale presets
	scale = {
		tiny = {
			name = "Tiny",
			multiplier = 0.25,
			description = "0.25x scale for micro scenes",
		},
		small = {
			name = "Small",
			multiplier = 0.5,
			description = "0.5x scale for compact areas",
		},
		normal = {
			name = "Normal",
			multiplier = 1.0,
			description = "1.0x standard scale",
		},
		large = {
			name = "Large",
			multiplier = 2.0,
			description = "2.0x scale for expansive areas",
		},
		huge = {
			name = "Huge",
			multiplier = 4.0,
			description = "4.0x scale for massive worlds",
		},
	},

	-- Semantic zones
	zones = {
		market = {
			name = "Market",
			color = Color3.fromRGB(200, 150, 100),
			density = 0.8,
			decorations = {"stall", "crate", "sign", "lantern"},
		},
		residential = {
			name = "Residential",
			color = Color3.fromRGB(100, 200, 100),
			density = 0.6,
			decorations = {"house", "fence", "door", "plant"},
		},
		industrial = {
			name = "Industrial",
			color = Color3.fromRGB(150, 150, 150),
			density = 0.7,
			decorations = {"machine", "crate", "barrel", "pipe"},
		},
		natural = {
			name = "Natural",
			color = Color3.fromRGB(100, 180, 100),
			density = 0.5,
			decorations = {"tree", "rock", "grass", "water"},
		},
		plaza = {
			name = "Plaza",
			color = Color3.fromRGB(150, 150, 200),
			density = 0.2,
			decorations = {"fountain", "bench", "light", "statue"},
		},
	},
}

-- Helper function to get preset by category and name
function LayoutPresets.getPreset(category, presetName)
	if LayoutPresets[category] and LayoutPresets[category][presetName] then
		return LayoutPresets[category][presetName]
	end
	return nil
end

-- Helper to list all presets in a category
function LayoutPresets.listCategory(category)
	if not LayoutPresets[category] then return {} end
	local list = {}
	for name, preset in pairs(LayoutPresets[category]) do
		if preset.name then
			table.insert(list, {name = preset.name, id = name, description = preset.description})
		end
	end
	return list
end

-- Merge preset with custom overrides
function LayoutPresets.merge(presetName, overrides)
	local preset = LayoutPresets.getPreset("grid", presetName)
	if not preset then return overrides end
	
	local merged = {}
	for k, v in pairs(preset) do
		merged[k] = v
	end
	for k, v in pairs(overrides or {}) do
		merged[k] = v
	end
	return merged
end

return LayoutPresets
