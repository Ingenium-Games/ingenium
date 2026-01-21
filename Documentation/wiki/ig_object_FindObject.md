# ig.object.FindObject

## Description

Searches for an object entity by network ID and returns detailed lookup results.

## Signature

```lua
function ig.object.FindObject(net)
```

## Parameters

- **`net`**: number - The network ID of the object

## Returns

- **`boolean`** - `true` if object exists, `false` otherwise
- **`table|false`** - The object entity table if found, `false` otherwise
- **`string|false`** - The index key if found, `false` otherwise

## Example

```lua
-- Find an object with detailed results
local exists, obj, key = ig.object.FindObject(netId)
if exists then
    print("Found object at key:", key)
    print("Object UUID:", obj.UUID)
end
```

## Source

Defined in: `server/[Objects]/_objects.lua`
