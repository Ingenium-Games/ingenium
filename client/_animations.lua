-- ====================================================================================--
ig.animation = {}
-- ====================================================================================--
RegisterNetEvent("Animation:General:ArmsCrossed")
AddEventHandler("Animation:General:ArmsCrossed", function(bool, ped)
    local ped = ped or GetPlayerPed(-1)
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
            ig.data.SetLocalPlayerState("Animation", "CrossedArms", true) 
        end
        RemoveAnimDict(dict)
    else
        ClearPedTasks(ped)
        if IsPedAPlayer(ped) then
            ig.data.SetLocalPlayerState("Animation", false, true)
        end
        RemoveAnimDict(dict)
    end
end)
-- ====================================================================================--
RegisterNetEvent("Animation:General:HandsUp")
AddEventHandler("Animation:General:HandsUp", function(bool, ped)
    local ped = ped or GetPlayerPed(-1)
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
            ig.data.SetLocalPlayerState("Animation", "HandsUp", true)
        end
        RemoveAnimDict(dict)
    else
        ClearPedTasks(ped)
        if IsPedAPlayer(ped) then
            ig.data.SetLocalPlayerState("Animation", false, true) 
        end
        RemoveAnimDict(dict)
    end
end)
-- ====================================================================================--
RegisterNetEvent("Animation:General:HoldArm")
AddEventHandler("Animation:General:HoldArm", function(bool, ped)
    local ped = ped or GetPlayerPed(-1)
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
            ig.data.SetLocalPlayerState("Animation", "ArmHold", true)
        end
        RemoveAnimDict(dict)
    else
        ClearPedTasks(ped)
        if IsPedAPlayer(ped) then
            ig.data.SetLocalPlayerState("Animation", false, true)
        end
        RemoveAnimDict(dict)
    end
end)
-- ====================================================================================--
RegisterNetEvent("Animation:General:Mugging")
AddEventHandler("Animation:General:Mugging", function(bool, ped)
    local ped = ped or GetPlayerPed(-1)
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
            ig.data.SetLocalPlayerState("Animation", "Mugging", true)
        end
        RemoveAnimDict(dict)
    else
        ClearPedTasks(ped)
        if IsPedAPlayer(ped) then
            ig.data.SetLocalPlayerState("Animation", false, true)
        end
        RemoveAnimDict(dict)
    end
end)
-- ====================================================================================--
RegisterNetEvent("Animation:General:PickUp")
AddEventHandler("Animation:General:PickUp", function(bool, ped)
    local ped = ped or GetPlayerPed(-1)
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
            ig.data.SetLocalPlayerState("Animation", "PickUp", true)
        end
        RemoveAnimDict(dict)
    else
        ClearPedTasks(ped)
        if IsPedAPlayer(ped) then
            ig.data.SetLocalPlayerState("Animation", false, true)
        end
        RemoveAnimDict(dict)
    end
end)
-- ====================================================================================--
RegisterNetEvent("Animation:General:Escorting")
AddEventHandler("Animation:General:Escorting", function(bool, ped)
    local ped = ped or GetPlayerPed(-1)
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
            ig.data.SetLocalPlayerState("Animation", "Escorting", true)
        end
        RemoveAnimDict(dict)
    else
        ClearPedTasks(ped)
        if IsPedAPlayer(ped) then
            ig.data.SetLocalPlayerState("Animation", false, true)
        end
        RemoveAnimDict(dict)
    end
end)
-- ====================================================================================--
RegisterNetEvent("Animation:General:Escorted")
AddEventHandler("Animation:General:Escorted", function(bool, ped)
    local ped = ped or GetPlayerPed(-1)
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
            ig.data.SetLocalPlayerState("Animation", "Escorted", true)
        end
        RemoveAnimDict(dict)
    else
        ClearPedTasks(ped)
        if IsPedAPlayer(ped) then
            ig.data.SetLocalPlayerState("Animation", false, true)
        end
        RemoveAnimDict(dict)
    end
end)
-- ====================================================================================--
RegisterNetEvent("Animation:General:Nod")
AddEventHandler("Animation:General:Nod", function(bool, ped)
    local ped = ped or GetPlayerPed(-1)
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
            ig.data.SetLocalPlayerState("Animation", "Nod", true)
        end
        RemoveAnimDict(dict)
    else
        ClearPedTasks(ped)
        if IsPedAPlayer(ped) then
            ig.data.SetLocalPlayerState("Animation", false, true)
        end
        RemoveAnimDict(dict)
    end
end)
-- ====================================================================================--
RegisterNetEvent("Animation:General:Lockpick")
AddEventHandler("Animation:General:Lockpick", function(bool, ped)
    local ped = ped or GetPlayerPed(-1)
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
            ig.data.SetLocalPlayerState("Animation", "Lockpick", true)
        end
        RemoveAnimDict(dict)
    else
        ClearPedTasks(ped)
        if IsPedAPlayer(ped) then
            ig.data.SetLocalPlayerState("Animation", false, true)
        end
        RemoveAnimDict(dict)
    end
end)
-- ====================================================================================--
RegisterNetEvent("Animation:General:Repair")
AddEventHandler("Animation:General:Repair", function(bool, ped)
    local ped = ped or GetPlayerPed(-1)
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
            ig.data.SetLocalPlayerState("Animation", "Repair", true)
        end
        RemoveAnimDict(dict)
    else
        ClearPedTasks(ped)
        if IsPedAPlayer(ped) then
            ig.data.SetLocalPlayerState("Animation", false, true)
        end
        RemoveAnimDict(dict)
    end
end)
-- ====================================================================================--
RegisterNetEvent("Animation:General:PhoneCall")
AddEventHandler("Animation:General:PhoneCall", function(bool, ped)
    local ped = ped or GetPlayerPed(-1)
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
            ig.data.SetLocalPlayerState("Animation", "PhoneCall", true)
        end
        RemoveAnimDict(dict)
    else
        ClearPedTasks(ped)
        if IsPedAPlayer(ped) then
            ig.data.SetLocalPlayerState("Animation", false, true)
        end
        RemoveAnimDict(dict)
    end
end)
-- ====================================================================================--
RegisterNetEvent("Animation:General:FacePalm")
AddEventHandler("Animation:General:FacePalm", function(bool, ped)
    local ped = ped or GetPlayerPed(-1)
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
            ig.data.SetLocalPlayerState("Animation", "FacePalm", true)
        end
        RemoveAnimDict(dict)
    else
        ClearPedTasks(ped)
        if IsPedAPlayer(ped) then
            ig.data.SetLocalPlayerState("Animation", false, true)
        end
        RemoveAnimDict(dict)
    end
end)
-- ====================================================================================--
