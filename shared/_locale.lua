-- ====================================================================================--
-- https://github.com/sesipod/FiveM/blob/master/resources/%5BStart-3%5D/es_extended/locale.lua

Locales = {}

function _(key) -- Translate string
    local locale = exports["ig.core"]:GetLocale()
    if Locales[locale] ~= nil then
        if Locales[locale][key] ~= nil then
            return string.format(Locales[locale][key])
        else
            return 'Translation [' .. locale .. '][' .. key .. '] does not exists'
        end
    else
        return 'Locale [' .. locale .. '] does not exists'
    end
end

function _L(key) -- Translate string first char uppercase
    return tostring(_(key):gsub("^%l", string.upper))
end

exports("_L", _L)
