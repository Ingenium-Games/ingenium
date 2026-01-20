# Inventory System

## Overview

Ingenium's inventory system features **multi-layer exploit prevention**, supporting weapons, consumables, stacking, degradation, and real-time synchronization. The system is server-authoritative with comprehensive validation.

## Inventory Structure

### Storage Format

Player inventory is stored as a **JSON-encoded table** in the database, decoded to Lua on load:

```lua
-- Database: VARCHAR/TEXT column "Inventory"
-- Memory: Lua table self.Inventory
-- StateBag: self.State.Inventory (real-time sync to client)
```

### Item Slot Structure

Each inventory slot contains 6 properties:

```lua
{
    ["Item"]     = "ItemName",        -- string: Item identifier
    ["Quantity"] = 5,                 -- number: Stack quantity (1 if non-stackable)
    ["Quality"]  = 85,                -- number: Durability (0-100)
    ["Weapon"]   = "12345678",        -- string/boolean: Weapon hash or false
    ["Meta"]     = {...},             -- table: Custom metadata
    ["Name"]     = "Custom Name"      -- string: Display name override
}
```

### Example Inventory

```lua
{
    [1] = {Item = "bread", Quantity = 5, Quality = 100, Weapon = false, Meta = {}, Name = "Bread"},
    [2] = {Item = "WEAPON_PISTOL", Quantity = 1, Quality = 85, Weapon = "453432689", Meta = {SerialNumber = "ABC123"}, Name = "Pistol"},
    [3] = {Item = "water", Quantity = 3, Quality = 100, Weapon = false, Meta = {}, Name = "Water"}
}
```

## Item Management Functions

### Check if Player Has Item

```lua
xPlayer.HasItem(name)
```

Returns: `(boolean, position)`

Example:
```lua
local hasItem, slot = xPlayer.HasItem("bread")
if hasItem then
    print("Player has bread in slot:", slot)
end
```

### Get Item Quantity

```lua
xPlayer.GetItemQuantity(name)
```

Returns: `(quantity, position)`

Example:
```lua
local quantity, slot = xPlayer.GetItemQuantity("bread")
print("Player has", quantity, "bread in slot", slot)
```

### Get Item Quality

```lua
xPlayer.GetItemQuality(name)
```

Returns: `(quality, position)`

Example:
```lua
local quality, slot = xPlayer.GetItemQuality("WEAPON_PISTOL")
print("Weapon quality:", quality, "%")
```

### Get Item from Slot

```lua
xPlayer.GetItemFromPosition(position)
```

Returns: `item table` or `false`

Example:
```lua
local item = xPlayer.GetItemFromPosition(1)
if item then
    print("Slot 1 contains:", item.Item, "x", item.Quantity)
end
```

### Add Item

```lua
xPlayer.AddItem(table)
```

Example:
```lua
-- Simple add
xPlayer.AddItem({"bread", 5})

-- With quality
xPlayer.AddItem({"bread", 5, 80})

-- Weapon with hash
xPlayer.AddItem({"WEAPON_PISTOL", 1, 100, "453432689"})

-- With metadata
xPlayer.AddItem({"WEAPON_PISTOL", 1, 100, "453432689", {SerialNumber = "ABC123"}})
```

**Stacking Logic:**
- Weapons with unique hashes → New slot always
- Non-stackable items → New slot
- Stackable items already present → Add to existing quantity
- Stackable items not present → New slot

### Remove Item

```lua
xPlayer.RemoveItem(name, slot, amount)
```

Example:
```lua
-- Remove 1 from stack
xPlayer.RemoveItem("bread", 1, 1)

-- Remove entire stack
local qty = xPlayer.GetItemQuantity("bread")
xPlayer.RemoveItem("bread", slot, qty)
```

### Consume Item

```lua
xPlayer.ConsumeItem(position)
```

Triggers item-specific consumption event:

```lua
xPlayer.ConsumeItem(1)  -- Slot 1
-- Triggers: "Inventory:Consume:bread" event
```

### Rearrange Items

```lua
xPlayer.RearrangeItems(newPosition, oldPosition)
```

Example:
```lua
-- Move item from slot 5 to slot 2
xPlayer.RearrangeItems(2, 5)
```

### Get Full Inventory

```lua
xPlayer.GetInventory()
```

Returns complete inventory table:

```lua
local inv = xPlayer.GetInventory()
for i, item in ipairs(inv) do
    print(i, item.Item, item.Quantity)
end
```

### Set Inventory

```lua
xPlayer.SetInventory(table)
```

**Warning:** Only use after validation:

```lua
local valid, processed = ig.validation.ValidateAndUnpack(source, newInventory)
if valid then
    xPlayer.SetInventory(processed)
end
```

## Item Database (items.json)

### Item Definition Structure

```json
{
    "Name": "Display Name",
    "Weight": 0.5,
    "Cost": 10,
    "Degrade": false,
    "Weapon": false,
    "Quality": 100,
    "Consumeable": true,
    "Hotkey": true,
    "Stackable": true,
    "Materials": false,
    "Recipe": false,
    "Data": {...},
    "Meta": {...}
}
```

### Consumable Example (Food)

```json
"bread": {
    "Name": "Bread",
    "Weight": 0.3,
    "Cost": 2,
    "Degrade": false,
    "Weapon": false,
    "Data": {
        "Status": {
            "Hunger": 20,
            "Stress": -2,
            "Health": 0,
            "Thirst": 0,
            "Armour": 0
        },
        "Modifiers": {
            "Hunger": 3,
            "Stress": 1,
            "Thirst": 0
        }
    },
    "Quality": 100,
    "Consumeable": true,
    "Hotkey": true,
    "Stackable": true,
    "Materials": false,
    "Recipe": false
}
```

### Weapon Example

```json
"WEAPON_PISTOL": {
    "Name": "Pistol",
    "Weight": 1.5,
    "Cost": 500,
    "Weapon": "453432689",
    "Data": {
        "Tints": [...],
        "Components": {...},
        "AmmoType": "AMMO_PISTOL"
    },
    "Meta": {
        "SerialNumber": "",
        "BatchNumber": "",
        "Ammo": "9mm",
        "Components": [],
        "Registered": false,
        "Crafted": false
    },
    "Quality": 100,
    "Stackable": false,
    "Hotkey": true,
    "Degrade": true
}
```

## Item Query Functions

### Check Item Existence

```lua
ig.item.Exists(name)
```

Example:
```lua
if ig.item.Exists("bread") then
    print("Item exists in database")
end
```

### Get Item Data

```lua
ig.item.GetItem(name)
```

Returns full item definition:

```lua
local item = ig.item.GetItem("bread")
print(item.Name, item.Weight, item.Cost)
```

### Item Type Checks

```lua
ig.item.IsWeapon(name)        -- string (hash) or false
ig.item.IsConsumeable(name)   -- boolean
ig.item.CanStack(name)        -- boolean
ig.item.CanHotkey(name)       -- boolean
ig.item.CanDegrade(name)      -- boolean
```

Example:
```lua
if ig.item.IsWeapon("WEAPON_PISTOL") then
    print("This is a weapon with hash:", ig.item.IsWeapon("WEAPON_PISTOL"))
end

if ig.item.CanStack("bread") then
    print("Bread can stack")
end
```

### Get Item Properties

```lua
ig.item.GetWeight(name)           -- number
ig.item.GetValue(name)            -- number (cost)
ig.item.GetLabel(name)            -- string (display name)
ig.item.GetStackSize(name)        -- number (max stack)
ig.item.GetMeta(name)             -- table (metadata)
ig.item.GetData(name)             -- table (data)
ig.item.GetAbout(name)            -- string (description)
ig.item.GetWeaponAmmoType(name)   -- string (ammo type)
```

### Query Items

```lua
ig.item.GetAll()                           -- All items
ig.item.GetWeapons()                       -- All weapons
ig.item.GetConsumables()                   -- All consumables
ig.item.GetCraftable()                     -- All craftable items
ig.item.GetByCategory(category)            -- Items by category
ig.item.GetByWeightRange(min, max)         -- Items in weight range
ig.item.GetByValueRange(min, max)          -- Items in value range
ig.item.Search(pattern)                    -- Items matching pattern
```

Example:
```lua
-- Get all weapons
local weapons = ig.item.GetWeapons()
for name, item in pairs(weapons) do
    print(name, item.Name, item.Weapon)
end

-- Get items by weight
local lightItems = ig.item.GetByWeightRange(0, 1.0)

-- Search items
local breadItems = ig.item.Search("bread")
```

## Inventory Validation

### Validate Single Slot

```lua
ig.validation.ValidateSlot(slot, index)
```

Returns: `(boolean, errorMessage)`

Checks:
- Item exists in database
- Quantity is number (1-999,999)
- Quality is number (0-100)
- Weapon flag consistency
- Weapons cannot stack (qty must be 1)

Example:
```lua
local valid, error = ig.validation.ValidateSlot({
    Item = "bread",
    Quantity = 5,
    Quality = 100,
    Weapon = false
}, 1)

if not valid then
    print("Invalid slot:", error)
end
```

### Validate Full Inventory

```lua
ig.validation.ValidateInventory(inventory)
```

Returns: `(boolean, errorMessage)`

Example:
```lua
local valid, error = ig.validation.ValidateInventory(playerInventory)
if not valid then
    ig.log.Error("INVENTORY", "Validation failed: %s", error)
end
```

### Validate Integrity (Anti-Exploit)

```lua
ig.validation.ValidateInventoryIntegrity(beforeInv1, beforeInv2, afterInv1, afterInv2)
```

**Detects:**
- Item injection (new items appearing)
- Item duplication (quantity increases)
- Invalid quantity changes

Returns: `(boolean, errorMessage)`

Example:
```lua
local serverInv = xPlayer.GetInventory()
local valid, error = ig.validation.ValidateInventoryIntegrity(
    serverInv,  -- Before state
    nil,        -- No second inventory
    clientInv,  -- After state
    nil
)

if not valid then
    ig.validation.LogAndBanExploiter(source, error)
end
```

### Validate and Unpack

```lua
ig.validation.ValidateAndUnpack(source, inventory)
```

Unified validation + processing:
- Validates entire inventory
- Removes items with quality ≤ 0
- Bans exploiters on failure

Returns: `(processed, success, error)`

Example:
```lua
local processed, success, error = ig.validation.ValidateAndUnpack(source, clientInventory)

if success then
    xPlayer.SetInventory(processed)
else
    print("Validation failed:", error)
end
```

## Weight System

### Get Current Weight

```lua
xPlayer.GetWeight()
```

**Note:** Weight counts **unique item types**, not total quantity:

```lua
-- Inventory:
-- 50x bread (0.3 weight each)
-- 1x knife (1.0 weight)
-- Result: Weight = 2 (not 16.0)
```

### Maximum Weight

```lua
xPlayer.MaxWeight = 25  -- Default
```

**Note:** Weight is **not enforced** by default. Implement custom enforcement:

```lua
function xPlayer.AddItemWithWeightCheck(item, qty)
    local newWeight = xPlayer.GetWeight() + 1  -- +1 for new item type
    if newWeight > xPlayer.MaxWeight then
        return false, "Inventory full"
    end
    xPlayer.AddItem({item, qty})
    return true
end
```

## Quality & Degradation

### Quality System

- **Range:** 0-100
- **100:** Perfect condition
- **50:** Half durability
- **0:** Broken/unusable
- **< 0:** Deleted on inventory load

### Degradation

Items with `"Degrade": true` lose quality over time:

```lua
-- In item consumption or usage
local item = xPlayer.GetItemFromPosition(slot)
if ig.item.CanDegrade(item.Item) then
    local newQuality = item.Quality - 5  -- Reduce by 5%
    item.Quality = math.max(0, newQuality)
    xPlayer.IsDirty = true
end
```

### Quality Checks

```lua
local quality, slot = xPlayer.GetItemQuality("WEAPON_PISTOL")

if quality < 20 then
    xPlayer.Notify("Weapon is in poor condition")
elseif quality < 50 then
    xPlayer.Notify("Weapon needs maintenance")
end
```

## Stacking System

### Stackable Items

Items with `"Stackable": true` combine quantities:

```lua
-- Player has 5x bread in slot 1
xPlayer.AddItem({"bread", 3})
-- Result: 8x bread in slot 1 (no new slot)
```

### Non-Stackable Items

Items with `"Stackable": false` take new slots:

```lua
-- Player has skateboard in slot 1
xPlayer.AddItem({"skateboard", 1})
-- Result: New skateboard in slot 2
```

### Weapons (Special Case)

Weapons with unique hashes never stack:

```lua
xPlayer.AddItem({"WEAPON_PISTOL", 1, 100, "453432689"})  -- Slot 1
xPlayer.AddItem({"WEAPON_PISTOL", 1, 100, "987654321"})  -- Slot 2 (different hash)
```

### Stack Size Limits

```lua
ig.item.GetStackSize(name)  -- Returns max stack (default 99 for stackables)
```

Enforce in AddItem logic:

```lua
local maxStack = ig.item.GetStackSize(itemName)
if currentQty + newQty > maxStack then
    -- Split into multiple slots or reject
end
```

## Metadata System

### Common Metadata Fields

**Weapons:**
```lua
Meta = {
    SerialNumber = "ABC123",
    BatchNumber = "20240101",
    Ammo = "9mm",
    Components = {"COMPONENT_PISTOL_CLIP_02", "COMPONENT_AT_PI_SUPP"},
    Registered = false,
    Crafted = false
}
```

**Vehicles (keys):**
```lua
Meta = {
    Plate = "ABC 123",
    Model = "adder",
    Owner = Character_ID
}
```

**Custom Items:**
```lua
Meta = {
    CustomField = "value",
    Timestamp = os.time(),
    Author = playerName
}
```

### Access Metadata

```lua
local item = xPlayer.GetItemFromPosition(slot)
print("Serial:", item.Meta.SerialNumber)
print("Registered:", item.Meta.Registered)
```

### Modify Metadata

```lua
local item = xPlayer.GetItemFromPosition(slot)
item.Meta.SerialNumber = "XYZ789"
item.Meta.Registered = true
xPlayer.IsDirty = true  -- Mark for save
```

## Hotbar System

### Get Hotbar

```lua
xPlayer.GetHotbar()
```

Returns hotbar configuration (typically 1-10 slots):

```lua
local hotbar = xPlayer.GetHotbar()
for i, slotInfo in ipairs(hotbar) do
    print("Hotkey", i, "assigned to slot", slotInfo.slot)
end
```

### Set Hotbar

```lua
xPlayer.SetHotbar(table)
```

Example:
```lua
xPlayer.SetHotbar({
    [1] = {slot = 5},  -- Hotkey 1 = Inventory slot 5
    [2] = {slot = 8},  -- Hotkey 2 = Inventory slot 8
    [3] = {slot = 12}  -- Hotkey 3 = Inventory slot 12
})
```

### Use Hotkey

```lua
ig.callback.RegisterServer("UseItemQuick", function(source, position)
    local xPlayer = ig.data.GetPlayer(source)
    local item = xPlayer.GetItemFromPosition(position)
    
    if item and ig.item.CanHotkey(item.Item) then
        xPlayer.ConsumeItem(position)
        return true
    end
    
    return false
end)
```

## Cash System

### Dual Cash Types

- **Cash:** Dollar bills (whole dollars)
- **Change:** Cents (divided by 100)

### Get Total Cash

```lua
xPlayer.GetCash()
```

Combines both types:

```lua
-- Cash: 50
-- Change: 250 (= $2.50)
-- Total: $52.50
```

### Add Cash

```lua
xPlayer.AddCash(amount)
```

Automatically splits into Cash and Change:

```lua
xPlayer.AddCash(52.75)
-- Cash += 52
-- Change += 75
```

### Remove Cash

```lua
xPlayer.RemoveCash(amount)
```

Handles both types:

```lua
xPlayer.RemoveCash(10.25)
-- Removes from Cash first, then Change
```

## Inventory Callbacks

### Get Inventory

```lua
ig.callback.RegisterServer("Server:Inventory:GetInventory", function(source, entityType, netId)
    -- entityType: "player", "vehicle", "object", "npc"
    -- netId: Network ID of entity
    
    -- Returns inventory based on entity type
end)
```

### Organize Inventory (Single)

```lua
ig.callback.RegisterServer("Server:Inventory:OrganizeInventory", function(source, inv1, cb)
    -- Validates and updates single inventory
    -- Anti-duplication checks
    -- Bans exploiters
end)
```

### Organize Inventories (Transfer)

```lua
ig.callback.RegisterServer("Server:Inventory:OrganizeInventories", function(source, inv1, inv2, cb)
    -- Dual-inventory transfer
    -- Validates against SERVER state (not client snapshot)
    -- Detects race conditions
    -- Prevents item injection
end)
```

### Transfer Item

```lua
ig.callback.RegisterServer("Server:Inventory:TransferInventoryItem", function(source, data, cb)
    -- Live drag-drop transfer
    -- Validates source/destination
    -- Updates StateBags
    -- Notifies nearby players
end)
```

## Consumption Events

### Item Consumption

Items trigger events on use:

```lua
-- Consumables
RegisterNetEvent("Inventory:Consume:bread", function(source, position, quantity)
    local xPlayer = ig.data.GetPlayer(source)
    
    -- Apply effects
    xPlayer.AddHunger(20)
    xPlayer.AddStress(-2)
    
    -- Remove item
    xPlayer.RemoveItem("bread", position, 1)
end)

-- Weapons
RegisterNetEvent("Inventory:Consume:WEAPON_PISTOL", function(source, position, quantity)
    TriggerClientCallback("Client:Item:Weapon", source, position)
end)
```

### Auto-Generated Events

```lua
ig.item.GenerateConsumptionEvents()
```

Creates event for each item based on type:
- Weapons → `Client:Item:Weapon`
- Consumables → `Client:Item:Consumeable`
- Special items → Custom handlers

## Best Practices

1. **Always validate** - Use ig.validation before accepting client data
2. **Check server state** - Use GetInventory(), not cached data
3. **Mark dirty** - Set IsDirty = true after changes
4. **Handle stacking** - Respect Stackable flag and weapon hashes
5. **Validate quality** - Check 0-100 range, remove < 0
6. **Enforce weight** - Implement custom weight checks if needed
7. **Protect metadata** - Validate custom fields
8. **Log exploits** - Ban players attempting duplication/injection
9. **Use callbacks** - Don't trust client inventory state
10. **Test edge cases** - Empty slots, full inventory, concurrent access

## Security Checklist

- ✅ Validate all client inventory data
- ✅ Check server state before accepting changes
- ✅ Detect item injection (new items)
- ✅ Detect duplication (quantity increases)
- ✅ Enforce weapon stacking rules
- ✅ Validate quality range (0-100)
- ✅ Ban exploiters automatically
- ✅ Log all violations
- ✅ Rate limit operations
- ✅ Use dirty flags for saves

## Related Documentation

- [Validation & Security](Validation_Security.md) - Inventory validation details
- [Class System](Class_System.md) - Player entity methods
- [Data Persistence](Data_Persistence.md) - Inventory save system
- [Callback System](Callback_System.md) - Inventory callbacks
