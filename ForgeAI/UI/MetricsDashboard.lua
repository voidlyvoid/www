--[[
	MetricsDashboard - Real-time performance metrics display
	Shows part counts, complexity scores, device impact, and recommendations
]]

local MetricsDashboard = {}
local PerformanceAnalyzer = require(script.Parent.Parent.Core.PerformanceAnalyzer)

--[[
	Create metrics dashboard panel
]]
function MetricsDashboard.create(parent)
	local dashboard = Instance.new("Frame")
	dashboard.Name = "MetricsDashboard"
	dashboard.Size = UDim2.new(1, 0, 1, 0)
	dashboard.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	dashboard.BorderSizePixel = 0
	dashboard.Parent = parent
	
	-- Create scrollable content
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Name = "ScrollContent"
	scrollFrame.Size = UDim2.new(1, -10, 1, -40)
	scrollFrame.Position = UDim2.new(0, 5, 0, 35)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.BorderSizePixel = 0
	scrollFrame.ScrollBarThickness = 8
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
	scrollFrame.Parent = dashboard
	
	-- UIListLayout for vertical stacking
	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Stretch
	layout.VerticalAlignment = Enum.VerticalAlignment.Top
	layout.Padding = UDim.new(0, 10)
	layout.Parent = scrollFrame
	
	-- Add title bar
	local titleBar = Instance.new("TextLabel")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, 30)
	titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	titleBar.TextColor3 = Color3.fromRGB(220, 220, 220)
	titleBar.Text = "Performance Metrics"
	titleBar.TextSize = 14
	titleBar.Font = Enum.Font.GothamBold
	titleBar.Parent = dashboard
	
	return {
		frame = dashboard
	}
	
	-- Create metric sections
	MetricsDashboard.createMetricSection(scrollFrame, "Part Analysis", {
		{label = "Total Parts", value = "0", color = Color3.fromRGB(100, 150, 255)},
		{label = "Mesh Parts", value = "0", color = Color3.fromRGB(100, 200, 150)},
		{label = "Max Depth", value = "0", color = Color3.fromRGB(255, 180, 100)}
	})
	
	MetricsDashboard.createMetricSection(scrollFrame, "Performance Scores", {
		{label = "Complexity", value = "0", color = Color3.fromRGB(150, 100, 255)},
		{label = "Overall Score", value = "--", color = Color3.fromRGB(100, 255, 150)},
		{label = "Risk Level", value = "Unknown", color = Color3.fromRGB(255, 150, 100)}
	})
	
	MetricsDashboard.createMetricSection(scrollFrame, "Device Impact", {
		{label = "Mobile", value = "High", color = Color3.fromRGB(255, 100, 100)},
		{label = "PC", value = "Medium", color = Color3.fromRGB(255, 200, 100)},
		{label = "Optimization Ready", value = "Yes", color = Color3.fromRGB(100, 255, 100)}
	})
	
	-- Add recommendations section
	MetricsDashboard.createRecommendations(scrollFrame)
	
	-- Add refresh button
	local refreshButton = Instance.new("TextButton")
	refreshButton.Name = "RefreshButton"
	refreshButton.Size = UDim2.new(1, 0, 0, 30)
	refreshButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
	refreshButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	refreshButton.Text = "Scan Selection"
	refreshButton.TextSize = 12
	refreshButton.Font = Enum.Font.GothamMedium
	refreshButton.Parent = scrollFrame
	
	return dashboard
end

--[[
	Create a metric section with multiple values
]]
function MetricsDashboard.createMetricSection(parent, title, metrics)
	local section = Instance.new("Frame")
	section.Name = title
	section.Size = UDim2.new(1, 0, 0, 120)
	section.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	section.Parent = parent
	
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "SectionTitle"
	titleLabel.Size = UDim2.new(1, -10, 0, 25)
	titleLabel.Position = UDim2.new(0, 5, 0, 5)
	titleLabel.BackgroundTransparency = 1
	titleLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	titleLabel.Text = title
	titleLabel.TextSize = 12
	titleLabel.Font = Enum.Font.GothamMedium
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = section
	
	local metricsContainer = Instance.new("Frame")
	metricsContainer.Name = "MetricsContainer"
	metricsContainer.Size = UDim2.new(1, -10, 1, -35)
	metricsContainer.Position = UDim2.new(0, 5, 0, 30)
	metricsContainer.BackgroundTransparency = 1
	metricsContainer.Parent = section
	
	local gridLayout = Instance.new("UIGridLayout")
	gridLayout.CellSize = UDim2.new(0.33, 0, 1, 0)
	gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Fill
	gridLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	gridLayout.Parent = metricsContainer
	
	for _, metricData in ipairs(metrics) do
		MetricsDashboard.createMetricItem(metricsContainer, metricData)
	end
end

--[[
	Create individual metric display item
]]
function MetricsDashboard.createMetricItem(parent, data)
	local item = Instance.new("Frame")
	item.Name = data.label
	item.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	item.Parent = parent
	
	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Size = UDim2.new(1, -5, 0, 20)
	label.Position = UDim2.new(0, 5, 0, 5)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(120, 120, 120)
	label.Text = data.label
	label.TextSize = 10
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = item
	
	local value = Instance.new("TextLabel")
	value.Name = "Value"
	value.Size = UDim2.new(1, -5, 1, -30)
	value.Position = UDim2.new(0, 5, 0, 25)
	value.BackgroundTransparency = 1
	value.TextColor3 = data.color
	value.Text = data.value
	value.TextSize = 14
	value.Font = Enum.Font.GothamBold
	value.Parent = item
end

--[[
	Create recommendations section
]]
function MetricsDashboard.createRecommendations(parent)
	local section = Instance.new("Frame")
	section.Name = "Recommendations"
	section.Size = UDim2.new(1, 0, 0, 150)
	section.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	section.Parent = parent
	
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, -10, 0, 25)
	titleLabel.Position = UDim2.new(0, 5, 0, 5)
	titleLabel.BackgroundTransparency = 1
	titleLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
	titleLabel.Text = "Optimization Recommendations"
	titleLabel.TextSize = 12
	titleLabel.Font = Enum.Font.GothamMedium
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = section
	
	local recContainer = Instance.new("ScrollingFrame")
	recContainer.Name = "RecommendationsContainer"
	recContainer.Size = UDim2.new(1, -10, 1, -35)
	recContainer.Position = UDim2.new(0, 5, 0, 30)
	recContainer.BackgroundTransparency = 1
	recContainer.BorderSizePixel = 0
	recContainer.ScrollBarThickness = 6
	recContainer.CanvasSize = UDim2.new(0, 0, 0, 300)
	recContainer.Parent = section
	
	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Stretch
	layout.VerticalAlignment = Enum.VerticalAlignment.Top
	layout.Padding = UDim.new(0, 5)
	layout.Parent = recContainer
	
	-- Sample recommendations
	local recommendations = {
		"Reduce shadow-casting parts by 20%",
		"Consider using Level-of-Detail (LOD) systems",
		"Disable physics on decorative parts"
	}
	
	for i, rec in ipairs(recommendations) do
		local recItem = Instance.new("TextButton")
		recItem.Name = "Recommendation" .. i
		recItem.Size = UDim2.new(1, 0, 0, 40)
		recItem.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		recItem.TextColor3 = Color3.fromRGB(150, 200, 100)
		recItem.Text = "• " .. rec
		recItem.TextSize = 10
		recItem.Font = Enum.Font.Gotham
		recItem.TextWrapped = true
		recItem.TextXAlignment = Enum.TextXAlignment.Left
		recItem.Parent = recContainer
		
		-- Hover effect
		recItem.MouseEnter:Connect(function()
			recItem.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
		end)
		recItem.MouseLeave:Connect(function()
			recItem.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		end)
	end
end

return MetricsDashboard
