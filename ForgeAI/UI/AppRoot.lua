--[[
	AppRoot - Main UI container and layout orchestrator
	Manages the overall plugin GUI structure and component composition
]]

local AppRoot = {}

-- Import UI components
local NavigationPanel = require(script.Parent:WaitForChild("NavigationPanel"))
local PromptEditor = require(script.Parent:WaitForChild("PromptEditor"))
local PreviewViewport = require(script.Parent:WaitForChild("PreviewViewport"))
local MetricsDashboard = require(script.Parent:WaitForChild("MetricsDashboard"))
local OptimizationPanel = require(script.Parent:WaitForChild("OptimizationPanel"))
local ThemePanel = require(script.Parent:WaitForChild("ThemePanel"))
local NPCPanel = require(script.Parent:WaitForChild("NPCPanel"))
local ScriptGeneratorPanel = require(script.Parent:WaitForChild("ScriptGeneratorPanel"))

-- UI Constants
local PLUGIN_WIDTH = 1000
local PLUGIN_HEIGHT = 700
local SIDEBAR_WIDTH = 180
local PREVIEW_WIDTH = 300

--[[
	Create the main plugin GUI structure
]]
function AppRoot.create(plugin)
	-- Create main DockWidgetPluginGui
	local pluginGui = plugin:CreateDockWidgetPluginGui(
		"ForgeAI",
		DockWidgetPluginGuiInfo.new(
			Enum.InitialDockState.Float,
			false,
			false,
			PLUGIN_WIDTH,
			PLUGIN_HEIGHT,
			PLUGIN_WIDTH - 50,
			PLUGIN_HEIGHT - 50
		)
	)
	
	pluginGui.Title = "ForgeAI"
	pluginGui.Name = "ForgeAIWindow"
	
	-- Create main container with dark theme
	local mainContainer = Instance.new("Frame")
	mainContainer.Name = "MainContainer"
	mainContainer.Size = UDim2.new(1, 0, 1, 0)
	mainContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	mainContainer.BorderSizePixel = 0
	mainContainer.Parent = pluginGui
	
	-- Create top toolbar
	local topBar = AppRoot.createTopBar(mainContainer)
	
	-- Create main content area with sidebar and workspace
	local contentArea = Instance.new("Frame")
	contentArea.Name = "ContentArea"
	contentArea.Size = UDim2.new(1, 0, 1, -40)
	contentArea.Position = UDim2.new(0, 0, 0, 40)
	contentArea.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	contentArea.BorderSizePixel = 0
	contentArea.Parent = mainContainer
	
	-- Create left sidebar with navigation
	local navPanel = NavigationPanel.create(contentArea)
	
	-- Create main workspace
	local workspace = Instance.new("Frame")
	workspace.Name = "WorkspacePanel"
	workspace.Size = UDim2.new(1, -navPanel.frame.Size.X.Offset - PREVIEW_WIDTH, 1, 0)
	workspace.Position = UDim2.new(0, navPanel.frame.Size.X.Offset, 0, 0)
	workspace.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	workspace.BorderSizePixel = 0
	workspace.Parent = contentArea
	
	-- Create dynamic panel container for tool panels
	local toolPanel = Instance.new("Frame")
	toolPanel.Name = "ToolPanel"
	toolPanel.Size = UDim2.new(1, 0, 1, 0)
	toolPanel.BackgroundTransparency = 1
	toolPanel.Parent = workspace
	
	-- Create tool panels (initially hidden)
	local layoutPanel = PromptEditor.create(toolPanel, "layout")
	local assetPanel = PromptEditor.create(toolPanel, "assets")
	local perfPanel = MetricsDashboard.create(toolPanel)
	local npcPanel = NPCPanel.create(toolPanel)
	local scriptPanel = ScriptGeneratorPanel.create(toolPanel)
	local themePanel = ThemePanel.create(toolPanel)
	local uiPanel = PromptEditor.create(toolPanel, "ui")
	
	-- Hide all panels initially
	layoutPanel.frame.Visible = true
	assetPanel.frame.Visible = false
	perfPanel.frame.Visible = false
	npcPanel.frame.Visible = false
	scriptPanel.frame.Visible = false
	themePanel.frame.Visible = false
	uiPanel.frame.Visible = false
	
	-- Store panel references
	local panels = {
		layout = layoutPanel,
		assets = assetPanel,
		perf = perfPanel,
		npc = npcPanel,
		scripts = scriptPanel,
		theme = themePanel,
		ui = uiPanel,
	}
	
	-- Handle tool selection
	local function selectTool(toolId)
		for panelId, panel in pairs(panels) do
			panel.frame.Visible = (panelId == toolId)
		end
	end
	
	-- Connect navigation panel to tool selection
	navPanel.buttons.layout.MouseButton1Click:Connect(function() selectTool("layout") end)
	navPanel.buttons.assets.MouseButton1Click:Connect(function() selectTool("assets") end)
	navPanel.buttons.perf.MouseButton1Click:Connect(function() selectTool("perf") end)
	navPanel.buttons.npc.MouseButton1Click:Connect(function() selectTool("npc") end)
	navPanel.buttons.scripts.MouseButton1Click:Connect(function() selectTool("scripts") end)
	navPanel.buttons.theme.MouseButton1Click:Connect(function() selectTool("theme") end)
	navPanel.buttons.ui.MouseButton1Click:Connect(function() selectTool("ui") end)
	
	-- Create right preview panel with preview viewport
	local preview = AppRoot.createPreviewPanel(contentArea)
	local previewViewport = PreviewViewport.create(preview)
	
	-- Create status bar
	local statusBar = AppRoot.createStatusBar(mainContainer)
	
	-- Store references
	mainContainer:SetAttribute("navPanel", navPanel)
	mainContainer:SetAttribute("workspace", workspace)
	mainContainer:SetAttribute("preview", preview)
	mainContainer:SetAttribute("statusBar", statusBar)
	mainContainer:SetAttribute("topBar", topBar)
	mainContainer:SetAttribute("panels", panels)
	mainContainer:SetAttribute("previewViewport", previewViewport)
	
	return pluginGui
end

--[[
	Create top toolbar with buttons and controls
]]
function AppRoot.createTopBar(parent)
	local topBar = Instance.new("Frame")
	topBar.Name = "TopBar"
	topBar.Size = UDim2.new(1, 0, 0, 40)
	topBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	topBar.BorderSizePixel = 1
	topBar.BorderColor3 = Color3.fromRGB(50, 50, 50)
	topBar.Parent = parent
	
	-- Add buttons container
	local buttonsContainer = Instance.new("Frame")
	buttonsContainer.Name = "ButtonsContainer"
	buttonsContainer.Size = UDim2.new(1, -10, 1, 0)
	buttonsContainer.Position = UDim2.new(0, 5, 0, 0)
	buttonsContainer.BackgroundTransparency = 1
	buttonsContainer.Parent = topBar
	
	-- UIListLayout for horizontal button layout
	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.Padding = UDim.new(0, 5)
	layout.Parent = buttonsContainer
	
	-- Generate button helper
	local function createToolButton(name, tooltipText)
		local button = Instance.new("TextButton")
		button.Name = name
		button.Size = UDim2.new(0, 90, 0, 25)
		button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		button.TextColor3 = Color3.fromRGB(200, 200, 200)
		button.Text = name
		button.TextScaled = true
		button.TextSize = 12
		button.Font = Enum.Font.GothamMedium
		button.Parent = buttonsContainer
		
		-- Add hover effects
		button.MouseEnter:Connect(function()
			button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
		end)
		button.MouseLeave:Connect(function()
			button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		end)
		
		return button
	end
	
	-- Create toolbar buttons
	createToolButton("New", "Create new project")
	createToolButton("Save", "Save current state")
	createToolButton("Undo", "Undo last action")
	createToolButton("Redo", "Redo last action")
	
	return topBar
end



--[[
	Create right preview and metrics panel
]]
function AppRoot.createPreviewPanel(parent)
	local previewPanel = Instance.new("Frame")
	previewPanel.Name = "PreviewPanel"
	previewPanel.Size = UDim2.new(0, PREVIEW_WIDTH, 1, 0)
	previewPanel.Position = UDim2.new(1, -PREVIEW_WIDTH, 0, 0)
	previewPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	previewPanel.BorderSizePixel = 1
	previewPanel.BorderColor3 = Color3.fromRGB(50, 50, 50)
	previewPanel.Parent = parent
	
	-- Add title
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, 0, 0, 30)
	title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	title.TextColor3 = Color3.fromRGB(200, 200, 200)
	title.Text = "Metrics"
	title.TextSize = 14
	title.Font = Enum.Font.GothamBold
	title.Parent = previewPanel
	
	-- Create metrics display
	local metricsContainer = Instance.new("Frame")
	metricsContainer.Name = "MetricsContainer"
	metricsContainer.Size = UDim2.new(1, -10, 1, -40)
	metricsContainer.Position = UDim2.new(0, 5, 0, 35)
	metricsContainer.BackgroundTransparency = 1
	metricsContainer.Parent = previewPanel
	
	-- UIListLayout for metrics
	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Stretch
	layout.VerticalAlignment = Enum.VerticalAlignment.Top
	layout.Padding = UDim.new(0, 8)
	layout.Parent = metricsContainer
	
	-- Sample metrics
	local metrics = {
		{name = "Parts", value = "---"},
		{name = "Meshes", value = "---"},
		{name = "Lights", value = "---"},
		{name = "FPS Est.", value = "---"}
	}
	
	for _, metric in ipairs(metrics) do
		local metricFrame = Instance.new("Frame")
		metricFrame.Name = metric.name
		metricFrame.Size = UDim2.new(1, 0, 0, 25)
		metricFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		metricFrame.Parent = metricsContainer
		
		local label = Instance.new("TextLabel")
		label.Name = "Label"
		label.Size = UDim2.new(0.5, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.fromRGB(150, 150, 150)
		label.Text = metric.name
		label.TextSize = 11
		label.Font = Enum.Font.Gotham
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = metricFrame
		
		local value = Instance.new("TextLabel")
		value.Name = "Value"
		value.Size = UDim2.new(0.5, 0, 1, 0)
		value.Position = UDim2.new(0.5, 0, 0, 0)
		value.BackgroundTransparency = 1
		value.TextColor3 = Color3.fromRGB(100, 200, 100)
		value.Text = metric.value
		value.TextSize = 11
		value.Font = Enum.Font.GothamMedium
		value.TextXAlignment = Enum.TextXAlignment.Right
		value.Parent = metricFrame
	end
	
	return previewPanel
end

--[[
	Create status bar at bottom
]]
function AppRoot.createStatusBar(parent)
	local statusBar = Instance.new("Frame")
	statusBar.Name = "StatusBar"
	statusBar.Size = UDim2.new(1, 0, 0, 20)
	statusBar.Position = UDim2.new(0, 0, 1, -20)
	statusBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	statusBar.BorderSizePixel = 1
	statusBar.BorderColor3 = Color3.fromRGB(50, 50, 50)
	statusBar.Parent = parent
	
	local statusText = Instance.new("TextLabel")
	statusText.Name = "StatusText"
	statusText.Size = UDim2.new(1, -5, 1, 0)
	statusText.Position = UDim2.new(0, 5, 0, 0)
	statusText.BackgroundTransparency = 1
	statusText.TextColor3 = Color3.fromRGB(100, 100, 100)
	statusText.Text = "Ready"
	statusText.TextSize = 10
	statusText.Font = Enum.Font.Gotham
	statusText.TextXAlignment = Enum.TextXAlignment.Left
	statusText.Parent = statusBar
	
	return statusBar
end

return AppRoot
