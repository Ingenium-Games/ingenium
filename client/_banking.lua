-- ====================================================================================--
-- Banking Client - ATM and Bank Interactions
-- ====================================================================================--
-- IMPORTANT: NUI Callbacks consolidated in nui/lua/NUI-Client/_banking.lua
-- This file now contains location data and event handlers only
-- ====================================================================================--

-- ATM prop models
local atmModels = {
    "prop_atm_01",
    "prop_atm_02",
    "prop_atm_03",
    "prop_fleeca_atm"
}

-- Bank interior markers (can be expanded with more locations)
local bankLocations = {
    -- Main Los Santos Banks
    {coords = vector3(149.46, -1040.53, 29.37), radius = 2.0, name = "Fleeca Bank"},
    {coords = vector3(-1212.98, -330.84, 37.79), radius = 2.0, name = "Fleeca Bank"},
    {coords = vector3(-2962.47, 482.93, 15.70), radius = 2.0, name = "Fleeca Bank"},
    {coords = vector3(-112.21, 6469.77, 31.63), radius = 2.0, name = "Blaine County Savings"},
    {coords = vector3(314.23, -278.83, 54.17), radius = 2.0, name = "Fleeca Bank"},
    {coords = vector3(-351.26, -49.53, 49.04), radius = 2.0, name = "Fleeca Bank"},
    {coords = vector3(1175.02, 2706.87, 38.09), radius = 2.0, name = "Fleeca Bank"}
}

-- ====================================================================================--
-- NUI Callbacks - CONSOLIDATED
-- ====================================================================================--
-- Banking NUI callbacks moved to: nui/lua/NUI-Client/_banking.lua
-- Callbacks:
--   - NUI:Client:BankingClose → nui/lua/NUI-Client/_banking.lua
--   - NUI:Client:BankingTransfer → nui/lua/NUI-Client/_banking.lua
--   - NUI:Client:BankingWithdraw → nui/lua/NUI-Client/_banking.lua
--   - NUI:Client:BankingDeposit → nui/lua/NUI-Client/_banking.lua
--   - NUI:Client:BankingAddFavorite → nui/lua/NUI-Client/_banking.lua
--   - NUI:Client:BankingRemoveFavorite → nui/lua/NUI-Client/_banking.lua
--
-- DO NOT register callbacks here - they are centralized in nui/lua/NUI-Client/_banking.lua
-- ====================================================================================--

-- Event to open banking menu
RegisterNetEvent("Client:Banking:OpenMenu", function(data)
    -- Security: Prevent external resource invocation
    if GetInvokingResource() ~= GetCurrentResourceName() then
        CancelEvent()
        return
    end
    --
    SetNuiFocus(true, true)
    SendNUIMessage({
        message = "Client:NUI:BankingOpen",
        data = data
    })
end)

-- Function to open banking
local function OpenBanking()
    TriggerServerCallback({
        eventName = "Server:Bank:Open",
        eventCallback = function()
            -- Server will send Client:Banking:OpenMenu event with data
        end
    })
end

-- Add ATM targets globally
CreateThread(function()
    -- Wait for player to be loaded
    while not ig or not ig.target do
        Wait(500) -- Increased wait interval to reduce performance impact
    end
    
    Wait(2000) -- Additional wait to ensure system is fully loaded
    
    -- Add global object targets for ATMs
    for i = 1, #atmModels do
        ig.target.AddGlobalObject({
            {
                name = "atm_banking_" .. i,
                icon = "💳",
                label = "Use ATM",
                model = atmModels[i],
                distance = 1.5,
                onSelect = function()
                    OpenBanking()
                end
            }
        })
    end
    
    if ig and ig.log and ig.log.Info then
        ig.log.Info("Banking", "ATM targets registered")
    else
        ig.log.Info("BANKING", "ATM targets registered")
    end
end)

-- Add bank location zones
CreateThread(function()
    -- Wait for player to be loaded
    while not ig or not ig.target do
        Wait(500) -- Increased wait interval to reduce performance impact
    end
    
    Wait(2000)
    
    -- Add box zones for bank locations
    for i = 1, #bankLocations do
        local bank = bankLocations[i]
        ig.target.AddBoxZone({
            name = "bank_location_" .. i,
            coords = bank.coords,
            size = vec3(2.0, 2.0, 2.0),
            rotation = 0.0,
            debug = false,
            options = {
                {
                    name = "bank_access",
                    icon = "🏦",
                    label = "Access Bank",
                    onSelect = function()
                        OpenBanking()
                    end
                }
            }
        })
    end
    
    if ig and ig.log and ig.log.Info then
        ig.log.Info("Banking", "Bank location zones registered")
    else
        ig.log.Info("BANKING", "Bank location zones registered")
    end
end)

-- Export for other resources
exports("OpenBanking", OpenBanking)
