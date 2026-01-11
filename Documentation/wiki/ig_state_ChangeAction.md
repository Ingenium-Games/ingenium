# ig.state.ChangeAction

## Description

Changes the action handler for a registered state. Allows dynamic modification of what happens when a state is triggered.

## Signature

```lua
function ig.state.ChangeAction(name, value, cb)
```

## Parameters

- **`name`**: string
- **`value`**: any
- **`cb`**: function

## Example

```lua
-- Change action for an existing state
ig.state.ChangeAction("wounded", function(player)
    print("Player is wounded:", player)
    -- New handling logic
end)
```

## Source

Defined in: `client/_states.lua`
