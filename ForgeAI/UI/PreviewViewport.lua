--[[
	PreviewViewport.lua
	3D preview viewport for generated content
	Shows scene impact and real-time feedback
]]

local PreviewViewport = {}

-- Create a 3D preview viewport
function PreviewViewport.create(parent)
	local viewportFrame = Instance.new("ViewportFrame")
	viewportFrame.Name = "PreviewViewport"
	viewportFrame.Size = UDim2.new(1, 0, 0.7, 0)
	viewportFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	viewportFrame.BorderSizePixel = 0
	viewportFrame.Parent = parent

	-- Camera setup
	local camera = Instance.new("Camera")
	camera.CFrame = CFrame.new(Vector3.new(50, 50, 50)) * CFrame.Angles(math.rad(-45), math.rad(-45), 0)
	camera.Parent = viewportFrame
	viewportFrame.CurrentCamera = camera

	-- Lighting setup
	local light = Instance.new("Light")
	light.Brightness = 2
	local lightPart = Instance.new("Part")
	lightPart.CanCollide = false
	lightPart.CanTouch = false
	lightPart.CanQuery = false
	lightPart.Transparency = 1
	lightPart.Parent = viewportFrame
	light.Parent = lightPart

	-- Info overlay
	local infoLabel = Instance.new("TextLabel")
	infoLabel.Name = "InfoOverlay"
	infoLabel.Size = UDim2.new(1, 0, 0, 80)
	infoLabel.Position = UDim2.new(0, 0, 1, -80)
	infoLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	infoLabel.BorderSizePixel = 0
	infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	infoLabel.TextSize = 11
	infoLabel.Font = Enum.Font.Gotham
	infoLabel.TextXAlignment = Enum.TextXAlignment.Left
	infoLabel.TextYAlignment = Enum.TextYAlignment.Top
	infoLabel.Padding = UDim.new(0, 8)
	infoLabel.Parent = viewportFrame

	-- Labels for stats
	local partCountLabel = Instance.new("TextLabel")
	partCountLabel.Name = "PartCount"
	partCountLabel.Size = UDim2.new(0.5, 0, 0.5, 0)
	partCountLabel.BackgroundTransparency = 1
	partCountLabel.TextColor3 = Color3.fromRGB(150, 200, 100)
	partCountLabel.TextSize = 12
	partCountLabel.Font = Enum.Font.GothamBold
	partCountLabel.Text = "Parts: 0"
	partCountLabel.Parent = infoLabel

	local perfScoreLabel = Instance.new("TextLabel")
	perfScoreLabel.Name = "PerfScore"
	perfScoreLabel.Size = UDim2.new(0.5, 0, 0.5, 0)
	perfScoreLabel.Position = UDim2.new(0.5, 0, 0, 0)
	perfScoreLabel.BackgroundTransparency = 1
	perfScoreLabel.TextColor3 = Color3.fromRGB(100, 150, 255)
	perfScoreLabel.TextSize = 12
	perfScoreLabel.Font = Enum.Font.GothamBold
	perfScoreLabel.Text = "Score: N/A"
	perfScoreLabel.Parent = infoLabel

	local estimateLabel = Instance.new("TextLabel")
	estimateLabel.Name = "Estimate"
	estimateLabel.Size = UDim2.new(1, 0, 0.5, 0)
	estimateLabel.Position = UDim2.new(0, 0, 0.5, 0)
	estimateLabel.BackgroundTransparency = 1
	estimateLabel.TextColor3 = Color3.fromRGB(220, 120, 120)
	estimateLabel.TextSize = 11
	estimateLabel.Font = Enum.Font.Gotham
	estimateLabel.Text = "Mobile Impact: N/A"
	estimateLabel.Parent = infoLabel

	-- Reference system
	local reference = Instance.new("Part")
	reference.Name = "Reference"
	reference.Size = Vector3.new(1, 1, 1)
	reference.Color = Color3.fromRGB(100, 100, 100)
	reference.CanCollide = false
	reference.CanTouch = false
	reference.Parent = viewportFrame

	return {
		frame = viewportFrame,
		camera = camera,
		viewport = viewportFrame,

		-- Update preview with object list
		updatePreview = function(self, objects)
			-- Clear existing objects
			local existingModel = viewportFrame:FindFirstChild("Model")
			if existingModel then
				for _, child in ipairs(existingModel:GetChildren()) do
					child:Destroy()
				end
				existingModel:Destroy()
			end

			-- Create model container
			local model = Instance.new("Model")
			model.Name = "Model"
			model.Parent = viewportFrame

			-- Copy objects to viewport
			if objects then
				for _, obj in ipairs(objects) do
					if obj:IsDescendantOf(game.Workspace) then
						local clone = obj:Clone()
						clone.Parent = model
					end
				end
			end

			-- Auto-focus camera
			self:focusOnModel()
		end,

		-- Update stats display
		updateStats = function(self, partCount, perfScore, mobileImpact)
			partCountLabel.Text = "Parts: " .. tostring(partCount or 0)
			perfScoreLabel.Text = "Score: " .. (perfScore and string.format("%.0f%%", perfScore) or "N/A")
			estimateLabel.Text = "Mobile Impact: " .. (mobileImpact or "Low")
		end,

		-- Auto-focus camera on model content
		focusOnModel = function(self)
			local model = viewportFrame:FindFirstChild("Model")
			if model and #model:GetChildren() > 0 then
				local parts = {}
				for _, descendant in ipairs(model:GetDescendants()) do
					if descendant:IsA("BasePart") then
						table.insert(parts, descendant)
					end
				end

				if #parts > 0 then
					-- Calculate bounds
					local minPos = parts[1].Position
					local maxPos = parts[1].Position
					
					for _, part in ipairs(parts) do
						minPos = Vector3.new(
							math.min(minPos.X, part.Position.X - part.Size.X/2),
							math.min(minPos.Y, part.Position.Y - part.Size.Y/2),
							math.min(minPos.Z, part.Position.Z - part.Size.Z/2)
						)
						maxPos = Vector3.new(
							math.max(maxPos.X, part.Position.X + part.Size.X/2),
							math.max(maxPos.Y, part.Position.Y + part.Size.Y/2),
							math.max(maxPos.Z, part.Position.Z + part.Size.Z/2)
						)
					end

					-- Center camera
					local center = (minPos + maxPos) / 2
					local size = (maxPos - minPos).Magnitude
					camera.CFrame = CFrame.new(center + Vector3.new(size, size, size)) * CFrame.Angles(math.rad(-45), math.rad(-45), 0)
				end
			end
		end,

		-- Clear preview
		clear = function(self)
			local model = viewportFrame:FindFirstChild("Model")
			if model then
				model:Destroy()
			end
			partCountLabel.Text = "Parts: 0"
			perfScoreLabel.Text = "Score: N/A"
			estimateLabel.Text = "Mobile Impact: N/A"
		end
	}
end

return PreviewViewport
