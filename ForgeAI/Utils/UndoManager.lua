--[[
	UndoManager - Handles undo/redo for plugin operations
	Uses Roblox ChangeHistoryService for proper integration with Studio
]]

local UndoManager = {}
local ChangeHistoryService = game:GetService("ChangeHistoryService")

-- Track current operation
local currentOperation = nil
local operationStack = {}

--[[
	Begin a new undo operation
]]
function UndoManager.beginOperation(name)
	if currentOperation then
		UndoManager.endOperation()
	end
	
	currentOperation = {
		name = name or "ForgeAI Operation",
		startTime = tick(),
		objects = {}
	}
	
	-- Start recording in ChangeHistoryService
	ChangeHistoryService:SetWaypoint(currentOperation.name)
end

--[[
	End current undo operation
]]
function UndoManager.endOperation()
	if not currentOperation then return end
	
	table.insert(operationStack, currentOperation)
	
	-- Create waypoint for undo
	ChangeHistoryService:SetWaypoint(currentOperation.name .. " (End)")
	
	-- Keep stack size reasonable (max 50 operations)
	if #operationStack > 50 then
		table.remove(operationStack, 1)
	end
	
	currentOperation = nil
end

--[[
	Record object creation for undo
]]
function UndoManager.recordCreated(object)
	if not currentOperation then return end
	
	table.insert(currentOperation.objects, {
		type = "created",
		object = object,
		parent = object.Parent
	})
end

--[[
	Record object deletion for undo
]]
function UndoManager.recordDeleted(object, parent)
	if not currentOperation then return end
	
	table.insert(currentOperation.objects, {
		type = "deleted",
		object = object,
		parent = parent or object.Parent
	})
end

--[[
	Record object modification for undo
]]
function UndoManager.recordModified(object, propertyName, oldValue, newValue)
	if not currentOperation then return end
	
	table.insert(currentOperation.objects, {
		type = "modified",
		object = object,
		property = propertyName,
		oldValue = oldValue,
		newValue = newValue
	})
end

--[[
	Undo last operation (wrapper around ChangeHistoryService)
]]
function UndoManager.undo()
	pcall(function()
		ChangeHistoryService:Undo()
	end)
end

--[[
	Redo last undone operation
]]
function UndoManager.redo()
	pcall(function()
		ChangeHistoryService:Redo()
	end)
end

--[[
	Get operation history
]]
function UndoManager.getHistory()
	return operationStack
end

--[[
	Clear operation history
]]
function UndoManager.clear()
	operationStack = {}
	currentOperation = nil
end

return UndoManager
