# ig.data.LoadPlayer

## Description

Object sync - moderate frequency (5 min)

## Signature

```lua
function ig.data.LoadPlayer(source, Character_ID)
```

## Parameters

- **`source`**: number
- **`Character_ID`**: string

## Example

```lua
-- Example usage of ig.data.LoadPlayer
local result = ig.data.LoadPlayer(source, Character_ID)
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

Defined in: `server/_data.lua`
