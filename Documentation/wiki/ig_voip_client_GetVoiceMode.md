# ig.voip.client.GetVoiceMode

## Description

Retrieves and returns voicemode data

## Signature

```lua
function ig.voip.client.GetVoiceMode()
```

## Parameters

*No parameters*

## Example

```lua
-- Get voicemode data
local result = ig.voip.client.GetVoiceMode()
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/[Voice]/_voip.lua`
