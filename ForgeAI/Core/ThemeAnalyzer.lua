--[[
	ThemeAnalyzer - Analyzes and suggests visual themes
	Core responsibility: Material detection, color extraction, lighting analysis, theme classification
]]

local ThemeAnalyzer = {}
local Validator = require(script.Parent.Parent.Utils.Validator)
local SceneScanner = require(script.Parent.Parent.Utils.SceneScanner)

--[[
	Analyze theme of a region
]]
function ThemeAnalyzer.analyzeTheme(region)
	Validator.assertInWorkspace(region, "region")
	
	local theme = {
		timestamp = tick(),
		region = region,
		detectedStyle = "unknown",
		dominantMaterials = {},
		dominantColors = {},
		lightingProfile = {},
		assetTypes = {},
		suggestions = {}
	}
	
	-- Analyze materials
	theme.dominantMaterials = ThemeAnalyzer.analyzeMaterials(region)
	
	-- Analyze colors
	theme.dominantColors = ThemeAnalyzer.analyzeColors(region)
	
	-- Analyze lighting
	theme.lightingProfile = ThemeAnalyzer.analyzeLighting()
	
	-- Detect theme
	theme.detectedStyle = ThemeAnalyzer.detectTheme(theme)
	
	-- Generate suggestions
	theme.suggestions = ThemeAnalyzer.generateThemeSuggestions(theme)
	
	return theme
end

--[[
	Analyze dominant materials in a region
]]
function ThemeAnalyzer.analyzeMaterials(region)
	local materials = {}
	local materialCounts = {}
	
	local descendants = region:GetDescendants()
	
	for _, object in ipairs(descendants) do
		if object:IsA("BasePart") then
			local material = tostring(object.Material)
			materialCounts[material] = (materialCounts[material] or 0) + 1
		end
	end
	
	-- Sort by frequency
	local sortedMaterials = {}
	for material, count in pairs(materialCounts) do
		table.insert(sortedMaterials, {name = material, count = count})
	end
	
	table.sort(sortedMaterials, function(a, b)
		return a.count > b.count
	end)
	
	-- Take top 5
	for i = 1, math.min(5, #sortedMaterials) do
		table.insert(materials, {
			name = sortedMaterials[i].name,
			frequency = sortedMaterials[i].count,
			importance = (6 - i) / 5 -- Weight by rank
		})
	end
	
	return materials
end

--[[
	Analyze dominant colors in a region
]]
function ThemeAnalyzer.analyzeColors(region)
	local colors = {}
	local colorSamples = {}
	
	local descendants = region:GetDescendants()
	
	for _, object in ipairs(descendants) do
		if object:IsA("BasePart") then
			if object:IsA("Part") or object:IsA("MeshPart") then
				table.insert(colorSamples, object.Color)
			end
		end
	end
	
	-- Simple color clustering (group similar colors)
	local colorBuckets = {}
	
	for _, color in ipairs(colorSamples) do
		local r = math.floor(color.R * 5) / 5
		local g = math.floor(color.G * 5) / 5
		local b = math.floor(color.B * 5) / 5
		
		local key = r .. "_" .. g .. "_" .. b
		colorBuckets[key] = (colorBuckets[key] or 0) + 1
	end
	
	-- Convert to color objects and sort
	local sortedColors = {}
	for key, count in pairs(colorBuckets) do
		local parts = key:split("_")
		table.insert(sortedColors, {
			color = Color3.new(tonumber(parts[1]), tonumber(parts[2]), tonumber(parts[3])),
			frequency = count
		})
	end
	
	table.sort(sortedColors, function(a, b)
		return a.frequency > b.frequency
	end)
	
	-- Take top 5
	for i = 1, math.min(5, #sortedColors) do
		table.insert(colors, {
			color = sortedColors[i].color,
			hex = ThemeAnalyzer.colorToHex(sortedColors[i].color),
			frequency = sortedColors[i].frequency
		})
	end
	
	return colors
end

--[[
	Analyze lighting in the workspace
]]
function ThemeAnalyzer.analyzeLighting()
	local Lighting = game:GetService("Lighting")
	
	return {
		brightness = Lighting.Brightness,
		ambient = Lighting.Ambient,
		outdoorAmbient = Lighting.OutdoorAmbient,
		clockTime = Lighting.ClockTime,
		hasAtmosphere = Lighting:FindFirstChild("Atmosphere") ~= nil,
		hasTerrain = workspace.Terrain and workspace.Terrain.Size.Magnitude > 0
	}
end

--[[
	Detect theme based on analysis
]]
function ThemeAnalyzer.detectTheme(theme)
	local materialScores = {
		urban = 0,
		nature = 0,
		tech = 0,
		fantasy = 0,
		steampunk = 0
	}
	
	-- Score based on materials
	for _, material in ipairs(theme.dominantMaterials) do
		local name = material.name:lower()
		local weight = material.importance
		
		if name:find("concrete") or name:find("brick") or name:find("asphalt") then
			materialScores.urban += weight * 2
		elseif name:find("grass") or name:find("leaf") or name:find("wood") then
			materialScores.nature += weight * 2
		elseif name:find("metal") or name:find("neon") then
			materialScores.tech += weight * 2
		elseif name:find("ice") or name:find("gem") then
			materialScores.fantasy += weight * 2
		end
	end
	
	-- Score based on colors
	for _, colorData in ipairs(theme.dominantColors) do
		local r = colorData.color.R
		local g = colorData.color.G
		local b = colorData.color.B
		
		if r > 0.7 or g > 0.7 then
			materialScores.tech += 0.5
		end
		if g > 0.5 then
			materialScores.nature += 0.5
		end
		if math.abs(r - b) < 0.2 and g < 0.4 then
			materialScores.steampunk += 0.5
		end
	end
	
	-- Find highest score
	local maxScore = 0
	local detectedTheme = "mixed"
	
	for themeName, score in pairs(materialScores) do
		if score > maxScore then
			maxScore = score
			detectedTheme = themeName
		end
	end
	
	return detectedTheme
end

--[[
	Generate theme suggestions
]]
function ThemeAnalyzer.generateThemeSuggestions(theme)
	local suggestions = {
		colorPalettes = {},
		assetSuggestions = {},
		lightingTips = {},
		materialRecommendations = {}
	}
	
	-- Color palette suggestions
	local palettes = {
		urban = {Color3.fromRGB(100, 100, 100), Color3.fromRGB(200, 100, 50), Color3.fromRGB(50, 50, 50)},
		nature = {Color3.fromRGB(100, 150, 80), Color3.fromRGB(180, 160, 100), Color3.fromRGB(80, 120, 60)},
		tech = {Color3.fromRGB(0, 200, 255), Color3.fromRGB(100, 50, 150), Color3.fromRGB(50, 50, 50)},
		fantasy = {Color3.fromRGB(150, 100, 200), Color3.fromRGB(200, 150, 100), Color3.fromRGB(100, 150, 255)}
	}
	
	suggestions.colorPalettes = palettes[theme.detectedStyle] or palettes.mixed
	
	-- Asset suggestions based on theme
	local assetMap = {
		urban = {"lamp_post", "bench", "signage", "vehicle"},
		nature = {"tree", "rock", "bush", "flower"},
		tech = {"monitor", "antenna", "drone", "panel"},
		fantasy = {"statue", "fountain", "rune_stone", "crystal"}
	}
	
	suggestions.assetSuggestions = assetMap[theme.detectedStyle] or {}
	
	-- Lighting tips
	suggestions.lightingTips = {
		"Consider adjusting brightness to " .. (theme.detectedStyle == "nature" and "0.5-0.8" or "1.0-1.5"),
		"Use warm colors for cozy atmosphere",
		"Add directional shadows for depth"
	}
	
	-- Material recommendations
	suggestions.materialRecommendations = {
		{material = "Concrete", theme = "urban"},
		{material = "Grass", theme = "nature"},
		{material = "Neon", theme = "tech"},
		{material = "Rock", theme = "fantasy"}
	}
	
	return suggestions
end

--[[
	Convert Color3 to hex string
]]
function ThemeAnalyzer.colorToHex(color)
	local r = math.floor(color.R * 255)
	local g = math.floor(color.G * 255)
	local b = math.floor(color.B * 255)
	
	return string.format("#%02X%02X%02X", r, g, b)
end

--[[
	Apply theme palette to a region
]]
function ThemeAnalyzer.applyThemePalette(region, palette, dryRun)
	dryRun = dryRun or true
	
	local results = {
		applied = 0,
		failed = 0,
		changes = {}
	}
	
	local descendants = region:GetDescendants()
	local colorIndex = 1
	
	for _, object in ipairs(descendants) do
		if object:IsA("BasePart") then
			local newColor = palette[colorIndex]
			
			if not dryRun then
				object.Color = newColor
			end
			
			table.insert(results.changes, {
				object = object,
				newColor = newColor,
				applied = not dryRun
			})
			
			results.applied += 1
			colorIndex = (colorIndex % #palette) + 1
		end
	end
	
	return results
end

return ThemeAnalyzer
