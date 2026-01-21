# ig.phone.GetOrCreate

## Description

Retrieves phone data from inventory or creates new phone data if it doesn't exist.

## Signature

```lua
function ig.phone.GetOrCreate(xPlayer, position)
```

## Parameters

- **`xPlayer`**: table - The player entity object
- **`position`**: number - The inventory position/slot number

## Returns

- **`table|nil`** - Phone data object with IMEI, contacts, settings, etc.

## Example

```lua
-- Get or create phone data
local xPlayer = ig.data.GetPlayer(source)
local phone = ig.phone.GetOrCreate(xPlayer, 5)
if phone then
    print("Phone number:", phone.phoneNumber)
    print("IMEI:", phone.imei)
end
```

## Source

Defined in: `server/[Data - No Save Needed]/_phone.lua`
