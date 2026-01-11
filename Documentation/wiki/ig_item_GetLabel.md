# ig.item.GetLabel

## Description

Retrieves and returns label data

## Signature

```lua
function ig.item.GetLabel(name)
```

## Parameters

- **`name`**: number

## Example

```lua
-- Get label data
local result = ig.item.GetLabel(100)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Data - Save to File]/_items.lua`
