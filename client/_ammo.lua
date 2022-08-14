-- ====================================================================================--
c.Ammo = {["9mm"]=0,["5.56mm"]=0,["7.62mm"]=0,["20g"]=0,[".223"]=0,[".308"]=0}
c.ammo = {}
-- ====================================================================================--

function c.ammo.SetAmmo(type, amount)
    c.Ammo[type] = c.check.Number(amount, 0, 500)
end

function c.ammo.GetAmmo(type)
    return c.Ammo[type]
end

function c.ammo.GetAll()
    return c.Ammo
end

function c.ammo.ServerSync()
    local ammo = c.ammo.GetAll()
    TriggerServerCallback({eventName = "UpdateAmmo", args = {ammo}})
end

