# ig.gsr.CleanOld

## Description

Find recent GSR for this character

## Signature

```lua
function ig.gsr.CleanOld(maxAge)
```

## Parameters

- **`id`**: string GSR ID
- **`maxAge`**: number|nil Max age in seconds (uses config if nil)

## Example

```lua
-- Example usage of ig.gsr.CleanOld
local result = ig.gsr.CleanOld(maxAge)
```

## Related Functions

- [ig.gsr.Add](ig_gsr_Add.md)
- [ig.gsr.Clean](ig_gsr_Clean.md)
- [ig.gsr.Clear](ig_gsr_Clear.md)
- [ig.gsr.Create](ig_gsr_Create.md)
- [ig.gsr.Exist](ig_gsr_Exist.md)

## Source

Defined in: `server/[Data - Save to File]/_gsr.lua`
