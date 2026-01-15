-- ====================================================================================--
-- Death handling (ig.death initialized in client/_var.lua)
-- ====================================================================================--

function ig.death.PlayerKilled()
    local ply = PlayerId()
    local ped = PlayerPedId()
    local log = false
    local cause = GetPedCauseOfDeath(ped)
    local source = GetPedSourceOfDeath(ped)
    local data

    if source ~= 0 then
        local type = GetEntityType(source)
        if type == 1 then
            cause = "Weapon"
            local attacker, weapon = NetworkGetEntityKillerOfPlayer(ply)
            local isplayer = IsPedAPlayer(attacker)
            if isplayer then
                log = {["Source"] = NetworkGetPlayerIndexFromPed(attacker), ["Weapon"] = weapon}
            else
                log = {["Source"] = 0, ["Weapon"] = weapon}
            end
        elseif type == 2 then
            cause = "Vehicle"
            local attacker = GetPedInVehicleSeat(source, 1)
            local class = GetVehicleClass(source)
            local primary, secondary = GetVehicleColours(source)
            local isplayer = IsPedAPlayer(attacker)
            if isplayer then
                log = {["Source"] = NetworkGetPlayerIndexFromPed(attacker), ["Class"] = conf.vehicle.classes[class], ["Primary"] = primary, ["Secondary"] = secondary}
            else
                log = {["Source"] = 0, ["Class"] = conf.vehicle.classes[class] or 21, ["Primary"] = primary, ["Secondary"] = secondary}
            end 
        elseif type == 3 then
            -- Did a brick fall on your ped, wtf?
            cause = "Object"
            log = {["Source"] = 0}
        end
    elseif source == 0 then
        cause = "Unknown"
        log = {["Source"] = -1}
    end
    data = {
        Log = log,
        Cause = cause,
        Coords = vector3(GetEntityCoords(ped)),
    }
    TriggerEvent("Client:Character:Death", data)
    -- Use callback for secure death reporting
    TriggerServerCallback({
        eventName = "Server:Character:Death",
        args = {data},
        callback = function(result)
            if result and not result.success then
                ig.debug.Error("Failed to report death: " .. (result.error or "Unknown error"))
            end
        end
    })
    ig.data.SetLocalPlayerState("IsDead", true, true)
    Wait(5850)
    local pos = GetEntityCoords(ped)
    local found, groundz = GetGroundZFor_3dCoord(pos.x, pos.y, pos.z, false)
    if found then
        SetEntityCoords(ped, vector3(pos.x, pos.y, groundz - 0.42))
    else
        SetEntityCoords(ped, vector3(pos.x, pos.y, pos.z - 0.42))
    end
end