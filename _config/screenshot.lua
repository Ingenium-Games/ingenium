-- ====================================================================================--
-- Screenshot Configuration
-- ====================================================================================--
conf.screenshot = {
    -- Enable/disable screenshot system
    enabled = true,
    
    -- Screenshot output methods (can have multiple enabled)
    outputs = {
        -- Discord webhook
        discord = {
            enabled = true,
            webhook = "", -- Add your Discord webhook URL here
            username = "Ingenium Screenshot Bot",
            avatar_url = ""
        },
        
        -- Image hosting server (e.g., imgur, custom server)
        imageHost = {
            enabled = false,
            url = "", -- URL endpoint to POST screenshot data
            headers = {
                -- Custom headers for authentication
                -- ["Authorization"] = "Bearer YOUR_TOKEN"
            }
        },
        
        -- Discourse integration
        discourse = {
            enabled = false,
            url = "", -- Your Discourse instance URL (e.g., "https://forum.example.com")
            apiKey = "", -- Discourse API key
            apiUsername = "", -- Discourse API username
            categoryId = nil -- Category ID for screenshot posts (required if Discourse is enabled)
            -- To find your category ID: go to your category page and check the URL
            -- Example: https://forum.example.com/c/screenshots/5 -> categoryId = 5
        }
    },
    
    -- Screenshot quality and format
    quality = 0.92, -- JPEG quality (0.0 - 1.0)
    encoding = "jpg", -- jpg or png
    
    -- Automatic screenshot on specific events
    autoScreenshot = {
        onReport = true, -- Take screenshot when player reports
        onError = true, -- Take screenshot on client errors
        onDeath = false, -- Take screenshot on player death
        onBan = false -- Take screenshot on ban
    },
    
    -- Include additional metadata
    includeMetadata = {
        playerName = true,
        playerIdentifiers = true,
        coordinates = true,
        gameTime = true,
        vehicleInfo = false,
        nearbyPlayers = false
    }
}

-- Example configuration - copy this to your server's config
--[[
conf.screenshot.outputs.discord.webhook = "https://discord.com/api/webhooks/YOUR_WEBHOOK_ID/YOUR_WEBHOOK_TOKEN"

-- Or use environment variable for security
local discordWebhook = GetConvar('ig_screenshot_webhook', '')
if discordWebhook ~= '' then
    conf.screenshot.outputs.discord.webhook = discordWebhook
    conf.screenshot.outputs.discord.enabled = true
end
]]--
