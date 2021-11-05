-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
-- ====================================================================================--
c.text = {}
c.texts = {}
--[[
NOTES.
    -
    -
    -
]] --
math.randomseed(c.Seed)
-- ====================================================================================--

function c.text.AddEntry(s1, s2)
    local str1 = string.upper(s1)
    local str2 = s2
    if not c.texts[str1] then
        c.texts[str1] = str2
        AddTextEntry(str1, str2)
    else
        c.debug_1("Text Entry: "..str1.." has already been used. Ignoring this input.")
    end    
end

function c.text.DisplayHelp(s, addon)
    SetTextComponentFormat(s)
    AddTextComponentSubstringPlayerName(addon)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

-- Example to be used in _markers.lua
c.text.AddEntry("KEYBOARD_USE", "Press ~INPUT_PICKUP~ to ~a~")