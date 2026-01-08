# ig.state.ChangeAction

## Description

====================================================================================--

## Signature

```lua
function ig.state.ChangeAction(name, value, cb)
```

## Parameters

- **`name`**: string "The name of the state like 'Hungry'
- **`description`**: string "You feel your stomach ache a little.
- **`value`**: number "You feel your stomach ache a little.
- **`effect`**: function "Any change to the screen on the users end
- **`action`**: function "Any change to the screen on the users end

## Example

```lua
-- Example usage of ig.state.ChangeAction
local result = ig.state.ChangeAction(name, value, cb)
```

## Related Functions

- [ig.state.AddState](ig_state_AddState.md)
- [ig.state.ChangeEffect](ig_state_ChangeEffect.md)
- [ig.state.TriggerAction](ig_state_TriggerAction.md)
- [ig.state.TriggerEffect](ig_state_TriggerEffect.md)
- [ig.state.TriggerState](ig_state_TriggerState.md)

## Source

Defined in: `client/_states.lua`
