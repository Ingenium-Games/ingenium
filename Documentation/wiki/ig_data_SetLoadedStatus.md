# ig.data.SetLoadedStatus

## Description

Use secure callback for player connecting

## Signature

```lua
function ig.data.SetLoadedStatus(bool)
```

## Parameters

- **`bool`**: boolean "Set loaded status to true or false.

## Example

```lua
-- Example usage of ig.data.SetLoadedStatus
ig.data.SetLoadedStatus(value)
```

## Important Notes

> ⚠️ **Security**: This function executes code dynamically. Never use with untrusted input.

## Related Functions

- [ig.data.GetEntityState](ig_data_GetEntityState.md)
- [ig.data.GetEntityStateCheck](ig_data_GetEntityStateCheck.md)
- [ig.data.GetLoadedStatus](ig_data_GetLoadedStatus.md)
- [ig.data.GetLocalPlayer](ig_data_GetLocalPlayer.md)
- [ig.data.GetLocalPlayerState](ig_data_GetLocalPlayerState.md)

## Source

Defined in: `client/_data.lua`
