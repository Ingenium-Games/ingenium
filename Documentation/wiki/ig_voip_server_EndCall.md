# ig.voip.server.EndCall

## Description

End a call for a player

## Signature

```lua
function ig.voip.server.EndCall(playerId)
```

## Parameters

- **`playerId`**: number The server ID of the player

## Example

```lua
-- Example usage of ig.voip.server.EndCall
local result = ig.voip.server.EndCall(playerId)
```

## Related Functions

- [ig.voip.server.CleanupPlayer](ig_voip_server_CleanupPlayer.md)
- [ig.voip.server.EndAdminCall](ig_voip_server_EndAdminCall.md)
- [ig.voip.server.EndConnection](ig_voip_server_EndConnection.md)
- [ig.voip.server.GetPlayersInProximity](ig_voip_server_GetPlayersInProximity.md)
- [ig.voip.server.GetVoiceMode](ig_voip_server_GetVoiceMode.md)

## Source

Defined in: `server/[Voice]/_voip.lua`
