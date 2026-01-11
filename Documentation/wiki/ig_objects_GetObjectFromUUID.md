# ig.objects.GetObjectFromUUID

## Description

Retrieves and returns objectfromuuid data

## Signature

```lua
function ig.objects.GetObjectFromUUID(uuid)
```

## Parameters

- **`uuid`**: any

## Example

```lua
-- Get objectfromuuid data
local result = ig.objects.GetObjectFromUUID(value)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Objects]/_objects.lua`
