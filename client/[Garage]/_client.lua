
-- Optimized: Simplified heading calculation
local function factorH(h)
    return (h + 180) % 360
end

-- Optimized: Create entities only once, avoiding duplication
local function CreateGarageEntities()
    -- Clean up existing entities first
    for k,v in pairs(CreatedEntities) do
        if DoesEntityExist(v) then
            DeleteEntity(v)
        end
    end
    CreatedEntities = {}
    
    -- Create new entities
    for k,v in pairs(Props) do
        local H = factorH(v.h)
        CreatedEntities[k] = CreateObject(TicketMachine, v.x, v.y, v.z - 1, false, false, false)
        SetEntityHeading(CreatedEntities[k], H)
    end
end

AddEventHandler("Client:Character:Ready", function()
    CreateGarageEntities()
end)

AddEventHandler("onResourceStop", function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    -- Optimized: Properly clean up entities
    for k,v in pairs(CreatedEntities) do
        if DoesEntityExist(v) then
            DeleteEntity(v)
        end
    end
    CreatedEntities = {}
    VehicleBlip = nil
end)
