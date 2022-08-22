
local Weapon = RegisterClientCallback({
    eventName = "Client:Item:Weapon",
    eventCallback = function(k, ammo, ammotype, hash, components)
        local Ped = PlayerPedId()
        -- _Weaponnameame
        local Name = k
        c._weaponname = Name
        -- _Type
        local AmmoType = ammotype
        c._ammotype = AmmoType
        -- _Ammo
        local Ammo = ammo
        if c._ammo[AmmoType] > Ammo then
            Ammo = c._ammo[AmmoType]
        else
            c._ammo[AmmoType] = Ammo
        end
        -- _Weapon
        local Hash = tonumber(hash)
        -- _Componenets
        local Components = components
        c._components = Components
        --
        if c._weapon == Hash then
            SetCurrentPedWeapon(Ped, `WEAPON_UNARMED`, true)
            RemoveAllPedWeapons(Ped, true)
            c._weapon = nil
        else
            if Hash == `WEAPON_PETROLCAN` or Hash == `WEAPON_FIREEXTINGUISHER` then
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
            c._weapon = Hash
        end
        --
    end
})

local Consumeable = RegisterClientCallback({
    eventName = "Client:Item:Consumeable",
    eventCallback = function(k)
        local Name = k
        local Data = c.item.GetData(Name)
        --
        if Data.Modifiers then
            if Data.Modifiers.Hunger then
                c.modifier.AddHungerModifier(Data.Modifiers.Hunger)
            end
            if Data.Modifiers.Thirst then
                c.modifier.AddThirstModifier(Data.Modifiers.Thirst)
            end
            if Data.Modifiers.Stress then
                c.modifier.AddStressModifier(Data.Modifiers.Stress)
            end
        end
        --
        if Data.Status then
            if Data.Status.Health then
                c.status.SetHealth(c.check.Number((c.status.GetHealth() + Data.Status.Health), 0, 400))
            end
            if Data.Status.Armour then
                c.status.AddArmourToAmount(c.check.Number(Data.Status.Armour, 1, 100))
            end
            if Data.Status.Hunger then
                if Data.Status.Hunger > 0 then
                    c.status.AddHunger(Data.Status.Hunger)
                else
                    c.status.RemoveHunger(Data.Status.Hunger)
                end
            end
            if Data.Status.Thirst then
                if Data.Status.Thirst > 0 then
                    c.status.AddThirst(Data.Status.Thirst)
                else
                    c.status.RemoveThirst(Data.Status.Thirst)
                end
            end
            if Data.Status.Stress then
                if Data.Status.Stress > 0 then
                    c.status.AddStress(Data.Status.Stress)
                else
                    c.status.RemoveStress(Data.Status.Stress)
                end
            end
        end
        --
    end
})