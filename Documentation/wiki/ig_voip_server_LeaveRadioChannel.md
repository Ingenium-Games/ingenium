# ig.voip.server.LeaveRadioChannel

## Description

Initialize channel if doesn't exist

## Signature

```lua
function ig.voip.server.LeaveRadioChannel(playerId, channel)
```

## Parameters

- **`playerId`**: number The server ID of the player
- **`channel`**: number The radio channel number

## Example

```lua
-- Example usage of ig.voip.server.LeaveRadioChannel
local result = ig.voip.server.LeaveRadioChannel(playerId, channel)
```

## Related Functions

- [ig.voip.server.CleanupPlayer](ig_voip_server_CleanupPlayer.md)
- [ig.voip.server.EndAdminCall](ig_voip_server_EndAdminCall.md)
- [ig.voip.server.EndCall](ig_voip_server_EndCall.md)
- [ig.voip.server.EndConnection](ig_voip_server_EndConnection.md)
- [ig.voip.server.GetPlayersInProximity](ig_voip_server_GetPlayersInProximity.md)

## Source

Defined in: `server/[Voice]/_voip.lua`
