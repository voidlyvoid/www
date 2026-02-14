--[[
	OptimizationPanel - UI for applying and managing optimizations
	Allows users to configure and apply auto-optimization with dry-run preview
]]

local OptimizationPanel = {}
local OptimizationEngine = require(script.Parent.Parent.Core.OptimizationEngine)

--[[
	Create optimization panel
]]
function OptimizationPanel.create(parent)
	local panel = Instance.new("Frame")
	panel.Name = "OptimizationPanel"
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
	titleBar.Text = "Optimization Engine"
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
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
	scrollFrame.Parent = panel
	
	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Stretch
	layout.VerticalAlignment = Enum.VerticalAlignment.Top
	layout.Padding = UDim.new(0, 10)
	layout.Parent = scrollFrame
	
	-- Create optimization options
	OptimizationPanel.createCheckboxOption(scrollFrame, "Disable Shadows", true, 
		"Remove CanCastShadow from non-critical parts")
	OptimizationPanel.createCheckboxOption(scrollFrame, "Disable Physics", false,
		"Set CanCollide = false on decorative parts")
	OptimizationPanel.createCheckboxOption(scrollFrame, "Merge Static Parts", true,
		"Combine adjacent static geometry")
	OptimizationPanel.createCheckboxOption(scrollFrame, "Convert Meshes", false,
		"Replace complex meshes with primitives")
	
	-- Add dry-run checkbox
	OptimizationPanel.createCheckboxOption(scrollFrame, "Dry Run", true,
		"Preview changes without applying them")
	
	-- Add preset buttons
	OptimizationPanel.createPresetSection(scrollFrame)
	
	-- Add LOD suggestions section
	OptimizationPanel.createLODSection(scrollFrame)
	
	-- Add apply buttons
	OptimizationPanel.createActionButtons(scrollFrame)
	
	return {
		frame = panel
	}
end

--[[
	Create checkbox configuration option
]]
function OptimizationPanel.createCheckboxOption(parent, labelText, defaultChecked, description)
	local container = Instance.new("Frame")
	container.Name = labelText
	container.Size = UDim2.new(1, 0, 0, 70)
	container.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	container.Parent = parent
	
	-- Checkbox
	local checkbox = Instance.new("TextButton")
	checkbox.Name = "Checkbox"
	checkbox.Size = UDim2.new(0, 20, 0, 20)
	checkbox.Position = UDim2.new(0, 10, 0, 10)
	checkbox.BackgroundColor3 = defaultChecked and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(60, 60, 60)
	checkbox.TextColor3 = Color3.fromRGB(255, 255, 255)
	checkbox.Text = defaultChecked and "✓" or ""
	checkbox.TextSize = 16
	checkbox.Font = Enum.Font.GothamBold
	checkbox.Parent = container
	
	-- Label
	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Size = UDim2.new(1, -50, 0, 20)
	label.Position = UDim2.new(0, 35, 0, 10)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(200, 200, 200)
	label.Text = labelText
	label.TextSize = 12
	label.Font = Enum.Font.GothamMedium
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container
	
	-- Description
	local desc = Instance.new("TextLabel")
	desc.Name = "Description"
	desc.Size = UDim2.new(1, -40, 0, 35)
	desc.Position = UDim2.new(0, 35, 0, 32)
	desc.BackgroundTransparency = 1
	desc.TextColor3 = Color3.fromRGB(120, 120, 120)
	desc.Text = description
	desc.TextSize = 10
	desc.Font = Enum.Font.Gotham
	desc.TextWrapped = true
	desc.TextXAlignment = Enum.TextXAlignment.Left
	desc.TextYAlignment = Enum.TextYAlignment.Top
	desc.Parent = container
	
	-- Toggle on click
	local isChecked = defaultChecked
	checkbox.MouseButton1Click:Connect(function()
		isChecked = not isChecked
		checkbox.BackgroundColor3 = isChecked and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(60, 60, 60)
		checkbox.Text = isChecked and "✓" or ""
	end)
	
	return container
end

--[[
	Create preset optimization section
]]
function OptimizationPanel.createPresetSection(parent)
	local section = Instance.new("Frame")
	section.Name = "PresetsSection"
	section.Size = UDim2.new(1, 0, 0, 100)
	section.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	section.Parent = parent
	
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, -10, 0, 20)
	title.Position = UDim2.new(0, 5, 0, 5)
	title.BackgroundTransparency = 1
	title.TextColor3 = Color3.fromRGB(180, 180, 180)
	title.Text = "Optimization Presets"
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
	
	local presets = {"Conservative", "Balanced", "Aggressive"}
	
	for _, presetName in ipairs(presets) do
		local button = Instance.new("TextButton")
		button.Name = presetName
		button.Size = UDim2.new(0, 85, 0, 25)
		button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		button.TextColor3 = Color3.fromRGB(150, 150, 150)
		button.Text = presetName
		button.TextSize = 10
		button.Font = Enum.Font.GothamMedium
		button.Parent = buttonContainer
		
		button.MouseEnter:Connect(function()
			button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
		end)
		button.MouseLeave:Connect(function()
			button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		end)
	end
end

--[[
	Create LOD suggestions section
]]
function OptimizationPanel.createLODSection(parent)
	local section = Instance.new("Frame")
	section.Name = "LODSection"
	section.Size = UDim2.new(1, 0, 0, 120)
	section.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	section.Parent = parent
	
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, -10, 0, 20)
	title.Position = UDim2.new(0, 5, 0, 5)
	title.BackgroundTransparency = 1
	title.TextColor3 = Color3.fromRGB(180, 180, 180)
	title.Text = "LOD (Level of Detail) Suggestions"
	title.TextSize = 11
	title.Font = Enum.Font.GothamMedium
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = section
	
	local infoContainer = Instance.new("Frame")
	infoContainer.Name = "InfoContainer"
	infoContainer.Size = UDim2.new(1, -10, 1, -30)
	infoContainer.Position = UDim2.new(0, 5, 0, 30)
	infoContainer.BackgroundTransparency = 1
	infoContainer.Parent = section
	
	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Stretch
	layout.VerticalAlignment = Enum.VerticalAlignment.Top
	layout.Padding = UDim.new(0, 3)
	layout.Parent = infoContainer
	
	local lodLevels = {
		{label = "Close (0-50 studs)", color = Color3.fromRGB(100, 200, 100)},
		{label = "Medium (50-200 studs)", color = Color3.fromRGB(255, 200, 100)},
		{label = "Far (200+ studs)", color = Color3.fromRGB(255, 100, 100)}
	}
	
	for _, lod in ipairs(lodLevels) do
		local item = Instance.new("TextLabel")
		item.Name = lod.label
		item.Size = UDim2.new(1, 0, 0, 20)
		item.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		item.TextColor3 = lod.color
		item.Text = "◆ " .. lod.label
		item.TextSize = 10
		item.Font = Enum.Font.Gotham
		item.TextXAlignment = Enum.TextXAlignment.Left
		item.Parent = infoContainer
	end
end

--[[
	Create action buttons
]]
function OptimizationPanel.createActionButtons(parent)
	local container = Instance.new("Frame")
	container.Name = "ActionButtons"
	container.Size = UDim2.new(1, 0, 0, 70)
	container.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	container.Parent = parent
	
	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Stretch
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.Padding = UDim.new(0, 5)
	layout.Parent = container
	
	-- Preview button
	local previewButton = Instance.new("TextButton")
	previewButton.Name = "PreviewButton"
	previewButton.Size = UDim2.new(1, -10, 0, 30)
	previewButton.Position = UDim2.new(0, 5, 0, 0)
	previewButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
	previewButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	previewButton.Text = "Preview Changes (Dry Run)"
	previewButton.TextSize = 11
	previewButton.Font = Enum.Font.GothamMedium
	previewButton.Parent = container
	
	previewButton.MouseEnter:Connect(function()
		previewButton.BackgroundColor3 = Color3.fromRGB(120, 170, 255)
	end)
	previewButton.MouseLeave:Connect(function()
		previewButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
	end)
	
	-- Apply button
	local applyButton = Instance.new("TextButton")
	applyButton.Name = "ApplyButton"
	applyButton.Size = UDim2.new(1, -10, 0, 30)
	applyButton.Position = UDim2.new(0, 5, 0, 35)
	applyButton.BackgroundColor3 = Color3.fromRGB(150, 100, 255)
	applyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	applyButton.Text = "Apply Optimization"
	applyButton.TextSize = 11
	applyButton.Font = Enum.Font.GothamMedium
	applyButton.Parent = container
	
	applyButton.MouseEnter:Connect(function()
		applyButton.BackgroundColor3 = Color3.fromRGB(170, 120, 255)
	end)
	applyButton.MouseLeave:Connect(function()
		applyButton.BackgroundColor3 = Color3.fromRGB(150, 100, 255)
	end)
end

return OptimizationPanel
