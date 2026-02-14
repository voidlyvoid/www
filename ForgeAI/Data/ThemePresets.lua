--[[
	ThemePresets.lua
	Predefined color palettes and material themes
	Used for automatic theme detection and application
]]

local ThemePresets = {
	-- Urban/Modern theme
	urban = {
		name = "Urban Modern",
		description = "Clean, industrial aesthetic",
		colors = {
			Color3.fromRGB(50, 50, 50),
			Color3.fromRGB(100, 100, 100),
			Color3.fromRGB(150, 150, 150),
			Color3.fromRGB(200, 200, 200),
			Color3.fromRGB(240, 240, 240),
		},
		materials = {Enum.Material.Concrete, Enum.Material.Metal, Enum.Material.Plastic},
		lighting = {
			ambient = Color3.fromRGB(150, 150, 150),
			brightness = 1.5,
			temperature = 0.1,
		},
		accent = Color3.fromRGB(0, 150, 255),
	},

	-- Nature/Forest theme
	forest = {
		name = "Forest Nature",
		description = "Organic woodland aesthetic",
		colors = {
			Color3.fromRGB(80, 120, 60),
			Color3.fromRGB(120, 160, 80),
			Color3.fromRGB(160, 200, 100),
			Color3.fromRGB(100, 80, 40),
			Color3.fromRGB(60, 40, 20),
		},
		materials = {Enum.Material.Wood, Enum.Material.Grass, Enum.Material.Mud},
		lighting = {
			ambient = Color3.fromRGB(180, 180, 150),
			brightness = 0.8,
			temperature = 0.2,
		},
		accent = Color3.fromRGB(100, 200, 100),
	},

	-- Medieval/Fantasy theme
	medieval = {
		name = "Medieval Fantasy",
		description = "Castle and stone architecture",
		colors = {
			Color3.fromRGB(80, 60, 40),
			Color3.fromRGB(120, 100, 70),
			Color3.fromRGB(160, 140, 100),
			Color3.fromRGB(60, 50, 40),
			Color3.fromRGB(200, 180, 140),
		},
		materials = {Enum.Material.Brick, Enum.Material.Stone, Enum.Material.Wood},
		lighting = {
			ambient = Color3.fromRGB(200, 180, 140),
			brightness = 0.9,
			temperature = 0.3,
		},
		accent = Color3.fromRGB(255, 200, 0),
	},

	-- Cyberpunk/Tech theme
	cyberpunk = {
		name = "Cyberpunk Tech",
		description = "Neon and high-tech aesthetic",
		colors = {
			Color3.fromRGB(20, 20, 40),
			Color3.fromRGB(40, 40, 80),
			Color3.fromRGB(60, 60, 120),
			Color3.fromRGB(200, 0, 255),
			Color3.fromRGB(0, 255, 200),
		},
		materials = {Enum.Material.Metal, Enum.Material.Neon, Enum.Material.Glass},
		lighting = {
			ambient = Color3.fromRGB(100, 100, 150),
			brightness = 2.0,
			temperature = -0.5,
		},
		accent = Color3.fromRGB(255, 0, 200),
	},

	-- Desert/Sandy theme
	desert = {
		name = "Desert Wasteland",
		description = "Sandy, arid environment",
		colors = {
			Color3.fromRGB(200, 180, 140),
			Color3.fromRGB(220, 190, 150),
			Color3.fromRGB(240, 210, 170),
			Color3.fromRGB(160, 120, 80),
			Color3.fromRGB(180, 140, 100),
		},
		materials = {Enum.Material.Sand, Enum.Material.Brick, Enum.Material.Wood},
		lighting = {
			ambient = Color3.fromRGB(255, 220, 180),
			brightness = 1.8,
			temperature = 0.5,
		},
		accent = Color3.fromRGB(255, 140, 0),
	},

	-- Ice/Winter theme
	winter = {
		name = "Frozen Winter",
		description = "Icy, cold aesthetic",
		colors = {
			Color3.fromRGB(200, 220, 240),
			Color3.fromRGB(220, 230, 245),
			Color3.fromRGB(150, 200, 240),
			Color3.fromRGB(100, 150, 200),
			Color3.fromRGB(80, 120, 180),
		},
		materials = {Enum.Material.Ice, Enum.Material.Snow, Enum.Material.Glass},
		lighting = {
			ambient = Color3.fromRGB(200, 220, 240),
			brightness = 1.2,
			temperature = -0.3,
		},
		accent = Color3.fromRGB(100, 200, 255),
	},

	-- Deep Ocean theme
	ocean = {
		name = "Deep Ocean",
		description = "Aquatic underwater aesthetic",
		colors = {
			Color3.fromRGB(0, 80, 120),
			Color3.fromRGB(20, 100, 150),
			Color3.fromRGB(40, 120, 180),
			Color3.fromRGB(60, 140, 200),
			Color3.fromRGB(100, 180, 220),
		},
		materials = {Enum.Material.Glass, Enum.Material.Water, Enum.Material.Metal},
		lighting = {
			ambient = Color3.fromRGB(100, 150, 180),
			brightness = 0.7,
			temperature = -0.2,
		},
		accent = Color3.fromRGB(0, 255, 200),
	},

	-- Steampunk theme
	steampunk = {
		name = "Steampunk Industrial",
		description = "Brass and mechanical aesthetic",
		colors = {
			Color3.fromRGB(80, 60, 20),
			Color3.fromRGB(120, 100, 40),
			Color3.fromRGB(160, 140, 80),
			Color3.fromRGB(200, 160, 100),
			Color3.fromRGB(220, 180, 120),
		},
		materials = {Enum.Material.Metal, Enum.Material.Brass, Enum.Material.Wood},
		lighting = {
			ambient = Color3.fromRGB(180, 140, 100),
			brightness = 1.3,
			temperature = 0.4,
		},
		accent = Color3.fromRGB(200, 120, 0),
	},

	-- Futuristic theme
	futuristic = {
		name = "Futuristic Sci-Fi",
		description = "High-tech sleek aesthetic",
		colors = {
			Color3.fromRGB(10, 20, 40),
			Color3.fromRGB(30, 50, 100),
			Color3.fromRGB(50, 100, 200),
			Color3.fromRGB(0, 200, 255),
			Color3.fromRGB(255, 0, 100),
		},
		materials = {Enum.Material.Neon, Enum.Material.Metal, Enum.Material.Glass},
		lighting = {
			ambient = Color3.fromRGB(100, 150, 255),
			brightness = 2.2,
			temperature = -0.4,
		},
		accent = Color3.fromRGB(0, 255, 100),
	},
}

-- Get theme by name
function ThemePresets.getTheme(themeName)
	return ThemePresets[themeName] or nil
end

-- List all available themes
function ThemePresets.listThemes()
	local list = {}
	for name, theme in pairs(ThemePresets) do
		table.insert(list, {id = name, name = theme.name, description = theme.description})
	end
	return list
end

-- Get theme by closest color match
function ThemePresets.getThemeByColor(color)
	local bestMatch = nil
	local bestDistance = math.huge
	
	for themeName, theme in pairs(ThemePresets) do
		for _, themeColor in ipairs(theme.colors) do
			local dist = (color.R - themeColor.R)^2 + (color.G - themeColor.G)^2 + (color.B - themeColor.B)^2
			if dist < bestDistance then
				bestDistance = dist
				bestMatch = themeName
			end
		end
	end
	
	return bestMatch
end

-- Merge theme with overrides
function ThemePresets.merge(themeName, overrides)
	local theme = ThemePresets.getTheme(themeName)
	if not theme then return overrides end
	
	local merged = {}
	for k, v in pairs(theme) do
		if type(v) == "table" then
			merged[k] = {}
			for tk, tv in pairs(v) do
				merged[k][tk] = tv
			end
		else
			merged[k] = v
		end
	end
	
	for k, v in pairs(overrides or {}) do
		if type(v) == "table" and type(merged[k]) == "table" then
			for tk, tv in pairs(v) do
				merged[k][tk] = tv
			end
		else
			merged[k] = v
		end
	end
	
	return merged
end

return ThemePresets
