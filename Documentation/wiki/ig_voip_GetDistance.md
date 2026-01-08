# ig.voip.GetDistance

## Description

Check if a radio channel is valid

## Signature

```lua
function ig.voip.GetDistance(x1, y1, z1, x2, y2, z2)
```

## Parameters

- **`channel`**: number The radio channel number
- **`x1`**: number X coordinate of position 1
- **`y1`**: number Y coordinate of position 1
- **`z1`**: number Z coordinate of position 1
- **`x2`**: number X coordinate of position 2
- **`y2`**: number Y coordinate of position 2
- **`z2`**: number Z coordinate of position 2

## Example

```lua
-- Example usage of ig.voip.GetDistance
local result = ig.voip.GetDistance()
```

## Related Functions

- [ig.voip.client.GetVoiceMode](ig_voip_client_GetVoiceMode.md)
- [ig.voip.client.HandleAdminCallStateChange](ig_voip_client_HandleAdminCallStateChange.md)
- [ig.voip.client.HandleCallStateChange](ig_voip_client_HandleCallStateChange.md)
- [ig.voip.client.HandleConnectionStateChange](ig_voip_client_HandleConnectionStateChange.md)
- [ig.voip.client.InitializeMumble](ig_voip_client_InitializeMumble.md)

## Source

Defined in: `shared/[Voice]/_voip.lua`
