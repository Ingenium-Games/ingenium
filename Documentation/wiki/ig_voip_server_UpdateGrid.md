# ig.voip.server.UpdateGrid

## Description

====================================================================================--

## Signature

```lua
function ig.voip.server.UpdateGrid(playerId, x, y)
```

## Parameters

- **`playerId`**: number The server ID of the player
- **`x`**: number The X coordinate
- **`y`**: number The Y coordinate

## Example

```lua
-- Example usage of ig.voip.server.UpdateGrid
local result = ig.voip.server.UpdateGrid(playerId, x, y)
```

## Related Functions

- [ig.voip.server.CleanupPlayer](ig_voip_server_CleanupPlayer.md)
- [ig.voip.server.EndAdminCall](ig_voip_server_EndAdminCall.md)
- [ig.voip.server.EndCall](ig_voip_server_EndCall.md)
- [ig.voip.server.EndConnection](ig_voip_server_EndConnection.md)
- [ig.voip.server.GetPlayersInProximity](ig_voip_server_GetPlayersInProximity.md)

## Source

Defined in: `server/[Voice]/_voip.lua`
