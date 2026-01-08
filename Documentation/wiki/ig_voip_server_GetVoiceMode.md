# ig.voip.server.GetVoiceMode

## Description

Try to get xPlayer first (if character is loaded)

## Signature

```lua
function ig.voip.server.GetVoiceMode(playerId)
```

## Parameters

- **`playerId`**: number The server ID of the player

## Example

```lua
-- Example usage of ig.voip.server.GetVoiceMode
local result = ig.voip.server.GetVoiceMode()
```

## Related Functions

- [ig.voip.server.CleanupPlayer](ig_voip_server_CleanupPlayer.md)
- [ig.voip.server.EndAdminCall](ig_voip_server_EndAdminCall.md)
- [ig.voip.server.EndCall](ig_voip_server_EndCall.md)
- [ig.voip.server.EndConnection](ig_voip_server_EndConnection.md)
- [ig.voip.server.GetPlayersInProximity](ig_voip_server_GetPlayersInProximity.md)

## Source

Defined in: `server/[Voice]/_voip.lua`
