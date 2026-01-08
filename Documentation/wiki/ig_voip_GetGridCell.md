# ig.voip.GetGridCell

## Description

Calculate distance between two 3D positions

## Signature

```lua
function ig.voip.GetGridCell(x, y)
```

## Parameters

- **`x1`**: number X coordinate of position 1
- **`y1`**: number Y coordinate of position 1
- **`z1`**: number Z coordinate of position 1
- **`x2`**: number X coordinate of position 2
- **`y2`**: number Y coordinate of position 2
- **`z2`**: number Z coordinate of position 2
- **`x`**: number X coordinate
- **`y`**: number Y coordinate

## Example

```lua
-- Example usage of ig.voip.GetGridCell
local result = ig.voip.GetGridCell()
```

## Related Functions

- [ig.voip.client.GetVoiceMode](ig_voip_client_GetVoiceMode.md)
- [ig.voip.client.HandleAdminCallStateChange](ig_voip_client_HandleAdminCallStateChange.md)
- [ig.voip.client.HandleCallStateChange](ig_voip_client_HandleCallStateChange.md)
- [ig.voip.client.HandleConnectionStateChange](ig_voip_client_HandleConnectionStateChange.md)
- [ig.voip.client.InitializeMumble](ig_voip_client_InitializeMumble.md)

## Source

Defined in: `shared/[Voice]/_voip.lua`
