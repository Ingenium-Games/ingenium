# ig.item.GetDescription

## Description

Retrieves and returns description data

## Signature

```lua
function ig.item.GetDescription(name)
```

## Parameters

- **`name`**: number

## Example

```lua
-- Get description data
local result = ig.item.GetDescription(100)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Data - Save to File]/_items.lua`
