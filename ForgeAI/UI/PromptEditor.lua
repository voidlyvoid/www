--[[
	PromptEditor - UI for entering generation prompts
	Allows users to specify what they want to generate (layouts, NPCs, scripts, etc.)
]]

local PromptEditor = {}

--[[
	Create prompt editor panel
]]
function PromptEditor.create(parent, generationType)
	generationType = generationType or "layout"
	
	local panel = Instance.new("Frame")
	panel.Name = "PromptEditor"
	panel.Size = UDim2.new(1, 0, 1, 0)
	panel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	panel.BorderSizePixel = 0
	panel.Parent = parent
	
	-- Title
	local titleBar = Instance.new("TextLabel")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, 30)
	titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	titleBar.TextColor3 = Color3.fromRGB(220, 220, 220)
	titleBar.Text = "Generate " .. string.upper(generationType)
	titleBar.TextSize = 14
	titleBar.Font = Enum.Font.GothamBold
	titleBar.Parent = panel
	
	-- Create scrollable content
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Name = "ScrollContent"
	scrollFrame.Size = UDim2.new(1, -10, 1, -40)
	scrollFrame.Position = UDim2.new(0, 5, 0, 35)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.BorderSizePixel = 0
	scrollFrame.ScrollBarThickness = 8
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 800)
	scrollFrame.Parent = panel
	
	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Stretch
	layout.VerticalAlignment = Enum.VerticalAlignment.Top
	layout.Padding = UDim.new(0, 10)
	layout.Parent = scrollFrame
	
	-- Description
	local descLabel = Instance.new("TextLabel")
	descLabel.Name = "Description"
	descLabel.Size = UDim2.new(1, 0, 0, 30)
	descLabel.BackgroundTransparency = 1
	descLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
	descLabel.Text = "Describe what you want to create"
	descLabel.TextSize = 11
	descLabel.Font = Enum.Font.Gotham
	descLabel.TextXAlignment = Enum.TextXAlignment.Left
	descLabel.Parent = scrollFrame
	
	-- Prompt text box
	PromptEditor.createTextInput(scrollFrame, "PromptInput", "Type your description here...", 100)
	
	-- Type-specific settings
	if generationType == "layout" then
		PromptEditor.createLayoutSettings(scrollFrame)
	elseif generationType == "assets" then
		PromptEditor.createAssetSettings(scrollFrame)
	elseif generationType == "npc" then
		PromptEditor.createNPCSettings(scrollFrame)
	elseif generationType == "script" then
		PromptEditor.createScriptSettings(scrollFrame)
	elseif generationType == "ui" then
		PromptEditor.createUISettings(scrollFrame)
	end
	
	-- Presets/templates
	PromptEditor.createTemplates(scrollFrame, generationType)
	
	-- Generate button
	local generateButton = Instance.new("TextButton")
	generateButton.Name = "GenerateButton"
	generateButton.Size = UDim2.new(1, 0, 0, 40)
	generateButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
	generateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	generateButton.Text = "Generate " .. string.upper(generationType)
	generateButton.TextSize = 12
	generateButton.Font = Enum.Font.GothamMedium
	generateButton.Parent = scrollFrame
	
	generateButton.MouseEnter:Connect(function()
		generateButton.BackgroundColor3 = Color3.fromRGB(120, 220, 120)
	end)
	generateButton.MouseLeave:Connect(function()
		generateButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
	end)
	
	return {
		frame = panel,
		generationType = generationType
	}
end

--[[
	Create text input field
]]
function PromptEditor.createTextInput(parent, name, placeholder, height)
	local container = Instance.new("Frame")
	container.Name = name .. "Container"
	container.Size = UDim2.new(1, 0, 0, height)
	container.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	container.Parent = parent
	
	local textBox = Instance.new("TextBox")
	textBox.Name = name
	textBox.Size = UDim2.new(1, -10, 1, -10)
	textBox.Position = UDim2.new(0, 5, 0, 5)
	textBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	textBox.TextColor3 = Color3.fromRGB(200, 200, 200)
	textBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
	textBox.Text = ""
	textBox.PlaceholderText = placeholder
	textBox.TextSize = 11
	textBox.Font = Enum.Font.Gotham
	textBox.ClearTextOnFocus = false
	textBox.TextWrapped = true
	textBox.TextXAlignment = Enum.TextXAlignment.Left
	textBox.TextYAlignment = Enum.TextYAlignment.Top
	textBox.Parent = container
	
	return textBox
end

--[[
	Create layout-specific settings
]]
function PromptEditor.createLayoutSettings(parent)
	local section = Instance.new("Frame")
	section.Name = "LayoutSettings"
	section.Size = UDim2.new(1, 0, 0, 150)
	section.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	section.Parent = parent
	
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, -10, 0, 20)
	title.Position = UDim2.new(0, 5, 0, 5)
	title.BackgroundTransparency = 1
	title.TextColor3 = Color3.fromRGB(180, 180, 180)
	title.Text = "Layout Settings"
	title.TextSize = 11
	title.Font = Enum.Font.GothamMedium
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = section
	
	-- Layout type selector
	PromptEditor.createSelector(section, "Layout Type", {"Grid", "Organic", "Modular"}, 0, 30)
	
	-- Density slider
	PromptEditor.createSlider(section, "Density", 50, 0, 100, 0, 65)
	
	-- Scale slider
	PromptEditor.createSlider(section, "Scale", 1, 0.5, 2, 0, 100)
end

--[[
	Create asset placement settings
]]
function PromptEditor.createAssetSettings(parent)
	local section = Instance.new("Frame")
	section.Name = "AssetSettings"
	section.Size = UDim2.new(1, 0, 0, 160)
	section.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	section.Parent = parent
	
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, -10, 0, 20)
	title.Position = UDim2.new(0, 5, 0, 5)
	title.BackgroundTransparency = 1
	title.TextColor3 = Color3.fromRGB(180, 180, 180)
	title.Text = "Asset Placement Settings"
	title.TextSize = 11
	title.Font = Enum.Font.GothamMedium
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = section
	
	-- Asset type selector
	PromptEditor.createSelector(section, "Asset Type", {"Decorations", "Structures", "Props"}, 0, 30)
	
	-- Zone type selector
	PromptEditor.createSelector(section, "Zone Type", {"Market", "Residential", "Industrial", "Natural"}, 0, 65)
	
	-- Density slider
	PromptEditor.createSlider(section, "Density", 50, 0, 100, 0, 100)
	
	-- Spacing slider
	PromptEditor.createSlider(section, "Spacing", 10, 1, 30, 0, 135)
end

--[[
	Create NPC-specific settings
]]
function PromptEditor.createNPCSettings(parent)
	local section = Instance.new("Frame")
	section.Name = "NPCSettings"
	section.Size = UDim2.new(1, 0, 0, 120)
	section.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	section.Parent = parent
	
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, -10, 0, 20)
	title.Position = UDim2.new(0, 5, 0, 5)
	title.BackgroundTransparency = 1
	title.TextColor3 = Color3.fromRGB(180, 180, 180)
	title.Text = "NPC Configuration"
	title.TextSize = 11
	title.Font = Enum.Font.GothamMedium
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = section
	
	-- NPC type selector
	PromptEditor.createSelector(section, "NPC Type", {"Patrol", "Stationary", "Interactive"}, 0, 30)
	
	-- Count slider
	PromptEditor.createSlider(section, "NPC Count", 5, 1, 20, 0, 65)
end

--[[
	Create UI analysis and generation settings
]]
function PromptEditor.createUISettings(parent)
	local section = Instance.new("Frame")
	section.Name = "UISettings"
	section.Size = UDim2.new(1, 0, 0, 140)
	section.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	section.Parent = parent
	
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, -10, 0, 20)
	title.Position = UDim2.new(0, 5, 0, 5)
	title.BackgroundTransparency = 1
	title.TextColor3 = Color3.fromRGB(180, 180, 180)
	title.Text = "UI Analysis Settings"
	title.TextSize = 11
	title.Font = Enum.Font.GothamMedium
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = section
	
	-- Analysis mode selector
	PromptEditor.createSelector(section, "Analysis Mode", {"Full Scan", "Layout Only", "Contrast Only"}, 0, 30)
	
	-- Device target selector
	PromptEditor.createSelector(section, "Target Device", {"Mobile", "Tablet", "Desktop"}, 0, 65)
	
	-- Suggestions toggle
	PromptEditor.createSelector(section, "Suggestions", {"Auto Fix", "Report Only"}, 0, 100)
end

--[[
	Create script-specific settings
]]
function PromptEditor.createScriptSettings(parent)
	local section = Instance.new("Frame")
	section.Name = "ScriptSettings"
	section.Size = UDim2.new(1, 0, 0, 120)
	section.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	section.Parent = parent
	
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, -10, 0, 20)
	title.Position = UDim2.new(0, 5, 0, 5)
	title.BackgroundTransparency = 1
	title.TextColor3 = Color3.fromRGB(180, 180, 180)
	title.Text = "Script Configuration"
	title.TextSize = 11
	title.Font = Enum.Font.GothamMedium
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = section
	
	-- Script type selector
	PromptEditor.createSelector(section, "Script Type", {"Server", "Client", "Module"}, 0, 30)
	
	-- Framework selector
	PromptEditor.createSelector(section, "Framework", {"No Framework", "OOP", "FSM"}, 0, 65)
end

--[[
	Create dropdown selector
]]
function PromptEditor.createSelector(parent, label, options, xPos, yPos)
	local container = Instance.new("Frame")
	container.Name = label .. "Selector"
	container.Size = UDim2.new(1, 0, 0, 25)
	container.Position = UDim2.new(0, xPos, 0, yPos)
	container.BackgroundTransparency = 1
	container.Parent = parent
	
	local labelText = Instance.new("TextLabel")
	labelText.Name = "Label"
	labelText.Size = UDim2.new(0.4, 0, 1, 0)
	labelText.BackgroundTransparency = 1
	labelText.TextColor3 = Color3.fromRGB(150, 150, 150)
	labelText.Text = label
	labelText.TextSize = 10
	labelText.Font = Enum.Font.Gotham
	labelText.TextXAlignment = Enum.TextXAlignment.Left
	labelText.Parent = container
	
	local dropdown = Instance.new("TextButton")
	dropdown.Name = "Dropdown"
	dropdown.Size = UDim2.new(0.55, 0, 1, 0)
	dropdown.Position = UDim2.new(0.4, 0, 0, 0)
	dropdown.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	dropdown.TextColor3 = Color3.fromRGB(150, 150, 150)
	dropdown.Text = options[1]
	dropdown.TextSize = 10
	dropdown.Font = Enum.Font.Gotham
	dropdown.Parent = container
end

--[[
	Create slider control
]]
function PromptEditor.createSlider(parent, label, defaultValue, minValue, maxValue, xPos, yPos)
	local container = Instance.new("Frame")
	container.Name = label .. "Slider"
	container.Size = UDim2.new(1, 0, 0, 30)
	container.Position = UDim2.new(0, xPos, 0, yPos)
	container.BackgroundTransparency = 1
	container.Parent = parent
	
	local labelText = Instance.new("TextLabel")
	labelText.Name = "Label"
	labelText.Size = UDim2.new(0.4, 0, 1, 0)
	labelText.BackgroundTransparency = 1
	labelText.TextColor3 = Color3.fromRGB(150, 150, 150)
	labelText.Text = label
	labelText.TextSize = 10
	labelText.Font = Enum.Font.Gotham
	labelText.TextXAlignment = Enum.TextXAlignment.Left
	labelText.Parent = container
	
	local slider = Instance.new("Frame")
	slider.Name = "Slider"
	slider.Size = UDim2.new(0.4, 0, 0, 5)
	slider.Position = UDim2.new(0.4, 0, 0, 12)
	slider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	slider.Parent = container
	
	local fill = Instance.new("Frame")
	fill.Name = "Fill"
	fill.Size = UDim2.new(0.5, 0, 1, 0)
	fill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
	fill.Parent = slider
	
	local valueLabel = Instance.new("TextLabel")
	valueLabel.Name = "Value"
	valueLabel.Size = UDim2.new(0.15, 0, 1, 0)
	valueLabel.Position = UDim2.new(0.85, 0, 0, -7)
	valueLabel.BackgroundTransparency = 1
	valueLabel.TextColor3 = Color3.fromRGB(100, 150, 255)
	valueLabel.Text = tostring(defaultValue)
	valueLabel.TextSize = 10
	valueLabel.Font = Enum.Font.GothamMedium
	valueLabel.Parent = container
end

--[[
	Create templates/presets section
]]
function PromptEditor.createTemplates(parent, generationType)
	local section = Instance.new("Frame")
	section.Name = "Templates"
	section.Size = UDim2.new(1, 0, 0, 100)
	section.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	section.Parent = parent
	
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, -10, 0, 20)
	title.Position = UDim2.new(0, 5, 0, 5)
	title.BackgroundTransparency = 1
	title.TextColor3 = Color3.fromRGB(180, 180, 180)
	title.Text = "Templates"
	title.TextSize = 11
	title.Font = Enum.Font.GothamMedium
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = section
	
	local buttonContainer = Instance.new("Frame")
	buttonContainer.Name = "ButtonContainer"
	buttonContainer.Size = UDim2.new(1, -10, 1, -30)
	buttonContainer.Position = UDim2.new(0, 5, 0, 30)
	buttonContainer.BackgroundTransparency = 1
	buttonContainer.Parent = section
	
	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.Padding = UDim.new(0, 5)
	layout.Parent = buttonContainer
	
	local templates = {"Template 1", "Template 2", "Template 3"}
	
	for _, templateName in ipairs(templates) do
		local button = Instance.new("TextButton")
		button.Name = templateName
		button.Size = UDim2.new(0, 80, 0, 25)
		button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		button.TextColor3 = Color3.fromRGB(150, 150, 150)
		button.Text = templateName
		button.TextSize = 9
		button.Font = Enum.Font.Gotham
		button.Parent = buttonContainer
		
		button.MouseEnter:Connect(function()
			button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
		end)
		button.MouseLeave:Connect(function()
			button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		end)
	end
end

return PromptEditor
