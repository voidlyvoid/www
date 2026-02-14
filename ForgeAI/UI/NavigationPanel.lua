--[[
	NavigationPanel.lua
	Sidebar navigation for ForgeAI main features
	Provides access to all core tools with visual indicators
]]

local NavigationPanel = {}

-- Create navigation panel with buttons for each tool
function NavigationPanel.create(parent, onToolSelected)
	local navPanel = Instance.new("Frame")
	navPanel.Name = "NavigationPanel"
	navPanel.Size = UDim2.new(0, 180, 1, 0)
	navPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	navPanel.BorderSizePixel = 0
	navPanel.Parent = parent

	-- Title section
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, 0, 0, 50)
	titleLabel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	titleLabel.BorderSizePixel = 0
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.TextSize = 16
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.Text = "ForgeAI"
	titleLabel.Parent = navPanel

	-- Tools list
	local toolsList = Instance.new("ScrollingFrame")
	toolsList.Name = "ToolsList"
	toolsList.Size = UDim2.new(1, 0, 1, -50)
	toolsList.Position = UDim2.new(0, 0, 0, 50)
	toolsList.BackgroundTransparency = 1
	toolsList.BorderSizePixel = 0
	toolsList.ScrollBarThickness = 6
	toolsList.CanvasSize = UDim2.new(0, 0, 0, 0)
	toolsList.Parent = navPanel

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 8)
	listLayout.FillDirection = Enum.FillDirection.Vertical
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = toolsList

	-- Tool definitions
	local tools = {
		{ name = "Layout Gen", icon = "◢", color = Color3.fromRGB(100, 150, 255), id = "layout" },
		{ name = "Asset Place", icon = "●", color = Color3.fromRGB(100, 255, 150), id = "assets" },
		{ name = "Performance", icon = "⚡", color = Color3.fromRGB(255, 200, 100), id = "perf" },
		{ name = "NPC Paths", icon = "⟿", color = Color3.fromRGB(255, 150, 150), id = "npc" },
		{ name = "Scripts", icon = "{ }", color = Color3.fromRGB(200, 150, 255), id = "scripts" },
		{ name = "Theme", icon = "◉", color = Color3.fromRGB(255, 150, 200), id = "theme" },
		{ name = "UI Analysis", icon = "⊞", color = Color3.fromRGB(150, 200, 255), id = "ui" },
	}

	local toolButtons = {}

	for idx, tool in ipairs(tools) do
		local button = Instance.new("TextButton")
		button.Name = tool.id
		button.Size = UDim2.new(1, -16, 0, 40)
		button.Position = UDim2.new(0, 8, 0, 0)
		button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		button.BorderSizePixel = 0
		button.TextColor3 = Color3.fromRGB(200, 200, 200)
		button.TextSize = 12
		button.Font = Enum.Font.Gotham
		button.Text = tool.icon .. " " .. tool.name
		button.LayoutOrder = idx
		button.Parent = toolsList

		-- Add corner radius
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 4)
		corner.Parent = button

		-- Store reference
		toolButtons[tool.id] = button

		-- Hover effect
		button.MouseEnter:Connect(function()
			button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		end)

		button.MouseLeave:Connect(function()
			button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		end)

		-- Click handler
		button.MouseButton1Click:Connect(function()
			-- Update visual state
			for _, btn in pairs(toolButtons) do
				btn.TextColor3 = Color3.fromRGB(200, 200, 200)
				btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			end
			button.TextColor3 = tool.color
			button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

			-- Notify selection
			if onToolSelected then
				onToolSelected(tool.id, tool.name)
			end
		end)
	end

	-- Update canvas size after all buttons added
	listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		toolsList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 16)
	end)

	-- Select first tool by default
	toolButtons.layout.MouseButton1Click:Fire()

	return {
		frame = navPanel,
		buttons = toolButtons,
		selectTool = function(self, toolId)
			if toolButtons[toolId] then
				toolButtons[toolId].MouseButton1Click:Fire()
			end
		end
	}
end

return NavigationPanel
