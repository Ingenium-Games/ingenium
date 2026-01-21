# ig.util.CheckBoneDistance

## Description

Validates that a bone exists on an entity and checks if the bone is within a specified distance threshold from given coordinates.

## Signature

```lua
function ig.util.CheckBoneDistance(entity, bone, coords, threshold)
```

## Parameters

- **`entity`**: number - The entity handle
- **`bone`**: string|number - The bone name or index
- **`coords`**: vector3 - The coordinates to check distance from
- **`threshold`**: number - Maximum distance threshold

## Returns

- **`boolean`** - `true` if the bone exists and is within threshold distance, `false` otherwise

## Example

```lua
-- Check if player's head bone is close to a coordinate
local ped = PlayerPedId()
local targetCoords = vector3(100.0, 200.0, 30.0)
local isClose = ig.util.CheckBoneDistance(ped, "SKEL_Head", targetCoords, 2.0)
if isClose then
    print("Head is within 2 units of target")
end
```

## Source

Defined in: `shared/[Tools]/_util.lua`
