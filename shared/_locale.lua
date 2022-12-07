-- ====================================================================================--
-- https://github.com/sesipod/FiveM/blob/master/resources/%5BStart-3%5D/es_extended/locale.lua

Locales = {}

function _(str, ...)  -- Translate string

  if Locales[c.locale] ~= nil then

    if Locales[c.locale][str] ~= nil then
      return string.format(Locales[c.locale][str], ...)
    else
      return 'Translation [' .. c.locale .. '][' .. str .. '] does not exists'
    end

  else
    return 'Locale [' .. c.locale .. '] does not exists'
  end

end

function _L(str, ...) -- Translate string first char uppercase
  return tostring(_(str, ...):gsub("^%l", string.upper))
end

exports("_L", _L)