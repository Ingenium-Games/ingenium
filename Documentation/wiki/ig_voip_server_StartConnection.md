# ig.voip.server.StartConnection

## Description

====================================================================================--

## Signature

```lua
function ig.voip.server.StartConnection(playerId, connectionId)
```

## Parameters

- **`playerId`**: number The server ID of the player
- **`connectionId`**: string The unique connection ID

## Example

```lua
-- Example usage of ig.voip.server.StartConnection
local result = ig.voip.server.StartConnection(playerId, connectionId)
```

## Related Functions

- [ig.voip.server.CleanupPlayer](ig_voip_server_CleanupPlayer.md)
- [ig.voip.server.EndAdminCall](ig_voip_server_EndAdminCall.md)
- [ig.voip.server.EndCall](ig_voip_server_EndCall.md)
- [ig.voip.server.EndConnection](ig_voip_server_EndConnection.md)
- [ig.voip.server.GetPlayersInProximity](ig_voip_server_GetPlayersInProximity.md)

## Source

Defined in: `server/[Voice]/_voip.lua`
