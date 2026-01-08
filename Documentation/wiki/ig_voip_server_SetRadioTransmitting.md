# ig.voip.server.SetRadioTransmitting

## Description

Remove empty channels

## Signature

```lua
function ig.voip.server.SetRadioTransmitting(playerId, transmitting)
```

## Parameters

- **`playerId`**: number The server ID of the player
- **`transmitting`**: boolean Whether the player is transmitting

## Example

```lua
-- Example usage of ig.voip.server.SetRadioTransmitting
ig.voip.server.SetRadioTransmitting(value)
```

## Related Functions

- [ig.voip.server.CleanupPlayer](ig_voip_server_CleanupPlayer.md)
- [ig.voip.server.EndAdminCall](ig_voip_server_EndAdminCall.md)
- [ig.voip.server.EndCall](ig_voip_server_EndCall.md)
- [ig.voip.server.EndConnection](ig_voip_server_EndConnection.md)
- [ig.voip.server.GetPlayersInProximity](ig_voip_server_GetPlayersInProximity.md)

## Source

Defined in: `server/[Voice]/_voip.lua`
