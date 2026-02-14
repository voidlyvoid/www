--[[
	UIAnalyzer - Analyzes and improves Roblox ScreenGuis
	Core responsibility: Layout analysis, contrast checking, mobile optimization, accessibility
]]

local UIAnalyzer = {}
local Validator = require(script.Parent.Parent.Utils.Validator)

--[[
	Analyze a ScreenGui for issues and recommendations
]]
function UIAnalyzer.analyzeUI(screenGui)
	Validator.assertType(screenGui, "Instance", "screenGui")
	
	if not screenGui:IsA("ScreenGui") then
		error("[ForgeAI] Expected ScreenGui, got " .. screenGui.ClassName)
	end
	
	local analysis = {
		timestamp = tick(),
		gui = screenGui,
		issues = {},
		recommendations = {},
		mobileProblems = {},
		accessibilityIssues = {}
	}
	
	-- Analyze layout and alignment
	analysis.issues = UIAnalyzer.checkAlignment(screenGui)
	
	-- Check contrast
	local contrastIssues = UIAnalyzer.checkContrast(screenGui)
	for _, issue in ipairs(contrastIssues) do
		table.insert(analysis.issues, issue)
	end
	
	-- Check mobile compatibility
	analysis.mobileProblems = UIAnalyzer.checkMobileCompatibility(screenGui)
	
	-- Check accessibility
	analysis.accessibilityIssues = UIAnalyzer.checkAccessibility(screenGui)
	
	-- Generate recommendations
	analysis.recommendations = UIAnalyzer.generateUIRecommendations(analysis)
	
	return analysis
end

--[[
	Check UI element alignment and positioning
]]
function UIAnalyzer.checkAlignment(screenGui)
	local issues = {}
	
	local children = screenGui:GetDescendants()
	
	for _, element in ipairs(children) do
		if element:IsA("GuiObject") then
			local size = element.Size
			local position = element.Position
			
			-- Check for extremely small elements
			if size.X.Offset < 10 or size.Y.Offset < 10 then
				table.insert(issues, {
					type = "tiny_element",
					element = element,
					severity = "medium",
					message = "Element is too small: " .. element.Name .. " (" .. size.X.Offset .. "x" .. size.Y.Offset .. ")"
				})
			end
			
			-- Check for off-screen elements
			if position.X.Offset > 1000 or position.Y.Offset > 1000 then
				table.insert(issues, {
					type = "off_screen",
					element = element,
					severity = "high",
					message = "Element positioned off-screen: " .. element.Name
				})
			end
			
			-- Check text scaling
			if element:IsA("TextLabel") or element:IsA("TextButton") then
				if element.TextScaled == false and element.TextSize > 40 then
					table.insert(issues, {
						type = "large_text",
						element = element,
						severity = "low",
						message = "Large text size may not scale properly: " .. element.Name
					})
				end
			end
		end
	end
	
	return issues
end

--[[
	Check text-background contrast
]]
function UIAnalyzer.checkContrast(screenGui)
	local issues = {}
	
	local function calculateLuminance(color)
		local r = color.R <= 0.03928 and color.R / 12.92 or math.pow((color.R + 0.055) / 1.055, 2.4)
		local g = color.G <= 0.03928 and color.G / 12.92 or math.pow((color.G + 0.055) / 1.055, 2.4)
		local b = color.B <= 0.03928 and color.B / 12.92 or math.pow((color.B + 0.055) / 1.055, 2.4)
		
		return 0.2126 * r + 0.7152 * g + 0.0722 * b
	end
	
	local children = screenGui:GetDescendants()
	
	for _, element in ipairs(children) do
		if (element:IsA("TextLabel") or element:IsA("TextButton")) and element.Text ~= "" then
			local textColor = element.TextColor3
			local bgColor = element.BackgroundColor3
			
			local textLum = calculateLuminance(textColor)
			local bgLum = calculateLuminance(bgColor)
			
			local contrast = (math.max(textLum, bgLum) + 0.05) / (math.min(textLum, bgLum) + 0.05)
			
			-- WCAG AA requires 4.5:1 for normal text, 3:1 for large text
			if contrast < 3 then
				table.insert(issues, {
					type = "low_contrast",
					element = element,
					severity = "high",
					message = "Low contrast ratio: " .. string.format("%.2f", contrast) .. ":1 for " .. element.Name,
					contrast = contrast
				})
			end
		end
	end
	
	return issues
end

--[[
	Check mobile compatibility
]]
function UIAnalyzer.checkMobileCompatibility(screenGui)
	local problems = {}
	
	local children = screenGui:GetDescendants()
	local mobileWidth = 375  -- iPhone width
	local mobileHeight = 667 -- iPhone height
	
	for _, element in ipairs(children) do
		if element:IsA("GuiObject") then
			-- Check if using scale (good for mobile) vs offset (bad)
			if element.Size.X.Offset > element.Size.X.Scale * 10 then
				table.insert(problems, {
					type = "fixed_size",
					element = element,
					severity = "medium",
					message = "Element uses fixed size instead of scale: " .. element.Name
				})
			end
			
			-- Check button size for touch
			if element:IsA("TextButton") or element:IsA("ImageButton") then
				if element.Size.X.Offset < 44 or element.Size.Y.Offset < 44 then
					table.insert(problems, {
						type = "small_touch_target",
						element = element,
						severity = "medium",
						message = "Button too small for touch (recommend 44x44+): " .. element.Name
					})
				end
			end
		end
	end
	
	return problems
end

--[[
	Check accessibility features
]]
function UIAnalyzer.checkAccessibility(screenGui)
	local issues = {}
	
	local children = screenGui:GetDescendants()
	
	for _, element in ipairs(children) do
		if element:IsA("GuiObject") then
			-- Check for missing descriptions on interactive elements
			if (element:IsA("TextButton") or element:IsA("ImageButton")) then
				if not element:GetAttribute("Description") and element.Name == "Button" then
					table.insert(issues, {
						type = "missing_label",
						element = element,
						severity = "medium",
						message = "Button missing descriptive name or description"
					})
				end
			end
			
			-- Check image buttons for alt text
			if element:IsA("ImageButton") and element:GetAttribute("AltText") == nil then
				table.insert(issues, {
					type = "missing_alt_text",
					element = element,
					severity = "low",
					message = "Image button missing alt text"
				})
			end
		end
	end
	
	return issues
end

--[[
	Generate recommendations to fix UI issues
]]
function UIAnalyzer.generateUIRecommendations(analysis)
	local recommendations = {}
	
	-- Analyze issue patterns
	local issueTypes = {}
	for _, issue in ipairs(analysis.issues) do
		issueTypes[issue.type] = (issueTypes[issue.type] or 0) + 1
	end
	
	-- Generate specific recommendations
	if issueTypes.low_contrast then
		table.insert(recommendations, {
			priority = "high",
			action = "Improve text/background contrast",
			severity = "Accessibility",
			details = "Several text elements have poor contrast ratios"
		})
	end
	
	if issueTypes.fixed_size then
		table.insert(recommendations, {
			priority = "high",
			action = "Use Scale instead of Offset for responsive design",
			severity = "Mobile",
			details = "Fixed-size elements don't scale to different screen sizes"
		})
	end
	
	if issueTypes.small_touch_target then
		table.insert(recommendations, {
			priority = "medium",
			action = "Increase button size to at least 44x44 pixels",
			severity = "Mobile",
			details = "Small buttons are hard to tap on touch devices"
		})
	end
	
	if #analysis.mobileProblems > 0 then
		table.insert(recommendations, {
			priority = "high",
			action = "Apply mobile-friendly layout",
			severity = "Mobile",
			details = string.format("Found %d mobile compatibility issues", #analysis.mobileProblems)
		})
	end
	
	if #analysis.accessibilityIssues > 0 then
		table.insert(recommendations, {
			priority = "medium",
			action = "Add accessibility labels and descriptions",
			severity = "Accessibility",
			details = string.format("Found %d accessibility issues", #analysis.accessibilityIssues)
		})
	end
	
	return recommendations
end

--[[
	Suggest AutoLayout implementation
]]
function UIAnalyzer.suggestAutoLayout(element)
	if not element:IsA("GuiObject") then
		return nil
	end
	
	return {
		element = element,
		suggestion = "Use UIListLayout or UIGridLayout for flexible layouts",
		benefits = {
			"Automatic responsive resizing",
			"Easy reordering of elements",
			"Consistent spacing"
		}
	}
end

--[[
	Generate a mobile-optimized layout
]]
function UIAnalyzer.generateMobileLayout(screenGui)
	Validator.assertType(screenGui, "Instance", "screenGui")
	
	local mobileTemplate = {
		safeAreaInsets = {top = 20, bottom = 34},
		guideline = "Use 16+ pt text, 44+ pt touch targets, scale-based sizing"
	}
	
	-- Analyze current layout
	local analysis = UIAnalyzer.analyzeUI(screenGui)
	
	return {
		template = mobileTemplate,
		issuesFound = #analysis.issues,
		recommendations = analysis.recommendations
	}
end

return UIAnalyzer
