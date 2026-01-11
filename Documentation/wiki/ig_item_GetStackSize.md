# ig.item.GetStackSize

## Description

Retrieves and returns stacksize data

## Signature

```lua
function ig.item.GetStackSize(name)
```

## Parameters

- **`name`**: number

## Example

```lua
-- Get stacksize data
local result = ig.item.GetStackSize(100)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Data - Save to File]/_items.lua`
