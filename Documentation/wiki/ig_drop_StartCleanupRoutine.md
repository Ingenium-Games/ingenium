# ig.drop.StartCleanupRoutine

## Description

Initializes the automatic cleanup routine for dropped items. Periodically removes old drops from the world to prevent performance issues. Runs on a timer to check and cleanup drops based on configured age threshold.

## Signature

```lua
function ig.drop.StartCleanupRoutine()
```

## Example

```lua
-- Start automatic cleanup of old drops
ig.drop.StartCleanupRoutine()

-- The routine will periodically clean up drops older than the configured timeout
-- This helps maintain server performance by removing stale items
```

## Important Notes

> ⚠️ **Security**: This function accesses player identifiers or can ban/kick players. Ensure proper permission checks.

## Related Functions

- [ig.drop.Activate](ig_drop_Activate.md)
- [ig.drop.CleanupOld](ig_drop_CleanupOld.md)
- [ig.drop.Create](ig_drop_Create.md)
- [ig.drop.Deactivate](ig_drop_Deactivate.md)
- [ig.drop.MergeDropsForSave](ig_drop_MergeDropsForSave.md)

## Source

Defined in: `server/[Data - Save to File]/_drops.lua`
