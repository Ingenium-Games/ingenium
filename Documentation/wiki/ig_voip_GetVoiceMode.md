# ig.voip.GetVoiceMode

## Description

Initialize voice modes from configuration

## Signature

```lua
function ig.voip.GetVoiceMode(modeIndex)
```

## Parameters

- **`modeIndex`**: number The 1-based index of the voice mode

## Example

```lua
-- Example usage of ig.voip.GetVoiceMode
local result = ig.voip.GetVoiceMode()
```

## Related Functions

- [ig.voip.client.GetVoiceMode](ig_voip_client_GetVoiceMode.md)
- [ig.voip.client.HandleAdminCallStateChange](ig_voip_client_HandleAdminCallStateChange.md)
- [ig.voip.client.HandleCallStateChange](ig_voip_client_HandleCallStateChange.md)
- [ig.voip.client.HandleConnectionStateChange](ig_voip_client_HandleConnectionStateChange.md)
- [ig.voip.client.InitializeMumble](ig_voip_client_InitializeMumble.md)

## Source

Defined in: `shared/[Voice]/_voip.lua`
