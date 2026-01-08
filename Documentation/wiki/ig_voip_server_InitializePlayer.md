# ig.voip.server.InitializePlayer

## Description

Storage for active radio channels

## Signature

```lua
function ig.voip.server.InitializePlayer(playerId)
```

## Parameters

- **`playerId`**: number The server ID of the player

## Example

```lua
-- Example usage of ig.voip.server.InitializePlayer
local result = ig.voip.server.InitializePlayer(playerId)
```

## Related Functions

- [ig.voip.server.CleanupPlayer](ig_voip_server_CleanupPlayer.md)
- [ig.voip.server.EndAdminCall](ig_voip_server_EndAdminCall.md)
- [ig.voip.server.EndCall](ig_voip_server_EndCall.md)
- [ig.voip.server.EndConnection](ig_voip_server_EndConnection.md)
- [ig.voip.server.GetPlayersInProximity](ig_voip_server_GetPlayersInProximity.md)

## Source

Defined in: `server/[Voice]/_voip.lua`
