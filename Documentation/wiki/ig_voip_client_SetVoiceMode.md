# ig.voip.client.SetVoiceMode

## Description

Update voice targets for connection

## Signature

```lua
function ig.voip.client.SetVoiceMode(modeIndex)
```

## Parameters

- **`modeIndex`**: number The voice mode index (1-based)

## Example

```lua
-- Example usage of ig.voip.client.SetVoiceMode
ig.voip.client.SetVoiceMode(value)
```

## Related Functions

- [ig.voip.client.GetVoiceMode](ig_voip_client_GetVoiceMode.md)
- [ig.voip.client.HandleAdminCallStateChange](ig_voip_client_HandleAdminCallStateChange.md)
- [ig.voip.client.HandleCallStateChange](ig_voip_client_HandleCallStateChange.md)
- [ig.voip.client.HandleConnectionStateChange](ig_voip_client_HandleConnectionStateChange.md)
- [ig.voip.client.InitializeMumble](ig_voip_client_InitializeMumble.md)

## Source

Defined in: `client/[Voice]/_voip.lua`
