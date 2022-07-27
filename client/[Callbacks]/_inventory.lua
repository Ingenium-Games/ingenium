local Weapon = RegisterClientCallback({
    eventName = "Client:Item:Weapon",
    eventCallback = function(data)
        local Ped = PlayerPedId()
        local Name = data.Name
        local Ammo = data.Ammo or 0
        local AmmoType = data.AmmoType
        local Hash = data.Hash
        local Components = data.Components
        --
        if c.CurrentWeapon == Name then
            SetCurrentPedWeapon(Ped, `WEAPON_UNARMED`, true)
            RemoveAllPedWeapons(Ped, true)
            c.CurrentWeapon = nil
        else
            if Name == "WEAPON_PETROLCAN" or Name == "WEAPON_FIREEXTINGUISHER" then
                Ammo = 4000
            end
            GiveWeaponToPed(Ped, Hash, 0, false, false)
            SetPedAmmo(Ped, Hash, Ammo)
            SetCurrentPedWeapon(Ped, Hash, true)
            if Components then
                for _, v in pairs(Components) do
                    GiveWeaponComponentToPed(Ped, Hash, GetHashKey(v))
                end
            end
            c.CurrentWeapon = Name
        end
        --
    end
})

local Consumeable = RegisterClientCallback({
    eventName = "Client:Item:Consumeable",
    eventCallback = function(data)
        local Name = data.Name
        local Meta = c.item.GetMeta(Name)
        local Data = c.item.GetData(Name)
        --
        
        --
    end
})