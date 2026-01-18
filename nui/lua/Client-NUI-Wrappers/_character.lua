-- ====================================================================================--
-- CHARACTER CLIENT-NUI WRAPPER FUNCTIONS
-- ====================================================================================--
-- Centralized wrapper functions for character system NUI operations.
-- These functions send messages FROM CLIENT TO NUI.
--
-- Call these from client/[Events]/_character.lua:
--   - ig.nui.character.ShowSelect()     => Client:NUI:CharacterSelectShow
--   - ig.nui.character.HideSelect()     => Client:NUI:CharacterSelectHide
--   - ig.nui.character.ShowCreate()     => Client:NUI:AppearanceOpen (mode: create)
--   - ig.nui.character.ShowCustomize()  => Client:NUI:AppearanceOpen (mode: customize)
--   - ig.nui.character.HideAppearance() => Client:NUI:AppearanceClose
--
-- ====================================================================================--

-- Show character selection UI
-- Called from: Client:Character:OpeningMenu
-- NOTE: NUI will request character data via Client:Request:OnJoinGetCharactersFromServer callback when mounted
function ig.nui.character.ShowSelect()
    ig.ui.Send("Client:NUI:CharacterSelectShow", {}, true)
end

-- Hide character selection UI
-- Called from: Client:Character:ReSpawn
function ig.nui.character.HideSelect()
    ig.ui.Send("Client:NUI:CharacterSelectHide", {}, false)
end

-- Show appearance creation UI
-- Called from: Client:Character:Create
function ig.nui.character.ShowCreate()
    ig.log.Info("NUI-Wrapper", "ShowCreate: Starting appearance creation UI")
    
    -- Use cached data from initialization (loaded via GetInitializationData)
    -- Static reference data should already be loaded - if not, that's a critical error
    local constants = ig.appearance_constants
    local peds = ig.peds
    local tattoos = ig.tattoos
    
    -- Validate that required data is loaded
    local pedsCount = peds and ig.table.SizeOf(peds) or 0
    local tattoosCount = tattoos and ig.table.SizeOf(tattoos) or 0
    local constantsCount = constants and ig.table.SizeOf(constants) or 0
    
    ig.log.Info("NUI-Wrapper", "ShowCreate: Using cached initialization data")
    ig.log.Info("NUI-Wrapper", "  - Peds: %d entries", pedsCount)
    ig.log.Info("NUI-Wrapper", "  - Tattoos: %d entries", tattoosCount)
    ig.log.Info("NUI-Wrapper", "  - Constants: %d keys", constantsCount)
    
    -- Critical error if data is missing (initialization failed)
    if pedsCount == 0 then
        ig.log.Error("NUI-Wrapper", "CRITICAL: ig.peds is empty! Client initialization failed.")
    end
    if tattoosCount == 0 then
        ig.log.Warn("NUI-Wrapper", "WARNING: ig.tattoos is empty. Tattoos may not be available.")
    end
    if constantsCount == 0 then
        ig.log.Error("NUI-Wrapper", "CRITICAL: ig.appearance_constants is empty! Appearance customization will fail.")
    end
    
    -- Get default appearance for new character with proper structure
    local defaultAppearance = {
        model = "mp_m_freemode_01",
        headBlend = {
            shapeFirst = 0,
            shapeSecond = 0,
            skinFirst = 0,
            skinSecond = 0,
            shapeMix = 0.5,
            skinMix = 0.5,
            thirdMix = 0.0
        },
        faceFeatures = {},
        headOverlays = {},
        hair = {
            style = 0,
            color = 0,
            highlight = 0
        },
        eyeColor = 0,
        components = {},
        props = {},
        tattoos = {}
    }
    
    -- Override with constants default if available
    if constants and constants.defaultAppearance then
        for k, v in pairs(constants.defaultAppearance) do
            defaultAppearance[k] = v
        end
    end
    
    ig.log.Info("NUI-Wrapper", "ShowCreate: Default appearance model=%s", defaultAppearance.model)
    
    -- Config for character creation (allow model change, allow tattoos)
    local config = {
        allowModelChange = true,
        allowTattoos = true,
        isCharacterCreation = true
    }
    
    -- Convert read-only tables to plain tables for JSON serialization
    -- MakeReadOnly creates proxy tables with metatables that json.encode() cannot serialize
    local plainPeds = ig.table.Convert2Plain(peds)
    local plainTattoos = ig.table.Convert2Plain(tattoos)
    local plainConstants = ig.table.Convert2Plain(constants)
    
    local data = {
        appearance = defaultAppearance,
        constants = plainConstants,
        peds = plainPeds,
        tattoos = plainTattoos,
        config = config,
        mode = "create",
        onComplete = "Client:Character:AppearanceComplete"
    }
    
    ig.log.Info("NUI-Wrapper", "ShowCreate: Sending to NUI - appearance model=%s, peds=%s, constants=%s", 
        data.appearance.model, 
        data.peds and "YES" or "NIL",
        data.constants and "YES" or "NIL")
    
    ig.log.Info("NUI-Wrapper", "ShowCreate: Sending appearance data to NUI with %d peds, %d tattoo entries", 
        plainPeds and ig.table.SizeOf(plainPeds) or 0,
        plainTattoos and ig.table.SizeOf(plainTattoos) or 0)
    
    ig.ui.Send("Client:NUI:AppearanceOpen", data, true)
    
    ig.log.Debug("NUI-Wrapper", "ShowCreate: Complete - NUI focus should now be active")
end

-- Show appearance customization UI
-- Called from: other resources for appearance editing
function ig.nui.character.ShowCustomize()
    -- Use cached data from initialization
    local constants = ig.appearance_constants
    local peds = ig.peds
    local tattoos = ig.tattoos
    
    -- Log if data is missing (should not happen)
    if not peds or ig.table.SizeOf(peds) == 0 then
        ig.log.Error("NUI-Wrapper", "ShowCustomize: ig.peds is empty! Cannot customize appearance.")
    end
    
    -- Get current player appearance
    local currentAppearance = ig.appearance.GetAppearance()
    
    -- Config for appearance customization
    local config = {
        allowModelChange = true,
        allowTattoos = true,
        isCharacterCreation = false
    }
    
    -- Convert read-only tables to plain tables for JSON serialization
    local plainPeds = ig.table.Convert2Plain(peds)
    local plainTattoos = ig.table.Convert2Plain(tattoos)
    local plainConstants = ig.table.Convert2Plain(constants)
    
    ig.ui.Send("Client:NUI:AppearanceOpen", {
        appearance = currentAppearance,
        constants = plainConstants,
        peds = plainPeds,
        tattoos = plainTattoos,
        config = config,
        mode = "customize",
        onComplete = "Client:Character:AppearanceComplete"
    }, true)
end

-- Hide appearance UI
-- Called from: Client:Character:AppearanceComplete or user cancel
function ig.nui.character.HideAppearance()
    ig.ui.Send("Client:NUI:AppearanceClose", {}, false)
end

ig.log.Info("Client-NUI", "Character wrapper functions loaded")