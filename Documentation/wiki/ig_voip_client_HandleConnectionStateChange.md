# ig.voip.client.HandleConnectionStateChange

## Description

Get call target from statebag

## Signature

```lua
function ig.voip.client.HandleConnectionStateChange(inConnection)
```

## Parameters

- **`inConnection`**: boolean Whether in connection

## Example

```lua
-- Example usage of ig.voip.client.HandleConnectionStateChange
local result = ig.voip.client.HandleConnectionStateChange(inConnection)
```

## Related Functions

- [ig.voip.client.GetVoiceMode](ig_voip_client_GetVoiceMode.md)
- [ig.voip.client.HandleAdminCallStateChange](ig_voip_client_HandleAdminCallStateChange.md)
- [ig.voip.client.HandleCallStateChange](ig_voip_client_HandleCallStateChange.md)
- [ig.voip.client.InitializeMumble](ig_voip_client_InitializeMumble.md)
- [ig.voip.client.IsTalking](ig_voip_client_IsTalking.md)

## Source

Defined in: `client/[Voice]/_voip.lua`
