# Export: GetIngenium()

**Returns**: `table` - Global `ig` object containing all framework functions  
**Security**: ✅ Public (no GetInvokingResource check)  
**Side**: [S C]

## Description

Get access to the main framework object containing all core functions and namespaces.

## Usage

```lua
-- Get the framework at startup
local ig = exports["ingenium"]:GetIngenium()

-- Now use framework functions throughout your resource:
ig.func.GetPlayers()
ig.inventory.GetInventory()
ig.appearance.SetAppearance(appearanceData)
ig.target.AddPolyZone(zoneData)
```

## Return Value

Returns a table with all framework namespaces:
- `ig.func` - Utility functions
- `ig.inventory` - Inventory operations
- `ig.appearance` - Character customization
- `ig.vehicle` - Vehicle operations
- `ig.job` - Job system
- `ig.bank` - Banking operations
- And 50+ more namespaces

## Examples

```lua
-- Get framework
local ig = exports["ingenium"]:GetIngenium()

-- Use different namespaces
local players = ig.func.GetPlayers()
local inventory = ig.inventory.GetInventory()

-- Chain operations
ig.func.Notify("Loaded framework!", "green", 3000)
```

## See Also

- [GetLocale](ig_export_GetLocale.md) - Get current server locale
- [Notify](ig_export_Notify.md) - Send notifications
- [GetCurrentExternalInventory](ig_export_GetCurrentExternalInventory.md) - Check open inventories
