-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
-- ====================================================================================--
c.animations = {}
--[[
NOTES.
    - Animations are registered as events, this can be useful for creating scripts that force a level of immersion.
    - Example for RP, A police officer is aiming a weapon at an UNARMED ped, that ped is forced to raise their hands.
    - If they aim at an ARMED ped, the ped does not have to raise hands.
]] --
-- ====================================================================================--
local function GetPed(Ped)
    if Ped == nil then
        Ped = GetPlayerPed(-1)
        return Ped
    else
        return Ped
    end
end
-- ====================================================================================--
RegisterNetEvent("Client:Animation:CrossedArms")
AddEventHandler("Client:Animation:CrossedArms", function(Bool, Ped)
    local ped = GetPed(Ped)
    local dict = "amb@world_human_hang_out_street@female_armscrossed@base" 
    local anim = "base" 
    --
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(1)
    end
    --
    if Bool and not IsEntityPlayingAnim(ped, dict, anim, 3) then
        TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 50, 0, false, false, false)
        c.data.SetPlayerState(PlayerId(), "Animation", "CrossedArms", true)
        RemoveAnimDict(dict)
    else
        ClearPedTasks(ped)
        c.data.SetPlayerState(PlayerId(), "Animation", false, true)
        RemoveAnimDict(dict)
    end
end)
-- ====================================================================================--
RegisterNetEvent("Client:Animation:HandsUp")
AddEventHandler("Client:Animation:HandsUp", function(Bool, Ped)
    local ped = GetPed(Ped)
    local dict = "missminuteman_1ig_2"
    local anim = "handsup_enter"
    --
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(1)
    end
    --
    if Bool and not IsEntityPlayingAnim(ped, dict, anim, 3) then
        TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 50, 0, false, false, false)
        c.data.SetPlayerState(PlayerId(), "Animation", "HandsUp", true)
        RemoveAnimDict(dict)
    else
        ClearPedTasks(ped)
        c.data.SetPlayerState(PlayerId(), "Animation", false, true)
        RemoveAnimDict(dict)
    end
end)
-- ====================================================================================--
RegisterNetEvent("Client:Animation:ArmHold")
AddEventHandler("Client:Animation:ArmHold", function(Bool, Ped)
    local ped = GetPed(Ped)
    local dict = "anim@amb@nightclub@peds@"
    local anim = "amb_world_human_hang_out_street_female_hold_arm_idle_b"
    --
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(1)
    end
    --
    if Bool and not IsEntityPlayingAnim(ped, dict, anim, 3) then
        TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 50, 0, false, false, false)
        c.data.SetPlayerState(PlayerId(), "Animation", "ArmHold", true)
        RemoveAnimDict(dict)
    else
        ClearPedTasks(ped)
        c.data.SetPlayerState(PlayerId(), "Animation", false, true)
        RemoveAnimDict(dict)
    end
end)
-- ====================================================================================--