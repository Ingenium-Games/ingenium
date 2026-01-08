# ig.gsr.IncrementShots

## Description

Check if character has recent GSR

## Signature

```lua
function ig.gsr.IncrementShots(characterId, maxAge)
```

## Parameters

- **`characterId`**: string Character ID
- **`maxAge`**: number|nil Max age in seconds (default 300)
- **`characterId`**: string Character ID
- **`maxAge`**: number|nil Time window to find existing GSR (default 60s)

## Example

```lua
-- Example usage of ig.gsr.IncrementShots
local result = ig.gsr.IncrementShots(characterId, maxAge)
```

## Related Functions

- [ig.gsr.Add](ig_gsr_Add.md)
- [ig.gsr.Clean](ig_gsr_Clean.md)
- [ig.gsr.CleanOld](ig_gsr_CleanOld.md)
- [ig.gsr.Clear](ig_gsr_Clear.md)
- [ig.gsr.Create](ig_gsr_Create.md)

## Source

Defined in: `server/[Data - Save to File]/_gsr.lua`
