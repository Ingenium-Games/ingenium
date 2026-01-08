# ig.voip.server.SetVoiceMode

## Description

End any active connections

## Signature

```lua
function ig.voip.server.SetVoiceMode(playerId, modeIndex)
```

## Parameters

- **`playerId`**: number The server ID of the player
- **`modeIndex`**: number The voice mode index (1-based)

## Example

```lua
-- Example usage of ig.voip.server.SetVoiceMode
ig.voip.server.SetVoiceMode(value)
```

## Related Functions

- [ig.voip.server.CleanupPlayer](ig_voip_server_CleanupPlayer.md)
- [ig.voip.server.EndAdminCall](ig_voip_server_EndAdminCall.md)
- [ig.voip.server.EndCall](ig_voip_server_EndCall.md)
- [ig.voip.server.EndConnection](ig_voip_server_EndConnection.md)
- [ig.voip.server.GetPlayersInProximity](ig_voip_server_GetPlayersInProximity.md)

## Source

Defined in: `server/[Voice]/_voip.lua`
