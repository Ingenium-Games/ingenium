# ig.door.FindHash

## Description

Finds doors in the system by their model hash. Returns all door instances that match the specified hash value.

## Signature

```lua
function ig.door.FindHash(hash)
```

## Parameters

- **`hash`**: any

## Example

```lua
-- Find doors by model hash
local doorHash = GetHashKey("prop_door_01")
local doors = ig.door.FindHash(doorHash)
for _, door in ipairs(doors) do
    print("Found door at:", door.coords)
end
```

## Source

Defined in: `client/_doors.lua`
