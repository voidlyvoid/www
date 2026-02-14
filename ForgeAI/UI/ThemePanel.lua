--[[
	ThemePanel.lua
	Theme analysis and application panel
	Analyzes materials, colors, and lighting for theme detection
]]

local ThemePanel = {}

function ThemePanel.create(parent, onApplyTheme)
	local container = Instance.new("Frame")
	container.Name = "ThemePanel"
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
	headerLabel.Text = "Theme Intelligence"
	headerLabel.Parent = header

	-- Analyze button
	local analyzeBtn = Instance.new("TextButton")
	analyzeBtn.Name = "AnalyzeBtn"
	analyzeBtn.Size = UDim2.new(0, 100, 0, 32)
	analyzeBtn.Position = UDim2.new(1, -108, 0, 4)
	analyzeBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
	analyzeBtn.BorderSizePixel = 0
	analyzeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	analyzeBtn.TextSize = 12
	analyzeBtn.Font = Enum.Font.GothamBold
	analyzeBtn.Text = "Analyze"
	analyzeBtn.Parent = header

	local analyzeCorner = Instance.new("UICorner")
	analyzeCorner.CornerRadius = UDim.new(0, 4)
	analyzeCorner.Parent = analyzeBtn

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

	-- Detected Theme Section
	local themeSection = Instance.new("Frame")
	themeSection.Name = "ThemeSection"
	themeSection.Size = UDim2.new(1, -16, 0, 100)
	themeSection.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	themeSection.BorderSizePixel = 0
	themeSection.LayoutOrder = 1
	themeSection.Parent = scrollFrame

	local themeCorner = Instance.new("UICorner")
	themeCorner.CornerRadius = UDim.new(0, 6)
	themeCorner.Parent = themeSection

	local themeLabel = Instance.new("TextLabel")
	themeLabel.Name = "Label"
	themeLabel.Size = UDim2.new(1, -8, 0, 20)
	themeLabel.Position = UDim2.new(0, 8, 0, 8)
	themeLabel.BackgroundTransparency = 1
	themeLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	themeLabel.TextSize = 11
	themeLabel.Font = Enum.Font.GothamBold
	themeLabel.Text = "Detected Theme"
	themeLabel.Parent = themeSection

	local themeNameLabel = Instance.new("TextLabel")
	themeNameLabel.Name = "ThemeName"
	themeNameLabel.Size = UDim2.new(1, -16, 0, 30)
	themeNameLabel.Position = UDim2.new(0, 8, 0, 32)
	themeNameLabel.BackgroundTransparency = 1
	themeNameLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
	themeNameLabel.TextSize = 16
	themeNameLabel.Font = Enum.Font.GothamBold
	themeNameLabel.Text = "None (Analyze workspace)"
	themeNameLabel.TextWrapping = true
	themeNameLabel.Parent = themeSection

	-- Color Palette Section
	local paletteSection = Instance.new("Frame")
	paletteSection.Name = "PaletteSection"
	paletteSection.Size = UDim2.new(1, -16, 0, 140)
	paletteSection.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	paletteSection.BorderSizePixel = 0
	paletteSection.LayoutOrder = 2
	paletteSection.Parent = scrollFrame

	local paletteCorner = Instance.new("UICorner")
	paletteCorner.CornerRadius = UDim.new(0, 6)
	paletteCorner.Parent = paletteSection

	local paletteLabel = Instance.new("TextLabel")
	paletteLabel.Name = "Label"
	paletteLabel.Size = UDim2.new(1, -8, 0, 20)
	paletteLabel.Position = UDim2.new(0, 8, 0, 8)
	paletteLabel.BackgroundTransparency = 1
	paletteLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	paletteLabel.TextSize = 11
	paletteLabel.Font = Enum.Font.GothamBold
	paletteLabel.Text = "Color Palette"
	paletteLabel.Parent = paletteSection

	-- Color swatches
	local swatchContainer = Instance.new("Frame")
	swatchContainer.Name = "Swatches"
	swatchContainer.Size = UDim2.new(1, -16, 0, 100)
	swatchContainer.Position = UDim2.new(0, 8, 0, 32)
	swatchContainer.BackgroundTransparency = 1
	swatchContainer.Parent = paletteSection

	local swatchLayout = Instance.new("UIGridLayout")
	swatchLayout.CellSize = UDim2.new(0, 50, 0, 50)
	swatchLayout.CellPadding = UDim2.new(0, 8, 0, 8)
	swatchLayout.FillDirection = Enum.FillDirection.Horizontal
	swatchLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	swatchLayout.SortOrder = Enum.SortOrder.LayoutOrder
	swatchLayout.Parent = swatchContainer

	-- Material Analysis Section
	local materialsSection = Instance.new("Frame")
	materialsSection.Name = "MaterialsSection"
	materialsSection.Size = UDim2.new(1, -16, 0, 120)
	materialsSection.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	materialsSection.BorderSizePixel = 0
	materialsSection.LayoutOrder = 3
	materialsSection.Parent = scrollFrame

	local materialsCorner = Instance.new("UICorner")
	materialsCorner.CornerRadius = UDim.new(0, 6)
	materialsCorner.Parent = materialsSection

	local materialsLabel = Instance.new("TextLabel")
	materialsLabel.Name = "Label"
	materialsLabel.Size = UDim2.new(1, -8, 0, 20)
	materialsLabel.Position = UDim2.new(0, 8, 0, 8)
	materialsLabel.BackgroundTransparency = 1
	materialsLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	materialsLabel.TextSize = 11
	materialsLabel.Font = Enum.Font.GothamBold
	materialsLabel.Text = "Top Materials"
	materialsLabel.Parent = materialsSection

	local materialsList = Instance.new("ScrollingFrame")
	materialsList.Name = "List"
	materialsList.Size = UDim2.new(1, -16, 0, 90)
	materialsList.Position = UDim2.new(0, 8, 0, 28)
	materialsList.BackgroundTransparency = 1
	materialsList.BorderSizePixel = 0
	materialsList.ScrollBarThickness = 4
	materialsList.CanvasSize = UDim2.new(0, 0, 0, 0)
	materialsList.Parent = materialsSection

	local materialsLayout = Instance.new("UIListLayout")
	materialsLayout.Padding = UDim.new(0, 4)
	materialsLayout.FillDirection = Enum.FillDirection.Vertical
	materialsLayout.SortOrder = Enum.SortOrder.LayoutOrder
	materialsLayout.Parent = materialsList

	-- Lighting Profile Section
	local lightingSection = Instance.new("Frame")
	lightingSection.Name = "LightingSection"
	lightingSection.Size = UDim2.new(1, -16, 0, 80)
	lightingSection.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	lightingSection.BorderSizePixel = 0
	lightingSection.LayoutOrder = 4
	lightingSection.Parent = scrollFrame

	local lightingCorner = Instance.new("UICorner")
	lightingCorner.CornerRadius = UDim.new(0, 6)
	lightingCorner.Parent = lightingSection

	local lightingLabel = Instance.new("TextLabel")
	lightingLabel.Name = "Label"
	lightingLabel.Size = UDim2.new(1, -8, 0, 20)
	lightingLabel.Position = UDim2.new(0, 8, 0, 8)
	lightingLabel.BackgroundTransparency = 1
	lightingLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	lightingLabel.TextSize = 11
	lightingLabel.Font = Enum.Font.GothamBold
	lightingLabel.Text = "Lighting Profile"
	lightingLabel.Parent = lightingSection

	local lightingInfo = Instance.new("TextLabel")
	lightingInfo.Name = "Info"
	lightingInfo.Size = UDim2.new(1, -16, 0, 50)
	lightingInfo.Position = UDim2.new(0, 8, 0, 28)
	lightingInfo.BackgroundTransparency = 1
	lightingInfo.TextColor3 = Color3.fromRGB(150, 150, 150)
	lightingInfo.TextSize = 11
	lightingInfo.Font = Enum.Font.Gotham
	lightingInfo.TextWrapping = true
	lightingInfo.Text = "No analysis yet"
	lightingInfo.Parent = lightingSection

	-- Apply Preset button
	local applyBtn = Instance.new("TextButton")
	applyBtn.Name = "ApplyBtn"
	applyBtn.Size = UDim2.new(1, -16, 0, 32)
	applyBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 150)
	applyBtn.BorderSizePixel = 0
	applyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	applyBtn.TextSize = 12
	applyBtn.Font = Enum.Font.GothamBold
	applyBtn.Text = "Apply Theme"
	applyBtn.LayoutOrder = 5
	applyBtn.Parent = scrollFrame

	local applyCorner = Instance.new("UICorner")
	applyCorner.CornerRadius = UDim.new(0, 4)
	applyCorner.Parent = applyBtn

	-- Update canvas
	scrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		scrollFrame.CanvasSize = UDim2.new(0, 0, 0, scrollLayout.AbsoluteContentSize.Y + 16)
	end)

	-- Button handlers
	analyzeBtn.MouseButton1Click:Connect(function()
		analyzeBtn.Text = "Analyzing..."
		analyzeBtn.BackgroundColor3 = Color3.fromRGB(150, 180, 200)
		analyzeBtn.TextEditable = false
		-- Analysis will be handled by ThemeAnalyzer engine
	end)

	applyBtn.MouseButton1Click:Connect(function()
		if onApplyTheme then
			onApplyTheme()
		end
	end)

	return {
		frame = container,
		updateTheme = function(self, themeName)
			themeNameLabel.Text = themeName or "Unknown"
		end,
		updatePalette = function(self, colors)
			-- Clear existing swatches
			for _, swatch in ipairs(swatchContainer:GetChildren()) do
				if swatch:IsA("Frame") then
					swatch:Destroy()
				end
			end
			-- Add new swatches
			if colors then
				for idx, color in ipairs(colors) do
					local swatch = Instance.new("Frame")
					swatch.Size = UDim2.new(1, 0, 1, 0)
					swatch.BackgroundColor3 = color
					swatch.BorderSizePixel = 0
					swatch.LayoutOrder = idx
					swatch.Parent = swatchContainer
					local corner = Instance.new("UICorner")
					corner.CornerRadius = UDim.new(0, 4)
					corner.Parent = swatch
				end
			end
		end,
		updateMaterials = function(self, materials)
			-- Clear existing
			for _, mat in ipairs(materialsList:GetChildren()) do
				if mat:IsA("TextLabel") then
					mat:Destroy()
				end
			end
			-- Add materials
			if materials then
				for idx, mat in ipairs(materials) do
					local label = Instance.new("TextLabel")
					label.Size = UDim2.new(1, 0, 0, 20)
					label.BackgroundTransparency = 1
					label.TextColor3 = Color3.fromRGB(180, 180, 180)
					label.TextSize = 10
					label.Font = Enum.Font.Gotham
					label.TextXAlignment = Enum.TextXAlignment.Left
					label.Text = (idx) .. ". " .. (mat or "Unknown")
					label.LayoutOrder = idx
					label.Parent = materialsList
				end
			end
		end,
		updateLighting = function(self, profile)
			lightingInfo.Text = profile or "No analysis yet"
		end
	}
end

return ThemePanel
