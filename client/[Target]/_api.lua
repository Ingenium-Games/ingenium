-- ====================================================================================--
-- Target API - Zone and Entity Targeting System
-- ====================================================================================--

ig.target = ig.target or {}

---@param data table
---@return number
function ig.target.AddPolyZone(data)
    data.resource = GetInvokingResource()
    return lib.zones.poly(data).id
end

-- Backward compatibility export for external resources
exports('AddPolyZone', ig.target.AddPolyZone)

---@param data table
---@return number
function ig.target.AddBoxZone(data)
    data.resource = GetInvokingResource()
    return lib.zones.box(data).id
end
exports('AddBoxZone', ig.target.AddBoxZone)

---@param data table
---@return number
function ig.target.AddSphereZone(data)
    data.resource = GetInvokingResource()
    return lib.zones.sphere(data).id
end
exports('AddSphereZone', ig.target.AddSphereZone)

---@param id number
function ig.target.removeZone(id)
    Zones[id]:remove()
end
exports('removeZone', ig.target.removeZone)

---@param target table
---@param Add table
---@param resource string
local function AddTarget(target, add, resource)
    local num = #target
    for i = 1, #add do
        num += 1
        add[i].resource = resource or 'ig.target'
        target[num] = add[i]
    end
end

---@param target table
---@param remove table
---@param resource string
local function removeTarget(target, remove, resource)
    if type(remove) ~= 'table' then remove = { remove } end

    for i = #target, 1, -1 do
        local option = target[i]

        if option.resource == resource then
            for j = 1, #remove do
                if option.name == remove[j] then
                    table.remove(target, i)
                    break
                end
            end
        end
    end
end

local Peds = {}

---@param options table
function ig.target.AddGlobalPed(options)
    AddTarget(Peds, options, GetInvokingResource())
end
exports('AddGlobalPed', ig.target.AddGlobalPed)

---@param options table
function ig.target.removeGlobalPed(options)
    removeTarget(Peds, options, GetInvokingResource())
end
exports('removeGlobalPed', ig.target.removeGlobalPed)

local Vehicles = {}

---@param options table
function ig.target.AddGlobalVehicle(options)
    AddTarget(Vehicles, options, GetInvokingResource())
end
exports('AddGlobalVehicle', ig.target.AddGlobalVehicle)

---@param options table
function ig.target.removeGlobalVehicle(options)
    removeTarget(Vehicles, options, GetInvokingResource())
end
exports('removeGlobalVehicle', ig.target.removeGlobalVehicle)

local Objects = {}

---@param options table
function ig.target.AddGlobalObject(options)
    AddTarget(Objects, options, GetInvokingResource())
end
exports('AddGlobalObject', ig.target.AddGlobalObject)

---@param options table
function ig.target.removeGlobalObject(options)
    removeTarget(Objects, options, GetInvokingResource())
end
exports('removeGlobalObject', ig.target.removeGlobalObject)

local Players = {}

---@param options table
function ig.target.AddGlobalPlayer(options)
    AddTarget(Players, options, GetInvokingResource())
end
exports('AddGlobalPlayer', ig.target.AddGlobalPlayer)

---@param options table
function ig.target.removeGlobalPlayer(options)
    removeTarget(Players, options, GetInvokingResource())
end
exports('removeGlobalPlayer', ig.target.removeGlobalPlayer)

local Models = {}

---@param arr number | number[]
---@param options table
function ig.target.AddModel(arr, options)
    if type(arr) ~= 'table' then arr = { arr } end
    local resource = GetInvokingResource()

    for i = 1, #arr do
        local model = arr[i]
        model = type(model) == 'string' and joaat(model) or model

        if not Models[model] then
            Models[model] = {}
        end

        AddTarget(Models[model], options, resource)
    end
end
exports('AddModel', ig.target.AddModel)

---@param arr number | number[]
---@param options table
function ig.target.removeModel(arr, options)
    if type(arr) ~= 'table' then arr = { arr } end
    local resource = GetInvokingResource()

    for i = 1, #arr do
        local model = arr[i]
        model = type(model) == 'string' and joaat(model) or model

        if Models[model] then
            removeTarget(Models[model], options, resource)
        end
    end
end
exports('removeModel', ig.target.removeModel)

local Entities = {}

---@param arr number | number[]
---@param options table
function ig.target.AddEntity(arr, options)
    if type(arr) ~= 'table' then arr = { arr } end
    local resource = GetInvokingResource()

    for i = 1, #arr do
        local netId = arr[i]

        if not Entities[netId] then
            Entities[netId] = {}
        end

        if NetworkDoesNetworkIdExist(netId) then
            AddTarget(Entities[netId], options, resource)
        end
    end
end
exports('AddEntity', ig.target.AddEntity)

---@param arr number | number[]
---@param options table
function ig.target.removeEntity(arr, options)
    if type(arr) ~= 'table' then arr = { arr } end
    local resource = GetInvokingResource()

    for i = 1, #arr do
        local netId = arr[i]

        if Entities[netId] then
            removeTarget(Entities[netId], options, resource)
        end
    end
end
exports('removeEntity', ig.target.removeEntity)

local LocalEntities = {}

---@param arr number | number[]
---@param options table
function ig.target.AddLocalEntity(arr, options)
    if type(arr) ~= 'table' then arr = { arr } end
    local resource = GetInvokingResource()

    for i = 1, #arr do
        local entity = arr[i]

        if not LocalEntities[entity] then
            LocalEntities[entity] = {}
        end

        if DoesEntityExist(entity) then
            AddTarget(LocalEntities[entity], options, resource)
        else
            print(("No entity with id '%s' exists."):format(entity))
        end
    end
end
exports('AddLocalEntity', ig.target.AddLocalEntity)

---@param arr number | number[]
---@param options table
function ig.target.removeLocalEntity(arr, options)
    if type(arr) ~= 'table' then arr = { arr } end
    local resource = GetInvokingResource()

    for i = 1, #arr do
        local entity = arr[i]

        if LocalEntities[entity] then
            removeTarget(LocalEntities[entity], options, resource)
        end
    end
end
exports('removeLocalEntity', ig.target.removeLocalEntity)

-- Special export for AddEntityZone (backward compatibility with existing code)
function ig.target.AddEntityZone(name, entity, zoneOptions, targetOptions)
    -- This is a compatibility wrapper for the old door system
    -- Convert to AddLocalEntity call
    ig.target.AddLocalEntity(entity, targetOptions.options)
end
exports('AddEntityZone', ig.target.AddEntityZone)

---@param resource string
---@param target table
local function removeResourceGlobals(resource, target)
    for i = 1, #target do
        local options = target[i]

        for j = #options, 1, -1 do
            if options[j].resource == resource then
                table.remove(options, j)
            end
        end
    end
end

---@param resource string
---@param target table
local function removeResourceTargets(resource, target)
    for i = 1, #target do
        for _, options in pairs(target[i]) do
            for j = #options, 1, -1 do
                if options[j].resource == resource then
                    table.remove(options, j)
                end
            end
        end
    end
end

---@param resource string
AddEventHandler('onClientResourceStop', function(resource)
    removeResourceGlobals(resource, { Peds, Vehicles, Objects, Players })
    removeResourceTargets(resource, { Models, Entities, LocalEntities })

    if Zones then
        for _, v in pairs(Zones) do
            if v.resource == resource then
                v:remove()
            end
        end
    end
end)

local NetworkGetEntityIsNetworked = NetworkGetEntityIsNetworked
local NetworkGetNetworkIdFromEntity = NetworkGetNetworkIdFromEntity

---@param entity number
---@param _type number
---@param model number
---@return table
function GetEntityOptions(entity, _type, model)
    if _type == 1 then
        if IsPedAPlayer(entity) then
            return {
                global = Players
            }
        end
    end

    local netId = NetworkGetEntityIsNetworked(entity) and NetworkGetNetworkIdFromEntity(entity)
    local global

    if _type == 1 then
        global = Peds
    elseif _type == 2 then
        global = Vehicles
    elseif _type == 3 then
        global = Objects
    end

    return {
        global = global,
        model = Models[model],
        entity = netId and Entities[netId] or nil,
        localEntity = LocalEntities[entity],
    }
end