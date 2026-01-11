# ig.screenshot.LogToDatabase

## Description

Logs screenshot information to the database. This is a placeholder function that should be implemented based on your database structure and requirements.

## Signature

```lua
function ig.screenshot.LogToDatabase(imageUrl, metadata)
```

## Parameters

- **`imageUrl`**: string - The URL of the uploaded screenshot
- **`metadata`**: table - Table containing metadata about the screenshot

## Returns

- None (void)

## Example

```lua
-- Example usage of ig.screenshot.LogToDatabase
local metadata = {
    playerName = "PlayerName",
    serverId = 1,
    reason = "player_report",
    coordinates = {x = 123.4, y = 456.7, z = 28.5}
}

ig.screenshot.LogToDatabase("https://i.imgur.com/example.jpg", metadata)
```

## Implementation Example

```lua
function ig.screenshot.LogToDatabase(imageUrl, metadata)
    local query = [[
        INSERT INTO screenshots 
        (player_id, image_url, reason, metadata, created_at) 
        VALUES (?, ?, ?, ?, NOW())
    ]]
    
    exports['ingenium.sql']:Execute(query, {
        metadata.serverId,
        imageUrl,
        metadata.reason,
        json.encode(metadata)
    }, function(result)
        if result then
            print('[IG Screenshot] Logged to database')
        end
    end)
end
```

## Important Notes

> ⚠️ **Not Implemented**: This is a placeholder function. You must implement the database logic based on your schema.

> ⚠️ **Server-Side Only**: This function should only be called on the server side.

> 📝 **Optional**: Database logging is disabled by default. Enable via `conf.screenshot.logToDatabase = true`.

> 🗄️ **Database Schema**: Requires a screenshots table with appropriate columns in your database.

## Suggested Database Schema

```sql
CREATE TABLE screenshots (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL,
    image_url VARCHAR(512) NOT NULL,
    reason VARCHAR(64),
    metadata TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## Related Functions

- [ig.screenshot.Take](ig_screenshot_Take.md)
- [ig.screenshot.SendToDiscord](ig_screenshot_SendToDiscord.md)
- [ig.screenshot.SendToImageHost](ig_screenshot_SendToImageHost.md)
- [ig.screenshot.SendToDiscourse](ig_screenshot_SendToDiscourse.md)

## Source

Defined in: `server/_screenshot.lua`
