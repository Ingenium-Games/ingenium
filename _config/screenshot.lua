-- ====================================================================================--
-- Screenshot Configuration
-- ====================================================================================--

ig.screenshot = {}

-- Configuration for screenshot outputs
ig.screenshot.config = {
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
            url = "", -- Your Discourse instance URL
            apiKey = "", -- Discourse API key
            apiUsername = "" -- Discourse API username
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

-- Function to validate webhook URL
function ig.screenshot.ValidateWebhook(webhook)
    if not webhook or webhook == "" then
        return false
    end
    
    -- Basic Discord webhook validation
    if string.match(webhook, "^https://discord%.com/api/webhooks/%d+/[%w_-]+$") or 
       string.match(webhook, "^https://discordapp%.com/api/webhooks/%d+/[%w_-]+$") then
        return true
    end
    
    return false
end

-- Example configuration - copy this to your server's config
--[[
ig.screenshot.config.outputs.discord.webhook = "https://discord.com/api/webhooks/YOUR_WEBHOOK_ID/YOUR_WEBHOOK_TOKEN"

-- Or use environment variable for security
local discordWebhook = GetConvar('ig_screenshot_webhook', '')
if discordWebhook ~= '' then
    ig.screenshot.config.outputs.discord.webhook = discordWebhook
    ig.screenshot.config.outputs.discord.enabled = true
end
]]--
