# ig.screenshot.ValidateWebhook

## Description

Validates a Discord webhook URL to ensure it follows the correct format. This function checks if the URL matches the expected Discord webhook pattern.

## Signature

```lua
function ig.screenshot.ValidateWebhook(webhook)
```

## Parameters

- **`webhook`**: string - The Discord webhook URL to validate

## Returns

- **boolean** - True if the webhook URL is valid, false otherwise

## Example

```lua
-- Validate a Discord webhook
local webhook = "https://discord.com/api/webhooks/123456789/abcdefghijk"
local isValid = ig.screenshot.ValidateWebhook(webhook)

if isValid then
    print('Webhook is valid')
else
    print('Invalid webhook URL')
end

-- Check before using webhook
if ig.screenshot.ValidateWebhook(conf.screenshot.outputs.discord.webhook) then
    -- Safe to use webhook
    ig.screenshot.SendToDiscord(imageUrl, metadata)
end
```

## Important Notes

> ℹ️ **Format**: Accepts webhooks from both discord.com and discordapp.com domains.

> 🔒 **Security**: This function only validates the URL format, not whether the webhook is active or has correct permissions.

> ⚠️ **Server-Side Only**: This function should only be called on the server side.

## Accepted Patterns

- `https://discord.com/api/webhooks/{id}/{token}`
- `https://discordapp.com/api/webhooks/{id}/{token}`

## Related Functions

- [ig.screenshot.SendToDiscord](ig_screenshot_SendToDiscord.md)
- [ig.screenshot.Take](ig_screenshot_Take.md)

## Source

Defined in: `server/_screenshot.lua`
