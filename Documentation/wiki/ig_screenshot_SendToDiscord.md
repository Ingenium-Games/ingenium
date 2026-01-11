# ig.screenshot.SendToDiscord

## Description

Sends a screenshot to a Discord channel via webhook. Creates a rich embed with player information, coordinates, game time, and other metadata based on configuration.

## Signature

```lua
function ig.screenshot.SendToDiscord(imageUrl, metadata)
```

## Parameters

- **`imageUrl`**: any
- **`metadata`**: string

## Example

```lua
-- Example usage
local result = ig.screenshot.SendToDiscord(value, "metadata")
```

## Source

Defined in: `server/_screenshot.lua`
