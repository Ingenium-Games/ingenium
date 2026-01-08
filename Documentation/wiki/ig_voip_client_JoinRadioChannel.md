# ig.voip.client.JoinRadioChannel

## Description

Trigger event for UI updates

## Signature

```lua
function ig.voip.client.JoinRadioChannel(channel)
```

## Parameters

- **`channel`**: number The radio channel number

## Example

```lua
-- Example usage of ig.voip.client.JoinRadioChannel
local result = ig.voip.client.JoinRadioChannel(channel)
```

## Related Functions

- [ig.voip.client.GetVoiceMode](ig_voip_client_GetVoiceMode.md)
- [ig.voip.client.HandleAdminCallStateChange](ig_voip_client_HandleAdminCallStateChange.md)
- [ig.voip.client.HandleCallStateChange](ig_voip_client_HandleCallStateChange.md)
- [ig.voip.client.HandleConnectionStateChange](ig_voip_client_HandleConnectionStateChange.md)
- [ig.voip.client.InitializeMumble](ig_voip_client_InitializeMumble.md)

## Source

Defined in: `client/[Voice]/_voip.lua`
