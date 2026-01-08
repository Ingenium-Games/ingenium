# ig.voip.server.StartAdminCall

## Description

====================================================================================--

## Signature

```lua
function ig.voip.server.StartAdminCall(adminId, targetId)
```

## Parameters

- **`adminId`**: number The server ID of the admin
- **`targetId`**: number The server ID of the target player

## Example

```lua
-- Example usage of ig.voip.server.StartAdminCall
local result = ig.voip.server.StartAdminCall(adminId, targetId)
```

## Important Notes

> ⚠️ **Security**: This function has administrative privileges. Restrict access to authorized users only.

## Related Functions

- [ig.voip.server.CleanupPlayer](ig_voip_server_CleanupPlayer.md)
- [ig.voip.server.EndAdminCall](ig_voip_server_EndAdminCall.md)
- [ig.voip.server.EndCall](ig_voip_server_EndCall.md)
- [ig.voip.server.EndConnection](ig_voip_server_EndConnection.md)
- [ig.voip.server.GetPlayersInProximity](ig_voip_server_GetPlayersInProximity.md)

## Source

Defined in: `server/[Voice]/_voip.lua`
