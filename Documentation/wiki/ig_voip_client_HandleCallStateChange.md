# ig.voip.client.HandleCallStateChange

## Description

Set radio transmitting state

## Signature

```lua
function ig.voip.client.HandleCallStateChange(inCall)
```

## Parameters

- **`transmitting`**: boolean Whether transmitting
- **`inCall`**: boolean Whether in call

## Example

```lua
-- Example usage of ig.voip.client.HandleCallStateChange
local result = ig.voip.client.HandleCallStateChange(inCall)
```

## Related Functions

- [ig.voip.client.GetVoiceMode](ig_voip_client_GetVoiceMode.md)
- [ig.voip.client.HandleAdminCallStateChange](ig_voip_client_HandleAdminCallStateChange.md)
- [ig.voip.client.HandleConnectionStateChange](ig_voip_client_HandleConnectionStateChange.md)
- [ig.voip.client.InitializeMumble](ig_voip_client_InitializeMumble.md)
- [ig.voip.client.IsTalking](ig_voip_client_IsTalking.md)

## Source

Defined in: `client/[Voice]/_voip.lua`
