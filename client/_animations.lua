-- ====================================================================================--

c.animation = {}
c.animations = {}
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

function c.animation.AddAnimation(dict, anim, name)
    if not c.animations[name] then
        c.animations[name] = function(bool, ped, cb, once)
            if once == nil then once = false end
            local p = promise.new()
            local ped = Getped(ped)
            local dict = c.check.String(dict)
            local anim = c.check.String(anim)
            --
            if not DoesAnimDictExist(dict) then
                c.debug_1("DoesAnimDictExist - "..dict.." Does not exist, please check the name.")
                return
            end
            --
            local duration = GetAnimDuration(dict, anim)
            RequestAnimDict(dict)
            while not HasAnimDictLoaded(dict) do
                Citizen.Wait(100)
            end
            --
            if bool and not IsEntityPlayingAnim(ped, dict, anim, 3) then
                TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 50, 0, false, false, false)
                c.data.SetPlayerState("Animation", name, true)
                if cb then
                    cb(duration)
                end
                if once then
                    Citizen.Wait(duration)
                    if HasEntityAnimFinished(ped, dict, anim, 3) then
                        p:resolve()
                        RemoveAnimDict(dict)
                        ClearPedTasks(ped)
                    end
                    Citizen.Await(p)
                    c.data.SetPlayerState("Animation", false, true)
                end
            else
                ClearPedTasks(ped)
                c.data.SetPlayerState("Animation", false, true)
                p:resolve()
                RemoveAnimDict(dict)
                Citizen.Await(p)
            end
        end
        RegisterNetEvent("Client:Animation:"..name)
        AddEventHandler("Client:Animation:"..name, function(bool, ped, cb, once)
            c.animations[name](bool, ped, cb, once)
        end)
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
        c.data.SetPlayerState("Animation", "CrossedArms", true)
        RemoveAnimDict(dict)
    else
        ClearPedTasks(ped)
        c.data.SetPlayerState("Animation", false, true)
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
        c.data.SetPlayerState("Animation", "HandsUp", true)
        RemoveAnimDict(dict)
    else
        ClearPedTasks(ped)
        c.data.SetPlayerState("Animation", false, true)
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
        c.data.SetPlayerState("Animation", "ArmHold", true)
        RemoveAnimDict(dict)
    else
        ClearPedTasks(ped)
        c.data.SetPlayerState("Animation", false, true)
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
        c.data.SetPlayerState("Animation", "Mugging", true)
        RemoveAnimDict(dict)
    else
        ClearPedTasks(ped)
        c.data.SetPlayerState("Animation", false, true)
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
        c.data.SetPlayerState("Animation", "PickUp", true)
        RemoveAnimDict(dict)
    else
        ClearPedTasks(ped)
        c.data.SetPlayerState("Animation", false, true)
        RemoveAnimDict(dict)
    end
end)
-- ====================================================================================--

c.animation.AddAnimation("random@getawaydriver", "gesture_nod_yes_hard", "Nod")
c.animation.AddAnimation("mini@repair", "fixing_a_player", "Lockpick")
c.animation.AddAnimation("mini@repair", "fixing_a_player", "RepairCar")
c.animation.AddAnimation("random@arrests", "idle_c", "PhoneCall")
c.animation.AddAnimation("random@car_thief@agitated@idle_a", "agitated_idle_a", "FacePalm")
-- Escort Player
c.animation.AddAnimation("missfinale_c2mcs_1", "fin_c2_mcs_1_camman", "Escorting")
c.animation.AddAnimation("amb@world_human_bum_slumped@male@laying_on_left_side@base", "base", "Escorted")
-- Cuff animation
c.animation.AddAnimation("mp_arrest_paired", "crook_p2_back_right", "Cuffed")
c.animation.AddAnimation("mp_arrest_paired", "cop_p2_back_right", "Cuffer")
-- surrender
c.animation.AddAnimation("random@arrests@busted", "enter", "Surrender")
