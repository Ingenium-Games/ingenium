# ig.voip.client.HandleAdminCallStateChange

## Description

====================================================================================--

## Signature

```lua
function ig.voip.client.HandleAdminCallStateChange(inAdminCall)
```

## Parameters

- **`inConnection`**: boolean Whether in connection
- **`inAdminCall`**: boolean Whether in admin call

## Example

```lua
-- Example usage of ig.voip.client.HandleAdminCallStateChange
local result = ig.voip.client.HandleAdminCallStateChange(inAdminCall)
```

## Important Notes

> ⚠️ **Security**: This function has administrative privileges. Restrict access to authorized users only.

## Related Functions

- [ig.voip.client.GetVoiceMode](ig_voip_client_GetVoiceMode.md)
- [ig.voip.client.HandleCallStateChange](ig_voip_client_HandleCallStateChange.md)
- [ig.voip.client.HandleConnectionStateChange](ig_voip_client_HandleConnectionStateChange.md)
- [ig.voip.client.InitializeMumble](ig_voip_client_InitializeMumble.md)
- [ig.voip.client.IsTalking](ig_voip_client_IsTalking.md)

## Source

Defined in: `client/[Voice]/_voip.lua`
