# ig.data.GetObjects

## Description

Retrieves all object entities in the server.

## Signature

```lua
function ig.data.GetObjects()
```

## Parameters

None

## Returns

- **`table`** - The complete `ig.odex` table containing all object entities indexed by network ID

## Example

```lua
-- Get all objects and count them
local objects = ig.data.GetObjects()
local count = 0
for k, v in pairs(objects) do
    count = count + 1
end
print("Total objects:", count)
```

## Source

Defined in: `server/_data.lua` (delegates to `ig.object.GetObjects` in `server/[Objects]/_objects.lua`)
