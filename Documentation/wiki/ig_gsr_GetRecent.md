# ig.gsr.GetRecent

## Description

Get all GSR records

## Signature

```lua
function ig.gsr.GetRecent(maxAge)
```

## Parameters

- **`characterId`**: string Character ID
- **`maxAge`**: number Max age in seconds (default 300 = 5 minutes)

## Example

```lua
-- Example usage of ig.gsr.GetRecent
local result = ig.gsr.GetRecent()
```

## Related Functions

- [ig.gsr.Add](ig_gsr_Add.md)
- [ig.gsr.Clean](ig_gsr_Clean.md)
- [ig.gsr.CleanOld](ig_gsr_CleanOld.md)
- [ig.gsr.Clear](ig_gsr_Clear.md)
- [ig.gsr.Create](ig_gsr_Create.md)

## Source

Defined in: `server/[Data - Save to File]/_gsr.lua`
