--[[
	NPCPanel.lua
	NPC pathfinding and routing configuration panel
	Manages patrol paths, interaction zones, and cover points
]]

local NPCPanel = {}

function NPCPanel.create(parent, onGeneratePaths)
	local container = Instance.new("Frame")
	container.Name = "NPCPanel"
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
	headerLabel.Text = "NPC Paths & Zones"
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

	-- Patrol Path Section
	local patrolSection = Instance.new("Frame")
	patrolSection.Name = "PatrolSection"
	patrolSection.Size = UDim2.new(1, -16, 0, 140)
	patrolSection.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	patrolSection.BorderSizePixel = 0
	patrolSection.LayoutOrder = 1
	patrolSection.Parent = scrollFrame

	local patrolCorner = Instance.new("UICorner")
	patrolCorner.CornerRadius = UDim.new(0, 6)
	patrolCorner.Parent = patrolSection

	local patrolLabel = Instance.new("TextLabel")
	patrolLabel.Name = "Label"
	patrolLabel.Size = UDim2.new(1, -8, 0, 20)
	patrolLabel.Position = UDim2.new(0, 8, 0, 8)
	patrolLabel.BackgroundTransparency = 1
	patrolLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	patrolLabel.TextSize = 12
	patrolLabel.Font = Enum.Font.GothamBold
	patrolLabel.Text = "Patrol Route Settings"
	patrolLabel.Parent = patrolSection

	-- Route type selection
	local routeTypeLabel = Instance.new("TextLabel")
	routeTypeLabel.Size = UDim2.new(1, -16, 0, 16)
	routeTypeLabel.Position = UDim2.new(0, 8, 0, 30)
	routeTypeLabel.BackgroundTransparency = 1
	routeTypeLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
	routeTypeLabel.TextSize = 10
	routeTypeLabel.Font = Enum.Font.Gotham
	routeTypeLabel.TextXAlignment = Enum.TextXAlignment.Left
	routeTypeLabel.Text = "Route Type:"
	routeTypeLabel.Parent = patrolSection

	-- Route type dropdown
	local routeOptions = {"Loop", "Linear", "Random"}
	local routeDropdown = Instance.new("TextButton")
	routeDropdown.Name = "RouteTypeDropdown"
	routeDropdown.Size = UDim2.new(1, -16, 0, 24)
	routeDropdown.Position = UDim2.new(0, 8, 0, 48)
	routeDropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	routeDropdown.BorderSizePixel = 0
	routeDropdown.TextColor3 = Color3.fromRGB(200, 200, 200)
	routeDropdown.TextSize = 11
	routeDropdown.Font = Enum.Font.Gotham
	routeDropdown.Text = "Loop ▼"
	routeDropdown.Parent = patrolSection

	local routeCorner = Instance.new("UICorner")
	routeCorner.CornerRadius = UDim.new(0, 4)
	routeCorner.Parent = routeDropdown

	-- Waypoint count
	local waypointLabel = Instance.new("TextLabel")
	waypointLabel.Size = UDim2.new(1, -16, 0, 16)
	waypointLabel.Position = UDim2.new(0, 8, 0, 78)
	waypointLabel.BackgroundTransparency = 1
	waypointLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
	waypointLabel.TextSize = 10
	waypointLabel.Font = Enum.Font.Gotham
	waypointLabel.TextXAlignment = Enum.TextXAlignment.Left
	waypointLabel.Text = "Waypoints: 5"
	waypointLabel.Parent = patrolSection

	local waypointSlider = Instance.new("Frame")
	waypointSlider.Name = "WaypointSlider"
	waypointSlider.Size = UDim2.new(1, -16, 0, 18)
	waypointSlider.Position = UDim2.new(0, 8, 0, 96)
	waypointSlider.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	waypointSlider.BorderSizePixel = 0
	waypointSlider.Parent = patrolSection

	local sliderCorner = Instance.new("UICorner")
	sliderCorner.CornerRadius = UDim.new(0, 3)
	sliderCorner.Parent = waypointSlider

	-- Interaction Zones Section
	local interactionSection = Instance.new("Frame")
	interactionSection.Name = "InteractionSection"
	interactionSection.Size = UDim2.new(1, -16, 0, 120)
	interactionSection.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	interactionSection.BorderSizePixel = 0
	interactionSection.LayoutOrder = 2
	interactionSection.Parent = scrollFrame

	local interactionCorner = Instance.new("UICorner")
	interactionCorner.CornerRadius = UDim.new(0, 6)
	interactionCorner.Parent = interactionSection

	local interactionLabel = Instance.new("TextLabel")
	interactionLabel.Name = "Label"
	interactionLabel.Size = UDim2.new(1, -8, 0, 20)
	interactionLabel.Position = UDim2.new(0, 8, 0, 8)
	interactionLabel.BackgroundTransparency = 1
	interactionLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	interactionLabel.TextSize = 12
	interactionLabel.Font = Enum.Font.GothamBold
	interactionLabel.Text = "Interaction Zones"
	interactionLabel.Parent = interactionSection

	-- Zone settings
	local zoneInfo = Instance.new("TextLabel")
	zoneInfo.Size = UDim2.new(1, -16, 0, 90)
	zoneInfo.Position = UDim2.new(0, 8, 0, 28)
	zoneInfo.BackgroundTransparency = 1
	zoneInfo.TextColor3 = Color3.fromRGB(150, 150, 150)
	zoneInfo.TextSize = 11
	zoneInfo.Font = Enum.Font.Gotham
	zoneInfo.TextWrapping = true
	zoneInfo.TextXAlignment = Enum.TextXAlignment.Left
	zoneInfo.TextYAlignment = Enum.TextYAlignment.Top
	zoneInfo.Text = "Enable detection of market stalls, vendor zones, and talk zones.\n\nInteraction radius: 10 studs\nDetection: Automatic"
	zoneInfo.Parent = interactionSection

	-- Cover Points Section
	local coverSection = Instance.new("Frame")
	coverSection.Name = "CoverSection"
	coverSection.Size = UDim2.new(1, -16, 0, 100)
	coverSection.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	coverSection.BorderSizePixel = 0
	coverSection.LayoutOrder = 3
	coverSection.Parent = scrollFrame

	local coverCorner = Instance.new("UICorner")
	coverCorner.CornerRadius = UDim.new(0, 6)
	coverCorner.Parent = coverSection

	local coverLabel = Instance.new("TextLabel")
	coverLabel.Name = "Label"
	coverLabel.Size = UDim2.new(1, -8, 0, 20)
	coverLabel.Position = UDim2.new(0, 8, 0, 8)
	coverLabel.BackgroundTransparency = 1
	coverLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	coverLabel.TextSize = 12
	coverLabel.Font = Enum.Font.GothamBold
	coverLabel.Text = "Cover Points Detection"
	coverLabel.Parent = coverSection

	local coverInfo = Instance.new("TextLabel")
	coverInfo.Size = UDim2.new(1, -16, 0, 70)
	coverInfo.Position = UDim2.new(0, 8, 0, 28)
	coverInfo.BackgroundTransparency = 1
	coverInfo.TextColor3 = Color3.fromRGB(150, 150, 150)
	coverInfo.TextSize = 10
	coverInfo.Font = Enum.Font.Gotham
	coverInfo.TextWrapping = true
	coverInfo.TextXAlignment = Enum.TextXAlignment.Left
	coverInfo.Text = "Automatically detects cover points behind walls, crates, and environmental objects for NPC combat behavior."
	coverInfo.Parent = coverSection

	-- Generate button
	local generateBtn = Instance.new("TextButton")
	generateBtn.Name = "GenerateBtn"
	generateBtn.Size = UDim2.new(1, -16, 0, 36)
	generateBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 150)
	generateBtn.BorderSizePixel = 0
	generateBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	generateBtn.TextSize = 12
	generateBtn.Font = Enum.Font.GothamBold
	generateBtn.Text = "Generate Paths & Zones"
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
		generateBtn.BackgroundColor3 = Color3.fromRGB(200, 120, 120)
		if onGeneratePaths then
			onGeneratePaths()
		end
	end)

	routeDropdown.MouseButton1Click:Connect(function()
		-- Dropdown would expand here
	end)

	return {
		frame = container,
		updatePathCount = function(self, count)
			-- Update path count display
		end,
		updateZoneCount = function(self, count)
			-- Update zone count display
		end,
		enableGeneration = function(self)
			generateBtn.Text = "Generate Paths & Zones"
			generateBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 150)
		end
	}
end

return NPCPanel
