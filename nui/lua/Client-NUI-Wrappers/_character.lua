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

if not ig.nui then ig.nui = {} end
if not ig.nui.character then ig.nui.character = {} end

-- Show character selection UI
-- Called from: Client:Character:OpeningMenu
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
    ig.ui.Send("Client:NUI:AppearanceOpen", {
        mode = "create",
        onComplete = "Client:Character:AppearanceComplete"
    }, true)
end

-- Show appearance customization UI
-- Called from: other resources for appearance editing
function ig.nui.character.ShowCustomize()
    ig.ui.Send("Client:NUI:AppearanceOpen", {
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
