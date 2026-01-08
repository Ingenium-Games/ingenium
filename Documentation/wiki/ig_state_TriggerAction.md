# ig.state.TriggerAction

## Description

- To action based on the key and value of various modifiers or other tasks.

## Signature

```lua
function ig.state.TriggerAction(name, value)
```

## Parameters

- **`name`**: string "The name of the State
- **`value`**: number "The number of the State containing values

## Example

```lua
-- Example usage of ig.state.TriggerAction
local result = ig.state.TriggerAction(name, value)
```

## Related Functions

- [ig.state.AddState](ig_state_AddState.md)
- [ig.state.ChangeAction](ig_state_ChangeAction.md)
- [ig.state.ChangeEffect](ig_state_ChangeEffect.md)
- [ig.state.TriggerEffect](ig_state_TriggerEffect.md)
- [ig.state.TriggerState](ig_state_TriggerState.md)

## Source

Defined in: `client/_states.lua`
