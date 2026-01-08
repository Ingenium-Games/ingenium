# ig.voip.server.GetPlayersInProximity

## Description

Remove player from grid

## Signature

```lua
function ig.voip.server.GetPlayersInProximity(playerId, distance)
```

## Parameters

- **`playerId`**: number The server ID of the player
- **`playerId`**: number The server ID of the player
- **`distance`**: number The maximum distance

## Example

```lua
-- Example usage of ig.voip.server.GetPlayersInProximity
local result = ig.voip.server.GetPlayersInProximity()
```

## Related Functions

- [ig.voip.server.CleanupPlayer](ig_voip_server_CleanupPlayer.md)
- [ig.voip.server.EndAdminCall](ig_voip_server_EndAdminCall.md)
- [ig.voip.server.EndCall](ig_voip_server_EndCall.md)
- [ig.voip.server.EndConnection](ig_voip_server_EndConnection.md)
- [ig.voip.server.GetVoiceMode](ig_voip_server_GetVoiceMode.md)

## Source

Defined in: `server/[Voice]/_voip.lua`
