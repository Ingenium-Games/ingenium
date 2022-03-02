-- ====================================================================================--

--[[
NOTES
    -
]] --
-- ====================================================================================--

local GetItems = RegisterServerCallback({
    eventName = "GetItems",
    eventCallback = function(source, ...)
        local items = c.item.GetItems()
        return items
    end
})

local GetJobs = RegisterServerCallback({
    eventName = "GetJobs",
    eventCallback = function(source, ...)
        local jobs = c.job.GetJobs()
        return jobs
    end
})

local GetActiveWorkers = RegisterServerCallback({
    eventName = "GetActiveWorkers",
    eventCallback = function(source, ...)
        return c.job.ActiveMembers()
    end
})

local GetInventory = RegisterServerCallback({
    eventName = "GetInventory",
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

local GetInventory = RegisterServerCallback({
    eventName = "OrganizeInventory",
    eventCallback = function(source, net, inv)
        local src = source
        local entity = NetworkGetEntityFromNetworkId(net)
        local type = GetEntityType(entity)
        -- Is it valid on the server?
        if DoesEntityExist(entity) then
            --
            -- Object
            if type == 3 then   
                local xObject = c.data.GetObject(net)
                local size = #xObject.GetInventory()
                if size == #inv then
                    xObject.UnpackInventory(inv)
                else
                    c.eventban(src, "Error in organizing invent, additional items or quanitty found, removed player.")
                end 
            --
            -- Vehicle
            elseif type == 2 then
                local xVehicle = c.data.GetVehicle(net)
                local size = #xVehicle.GetInventory()
                if size == #inv then
                    xVehicle.UnpackInventory(inv)
                else
                    c.eventban(src, "Error in organizing invent, additional items or quanitty found, removed player.")
                end
            --
            -- Ped
            elseif type == 1 then
                if IsPedAPlayer(entity) then
                    local xPlayer = c.data.GetPlayer(net)
                    local size = #xPlayer.GetInventory()
                    if size == #inv then
                        xPlayer.UnpackInventory(inv)
                    else
                        c.eventban(src, "Error in organizing invent, additional items or quanitty found, removed player.")
                    end
                else
                    -- is an NPC
                    local xNpc = c.data.GetNpc(net)
                    local size = #xNpc.GetInventory()
                    if size == #inv then
                        xNpc.UnpackInventory(inv)
                    else
                        c.eventban(src, "Error in organizing invent, additional items or quanitty found, removed player.")
                    end
                end
            end
        end
    end
})
