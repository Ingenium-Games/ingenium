# ig.voip.Debug

## Description

Get surrounding grid cells (for efficient proximity checks)

## Signature

```lua
function ig.voip.Debug(message)
```

## Parameters

- **`gridX`**: number The center grid cell X
- **`gridY`**: number The center grid cell Y
- **`message`**: string The debug message

## Example

```lua
-- Example usage of ig.voip.Debug
local result = ig.voip.Debug(message)
```

## Related Functions

- [ig.voip.client.GetVoiceMode](ig_voip_client_GetVoiceMode.md)
- [ig.voip.client.HandleAdminCallStateChange](ig_voip_client_HandleAdminCallStateChange.md)
- [ig.voip.client.HandleCallStateChange](ig_voip_client_HandleCallStateChange.md)
- [ig.voip.client.HandleConnectionStateChange](ig_voip_client_HandleConnectionStateChange.md)
- [ig.voip.client.InitializeMumble](ig_voip_client_InitializeMumble.md)

## Source

Defined in: `shared/[Voice]/_voip.lua`
