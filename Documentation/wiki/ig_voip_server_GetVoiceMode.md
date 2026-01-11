# ig.voip.server.GetVoiceMode

## Description

Try to get xPlayer first (if character is loaded)

## Signature

```lua
function ig.voip.server.GetVoiceMode(playerId)
```

## Parameters

- **`playerId`**: any

## Example

```lua
-- Get voicemode data
local result = ig.voip.server.GetVoiceMode(value)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Voice]/_voip.lua`
