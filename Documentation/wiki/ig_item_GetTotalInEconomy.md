# ig.item.GetTotalInEconomy

## Description

Retrieves and returns totalineconomy data

## Signature

```lua
function ig.item.GetTotalInEconomy(itemName)
```

## Parameters

- **`itemName`**: any

## Example

```lua
-- Get totalineconomy data
local result = ig.item.GetTotalInEconomy(value)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Data - Save to File]/_items.lua`
