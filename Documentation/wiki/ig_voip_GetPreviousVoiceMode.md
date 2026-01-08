# ig.voip.GetPreviousVoiceMode

## Description

Get voice mode count

## Signature

```lua
function ig.voip.GetPreviousVoiceMode(currentIndex)
```

## Parameters

- **`currentIndex`**: number The current voice mode index
- **`currentIndex`**: number The current voice mode index

## Example

```lua
-- Example usage of ig.voip.GetPreviousVoiceMode
local result = ig.voip.GetPreviousVoiceMode()
```

## Related Functions

- [ig.voip.client.GetVoiceMode](ig_voip_client_GetVoiceMode.md)
- [ig.voip.client.HandleAdminCallStateChange](ig_voip_client_HandleAdminCallStateChange.md)
- [ig.voip.client.HandleCallStateChange](ig_voip_client_HandleCallStateChange.md)
- [ig.voip.client.HandleConnectionStateChange](ig_voip_client_HandleConnectionStateChange.md)
- [ig.voip.client.InitializeMumble](ig_voip_client_InitializeMumble.md)

## Source

Defined in: `shared/[Voice]/_voip.lua`
