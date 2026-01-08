# ig.voip.server.StartCall

## Description

Use xPlayer method if available

## Signature

```lua
function ig.voip.server.StartCall(callerId, targetId)
```

## Parameters

- **`playerId`**: number The server ID of the player
- **`transmitting`**: boolean Whether the player is transmitting
- **`callerId`**: number The server ID of the caller
- **`targetId`**: number The server ID of the target

## Example

```lua
-- Example usage of ig.voip.server.StartCall
local result = ig.voip.server.StartCall(callerId, targetId)
```

## Related Functions

- [ig.voip.server.CleanupPlayer](ig_voip_server_CleanupPlayer.md)
- [ig.voip.server.EndAdminCall](ig_voip_server_EndAdminCall.md)
- [ig.voip.server.EndCall](ig_voip_server_EndCall.md)
- [ig.voip.server.EndConnection](ig_voip_server_EndConnection.md)
- [ig.voip.server.GetPlayersInProximity](ig_voip_server_GetPlayersInProximity.md)

## Source

Defined in: `server/[Voice]/_voip.lua`
