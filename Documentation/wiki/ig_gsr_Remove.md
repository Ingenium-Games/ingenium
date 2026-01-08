# ig.gsr.Remove

## Description

Increment shot count for existing GSR

## Signature

```lua
function ig.gsr.Remove(id)
```

## Parameters

- **`characterId`**: string Character ID
- **`maxAge`**: number|nil Time window to find existing GSR (default 60s)
- **`id`**: string GSR ID

## Example

```lua
-- Example usage of ig.gsr.Remove
ig.gsr.Remove(item)
```

## Related Functions

- [ig.gsr.Add](ig_gsr_Add.md)
- [ig.gsr.Clean](ig_gsr_Clean.md)
- [ig.gsr.CleanOld](ig_gsr_CleanOld.md)
- [ig.gsr.Clear](ig_gsr_Clear.md)
- [ig.gsr.Create](ig_gsr_Create.md)

## Source

Defined in: `server/[Data - Save to File]/_gsr.lua`
