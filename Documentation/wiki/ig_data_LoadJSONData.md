# ig.data.LoadJSONData

## Description

====================================================================================--

## Signature

```lua
function ig.data.LoadJSONData(callback)
```

## Parameters

- **`source`**: number
- **`Character_ID`**: string
- **`callback`**: function Optional callback to execute after loading

## Example

```lua
-- Example usage of ig.data.LoadJSONData
local result = ig.data.LoadJSONData(callback)
```

## Important Notes

> ⚠️ **Security**: This function executes code dynamically. Never use with untrusted input.

> 📋 **Parameter**: `callback` - Function to execute upon completion

## Related Functions

- [ig.data.GetEntityState](ig_data_GetEntityState.md)
- [ig.data.GetEntityStateCheck](ig_data_GetEntityStateCheck.md)
- [ig.data.GetLoadedStatus](ig_data_GetLoadedStatus.md)
- [ig.data.GetLocalPlayer](ig_data_GetLocalPlayer.md)
- [ig.data.GetLocalPlayerState](ig_data_GetLocalPlayerState.md)

## Source

Defined in: `server/_data.lua`
