# ig.validation.GetItemQuantities

## Description

Retrieves and returns itemquantities data

## Signature

```lua
function ig.validation.GetItemQuantities(inventory)
```

## Parameters

- **`inventory`**: table

## Example

```lua
-- Get itemquantities data
local result = ig.validation.GetItemQuantities({})
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Validation]/_validator.lua`
