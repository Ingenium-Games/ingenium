-- ====================================================================================--
-- Job Management NUI Callbacks
-- ====================================================================================--

-- Close job menu callback
RegisterNUICallback("NUI:Client:JobClose", function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

-- Invite employee callback
RegisterNUICallback("NUI:Client:JobInviteEmployee", function(data, cb)
    -- TODO: Implement invite employee logic
    -- This should open an input dialog to get the target player ID or name
    -- Then send to server to invite them
    print("[Job] Invite employee requested for job: " .. (data.jobName or "unknown"))
    cb('ok')
end)

-- Promote employee callback
RegisterNUICallback("NUI:Client:JobPromoteEmployee", function(data, cb)
    -- TODO: Send to server to promote employee
    print("[Job] Promote employee: " .. (data.characterId or "unknown") .. " in job: " .. (data.jobName or "unknown"))
    cb('ok')
end)

-- Demote employee callback
RegisterNUICallback("NUI:Client:JobDemoteEmployee", function(data, cb)
    -- TODO: Send to server to demote employee
    print("[Job] Demote employee: " .. (data.characterId or "unknown") .. " in job: " .. (data.jobName or "unknown"))
    cb('ok')
end)

-- Fire employee callback
RegisterNUICallback("NUI:Client:JobFireEmployee", function(data, cb)
    -- TODO: Send to server to fire employee
    print("[Job] Fire employee: " .. (data.characterId or "unknown") .. " from job: " .. (data.jobName or "unknown"))
    cb('ok')
end)

-- Add sales point callback
RegisterNUICallback("NUI:Client:JobAddSalesPoint", function(data, cb)
    -- TODO: Get player coordinates and send to server
    print("[Job] Add sales point for job: " .. (data.jobName or "unknown"))
    cb('ok')
end)

-- Add delivery point callback
RegisterNUICallback("NUI:Client:JobAddDeliveryPoint", function(data, cb)
    -- TODO: Get player coordinates and send to server
    print("[Job] Add delivery point for job: " .. (data.jobName or "unknown"))
    cb('ok')
end)

-- Set safe location callback
RegisterNUICallback("NUI:Client:JobSetSafe", function(data, cb)
    -- TODO: Get player coordinates and send to server
    print("[Job] Set safe location for job: " .. (data.jobName or "unknown"))
    cb('ok')
end)

-- Remove location callback
RegisterNUICallback("NUI:Client:JobRemoveLocation", function(data, cb)
    -- TODO: Send to server to remove location
    print("[Job] Remove " .. (data.type or "unknown") .. " location at index " .. (data.index or "unknown") .. " for job: " .. (data.jobName or "unknown"))
    cb('ok')
end)

-- Remove safe callback
RegisterNUICallback("NUI:Client:JobRemoveSafe", function(data, cb)
    -- TODO: Send to server to remove safe location
    print("[Job] Remove safe location for job: " .. (data.jobName or "unknown"))
    cb('ok')
end)

-- Add price item callback
RegisterNUICallback("NUI:Client:JobAddPrice", function(data, cb)
    -- TODO: Open input dialog to get item name and price
    print("[Job] Add price item for job: " .. (data.jobName or "unknown"))
    cb('ok')
end)

-- Remove price item callback
RegisterNUICallback("NUI:Client:JobRemovePrice", function(data, cb)
    -- TODO: Send to server to remove price
    print("[Job] Remove price for item: " .. (data.item or "unknown") .. " in job: " .. (data.jobName or "unknown"))
    cb('ok')
end)

-- Save prices callback
RegisterNUICallback("NUI:Client:JobSavePrices", function(data, cb)
    -- TODO: Send to server to save all prices
    print("[Job] Save prices for job: " .. (data.jobName or "unknown"))
    if data.prices then
        print("[Job] Prices data received:")
        for item, price in pairs(data.prices) do
            print("  " .. item .. " = $" .. price)
        end
    end
    cb('ok')
end)

-- Create memo callback
RegisterNUICallback("NUI:Client:JobCreateMemo", function(data, cb)
    -- TODO: Open input dialog to get memo title and content
    print("[Job] Create memo for job: " .. (data.jobName or "unknown"))
    cb('ok')
end)

-- Toggle pin memo callback
RegisterNUICallback("NUI:Client:JobTogglePinMemo", function(data, cb)
    -- TODO: Send to server to toggle pin
    print("[Job] Toggle pin memo at index " .. (data.index or "unknown") .. " for job: " .. (data.jobName or "unknown"))
    cb('ok')
end)

-- Delete memo callback
RegisterNUICallback("NUI:Client:JobDeleteMemo", function(data, cb)
    -- TODO: Send to server to delete memo
    print("[Job] Delete memo at index " .. (data.index or "unknown") .. " for job: " .. (data.jobName or "unknown"))
    cb('ok')
end)

print("[Job NUI] Job management callbacks registered")
