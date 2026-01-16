-- ====================================================================================--
-- GARAGE CLIENT-NUI WRAPPER FUNCTIONS
-- ====================================================================================--
-- Centralized wrapper functions for garage/vehicle system NUI operations.
-- These functions send messages FROM CLIENT TO NUI.
--
-- Call these from client event handlers:
--   - ig.nui.garage.Show(garageData, options)  => Client:NUI:GarageShow
--   - ig.nui.garage.Hide()                     => Client:NUI:GarageHide
--
-- ====================================================================================--

-- Show garage menu
-- Called from: Client code when player opens garage
function ig.nui.garage.Show(garageData, options)
    local focusGarage = true
    
    if options and options.focus ~= nil then
        focusGarage = options.focus
    end
    
    ig.ui.Send("Client:NUI:GarageShow", {
        vehicles = garageData and garageData.vehicles or {},
        garageId = garageData and garageData.garageId or 0,
        garageName = garageData and garageData.garageName or "Garage",
        garageType = garageData and garageData.garageType or "personal"
    }, focusGarage)
end

-- Hide garage menu
-- Called from: Garage close callback or client code
function ig.nui.garage.Hide()
    ig.ui.Send("Client:NUI:GarageHide", {}, false)
end

ig.log.Info("Client-NUI-Wrappers", "Garage wrapper functions loaded")
