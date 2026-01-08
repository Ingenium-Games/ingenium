# ig.gsr.HasRecent

## Description

Get GSR records near coordinates

## Signature

```lua
function ig.gsr.HasRecent(characterId, maxAge)
```

## Parameters

- **`coords`**: vector3 Center coordinates
- **`radius`**: number Search radius
- **`characterId`**: string Character ID
- **`maxAge`**: number|nil Max age in seconds (default 300)

## Example

```lua
-- Example usage of ig.gsr.HasRecent
local result = ig.gsr.HasRecent(characterId, maxAge)
```

## Related Functions

- [ig.gsr.Add](ig_gsr_Add.md)
- [ig.gsr.Clean](ig_gsr_Clean.md)
- [ig.gsr.CleanOld](ig_gsr_CleanOld.md)
- [ig.gsr.Clear](ig_gsr_Clear.md)
- [ig.gsr.Create](ig_gsr_Create.md)

## Source

Defined in: `server/[Data - Save to File]/_gsr.lua`
