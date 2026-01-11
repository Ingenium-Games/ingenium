# ig.screenshot.SendToDiscourse

## Description

Sends a screenshot to a Discourse forum as a new post. Creates a post with the screenshot image and metadata in JSON format.

## Signature

```lua
function ig.screenshot.SendToDiscourse(imageUrl, metadata)
```

## Parameters

- **`imageUrl`**: string - The URL of the uploaded screenshot
- **`metadata`**: table - Table containing metadata about the screenshot

## Returns

- None (void)

## Example

```lua
-- Example usage of ig.screenshot.SendToDiscourse
local metadata = {
    playerName = "PlayerName",
    serverId = 1,
    reason = "player_report",
    coordinates = {x = 123.4, y = 456.7, z = 28.5}
}

ig.screenshot.SendToDiscourse("https://i.imgur.com/example.jpg", metadata)
```

## Configuration

To use this function, configure Discourse settings in `_config/screenshot.lua`:

```lua
conf.screenshot.outputs.discourse = {
    enabled = true,
    url = "https://forum.example.com",
    apiKey = "your_api_key_here",
    apiUsername = "system",
    categoryId = 5  -- Required: the category ID for screenshot posts
}
```

### Finding Category ID

To find your category ID:
1. Go to your category page in Discourse
2. Check the URL: `https://forum.example.com/c/screenshots/5`
3. The number at the end (5) is your category ID

## Important Notes

> ⚠️ **Configuration Required**: Requires `conf.screenshot.outputs.discourse.url`, `apiKey`, `apiUsername`, and `categoryId` to be configured.

> ⚠️ **Server-Side Only**: This function should only be called on the server side.

> 🔑 **API Authentication**: Uses Discourse API key and username for authentication.

> 📝 **Post Format**: Creates a post with the screenshot embedded and metadata in a code block.

> ⚠️ **Category Required**: If categoryId is not configured, defaults to category 1 (Uncategorized).

## Post Title Format

Posts are created with the title: `Screenshot - {playerName} - {reason}`

## Related Functions

- [ig.screenshot.Take](ig_screenshot_Take.md)
- [ig.screenshot.SendToDiscord](ig_screenshot_SendToDiscord.md)
- [ig.screenshot.SendToImageHost](ig_screenshot_SendToImageHost.md)

## Source

Defined in: `server/_screenshot.lua`
