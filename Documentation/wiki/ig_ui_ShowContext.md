# ig.ui.ShowContext

## Description

Displays a context menu with the provided data.

## Signature

```lua
function ig.ui.ShowContext(data)
```

## Parameters

- **`data`**: table - Context menu configuration object

## Returns

None

## Example

```lua
-- Show a context menu
ig.ui.ShowContext({
    title = "Actions",
    options = {
        {label = "Option 1", value = "opt1"},
        {label = "Option 2", value = "opt2"}
    }
})
```

## Source

Defined in: `client/_ui.lua`
