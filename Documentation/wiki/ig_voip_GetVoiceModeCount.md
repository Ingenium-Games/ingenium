# ig.voip.GetVoiceModeCount

## Description

Retrieves and returns voicemodecount data

## Signature

```lua
function ig.voip.GetVoiceModeCount()
```

## Parameters

*No parameters*

## Example

```lua
-- Get voicemodecount data
local result = ig.voip.GetVoiceModeCount()
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `shared/[Voice]/_voip.lua`
