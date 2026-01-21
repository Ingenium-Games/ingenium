# ig.object.GetObject

## Description

Retrieves an object entity by its network ID.

## Signature

```lua
function ig.object.GetObject(net)
```

## Parameters

- **`net`**: number - The network ID of the object

## Returns

- **`table|false`** - The object entity table if found, `false` otherwise

## Example

```lua
-- Get an object by network ID
local obj = ig.object.GetObject(netId)
if obj then
    print("Object UUID:", obj.UUID)
end
```

## Source

Defined in: `server/[Objects]/_objects.lua`
