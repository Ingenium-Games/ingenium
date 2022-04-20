-- ====================================================================================--
if not c.rpc then c.rpc = {} end
--
c.rpc.EquipWeaponToPed = function(source, weapon, ammo, force)
    -- Item
    local ammo = ammo or 21
    local force = force or true
    local xPlayer = c.data.GetPlayer(source)
    local CurrentWeapon = GetSelectedPedWeapon(xPlayer.Ped)
    if CurrentWeapon ~= nil then
        RemoveWeaponFromPed(xPlayer.Ped, CurrentWeapon)
    end
    GiveWeaponToPed(xPlayer.Ped, weapon, ammo, false, force)
    for k,v in pairs(xPlayer) do
    
    end
end