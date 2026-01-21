# ig.phone.GetFromInventory

## Description

Retrieves phone data from a player's inventory at a specific position.

## Signature

```lua
function ig.phone.GetFromInventory(xPlayer, position)
```

## Parameters

- **`xPlayer`**: table - The player entity object
- **`position`**: number - The inventory position/slot number

## Returns

- **`table|nil`** - Phone data object if found, `nil` otherwise

## Example

```lua
-- Get phone from inventory slot 5
local xPlayer = ig.data.GetPlayer(source)
local phone = ig.phone.GetFromInventory(xPlayer, 5)
if phone then
    print("Phone IMEI:", phone.imei)
end
```

## Source

Defined in: `server/[Data - No Save Needed]/_phone.lua`
