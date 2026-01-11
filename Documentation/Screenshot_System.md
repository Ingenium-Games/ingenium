# Screenshot System

The screenshot system integrates with FiveM's `screenshot-basic` resource to automatically capture and upload screenshots for various events like player reports, errors, and administrative actions.

## Configuration

Configure the screenshot system in `_config/screenshot.lua`:

```lua
conf.screenshot = {
    enabled = true,
    
    outputs = {
        discord = {
            enabled = true,
            webhook = "YOUR_DISCORD_WEBHOOK_URL",
            username = "Ingenium Screenshot Bot",
            avatar_url = ""
        },
        
        imageHost = {
            enabled = false,
            url = "YOUR_IMAGE_HOST_URL",
            headers = {}
        },
        
        discourse = {
            enabled = false,
            url = "YOUR_DISCOURSE_URL",
            apiKey = "YOUR_API_KEY",
            apiUsername = "YOUR_USERNAME"
        }
    },
    
    quality = 0.92,
    encoding = "jpg",
    
    autoScreenshot = {
        onReport = true,
        onError = true,
        onDeath = false,
        onBan = false
    }
}
```

## Discord Webhook Setup

1. Create a webhook in your Discord channel:
   - Go to Channel Settings > Integrations > Webhooks
   - Click "New Webhook"
   - Copy the webhook URL

2. Add the webhook URL to your configuration:
   ```lua
   conf.screenshot.outputs.discord.webhook = "https://discord.com/api/webhooks/YOUR_WEBHOOK_ID/YOUR_TOKEN"
   ```

3. For security, you can use a convar instead:
   ```bash
   # In server.cfg
   set ig_screenshot_webhook "https://discord.com/api/webhooks/YOUR_WEBHOOK_ID/YOUR_TOKEN"
   ```
   
   ```lua
   -- In _config/screenshot.lua
   local webhook = GetConvar('ig_screenshot_webhook', '')
   if webhook ~= '' then
       conf.screenshot.outputs.discord.webhook = webhook
   end
   ```

## Usage

### Automatic Screenshots

Screenshots are automatically captured based on configured events:
- Player reports
- Client errors
- Player deaths (optional)
- Player bans (optional)

### Manual Screenshots

Administrators can manually request a screenshot from a player:

```bash
/screenshot <playerID>
```

Or trigger from a script:

```lua
-- Client-side
exports['ingenium']:TakeScreenshot('custom_reason', {
    customData = 'value'
}, function(success, imageUrl)
    if success then
        print('Screenshot captured: ' .. imageUrl)
    end
end)

-- Server-side (request from player)
TriggerClientEvent('ig:screenshot:takeOnReport', playerId, {
    reason = 'admin_request'
})
```

## Metadata

Screenshots include metadata such as:
- Player name and identifiers
- Server ID
- Coordinates
- Game time
- Vehicle information (optional)
- Nearby players (optional)

Configure metadata in `conf.screenshot.includeMetadata`.

## Output Formats

### Discord
Screenshots are posted to Discord with embedded metadata.

### Image Host
Screenshots are posted to a custom image hosting service via HTTP POST.

### Discourse
Screenshots are posted as new topics in Discourse with metadata.

## Dependencies

- `screenshot-basic` resource must be installed and started
- Configured in `fxmanifest.lua` dependencies

## Security Notes

- Never commit webhook URLs or API keys to version control
- Use convars for sensitive configuration
- Restrict screenshot command to admin+ only
- Screenshots may contain sensitive information - configure output carefully
