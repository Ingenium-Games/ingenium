# ig.screenshot.SendToDiscord

## Description

Sends a screenshot to a Discord channel via webhook. Creates a rich embed with player information, coordinates, game time, and other metadata based on configuration.

## Signature

```lua
function ig.screenshot.SendToDiscord(imageUrl, metadata)
```

## Parameters

- **`imageUrl`**: string - The URL of the uploaded screenshot
- **`metadata`**: table - Table containing metadata about the screenshot (player name, reason, coordinates, etc.)

## Returns

- None (void)

## Example

```lua
-- Example usage of ig.screenshot.SendToDiscord
local metadata = {
    playerName = "PlayerName",
    serverId = 1,
    reason = "player_report",
    coordinates = {x = 123.4, y = 456.7, z = 28.5},
    gameTime = {hours = 14, minutes = 30}
}

ig.screenshot.SendToDiscord("https://i.imgur.com/example.jpg", metadata)
```

## Important Notes

> ⚠️ **Configuration Required**: Requires `conf.screenshot.outputs.discord.webhook` to be configured with a valid Discord webhook URL.

> ⚠️ **Server-Side Only**: This function should only be called on the server side.

> 📝 **Validation**: The webhook URL is validated before sending. Invalid URLs will be rejected.

> 🎨 **Rich Embeds**: Creates formatted Discord embeds with player information, coordinates, identifiers, and nearby players.

## Metadata Fields

The metadata table can include:
- `playerName` - Player's display name
- `serverId` - Player's server ID
- `reason` - Reason for the screenshot
- `coordinates` - Table with x, y, z coordinates
- `gameTime` - Table with hours and minutes
- `vehicle` - Table with model and plate information
- `nearbyPlayers` - Array of nearby player information
- `playerIdentifiers` - Table of player identifiers

## Related Functions

- [ig.screenshot.Take](ig_screenshot_Take.md)
- [ig.screenshot.ValidateWebhook](ig_screenshot_ValidateWebhook.md)
- [ig.screenshot.SendToImageHost](ig_screenshot_SendToImageHost.md)
- [ig.screenshot.SendToDiscourse](ig_screenshot_SendToDiscourse.md)

## Source

Defined in: `server/_screenshot.lua`
