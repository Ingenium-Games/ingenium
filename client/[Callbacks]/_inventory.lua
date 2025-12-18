-- ====================================================================================--

-- ====================================================================================--
local Weapon = RegisterClientCallback({
    eventName = "Client:Item:Weapon",
    eventCallback = function(k, ammo, ammotype, hash, components)
        local Ped = PlayerPedId()
        -- _Weaponnameame
        local Name = k
        ig._weaponname = Name
        -- _Type
        local AmmoType = ammotype
        ig._ammotype = AmmoType
        -- _Ammo
        local Ammo = ammo
        if ig._ammo[AmmoType] > Ammo then
            Ammo = ig._ammo[AmmoType]
        else
            ig._ammo[AmmoType] = Ammo
        end
        -- _Weapon
        local Hash = tonumber(hash)
        -- _Componenets
        local Components = components
        ig._components = Components
        --
        if ig._weapon == Hash then
            -- If putting the gun away, update the ammo
            TriggerServerCallback({
                eventName = "UpdateAmmo",
                args = {ig._ammotype, ig._ammo[ig._ammotype]}
            })
            --
            SetCurrentPedWeapon(Ped, `WEAPON_UNARMED`, true)
            RemoveAllPedWeapons(Ped, true)
            ig._weapon = nil
        else
            if Hash == `WEAPON_PETROLCAN` or Hash == `WEAPON_FIREEXTINGUISHER` then
                Ammo = 4000
            end
            --
            GiveWeaponToPed(Ped, Hash, 0, false, false)
            SetCurrentPedWeapon(Ped, Hash, true)
            SetPedAmmo(Ped, Hash, Ammo)
            --
            if Components then
                for _, v in pairs(Components) do
                    GiveWeaponComponentToPed(Ped, Hash, GetHashKey(v))
                end
            end
            --
            ig._weapon = Hash
        end
        --
    end
})

local Consumeable = RegisterClientCallback({
    eventName = "Client:Item:Consumeable",
    eventCallback = function(k)
        local Name = k
        local Data = ig.item.GetData(Name)
        --
        if Data.Modifiers then
            if Data.Modifiers.Hunger then
                ig.modifier.SetHungerModifier(Data.Modifiers.Hunger)
            end
            if Data.Modifiers.Thirst then
                ig.modifier.SetThirstModifier(Data.Modifiers.Thirst)
            end
            if Data.Modifiers.Stress then
                ig.modifier.SetStressModifier(Data.Modifiers.Stress)
            end
        end
        --
        if Data.Status then
            if Data.Status.Health then
                ig.status.SetHealth(ig.check.Number((ig.status.GetHealth() + Data.Status.Health), 0, 400))
            end
            if Data.Status.Armour then
                ig.status.AddArmourToAmount(ig.check.Number(Data.Status.Armour, 1, 100))
            end
            if Data.Status.Hunger then
                if Data.Status.Hunger > 0 then
                    ig.status.AddHunger(Data.Status.Hunger)
                else
                    ig.status.RemoveHunger(Data.Status.Hunger)
                end
            end
            if Data.Status.Thirst then
                if Data.Status.Thirst > 0 then
                    ig.status.AddThirst(Data.Status.Thirst)
                else
                    ig.status.RemoveThirst(Data.Status.Thirst)
                end
            end
            if Data.Status.Stress then
                if Data.Status.Stress > 0 then
                    ig.status.AddStress(Data.Status.Stress)
                else
                    ig.status.RemoveStress(Data.Status.Stress)
                end
            end
        end
        --
        if Data.Ammo then
            local type = Data.Ammo.Type
            local amount = Data.Ammo.Amount
            ig._ammo[type] = ig._ammo[type] + amount
            TriggerServerCallback({
                eventName = "UpdateAmmo",
                args = {type, ig._ammo[type]}
            })
        end
    end
})


local Skateboard = RegisterClientCallback({
    eventName = "Client:Item:Skateboard",
    eventCallback = function()
        if IsPedOnFoot(PlayerPedId()) then
            ExecuteCommand("skate")
        else
            TriggerEvent("Client:Notify","You must be out of a vehicle to use this.")
        end
    end
})

local Phone = RegisterClientCallback({
    eventName = "Client:Item:Phone",
    eventCallback = function()
        local isOpen = exports["ig.phone"]:isOpen()
        if not isOpen then
            exports["ig.phone"]:openPhone()
        else
            exports["ig.phone"]:closePhone()
        end
    end
})
