-- ====================================================================================--

--[[
NOTES
    -
]] --
-- ====================================================================================--

local GetItems = RegisterServerCallback({
    eventName = 'GetItems',
    eventCallback = function(source, ...)
        local items = c.item.GetItems()
        return items
    end
})

local GetDumpedHashes = RegisterServerCallback({
    eventName = 'GetDumpedHashes',
    eventCallback = function(source, ...)
        local items = c.vehicle.GetDumpedHashes()
        return items
    end
})

local GetInventory = RegisterServerCallback({
    eventName = 'GetInventory',
    eventCallback = function(source, net)
        local src = source
        local entity = NetworkGetEntityFromNetworkId(net)
        local type = GetEntityType(entity)
        -- Is it valid on the server?
        if DoesEntityExist(entity) then
            --
            -- Object
            if type == 3 then   
                local xObject = c.data.GetObject(net)
                return xObject.GetInventory()
            --
            -- Vehicle
            elseif type == 2 then
                local xVehicle = c.data.GetVehicle(net)
                return xVehicle.GetInventory()
            --
            -- Ped
            elseif type == 1 then
                if IsPedAPlayer(entity) then
                    local xPlayer = c.data.GetPlayer(net)
                    return xPlayer.GetInventory()
                else
                    -- is an NPC
                    local xNpc = c.data.GetNpc(net)
                    return xNpc.GetInventory()
                end
            end
        end
    end
})

local GetJobs = RegisterServerCallback({
    eventName = 'GetJobs',
    eventCallback = function(source, ...)
        return c.job.ActiveMembers()
    end
})