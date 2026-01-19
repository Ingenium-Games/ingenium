# ig.modkit.GetAll

## Description

Returns all modkit data from the server's modkit registry. Modkits contain vehicle modification configurations including available mod slots and upgrade options.

## Signature

```lua
function ig.modkit.GetAll()
```

## Parameters

None

## Returns

- **`table`** - Table containing all modkits data indexed by modkit ID

## Example

```lua
-- Get all modkits
local modkits = ig.modkit.GetAll()
for id, modkit in pairs(modkits) do
    print(string.format("Modkit ID: %s, Vehicle Hash: %s", id, modkit.vehicle_hash))
end
```

## Related Functions

- [ig.modkit.GetByID](ig_modkit_GetByID.md) - Get specific modkit by ID
- [ig.modkit.GetForVehicle](ig_modkit_GetForVehicle.md) - Get modkit for vehicle hash
- [ig.modkit.HasModkit](ig_modkit_HasModkit.md) - Check if modkit exists for vehicle

## Source

Defined in: `server/[Data - No Save Needed]/_modkit.lua`
