# ig.voip.server.EndConnection

## Description

End a web connection for a player

## Signature

```lua
function ig.voip.server.EndConnection(playerId)
```

## Parameters

- **`playerId`**: number The server ID of the player

## Example

```lua
-- Example usage of ig.voip.server.EndConnection
local result = ig.voip.server.EndConnection(playerId)
```

## Related Functions

- [ig.voip.server.CleanupPlayer](ig_voip_server_CleanupPlayer.md)
- [ig.voip.server.EndAdminCall](ig_voip_server_EndAdminCall.md)
- [ig.voip.server.EndCall](ig_voip_server_EndCall.md)
- [ig.voip.server.GetPlayersInProximity](ig_voip_server_GetPlayersInProximity.md)
- [ig.voip.server.GetVoiceMode](ig_voip_server_GetVoiceMode.md)

## Source

Defined in: `server/[Voice]/_voip.lua`
