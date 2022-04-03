-- ====================================================================================--
c.animation = {}
--[[
NOTES.
    - Animations are registered as events, this can be useful for creating scripts that force a level of immersion.
    - Example for RP, A police officer is aiming a weapon at an UNARMED ped, that ped is forced to raise their hands.
    - If they aim at an ARMED ped, the ped does not have to raise hands.
]] --
-- ====================================================================================--
local function Getped(ped)
    if ped == nil then
        ped = GetPlayerped(-1)
        return ped
    else
        return ped
    end
end
-- ====================================================================================--
RegisterNetEvent("Client:Animation:CrossedArms")
AddEventHandler("Client:Animation:CrossedArms", function(bool, ped)
    local ped = Getped(ped)
    local dict = "amb@world_human_hang_out_street@female_arms_crossed@base" 
    local anim = "base" 
    --
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end
    --
    if bool and not IsEntityPlayingAnim(ped, dict, anim, 3) then
        TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 50, 0, false, false, false)
        if IsPedAPlayer(ped) then
            c.data.SetLocalPlayerState("Animation", "CrossedArms", true)
        else
            c.data.SetEntityState(ped, "Animation", "CrossedArms", true)    
        end
        RemoveAnimDict(dict)
    else
        ClearPedTasks(ped)
        if IsPedAPlayer(ped) then
            c.data.SetLocalPlayerState("Animation", false, true)
        else
            c.data.SetEntityState(ped, "Animation", false, true)    
        end
        RemoveAnimDict(dict)
    end
end)
-- ====================================================================================--
RegisterNetEvent("Client:Animation:HandsUp")
AddEventHandler("Client:Animation:HandsUp", function(bool, ped)
    local ped = Getped(ped)
    local dict = "missminuteman_1ig_2"
    local anim = "handsup_enter"
    --
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end
    --
    if bool and not IsEntityPlayingAnim(ped, dict, anim, 3) then
        TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 50, 0, false, false, false)
        if IsPedAPlayer(ped) then
            c.data.SetLocalPlayerState("Animation", "HandsUp", true)
        else
            c.data.SetEntityState(ped, "Animation", "HandsUp", true)   
        end
        RemoveAnimDict(dict)
    else
        ClearPedTasks(ped)
        if IsPedAPlayer(ped) then
            c.data.SetLocalPlayerState("Animation", false, true)
        else
            c.data.SetEntityState(ped, "Animation", false, true)    
        end
        RemoveAnimDict(dict)
    end
end)
-- ====================================================================================--
RegisterNetEvent("Client:Animation:ArmHold")
AddEventHandler("Client:Animation:ArmHold", function(bool, ped)
    local ped = Getped(ped)
    local dict = "anim@amb@nightclub@peds@"
    local anim = "amb_world_human_hang_out_street_female_hold_arm_idle_b"
    --
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end
    --
    if bool and not IsEntityPlayingAnim(ped, dict, anim, 3) then
        TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 50, 0, false, false, false)
        if IsPedAPlayer(ped) then
            c.data.SetLocalPlayerState("Animation", "ArmHold", true)
        else
            c.data.SetEntityState(ped, "Animation", "ArmHold", true)   
        end
        RemoveAnimDict(dict)
    else
        ClearPedTasks(ped)
        if IsPedAPlayer(ped) then
            c.data.SetLocalPlayerState("Animation", false, true)
        else
            c.data.SetEntityState(ped, "Animation", false, true)   
        end
        RemoveAnimDict(dict)
    end
end)
-- ====================================================================================--
RegisterNetEvent("Client:Animation:Mugging")
AddEventHandler("Client:Animation:Mugging", function(bool, ped)
    local ped = Getped(ped)
    local dict = "random@mugging5"
    local anim = "ig_1_guy_handoff"
    --
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end
    --
    if bool and not IsEntityPlayingAnim(ped, dict, anim, 3) then
        TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 50, 0, false, false, false)
        if IsPedAPlayer(ped) then
            c.data.SetLocalPlayerState("Animation", "Mugging", true)
        else
            c.data.SetEntityState(ped, "Animation", "Mugging", true)
        end
        RemoveAnimDict(dict)
    else
        ClearPedTasks(ped)
        if IsPedAPlayer(ped) then
            c.data.SetLocalPlayerState("Animation", false, true)
        else
            c.data.SetEntityState(ped, "Animation", false, true)
        end
        RemoveAnimDict(dict)
    end
end)
-- ====================================================================================--
RegisterNetEvent("Client:Animation:PickUp")
AddEventHandler("Client:Animation:PickUp", function(bool, ped)
    local ped = Getped(ped)
    local dict = "pickup_object"
    local anim = "putdown_low"
    --
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end
    --
    if bool and not IsEntityPlayingAnim(ped, dict, anim, 3) then
        TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 50, 0, false, false, false)
        if IsPedAPlayer(ped) then
            c.data.SetLocalPlayerState("Animation", "PickUp", true)
        else
            c.data.SetEntityState(ped, "Animation", "PickUp", true)
        end
        RemoveAnimDict(dict)
    else
        ClearPedTasks(ped)
        if IsPedAPlayer(ped) then
            c.data.SetLocalPlayerState("Animation", false, true)
        else
            c.data.SetEntityState(ped, "Animation", false, true)
        end
        RemoveAnimDict(dict)
    end
end)
-- ====================================================================================--
RegisterNetEvent("Client:Animation:Escorting")
AddEventHandler("Client:Animation:Escorting", function(bool, ped)
    local ped = Getped(ped)
    local dict = "missfinale_c2mcs_1"
    local anim = "fin_c2_mcs_1_camman"
    --
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end
    --
    if bool and not IsEntityPlayingAnim(ped, dict, anim, 3) then
        TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 50, 0, false, false, false)
        if IsPedAPlayer(ped) then
            c.data.SetLocalPlayerState("Animation", "Escorting", true)
        else
            c.data.SetEntityState(ped, "Animation", "Escorting", true)
        end
        RemoveAnimDict(dict)
    else
        ClearPedTasks(ped)
        if IsPedAPlayer(ped) then
            c.data.SetLocalPlayerState("Animation", false, true)
        else
            c.data.SetEntityState(ped, "Animation", false, true)
        end
        RemoveAnimDict(dict)
    end
end)
-- ====================================================================================--
RegisterNetEvent("Client:Animation:Escorted")
AddEventHandler("Client:Animation:Escorted", function(bool, ped)
    local ped = Getped(ped)
    local dict = "amb@world_human_bum_slumped@male@laying_on_left_side@base"
    local anim = "base"
    --
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end
    --
    if bool and not IsEntityPlayingAnim(ped, dict, anim, 3) then
        TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 50, 0, false, false, false)
        if IsPedAPlayer(ped) then
            c.data.SetLocalPlayerState("Animation", "Escorted", true)
        else
            c.data.SetEntityState(ped, "Animation", "Escorted", true)
        end
        RemoveAnimDict(dict)
    else
        ClearPedTasks(ped)
        if IsPedAPlayer(ped) then
            c.data.SetLocalPlayerState("Animation", false, true)
        else
            c.data.SetEntityState(ped, "Animation", false, true)
        end
        RemoveAnimDict(dict)
    end
end)
-- ====================================================================================--
RegisterNetEvent("Client:Animation:Nod")
AddEventHandler("Client:Animation:Nod", function(bool, ped)
    local ped = Getped(ped)
    local dict = "random@getawaydriver"
    local anim = "gesture_nod_yes_hard"
    --
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end
    --
    if bool and not IsEntityPlayingAnim(ped, dict, anim, 3) then
        TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 50, 0, false, false, false)
        if IsPedAPlayer(ped) then
            c.data.SetLocalPlayerState("Animation", "Nod", true)
        else
            c.data.SetEntityState(ped, "Animation", "Nod", true)
        end
        RemoveAnimDict(dict)
    else
        ClearPedTasks(ped)
        if IsPedAPlayer(ped) then
            c.data.SetLocalPlayerState("Animation", false, true)
        else
            c.data.SetEntityState(ped, "Animation", false, true)
        end
        RemoveAnimDict(dict)
    end
end)
-- ====================================================================================--
RegisterNetEvent("Client:Animation:Lockpick")
AddEventHandler("Client:Animation:Lockpick", function(bool, ped)
    local ped = Getped(ped)
    local dict = "mini@repair"
    local anim = "fixing_a_player"
    --
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end
    --
    if bool and not IsEntityPlayingAnim(ped, dict, anim, 3) then
        TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 50, 0, false, false, false)
        if IsPedAPlayer(ped) then
            c.data.SetLocalPlayerState("Animation", "Lockpick", true)
        else
            c.data.SetEntityState(ped, "Animation", "Lockpick", true)
        end
        RemoveAnimDict(dict)
    else
        ClearPedTasks(ped)
        if IsPedAPlayer(ped) then
            c.data.SetLocalPlayerState("Animation", false, true)
        else
            c.data.SetEntityState(ped, "Animation", false, true)
        end
        RemoveAnimDict(dict)
    end
end)
-- ====================================================================================--
RegisterNetEvent("Client:Animation:Repair")
AddEventHandler("Client:Animation:Repair", function(bool, ped)
    local ped = Getped(ped)
    local dict = "mini@repair"
    local anim = "fixing_a_player"
    --
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end
    --
    if bool and not IsEntityPlayingAnim(ped, dict, anim, 3) then
        TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 50, 0, false, false, false)
        if IsPedAPlayer(ped) then
            c.data.SetLocalPlayerState("Animation", "Repair", true)
        else
            c.data.SetEntityState(ped, "Animation", "Repair", true)
        end
        RemoveAnimDict(dict)
    else
        ClearPedTasks(ped)
        if IsPedAPlayer(ped) then
            c.data.SetLocalPlayerState("Animation", false, true)
        else
            c.data.SetEntityState(ped, "Animation", false, true)
        end
        RemoveAnimDict(dict)
    end
end)
-- ====================================================================================--
RegisterNetEvent("Client:Animation:PhoneCall")
AddEventHandler("Client:Animation:PhoneCall", function(bool, ped)
    local ped = Getped(ped)
    local dict = "random@arrests"
    local anim = "idle_c"
    --
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end
    --
    if bool and not IsEntityPlayingAnim(ped, dict, anim, 3) then
        TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 50, 0, false, false, false)
        if IsPedAPlayer(ped) then
            c.data.SetLocalPlayerState("Animation", "PhoneCall", true)
        else
            c.data.SetEntityState(ped, "Animation", "PhoneCall", true)
        end
        RemoveAnimDict(dict)
    else
        ClearPedTasks(ped)
        if IsPedAPlayer(ped) then
            c.data.SetLocalPlayerState("Animation", false, true)
        else
            c.data.SetEntityState(ped, "Animation", false, true)
        end
        RemoveAnimDict(dict)
    end
end)
-- ====================================================================================--
RegisterNetEvent("Client:Animation:FacePalm")
AddEventHandler("Client:Animation:FacePalm", function(bool, ped)
    local ped = Getped(ped)
    local dict = "random@car_thief@agitated@idle_a"
    local anim = "agitated_idle_a"
    --
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end
    --
    if bool and not IsEntityPlayingAnim(ped, dict, anim, 3) then
        TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 50, 0, false, false, false)
        if IsPedAPlayer(ped) then
            c.data.SetLocalPlayerState("Animation", "FacePalm", true)
        else
            c.data.SetEntityState(ped, "Animation", "FacePalm", true)
        end
        RemoveAnimDict(dict)
    else
        ClearPedTasks(ped)
        if IsPedAPlayer(ped) then
            c.data.SetLocalPlayerState("Animation", false, true)
        else
            c.data.SetEntityState(ped, "Animation", false, true)
        end
        RemoveAnimDict(dict)
    end
end)
