# ig.object.FindObjectFromUUID

## Description

Searches for an object entity by its UUID and returns detailed lookup results.

## Signature

```lua
function ig.object.FindObjectFromUUID(uuid)
```

## Parameters

- **`uuid`**: string - The unique identifier of the object

## Returns

- **`boolean`** - `true` if object exists, `false` otherwise
- **`table|false`** - The object entity table if found, `false` otherwise
- **`string|false`** - The index key (network ID) if found, `false` otherwise

## Example

```lua
-- Find an object by UUID with detailed results
local exists, obj, netId = ig.object.FindObjectFromUUID("abc-123-def-456")
if exists then
    print("Found object with network ID:", netId)
end
```

## Source

Defined in: `server/[Objects]/_objects.lua`
