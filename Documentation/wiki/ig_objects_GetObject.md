# ig.objects.GetObject

## Description

Retrieves and returns object data

## Signature

```lua
function ig.objects.GetObject(net)
```

## Parameters

- **`net`**: string

## Example

```lua
-- Get object data
local result = ig.objects.GetObject("net")
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Objects]/_objects.lua`
