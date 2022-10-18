-- ====================================================================================--

c.drop = {}
c.drops = false

-- ====================================================================================--

RegisterNetEvent("Client:Drops:Update")
AddEventHandler("Client:Drops:Update", function(Drops)
    c.drops = Drops
end)

