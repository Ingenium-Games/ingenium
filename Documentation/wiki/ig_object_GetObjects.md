# ig.object.GetObjects

## Description

Retrieves all object entities in the server.

## Signature

```lua
function ig.object.GetObjects()
```

## Parameters

None

## Returns

- **`table`** - The complete `ig.odex` table containing all object entities indexed by network ID

## Example

```lua
-- Get all objects and count them
local objects = ig.object.GetObjects()
local count = 0
for netId, obj in pairs(objects) do
    count = count + 1
    print("Object UUID:", obj.UUID)
end
print("Total objects:", count)
```

## Source

Defined in: `server/[Objects]/_objects.lua`
