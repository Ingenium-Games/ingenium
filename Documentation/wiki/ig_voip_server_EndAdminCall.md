# ig.voip.server.EndAdminCall

## Description

Update target's statebag using xPlayer method (server-only, permission checked)

## Signature

```lua
function ig.voip.server.EndAdminCall(adminId, targetId)
```

## Parameters

- **`adminId`**: number The server ID of the admin
- **`targetId`**: number|nil The server ID of the target (if nil, ends all admin calls from this admin)

## Example

```lua
-- Example usage of ig.voip.server.EndAdminCall
local result = ig.voip.server.EndAdminCall(adminId, targetId)
```

## Important Notes

> ⚠️ **Security**: This function has administrative privileges. Restrict access to authorized users only.

## Related Functions

- [ig.voip.server.CleanupPlayer](ig_voip_server_CleanupPlayer.md)
- [ig.voip.server.EndCall](ig_voip_server_EndCall.md)
- [ig.voip.server.EndConnection](ig_voip_server_EndConnection.md)
- [ig.voip.server.GetPlayersInProximity](ig_voip_server_GetPlayersInProximity.md)
- [ig.voip.server.GetVoiceMode](ig_voip_server_GetVoiceMode.md)

## Source

Defined in: `server/[Voice]/_voip.lua`
