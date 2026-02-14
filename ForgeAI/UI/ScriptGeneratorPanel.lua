--[[
	ScriptGeneratorPanel.lua
	Script generation panel with templates and configuration
	Generates clean server/client scripts and UI templates
]]

local ScriptGeneratorPanel = {}

function ScriptGeneratorPanel.create(parent, onGenerateScripts)
	local container = Instance.new("Frame")
	container.Name = "ScriptGeneratorPanel"
	container.Size = UDim2.new(1, 0, 1, 0)
	container.BackgroundTransparency = 1
	container.Parent = parent

	-- Header
	local header = Instance.new("Frame")
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0, 40)
	header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	header.BorderSizePixel = 0
	header.Parent = container

	local headerLabel = Instance.new("TextLabel")
	headerLabel.Size = UDim2.new(1, -8, 1, 0)
	headerLabel.Position = UDim2.new(0, 8, 0, 0)
	headerLabel.BackgroundTransparency = 1
	headerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	headerLabel.TextSize = 14
	headerLabel.Font = Enum.Font.GothamBold
	headerLabel.TextXAlignment = Enum.TextXAlignment.Left
	headerLabel.Text = "Script Generator"
	headerLabel.Parent = header

	-- Content scroll
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Name = "Content"
	scrollFrame.Size = UDim2.new(1, 0, 1, -40)
	scrollFrame.Position = UDim2.new(0, 0, 0, 40)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.BorderSizePixel = 0
	scrollFrame.ScrollBarThickness = 6
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollFrame.Parent = container

	local scrollLayout = Instance.new("UIListLayout")
	scrollLayout.Padding = UDim.new(0, 12)
	scrollLayout.FillDirection = Enum.FillDirection.Vertical
	scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
	scrollLayout.Parent = scrollFrame

	-- Script Type Selection
	local typeSection = Instance.new("Frame")
	typeSection.Name = "TypeSection"
	typeSection.Size = UDim2.new(1, -16, 0, 140)
	typeSection.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	typeSection.BorderSizePixel = 0
	typeSection.LayoutOrder = 1
	typeSection.Parent = scrollFrame

	local typeCorner = Instance.new("UICorner")
	typeCorner.CornerRadius = UDim.new(0, 6)
	typeCorner.Parent = typeSection

	local typeLabel = Instance.new("TextLabel")
	typeLabel.Name = "Label"
	typeLabel.Size = UDim2.new(1, -8, 0, 20)
	typeLabel.Position = UDim2.new(0, 8, 0, 8)
	typeLabel.BackgroundTransparency = 1
	typeLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	typeLabel.TextSize = 12
	typeLabel.Font = Enum.Font.GothamBold
	typeLabel.Text = "Script Types to Generate"
	typeLabel.Parent = typeSection

	-- Checkboxes for script types
	local scriptTypes = {
		{ name = "Server Script", checked = true, color = Color3.fromRGB(100, 200, 100) },
		{ name = "Local Script", checked = true, color = Color3.fromRGB(100, 150, 255) },
		{ name = "ModuleScript", checked = false, color = Color3.fromRGB(255, 200, 100) },
		{ name = "UI Templates", checked = false, color = Color3.fromRGB(255, 150, 200) },
	}

	for idx, scriptType in ipairs(scriptTypes) do
		local checkbox = Instance.new("Frame")
		checkbox.Name = scriptType.name
		checkbox.Size = UDim2.new(1, -16, 0, 24)
		checkbox.Position = UDim2.new(0, 8, 0, 28 + (idx - 1) * 26)
		checkbox.BackgroundTransparency = 1
		checkbox.Parent = typeSection

		local checkBox = Instance.new("TextButton")
		checkBox.Name = "CheckBox"
		checkBox.Size = UDim2.new(0, 16, 0, 16)
		checkBox.Position = UDim2.new(0, 0, 0.5, -8)
		checkBox.BackgroundColor3 = scriptType.checked and scriptType.color or Color3.fromRGB(45, 45, 45)
		checkBox.BorderSizePixel = 0
		checkBox.Text = ""
		checkBox.Parent = checkbox

		local checkCorner = Instance.new("UICorner")
		checkCorner.CornerRadius = UDim.new(0, 2)
		checkCorner.Parent = checkBox

		local checkMark = Instance.new("TextLabel")
		checkMark.Name = "Checkmark"
		checkMark.Size = UDim2.new(1, 0, 1, 0)
		checkMark.BackgroundTransparency = 1
		checkMark.TextColor3 = Color3.fromRGB(255, 255, 255)
		checkMark.TextSize = 12
		checkMark.Font = Enum.Font.GothamBold
		checkMark.Text = scriptType.checked and "✓" or ""
		checkMark.Parent = checkBox

		local textLabel = Instance.new("TextLabel")
		textLabel.Name = "Label"
		textLabel.Size = UDim2.new(1, -24, 1, 0)
		textLabel.Position = UDim2.new(0, 20, 0, 0)
		textLabel.BackgroundTransparency = 1
		textLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
		textLabel.TextSize = 11
		textLabel.Font = Enum.Font.Gotham
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		textLabel.Text = scriptType.name
		textLabel.Parent = checkbox

		-- Toggle functionality
		checkBox.MouseButton1Click:Connect(function()
			scriptType.checked = not scriptType.checked
			checkMark.Text = scriptType.checked and "✓" or ""
			checkBox.BackgroundColor3 = scriptType.checked and scriptType.color or Color3.fromRGB(45, 45, 45)
		end)
	end

	-- Framework Selection
	local frameworkSection = Instance.new("Frame")
	frameworkSection.Name = "FrameworkSection"
	frameworkSection.Size = UDim2.new(1, -16, 0, 100)
	frameworkSection.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	frameworkSection.BorderSizePixel = 0
	frameworkSection.LayoutOrder = 2
	frameworkSection.Parent = scrollFrame

	local frameworkCorner = Instance.new("UICorner")
	frameworkCorner.CornerRadius = UDim.new(0, 6)
	frameworkCorner.Parent = frameworkSection

	local frameworkLabel = Instance.new("TextLabel")
	frameworkLabel.Name = "Label"
	frameworkLabel.Size = UDim2.new(1, -8, 0, 20)
	frameworkLabel.Position = UDim2.new(0, 8, 0, 8)
	frameworkLabel.BackgroundTransparency = 1
	frameworkLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	frameworkLabel.TextSize = 12
	frameworkLabel.Font = Enum.Font.GothamBold
	frameworkLabel.Text = "Script Framework"
	frameworkLabel.Parent = frameworkSection

	local frameworkDropdown = Instance.new("TextButton")
	frameworkDropdown.Name = "FrameworkDropdown"
	frameworkDropdown.Size = UDim2.new(1, -16, 0, 28)
	frameworkDropdown.Position = UDim2.new(0, 8, 0, 32)
	frameworkDropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	frameworkDropdown.BorderSizePixel = 0
	frameworkDropdown.TextColor3 = Color3.fromRGB(200, 200, 200)
	frameworkDropdown.TextSize = 11
	frameworkDropdown.Font = Enum.Font.Gotham
	frameworkDropdown.Text = "Clean Architecture (Recommended) ▼"
	frameworkDropdown.Parent = frameworkSection

	local frameworkCorner2 = Instance.new("UICorner")
	frameworkCorner2.CornerRadius = UDim.new(0, 4)
	frameworkCorner2.Parent = frameworkDropdown

	local frameworkInfo = Instance.new("TextLabel")
	frameworkInfo.Size = UDim2.new(1, -16, 0, 32)
	frameworkInfo.Position = UDim2.new(0, 8, 0, 64)
	frameworkInfo.BackgroundTransparency = 1
	frameworkInfo.TextColor3 = Color3.fromRGB(150, 150, 150)
	frameworkInfo.TextSize = 9
	frameworkInfo.Font = Enum.Font.Gotham
	frameworkInfo.TextWrapping = true
	frameworkInfo.Text = "Service-oriented with ReplicatedStorage for shared modules and clean RemoteEvent patterns"
	frameworkInfo.Parent = frameworkSection

	-- Configuration Section
	local configSection = Instance.new("Frame")
	configSection.Name = "ConfigSection"
	configSection.Size = UDim2.new(1, -16, 0, 120)
	configSection.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	configSection.BorderSizePixel = 0
	configSection.LayoutOrder = 3
	configSection.Parent = scrollFrame

	local configCorner = Instance.new("UICorner")
	configCorner.CornerRadius = UDim.new(0, 6)
	configCorner.Parent = configSection

	local configLabel = Instance.new("TextLabel")
	configLabel.Name = "Label"
	configLabel.Size = UDim2.new(1, -8, 0, 20)
	configLabel.Position = UDim2.new(0, 8, 0, 8)
	configLabel.BackgroundTransparency = 1
	configLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	configLabel.TextSize = 12
	configLabel.Font = Enum.Font.GothamBold
	configLabel.Text = "Configuration"
	configLabel.Parent = configSection

	local configOptions = {
		"Auto-format code",
		"Include comments",
		"Add error handling",
		"Use typed code style"
	}

	for idx, option in ipairs(configOptions) do
		local optionFrame = Instance.new("Frame")
		optionFrame.Name = option
		optionFrame.Size = UDim2.new(0.5, -6, 0, 20)
		optionFrame.Position = UDim2.new((idx - 1) % 2 * 0.5 + 0.02, 0, 0.5 + math.floor((idx - 1) / 2) * 0.25, 0)
		optionFrame.BackgroundTransparency = 1
		optionFrame.Parent = configSection

		local checkbox = Instance.new("TextButton")
		checkbox.Name = "Checkbox"
		checkbox.Size = UDim2.new(0, 12, 0, 12)
		checkbox.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
		checkbox.BorderSizePixel = 0
		checkbox.Text = ""
		checkbox.Parent = optionFrame

		local cbCorner = Instance.new("UICorner")
		cbCorner.CornerRadius = UDim.new(0, 2)
		cbCorner.Parent = checkbox

		local label = Instance.new("TextLabel")
		label.Name = "Label"
		label.Size = UDim2.new(1, -16, 1, 0)
		label.Position = UDim2.new(0, 16, 0, 0)
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.fromRGB(180, 180, 180)
		label.TextSize = 9
		label.Font = Enum.Font.Gotham
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Text = option
		label.Parent = optionFrame
	end

	-- Generate button
	local generateBtn = Instance.new("TextButton")
	generateBtn.Name = "GenerateBtn"
	generateBtn.Size = UDim2.new(1, -16, 0, 36)
	generateBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 255)
	generateBtn.BorderSizePixel = 0
	generateBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	generateBtn.TextSize = 12
	generateBtn.Font = Enum.Font.GothamBold
	generateBtn.Text = "Generate Scripts"
	generateBtn.LayoutOrder = 4
	generateBtn.Parent = scrollFrame

	local generateCorner = Instance.new("UICorner")
	generateCorner.CornerRadius = UDim.new(0, 4)
	generateCorner.Parent = generateBtn

	-- Update canvas
	scrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		scrollFrame.CanvasSize = UDim2.new(0, 0, 0, scrollLayout.AbsoluteContentSize.Y + 16)
	end)

	-- Button handlers
	generateBtn.MouseButton1Click:Connect(function()
		generateBtn.Text = "Generating..."
		generateBtn.BackgroundColor3 = Color3.fromRGB(180, 120, 200)
		if onGenerateScripts then
			onGenerateScripts()
		end
	end)

	return {
		frame = container,
		getSelectedTypes = function(self)
			local selected = {}
			for _, scriptType in ipairs(scriptTypes) do
				if scriptType.checked then
					table.insert(selected, scriptType.name)
				end
			end
			return selected
		end,
		enableGeneration = function(self)
			generateBtn.Text = "Generate Scripts"
			generateBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 255)
		end
	}
end

return ScriptGeneratorPanel
