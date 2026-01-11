# ig.ammo.GetType

## Description

Retrieves the ammunition count for a specific ammo type.

## Signature

```lua
function ig.ammo.GetType(type)
```

## Parameters

- **`type`**: string

## Example

```lua
-- Get ammo count for a specific type
local count = ig.ammo.GetType("9mm")
print("9mm ammo count:", count)
```

## Source

Defined in: `client/_ammo.lua`
