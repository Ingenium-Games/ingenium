# ig.screenshot.SendToImageHost

## Description

Sends a screenshot to a custom image hosting service via HTTP POST request. The request includes the image URL and metadata in JSON format.

## Signature

```lua
function ig.screenshot.SendToImageHost(imageUrl, metadata)
```

## Parameters

- **`imageUrl`**: any
- **`metadata`**: any

## Example

```lua
-- Example usage
local result = ig.screenshot.SendToImageHost(value, value)
```

## Source

Defined in: `server/_screenshot.lua`
