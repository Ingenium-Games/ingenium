-- ====================================================================================--
conf.default = {}
-- ====================================================================================--

-- Accounts 
conf.default.accounts = {
    Bank = 500.00,
    Bitcoin = 0.00,
}

-- Default skills every new character has.
conf.default.skills = {}

-- Default Job and Accounts for new jobs found in the DB.
conf.default.job = {
    Name = "none",
    Grade = 1
}

conf.default.jobaccounts = {
    Bank = 5000.00,
    Safe = 0.00
}

-- Defaults for modifier and statuses of characters
conf.default.modifiers = {
    Hunger = 1,
    Thirst = 1,
    Stress = 1
}

conf.default.stats = {
    Hunger = 100, -- Min 0 Max 100
    Thirst = 100, -- Min 0 Max 100
    Stress = 0 -- Min 0 Max 100
}

conf.default.selfdamage = 3


-- Enable Item Craft / Degarde
conf.default.itemcraft = true
conf.default.itemdegrade = false

-- City job tax rate on all payments
conf.default.tax = 10.00

-- ====================================================================================--
-- Control & Keybinding Defaults
-- ====================================================================================--

-- Inventory Configuration
conf.inventory = {
    openKey = "I",                -- Default key to open/toggle inventory
    closeKey = "ESC",             -- Key to close inventory (can also close via button)
    allowHotkey = true            -- Enable/disable the hotkey entirely
}

-- HUD Configuration
conf.hud = {
    focusKey = "F2",              -- Key to toggle HUD drag/focus mode
    allowDragging = true,         -- Allow users to drag and reposition HUD
    persistPosition = true,       -- Save HUD position to localStorage
    enableFocusHighlight = true,  -- Show border/highlight when HUD is in focus mode
    normalZIndex = 100,           -- Default z-index (behind other menus)
    focusedZIndex = 1001          -- Z-index when focused/dragging (above other menus)
}

-- Menu Configuration
conf.menus = {
    allowDragging = true,         -- Allow users to drag and reposition menus
    persistPosition = true,       -- Save menu positions to localStorage
    dragCursorStyle = "grab"      -- CSS cursor style when hovering draggable area
}
