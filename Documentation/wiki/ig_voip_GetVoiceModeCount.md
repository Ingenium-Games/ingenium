# ig.voip.GetVoiceModeCount

## Description

Voice state types

## Signature

```lua
function ig.voip.GetVoiceModeCount()
```

## Parameters

- **`modeIndex`**: number The 1-based index of the voice mode

## Example

```lua
-- Example usage of ig.voip.GetVoiceModeCount
local result = ig.voip.GetVoiceModeCount()
```

## Related Functions

- [ig.voip.client.GetVoiceMode](ig_voip_client_GetVoiceMode.md)
- [ig.voip.client.HandleAdminCallStateChange](ig_voip_client_HandleAdminCallStateChange.md)
- [ig.voip.client.HandleCallStateChange](ig_voip_client_HandleCallStateChange.md)
- [ig.voip.client.HandleConnectionStateChange](ig_voip_client_HandleConnectionStateChange.md)
- [ig.voip.client.InitializeMumble](ig_voip_client_InitializeMumble.md)

## Source

Defined in: `shared/[Voice]/_voip.lua`
