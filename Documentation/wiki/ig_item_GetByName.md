# ig.item.GetByName

## Description

Retrieves and returns byname data

## Signature

```lua
function ig.item.GetByName(name)
```

## Parameters

- **`name`**: function

## Example

```lua
-- Get byname data
local result = ig.item.GetByName(function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Data - Save to File]/_items.lua`
