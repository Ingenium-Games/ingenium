# ig.data.GetObjectFromUUID

## Description

Retrieves an object entity by its unique UUID.

## Signature

```lua
function ig.data.GetObjectFromUUID(uuid)
```

## Parameters

- **`uuid`**: string - The unique identifier of the object

## Returns

- **`table|false`** - The object entity table if found, `false` otherwise

## Example

```lua
-- Get an object by UUID
local obj = ig.data.GetObjectFromUUID("abc-123-def-456")
if obj then
    print("Object network ID:", obj.Network)
end
```

## Source

Defined in: `server/_data.lua` (delegates to `ig.object.GetObjectFromUUID` in `server/[Objects]/_objects.lua`)
