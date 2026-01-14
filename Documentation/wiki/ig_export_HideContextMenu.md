# Export: HideContextMenu()

**Returns**: `void`  
**Security**: ✅ Public  
**Side**: [C]

## Description

Close the context menu.

## Usage

```lua
exports["ingenium"]:HideContextMenu()
```

## Examples

```lua
-- Open context menu
exports["ingenium"]:ShowContextMenu({
    actions = {
        {label = "Option 1", action = "opt1"},
        {label = "Cancel", action = "cancel"}
    }
})

-- Close it
exports["ingenium"]:HideContextMenu()
```

## See Also

- [ShowContextMenu](ig_export_ShowContextMenu.md) - Display context menu
