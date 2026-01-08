# ig.voip.server.CleanupPlayer

## Description

Initialize player voice data (internal tracking)

## Signature

```lua
function ig.voip.server.CleanupPlayer(playerId)
```

## Parameters

- **`playerId`**: number The server ID of the player

## Example

```lua
-- Example usage of ig.voip.server.CleanupPlayer
local result = ig.voip.server.CleanupPlayer(playerId)
```

## Related Functions

- [ig.voip.server.EndAdminCall](ig_voip_server_EndAdminCall.md)
- [ig.voip.server.EndCall](ig_voip_server_EndCall.md)
- [ig.voip.server.EndConnection](ig_voip_server_EndConnection.md)
- [ig.voip.server.GetPlayersInProximity](ig_voip_server_GetPlayersInProximity.md)
- [ig.voip.server.GetVoiceMode](ig_voip_server_GetVoiceMode.md)

## Source

Defined in: `server/[Voice]/_voip.lua`
