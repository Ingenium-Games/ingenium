-- ====================================================================================--
-- Math utilities (ig.math initialized in shared/_ig.lua)
-- ====================================================================================--
--- Rounds a number to a specified number of decimal places
---@param num number "Number to round"
---@param dec integer "Number of decimal places"
---@return number|nil Rounded number or nil if num is nil
function ig.math.Decimals(num, dec)
    local p = 10 ^ dec
    if num ~= nil then
        return math.floor((num * p) + 0.5) / (p)
    else
        return num
    end
end

--- Rounds a number to the nearest integer
---@param num number "Number to round"
---@return integer Rounded integer value
function ig.math.Round(num)
    return math.floor(num + 0.5)
end

--- Trims whitespace from start and end of a string
---@param num string|nil "String to trim"
---@return string|nil Trimmed string or nil if input is nil
function ig.math.Trim(num)
	if num then
		return (string.gsub(num, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end

-- ====================================================================================--
-- http://richard.warburton.it

--- Formats a number string with comma separators for thousands
---@param val string "Number string or value to format"
---@return string Formatted number string with commas
function ig.math.GroupDigits(val)
	local left,num,right = string.match(val,"^([^%d]*%d)(%d*)(.-)$")
	return left..(num:reverse():gsub("(%d%d%d)","%1,"):reverse())..right
end