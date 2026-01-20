# ig.data.GetObject

## Description

Retrieves an object entity by its network ID.

## Signature

```lua
function ig.data.GetObject(net)
```

## Parameters

- **`net`**: number - The network ID of the object

## Returns

- **`table|false`** - The object entity table if found, `false` otherwise

## Example

```lua
-- Get an object by network ID
local obj = ig.data.GetObject(netId)
if obj then
    print("Object UUID:", obj.UUID)
end
```

## Source

Defined in: `server/_data.lua` (delegates to `ig.object.GetObject` in `server/[Objects]/_objects.lua`)
