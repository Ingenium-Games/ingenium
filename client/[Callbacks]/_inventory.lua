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
                c.status.AddArmourToAmount(c.checkNumber(Data.Status.Armour, 1, 100))
            end
            if Data.Status.Hunger then
                if Data.Status.Hunger < 0 then
                    c.status.AddHunger(Data.Status.Hunger)
                else
                    c.status.RemoveHunger(Data.Status.Hunger)
                end
            end
            if Data.Status.Thirst then
                if Data.Status.Thirst < 0 then
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