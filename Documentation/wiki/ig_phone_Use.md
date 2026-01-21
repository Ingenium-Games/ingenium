# ig.phone.Use

## Description

Handles phone usage from inventory, opening the phone UI with the player's phone data.

## Signature

```lua
function ig.phone.Use(source, position)
```

## Parameters

- **`source`**: number - The player source ID
- **`position`**: number - The inventory position/slot number of the phone

## Returns

None

## Example

```lua
-- Use phone from inventory
ig.phone.Use(source, 5)
```

## Notes

This function is typically called when a player uses a phone item from their inventory. It retrieves or creates phone data and triggers the client to open the phone UI.

## Source

Defined in: `server/[Data - No Save Needed]/_phone.lua`
