# ig.voip.GetVoiceMode

## Description

Initialize voice modes from configuration

## Signature

```lua
function ig.voip.GetVoiceMode(modeIndex)
```

## Parameters

- **`modeIndex`**: any

## Example

```lua
-- Get voicemode data
local result = ig.voip.GetVoiceMode(value)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `shared/[Voice]/_voip.lua`
