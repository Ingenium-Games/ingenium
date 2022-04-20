-- ====================================================================================--
if not c.rpc then c.rpc = {} end
--
c.rpc.EquipWeaponToPed = function(source)
    local xPlayer = c.data.GetPlayer(source)
    local CurrentWeapon = GetSelectedPedWeapon(xPlayer.Ped)
    if CurrentWeapon ~= nil then
        RemoveWeaponFromPed(Ped,CurrentWeapon)
    end
    GiveWeaponToPed(Ped, c.item[v].Weapon, 100, false, true)
    for k,v in pairs() end
end