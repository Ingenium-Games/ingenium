# ig.table.MakeReadOnly

## Description

Makes a table read-only by preventing modifications

## Signature

```lua
function ig.table.MakeReadOnly(t, name)
```

## Parameters

- **`t`**: table The table to make read-only
- **`name`**: string|nil Optional name for error messages

## Example

```lua
-- Example usage of ig.table.MakeReadOnly
local result = ig.table.MakeReadOnly(t, name)
```

## Related Functions

- [ig.table.Clone](ig_table_Clone.md)
- [ig.table.Dump](ig_table_Dump.md)
- [ig.table.MatchKey](ig_table_MatchKey.md)
- [ig.table.MatchValue](ig_table_MatchValue.md)
- [ig.table.Merge](ig_table_Merge.md)

## Source

Defined in: `shared/[Tools]/_table.lua`
