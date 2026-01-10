-- ====================================================================================--
-- https://github.com/sesipod/FiveM/blob/master/resources/%5BStart-3%5D/es_extended/locale.lua

Locales = {}

local function _(key, ...) -- Translate string with optional formatting
    -- Usage: _("key", arg1, arg2, ...) where args replace %s, %d, etc. in the translation
    local locale = conf.locale
    local text = nil

    -- Try requested locale
    if Locales[locale] ~= nil and Locales[locale][key] ~= nil then
        text = Locales[locale][key]
    end

    -- Fallback to English if available
    if text == nil and locale ~= "en" and Locales["en"] ~= nil and Locales["en"][key] ~= nil then
        text = Locales["en"][key]
    end

    -- Return key if no translation found
    if text == nil then return key end

    -- If no formatting args provided, return the raw translation to avoid format errors
    if select("#", ...) == 0 then
        return text
    end

    return string.format(text, ...)
end

function _L(key, ...) -- Translate string first char uppercase
    return tostring(_(key, ...):gsub("^%l", string.upper))
end

exports("_L", _L)
