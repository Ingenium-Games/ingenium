-- ====================================================================================--
c.math = {}
-- ====================================================================================--
--- func desc
---@param . any
function c.math.Decimals(num, dec)
    local p = 10 ^ dec
    if num ~= nil then
        return math.floor((num * p) + 0.5) / (p)
    else
        return num
    end
end

--- func desc
---@param num any
function c.math.Round(num)
    return math.floor(num + 0.5)
end

--- func desc
---@param num any
function c.math.Trim(num)
	if num then
		return (string.gsub(num, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end

-- ====================================================================================--
-- http://richard.warburton.it

--- func desc
---@param val any
function c.math.GroupDigits(val)
	local left,num,right = string.match(val,"^([^%d]*%d)(%d*)(.-)$")
	return left..(num:reverse():gsub("(%d%d%d)","%1,"):reverse())..right
end