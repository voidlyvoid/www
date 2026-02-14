--[[
	Validator - Input validation and assertion utilities
	Ensures data integrity and type safety across ForgeAI
]]

local Validator = {}

--[[
	Validate that a value is of expected type
]]
function Validator.assertType(value, expectedType, paramName)
	local actualType = typeof(value)
	if actualType ~= expectedType then
		error(string.format(
			"[ForgeAI] Invalid type for '%s': expected %s, got %s",
			paramName or "parameter",
			expectedType,
			actualType
		))
	end
	return value
end

--[[
	Validate that a value is not nil
]]
function Validator.assertNotNil(value, paramName)
	if value == nil then
		error(string.format(
			"[ForgeAI] Required parameter '%s' is nil",
			paramName or "parameter"
		))
	end
	return value
end

--[[
	Validate that a Roblox object is in the workspace
]]
function Validator.assertInWorkspace(object, paramName)
	if not object or not object:IsDescendantOf(workspace) then
		error(string.format(
			"[ForgeAI] Object '%s' is not in workspace",
			paramName or "object"
		))
	end
	return object
end

--[[
	Validate numeric range
]]
function Validator.assertRange(value, min, max, paramName)
	Validator.assertType(value, "number", paramName)
	if value < min or value > max then
		error(string.format(
			"[ForgeAI] Parameter '%s' out of range [%d, %d]: got %d",
			paramName or "parameter",
			min,
			max,
			value
		))
	end
	return value
end

--[[
	Validate non-empty string
]]
function Validator.assertNonEmptyString(value, paramName)
	Validator.assertType(value, "string", paramName)
	if #value == 0 then
		error(string.format(
			"[ForgeAI] Parameter '%s' cannot be empty string",
			paramName or "parameter"
		))
	end
	return value
end

--[[
	Validate that a table contains expected keys
]]
function Validator.assertTableKeys(tbl, expectedKeys, paramName)
	Validator.assertType(tbl, "table", paramName)
	
	for _, key in ipairs(expectedKeys) do
		if tbl[key] == nil then
			error(string.format(
				"[ForgeAI] Table '%s' missing required key: %s",
				paramName or "table",
				key
			))
		end
	end
	return tbl
end

--[[
	Validate a configuration object
]]
function Validator.validateConfig(config, schema)
	Validator.assertType(config, "table", "config")
	Validator.assertType(schema, "table", "schema")
	
	for key, expectedType in pairs(schema) do
		if config[key] ~= nil then
			local actualType = typeof(config[key])
			if actualType ~= expectedType then
				error(string.format(
					"[ForgeAI] Config key '%s' has wrong type: expected %s, got %s",
					key,
					expectedType,
					actualType
				))
			end
		end
	end
	return config
end

--[[
	Safe validation that returns error tuple instead of throwing
]]
function Validator.safeValidate(fn, ...)
	local success, result = pcall(fn, ...)
	return success, result
end

return Validator
