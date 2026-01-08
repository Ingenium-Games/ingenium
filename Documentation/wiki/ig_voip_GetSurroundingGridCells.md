# ig.voip.GetSurroundingGridCells

## Description

Calculate grid cell from position (for grid-based proximity)

## Signature

```lua
function ig.voip.GetSurroundingGridCells(gridX, gridY)
```

## Parameters

- **`z1`**: number Z coordinate of position 1
- **`x2`**: number X coordinate of position 2
- **`y2`**: number Y coordinate of position 2
- **`z2`**: number Z coordinate of position 2
- **`x`**: number X coordinate
- **`y`**: number Y coordinate
- **`gridX`**: number The center grid cell X
- **`gridY`**: number The center grid cell Y

## Example

```lua
-- Example usage of ig.voip.GetSurroundingGridCells
local result = ig.voip.GetSurroundingGridCells()
```

## Related Functions

- [ig.voip.client.GetVoiceMode](ig_voip_client_GetVoiceMode.md)
- [ig.voip.client.HandleAdminCallStateChange](ig_voip_client_HandleAdminCallStateChange.md)
- [ig.voip.client.HandleCallStateChange](ig_voip_client_HandleCallStateChange.md)
- [ig.voip.client.HandleConnectionStateChange](ig_voip_client_HandleConnectionStateChange.md)
- [ig.voip.client.InitializeMumble](ig_voip_client_InitializeMumble.md)

## Source

Defined in: `shared/[Voice]/_voip.lua`
