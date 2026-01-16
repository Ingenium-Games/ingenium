-- ====================================================================================--
-- PLAYER LOAD RESTRICTION THREAD
-- ====================================================================================--
-- Restricts all player movement, actions, and keybinds until character is fully loaded.
-- 
-- This prevents players from getting stuck or performing actions before initialization.
-- Only allows: Chat key (T) and Escape (main menu)
--
-- Activated: When player joins (before Client:Character:OpeningMenu)
-- Deactivated: When ig.data.GetLoadedStatus() becomes true
--
-- ====================================================================================--

local restrictionActive = false

-- Start restriction thread on resource start
CreateThread(function()
    while true do
        Wait(0)
        
        local isLoaded = ig.data.GetLoadedStatus()
        
        -- If player is NOT loaded, enforce restrictions
        if not isLoaded then
            if not restrictionActive then
                restrictionActive = true
                ig.log.Debug("PlayerLoad", "Player load restriction ENABLED - controls locked")
            end
            
            -- Disable player movement and actions
            DisableControlAction(0, 21, true) -- Sprint
            DisableControlAction(0, 22, true) -- Jump
            DisableControlAction(0, 25, true) -- Aim
            DisableControlAction(0, 38, true) -- Fire weapon
            DisableControlAction(0, 47, true) -- Move forward/back
            DisableControlAction(0, 48, true) -- Move left/right
            DisableControlAction(0, 137, true) -- Reload weapon
            DisableControlAction(0, 199, true) -- Drop weapon
            DisableControlAction(0, 200, true) -- Zoom
            DisableControlAction(0, 24, true) -- Attack (melee)
            DisableControlAction(0, 140, true) -- Melee attack alternate
            DisableControlAction(0, 141, true) -- Melee attack 2
            DisableControlAction(0, 142, true) -- Melee attack 3
            DisableControlAction(0, 143, true) -- Melee attack 4
            
            -- Disable interaction keys
            DisableControlAction(0, 38, true) -- E key (interact)
            DisableControlAction(0, 47, true) -- G key
            DisableControlAction(0, 73, true) -- X key (hide weapon)
            
            -- Disable vehicle controls
            DisableControlAction(0, 71, true) -- Accelerate
            DisableControlAction(0, 72, true) -- Brake/Reverse
            DisableControlAction(0, 63, true) -- Steer left
            DisableControlAction(0, 64, true) -- Steer right
            
            -- Disable phone/inventory
            DisableControlAction(0, 243, true) -- Phone
            DisableControlAction(0, 244, true) -- Inventory
            
            -- ALLOWED: Escape key (main menu) - NOT disabled
            -- ALLOWED: T key (chat) - NOT disabled
            
        else
            -- Player is loaded, disable restrictions
            if restrictionActive then
                restrictionActive = false
                ig.log.Debug("PlayerLoad", "Player load restriction DISABLED - controls unlocked")
            end
        end
    end
end)

-- Log when player is ready
AddEventHandler("Client:Character:Ready", function()
    ig.log.Info("PlayerLoad", "Character fully loaded - movement restrictions removed")
end)
