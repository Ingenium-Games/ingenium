-- ====================================================================================--
-- https://github.com/sesipod/FiveM/blob/master/resources/%5BStart-3%5D/es_extended/locale.lua

Locales = {}

function _(key, ...) -- Translate string with optional formatting
    local locale = exports["ingenium"]:GetLocale()
    
    -- Try requested locale
    if Locales[locale] ~= nil and Locales[locale][key] ~= nil then
        return string.format(Locales[locale][key], ...)
    end
    
    -- Fallback to English if available
    if locale ~= "en" and Locales["en"] ~= nil and Locales["en"][key] ~= nil then
        return string.format(Locales["en"][key], ...)
    end
    
    -- Return key if no translation found
    return key
end

function _L(key, ...) -- Translate string first char uppercase
    return tostring(_(key, ...):gsub("^%l", string.upper))
end

exports("_L", _L)
