-- ====================================================================================--


-- ====================================================================================--

-- Default player to instance listed in conf.defaultinstance
-- [C+S]
RegisterNetEvent("Server:Instance:Player:Default")
AddEventHandler("Server:Instance:Player:Default", function(req)
    local src = req or source
    c.inst.SetPlayerDefault(src)
end)
