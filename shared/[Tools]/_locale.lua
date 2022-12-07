-- ====================================================================================--

function Locale(key)
    local locale = c.locale
    local f, err = io.open(GetResourcePath(GetCurrentResourceName()).."/locale/"..locale, "r")
    if not f then c.func.Debug_1(err) end
    local data = json.decode(f:read("a"))
    f:close()
    return data[key]
end

function _L(key)
    return Locale(key)
end

function L_(key)
    return Locale(key)
end

export("Locale", Locale)
export("_L", _L)
export("L_", L_)