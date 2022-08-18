-- ====================================================================================--
c.ammo = {}
-- ====================================================================================--

function c.ammo.SetDefault()
    c._ammo = {["9mm"]=0,["5.56mm"]=0,["7.62mm"]=0,["20g"]=0,[".223"]=0,[".308"]=0}
end

function c.ammo.SetType(type, amount)
    c._ammo[type] = c.check.Number(amount, 0, 500)
end

function c.ammo.GetType(type)
    return c._ammo[type]
end

function c.ammo.Get()
    return c._ammo
end

function c.ammo.ServerSync()
    local ammo = c.ammo.Get()
    TriggerServerCallback({eventName = "UpdateAmmo", args = {ammo}})
end

