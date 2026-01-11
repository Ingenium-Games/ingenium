# ig.voip.client.UpdateAdminCallTargets

## Description

Radio targets are managed server-side and communicated via statebags

## Signature

```lua
function ig.voip.client.UpdateAdminCallTargets()
```

## Parameters

*No parameters*

## Example

```lua
-- Get updateadmincalltargets data
local result = ig.voip.client.UpdateAdminCallTargets()
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/[Voice]/_voip.lua`
