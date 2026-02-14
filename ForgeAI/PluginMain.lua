--[[
	ForgeAI - Professional Roblox Studio Plugin
	Main entry point for the plugin system
	Handles initialization, UI creation, and lifecycle management
]]

local PluginMain = {}

-- Services
local RunService = game:GetService("RunService")
local Selection = game:GetService("Selection")
local ChangeHistoryService = game:GetService("ChangeHistoryService")

-- Local references
local PLUGIN = plugin
local PLUGIN_NAME = "ForgeAI"
local PLUGIN_ICON = "rbxasset://textures/Cursors/MouseLockedCursor.png"

-- Modules
local AppRoot = require(script.Parent.UI.AppRoot)
local UndoManager = require(script.Parent.Utils.UndoManager)
local SceneScanner = require(script.Parent.Utils.SceneScanner)

-- State
local pluginGui = nil
local isInitialized = false
local connections = {}

--[[
	Initialize the plugin toolbar and connections
]]
function PluginMain:init()
	if isInitialized then return end
	
	-- Create toolbar
	local toolbar = PLUGIN:CreateToolbar(PLUGIN_NAME)
	
	-- Create main plugin button
	local mainButton = toolbar:CreateButton(
		PLUGIN_NAME,
		"Open ForgeAI - Professional world-building toolkit",
		PLUGIN_ICON
	)
	
	-- Setup button click handler
	table.insert(connections, mainButton.Click:Connect(function()
		self:togglePluginGui()
	end))
	
	-- Create the main UI
	pluginGui = AppRoot.create(PLUGIN)
	
	-- Setup selection tracking
	table.insert(connections, Selection.SelectionChanged:Connect(function()
		self:onSelectionChanged()
	end))
	
	-- Setup plugin unload handler
	table.insert(connections, PLUGIN.Unloading:Connect(function()
		self:cleanup()
	end))
	
	isInitialized = true
	print("[ForgeAI] Plugin initialized successfully")
end

--[[
	Toggle the visibility of the plugin GUI
]]
function PluginMain:togglePluginGui()
	if not pluginGui then return end
	
	pluginGui.Enabled = not pluginGui.Enabled
	
	if pluginGui.Enabled then
		print("[ForgeAI] Plugin GUI opened")
	else
		print("[ForgeAI] Plugin GUI closed")
	end
end

--[[
	Handle selection changes in the workspace
]]
function PluginMain:onSelectionChanged()
	local selectedObjects = Selection:Get()
	
	-- Notify UI of selection change
	if pluginGui and pluginGui:FindFirstChild("AppContainer") then
		-- Selection change event will be handled by UI observers
	end
end

--[[
	Cleanup and disconnect all connections
]]
function PluginMain:cleanup()
	-- Disconnect all connections
	for _, connection in ipairs(connections) do
		if connection and connection.Connected then
			connection:Disconnect()
		end
	end
	connections = {}
	
	-- Cleanup UI
	if pluginGui then
		pluginGui:Destroy()
		pluginGui = nil
	end
	
	isInitialized = false
	print("[ForgeAI] Plugin cleanup complete")
end

-- Initialize on plugin load
PluginMain:init()

return PluginMain
