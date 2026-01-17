-- ====================================================================================--
-- Appearance Customization Client Callbacks
-- Server-driven events for opening appearance customization
-- ====================================================================================--
-- Note: Most appearance logic is handled via NUI callbacks (RegisterNUICallback)
-- in nui/lua/NUI-Client/_appearance_live_updates.lua
-- This file only contains the server-triggered "Open" callback for programmatic access
-- ====================================================================================--

---Open appearance customization UI (server-driven)
---@param config table|nil Configuration options
RegisterClientCallback({
    eventName = "Client:Appearance:Open",
    eventCallback = function(config)
        config = config or {}
        
        -- Store if this is character creation
        ig.appearance.IsCharacterCreation = config.isCharacterCreation or false
        
        -- Activate customization mode
        ig.appearance.SetCustomizationActive(true)
        
        -- Get current appearance
        local currentAppearance = ig.appearance.GetAppearance()
        
        -- Get appearance constants (loaded from JSON client-side)
        local constants = ig.appearance.GetConstants()
        
        -- Get ped data from server if needed
        local peds = nil
        if config.allowModelChange ~= false then
            peds = ig.callback.Await('ig:GameData:GetPeds')
        end
        
        -- Get tattoo data from server if tattoos enabled
        local tattoos = nil
        if config.allowTattoos ~= false then
            tattoos = ig.callback.Await('ig:GameData:GetTattoos')
        end
        
        -- Get pricing data from server if pricing enabled
        local pricing = nil
        if config.jobName then
            pricing = ig.callback.Await('Server:Appearance:GetPricing', config.jobName)
        end
        
        -- Send data to NUI
        ig.ui.Send("appearance:open", {
            appearance = currentAppearance,
            constants = constants,
            peds = peds,
            tattoos = tattoos,
            config = config,
            pricing = pricing
        }, true)
    end
})
