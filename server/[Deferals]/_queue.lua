-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[
 
EXPERIMENTAL, DO NOT USE.


local maxplayers = GetConvar(sv_maxclients, 0)
local queue = {} 

function AddToQueue(source)
    local num = tonumber(source)
    table.insert(queue, num)
end

function PlaceInQueue(source)
    local num = tonumber(source)
    local count = 0
    for k,v in ipairs(queue) do
        count = count + 1
        if v == num then
            break
        end
    end
    return count
end

function TriggerQueueUpdate(d)
    local place = PlaceInQueue() 
    local ingame = #GetPlayers()
    local connectingqueue = DeferralCards.Card:Create()
    local facts = DeferralCards.Container:FactSet({facts = {}})
    table.insert(connectingqueue.body, DeferralCards.Container:Create({
        items = {
            DeferralCards.CardElement:TextBlock({
                size = 'Medium',
                weight = 'Bolder',
                text = 'Place in Queue '..place..' / '.. #queue,
            }),
            DeferralCards.CardElement:TextBlock({
                text = 'Players in Game: '..ingame,
                wrap = true
            })
        }})
    )
    Citizen.Wait(0)
    d.presentCard(connectingqueue:Generate(), function(data, raw)
        if (maxplayers - ingame) >= 1 then
            Citizen.Wait(0)    
            d.upate("Joining...")
            Citizen.Wait(1000)
            d.done("")
        end
    end)
end

function RemoveFromQueue(source)
    local num = tonumber(source)
    table.remove(queue, num)
    TriggerQueueUpdate()
end

local QueueUpdate = RegisterServerCallback({
    eventName = 'QueueUpdate',
    eventCallback = function(source, ...)
        RemoveFromQueue(source)
    end
})


]]--
