# ig.ui.ShowMenu

## Description

Displays a menu with the provided configuration data.

## Signature

```lua
function ig.ui.ShowMenu(data)
```

## Parameters

- **`data`**: table - Menu configuration object

## Returns

None

## Example

```lua
-- Show a menu
ig.ui.ShowMenu({
    title = "Main Menu",
    items = {
        {label = "Item 1", description = "First item"},
        {label = "Item 2", description = "Second item"}
    }
})
```

## Source

Defined in: `client/_ui.lua`
