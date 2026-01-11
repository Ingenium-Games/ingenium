# ig.screenshot.SendToImageHost

## Description

Sends a screenshot to a custom image hosting service via HTTP POST request. The request includes the image URL and metadata in JSON format.

## Signature

```lua
function ig.screenshot.SendToImageHost(imageUrl, metadata)
```

## Parameters

- **`imageUrl`**: string - The URL of the uploaded screenshot
- **`metadata`**: table - Table containing metadata about the screenshot

## Returns

- None (void)

## Example

```lua
-- Example usage of ig.screenshot.SendToImageHost
local metadata = {
    playerName = "PlayerName",
    serverId = 1,
    reason = "player_report",
    coordinates = {x = 123.4, y = 456.7, z = 28.5}
}

ig.screenshot.SendToImageHost("https://i.imgur.com/example.jpg", metadata)
```

## Configuration

To use this function, configure the image host settings in `_config/screenshot.lua`:

```lua
conf.screenshot.outputs.imageHost = {
    enabled = true,
    url = "https://your-image-host.com/api/upload",
    headers = {
        ["Authorization"] = "Bearer YOUR_TOKEN",
        ["Content-Type"] = "application/json"
    }
}
```

## Important Notes

> ⚠️ **Configuration Required**: Requires `conf.screenshot.outputs.imageHost.url` to be configured.

> ⚠️ **Server-Side Only**: This function should only be called on the server side.

> 🔒 **Custom Headers**: Supports custom headers for authentication via `conf.screenshot.outputs.imageHost.headers`.

> 📤 **POST Request**: Sends a POST request with JSON payload containing `imageUrl` and `metadata`.

## Related Functions

- [ig.screenshot.Take](ig_screenshot_Take.md)
- [ig.screenshot.SendToDiscord](ig_screenshot_SendToDiscord.md)
- [ig.screenshot.SendToDiscourse](ig_screenshot_SendToDiscourse.md)

## Source

Defined in: `server/_screenshot.lua`
