# ig.voip.client.UpdateCallTargets

## Description

Update Mumble voice targets

## Signature

```lua
function ig.voip.client.UpdateCallTargets()
```

## Parameters

*No parameters*

## Example

```lua
-- Get updatecalltargets data
local result = ig.voip.client.UpdateCallTargets()
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/[Voice]/_voip.lua`
