-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[ 
NOTES.
    -
    -
    -
]] --

math.randomseed(c.Seed)
-- ====================================================================================--

local function PlayerKilled()
    local ply = PlayerId()
    local ped = PlayerPedId()
    local log = false
    local cause = GetPedCauseOfDeath(ped)
    local source = GetPedSourceOfDeath(ped)

    if source ~= 0 then
        local type = GetEntityType(source)
        if type == 1 then
            cause = "Weapon"
            local attacker, weapon = NetworkGetEntityKillerOfPlayer(ply)
            local isplayer = IsPedAPlayer(attacker)
            if isplayer then
                log = {["Source"] = NetworkGetPlayerIndexFromPed(attacker), ["Weapon"] = weapon}
            else
                log = {["Source"] = -1, ["Weapon"] = weapon}
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
                log = {["Source"] = -1, ["Class"] = conf.vehicle.classes[class], ["Primary"] = primary, ["Secondary"] = secondary}
            end 
        elseif type == 3 then
            -- Did a brick fall on your ped, wtf?
            cause = "Object"
            log = {["Source"] = -1}
        end
    end
    local data = {
        Log = log,
        Cause = cause,
        Coords = vector3(GetEntityCoords(ped)),
    }
    TriggerEvent("Client:Character:Death", data)
    TriggerServerEvent("Server:Character:Death", data)
end

Citizen.CreateThread(function()
    local IsDead = false
    while true do
        Citizen.Wait(0)
        if c.data.GetLoadedStatus() then
            local ply = PlayerId()
            local ped = PlayerPedId()
            while IsDead and IsPlayerDead() do
                Citizen.Wait(250)
            end
            if (IsPedFatallyInjured(ped) and not IsDead) or IsPlayerDead() then
                IsDead = true
                PlayerKilled()
            elseif not IsPedFatallyInjured(ped) and IsPlayerPlaying(ply) then
                IsDead = false
                Citizen.Wait(50)
            end
        else
            Citizen.Wait(1250)
        end
    end
end)