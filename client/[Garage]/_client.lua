
-- Optimized: Simplified heading calculation
local function factorH(h)
    return (h + 180) % 360
end

-- Optimized: Create entities only once, avoiding duplication
local function CreateGarageEntities()
    -- Clean up existing entities first
    for k,v in pairs(ig.garage._CreatedEntities) do
        if DoesEntityExist(v) then
            DeleteEntity(v)
        end
    end
    ig.garage._CreatedEntities = {}
    
    -- Create new entities
    for k,v in pairs(ig.garage._Props) do
        local H = factorH(v.h)
        ig.garage._CreatedEntities[k] = CreateObject(ig.garage._TicketMachine, v.x, v.y, v.z - 1, false, false, false)
        SetEntityHeading(ig.garage._CreatedEntities[k], H)
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
    for k,v in pairs(ig.garage._CreatedEntities) do
        if DoesEntityExist(v) then
            DeleteEntity(v)
        end
    end
    ig.garage._CreatedEntities = {}
    ig.garage._VehicleBlip = nil
end)
