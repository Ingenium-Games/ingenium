-- ====================================================================================--
ig.text = {}
ig.texts = {}
-- ====================================================================================--

--- func desc
---@param s1 any
---@param s2 any
function ig.text.AddEntry(s1, s2)
    local str1 = string.upper(s1)
    local str2 = s2
    if not ig.texts[str1] then
        ig.texts[str1] = str2
        AddTextEntry(str1, str2)
    else
        ig.func.Debug_1("Text Entry: "..str1.." has already been used. Ignoring this input.")
    end    
end

--- func desc
---@param s any
---@param addon any
function ig.text.DisplayHelp(s, addon)
    SetTextComponentFormat(s)
    AddTextComponentSubstringPlayerName(addon)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

-- Example to be used in _markers.lua
ig.text.AddEntry("KEYBOARD_USE", "Press ~INPUT_PICKUP~ to ~a~")