# State Bag Management Best Practices

## Overview

In the ingenium framework, **state bags** are the mechanism for synchronizing entity data from server to clients. This document outlines best practices for managing state bag updates to ensure data consistency, security, and performance.

## Core Principle: Use Class Methods, Not Direct Assignment

**❌ NEVER directly assign state bags in server-side business logic:**
```lua
-- WRONG - Direct state bag assignment bypasses validation
xObject.State.Inventory = some_inventory
xVehicle.State.Fuel = 50
xPlayer.State.Cash = 1000
```

**✅ ALWAYS use class methods to update entity state:**
```lua
-- CORRECT - Methods handle both internal state AND state bag sync
xObject.AddItem({"Water", 1, 100})
xVehicle.SetFuel(50)
xPlayer.AddCash(1000)
```

## Why This Matters

### 1. **Validation and Security**
Class methods include:
- Input validation (type checking, range clamping)
- Security checks (rate limiting, transaction logging)
- Business logic enforcement

Direct state bag assignment bypasses all of these protections.

### 2. **Dirty Flag Tracking**
Methods mark entities as "dirty" for database persistence:
```lua
self.SetFuel = function(v)
    -- Validation
    local num = ig.check.Number(v, 0, 100)
    if self.Fuel ~= num then
        self.Fuel = num              -- Internal state
        self.State.Fuel = num         -- State bag sync
        self.IsDirty = true           -- Mark for database save
        self.DirtyFields.Fuel = true  -- Track specific field
    end
end
```

Without dirty flags, changes might not be saved to the database.

### 3. **Consistency**
Methods ensure internal state and state bag stay in sync:
```lua
-- Method keeps self.Fuel and self.State.Fuel synchronized
xVehicle.SetFuel(75)

// Client can now reliably read
local fuel = Entity(veh).state.Fuel  -- Always matches server
```

Direct assignment can create inconsistencies between `self.Property` and `self.State.Property`.

### 4. **Maintainability**
Centralizing state updates in methods means:
- Single source of truth for state changes
- Easier to add logging, hooks, or validations later
- Clear API for other developers

---

## Entity Creation Functions

The framework provides helper functions to create entities with properly initialized classes:

### Object Creation

**Function:** `ig.func.CreateObject(model, x, y, z, isdoor, data)`

**Parameters:**
- `model` (string|number): Model name or hash
- `x, y, z` (number): World coordinates
- `isdoor` (boolean): Whether this is a door object
- `data` (table|nil): Optional existing object data

**Returns:** `entity, netId`

**Behavior:**
1. Creates physical entity in world
2. Generates network ID
3. Creates class instance (`BlankObject` or `ExistingObject`)
4. Stores in `ig.odex[netId]`
5. All state bags are initialized via class constructor

**Example:**
```lua
-- Create new object (uses BlankObject class)
local entity, netId = ig.func.CreateObject("prop_box_wood01a", x, y, z, false)
local xObject = ig.data.GetObject(netId)

-- Add items - state bag is automatically synced
xObject.AddItem({"Water", 5, 100})
xObject.AddItem({"Bandage", 2, 100})
```

### Vehicle Creation

**Function:** `ig.func.CreateVehicle(name, x, y, z, h, data)`

**Parameters:**
- `name` (string|number): Vehicle model name or hash
- `x, y, z, h` (number): World coordinates and heading
- `data` (table|nil): Optional existing vehicle data

**Returns:** `entity, netId`

**Behavior:**
1. Creates physical vehicle
2. Creates class instance (`Vehicle` or `OwnedVehicle`)
3. Stores in `ig.vdex[netId]`
4. Initializes inventory, fuel, keys, modifications
5. All state bags synced via class methods

**Example:**
```lua
-- Create unowned vehicle
local entity, netId = ig.func.CreateVehicle("adder", x, y, z, h)
local xVehicle = ig.data.GetVehicle(netId)

-- Modify vehicle state - methods handle state bag sync
xVehicle.SetFuel(50)
xVehicle.AddKey(characterId)
xVehicle.AddItem({"RepairKit", 1, 100})
```

### Ped/NPC Creation

**Function:** `ig.func.CreatePed(name, x, y, z, h)`

**Parameters:**
- `name` (string|number): Ped model name or hash
- `x, y, z, h` (number): World coordinates and heading

**Returns:** `entity, netId`

**Behavior:**
1. Creates physical ped
2. Creates `Npc` class instance
3. Stores in `ig.ndex[netId]`
4. Generates random name, City_ID
5. Initializes inventory with random cash

**Example:**
```lua
local entity, netId = ig.func.CreatePed("a_m_m_business_01", x, y, z, h)
local xNpc = ig.data.GetNpc(netId)

-- Interact with NPC inventory
xNpc.AddItem({"ID_Card", 1, 100})
local inventory = xNpc.GetInventory()
```

---

## Class Methods That Update State Bags

### Object Class (`ig.class.BlankObject` / `ig.class.ExistingObject`)

#### Inventory Methods

**`AddItem(table)`**
- Adds item to inventory
- Handles weapon/stackable logic
- **Automatically syncs state bag**
```lua
xObject.AddItem({"item_name", quantity, quality, weapon, meta, name})
-- self.State.Inventory is updated internally
```

**`RemoveItem(name, slot)`**
- Removes item from inventory
- Handles quantity reduction
- **Automatically syncs state bag**
```lua
xObject.RemoveItem("Water", 1)
-- self.State.Inventory is updated internally
```

**`RearrangeItems(new, old)`**
- Reorders inventory slots
- **Automatically syncs state bag**
```lua
xObject.RearrangeItems(5, 2)
-- self.State.Inventory is updated internally
```

**`UnpackInventory(inv)`**
- Initializes inventory from database/compressed format
- Validates all items
- **Syncs state bag**
```lua
xObject.UnpackInventory(saved_inventory)
-- self.State.Inventory is set
```

**`SyncInventory()`**
- Manual sync method for explicit control
- **Rarely needed** - use only if modifying `self.Inventory` directly (not recommended)
- Prefer using `AddItem`, `RemoveItem`, `RearrangeItems` which auto-sync
```lua
-- Only use if you must modify inventory directly (not recommended)
xObject.Inventory[1].Quantity = 5
xObject.SyncInventory()  // Explicit sync

// Better approach - use class methods that auto-sync:
xObject.RemoveItem(item_name, 1)
xObject.AddItem({item_name, 5, quality, weapon, meta})
```

#### Coordinate Methods

**`SetCoords(coords)`**
- Updates entity position
- Syncs coordinates to state bag
```lua
xObject.SetCoords({x = 100.0, y = 200.0, z = 30.0, h = 90.0, rx = 0.0, ry = 0.0, rz = 0.0})
```

---

### Vehicle Class (`ig.class.Vehicle` / `ig.class.OwnedVehicle`)

#### Fuel Methods

**`SetFuel(v)`**
- Sets fuel level (0-100)
- Validates and clamps value
- **Syncs state bag**
```lua
xVehicle.SetFuel(75)
```

**`AddFuel(v)`**
- Adds fuel (clamped to 100)
- **Syncs state bag**
```lua
xVehicle.AddFuel(25)
```

**`RemoveFuel(v)`**
- Removes fuel (clamped to 0)
- **Syncs state bag**
```lua
xVehicle.RemoveFuel(10)
```

#### Key Management

**`SetKeys(t)`**
- Replaces entire keys table
- **Syncs state bag**
```lua
xVehicle.SetKeys({char1_id, char2_id})
```

**`AddKey(id)`**
- Adds character to key holders
- **Syncs state bag**
```lua
xVehicle.AddKey(characterId)
```

**`RemoveKey(id)`**
- Removes character from key holders
- **Syncs state bag**
```lua
xVehicle.RemoveKey(characterId)
```

#### Modification Methods

**`SetModifications(modifications)`**
- Sets vehicle modifications
- **Syncs state bag**
```lua
xVehicle.SetModifications(modTable)
```

**`SetCondition(conditions)`**
- Sets vehicle condition/damage
- **Syncs state bag**
```lua
xVehicle.SetCondition(conditionTable)
```

#### Inventory Methods

Vehicle classes inherit the same inventory methods as objects:
- `AddItem(table)` - Syncs state bag
- `RemoveItem(name, slot)` - Syncs state bag
- `RearrangeItems(new, old)` - Syncs state bag
- `UnpackInventory(inv)` - Syncs state bag

---

### NPC Class (`ig.class.Npc`)

#### State Methods

**`SetCuffed(b)`**
- Sets cuffed state
- **Syncs state bag**
```lua
xNpc.SetCuffed(true)
```

**`SetEscorted(v)`**
- Sets escorted state
- **Syncs state bag**
```lua
xNpc.SetEscorted(player_ped)
```

**`SetEscorting(v)`**
- Sets escorting state
- **Syncs state bag**
```lua
xNpc.SetEscorting(other_ped)
```

#### Inventory Methods

NPC classes use the same inventory methods as objects:
- `AddItem(table)` - Syncs state bag
- `RemoveItem(name, slot)` - Syncs state bag
- `RearrangeItems(new, old)` - Syncs state bag
- `UnpackInventory(inv)` - Syncs state bag

---

## Common Patterns

### Pattern 1: Single Item Operation
```lua
-- Get entity
local xObject = ig.data.GetObject(netId)

-- Perform operation - state bag synced automatically
xObject.AddItem({"Water", 1, 100})
```

### Pattern 2: Batch Operations
```lua
local xObject = ig.data.GetObject(netId)

-- Multiple operations
for _, item in ipairs(item_list) do
    xObject.AddItem(item)  -- Each call syncs state bag
end

-- State bag is kept up-to-date with each AddItem call
```

### Pattern 3: Creation with Inventory
```lua
-- Create object
local entity, netId = ig.func.CreateObject("prop_box_wood01a", x, y, z, false)
local xObject = ig.data.GetObject(netId)

-- Populate inventory - each call syncs state
xObject.AddItem({"Water", 5, 100})
xObject.AddItem({"Bandage", 2, 100})
xObject.AddItem({"Cash", 500, 100})

-- No manual state bag sync needed!
```

### Pattern 4: Using Existing Data
```lua
-- Load from database
local data = {
    Model = "prop_box_wood01a",
    UUID = "some-uuid",
    Coords = '{"x":100,"y":200,"z":30}',
    Inventory = '[["Water",5,100,false,{},"Water"]]',
    Created = "1234567890",
    Updated = "1234567890"
}

-- Create with existing data
local entity, netId = ig.func.CreateObject("prop_box_wood01a", x, y, z, false, data)
local xObject = ig.data.GetObject(netId)

-- UnpackInventory was called during class construction
-- State bag already synchronized
```

---

## Anti-Patterns to Avoid

### ❌ Anti-Pattern 1: Direct State Assignment After Method Calls
```lua
-- WRONG - Redundant and bypasses validation
xObject.AddItem({"Water", 1, 100})
xObject.State.Inventory = xObject.GetInventory()  // Redundant!
```

**Why it's wrong:** `AddItem` already updates the state bag. The second line is unnecessary and can cause timing issues.

**Correct approach:**
```lua
xObject.AddItem({"Water", 1, 100})
// That's it - state bag is already synced
```

### ❌ Anti-Pattern 2: Direct State Modification
```lua
-- WRONG - Bypasses all validation and dirty flags
xVehicle.State.Fuel = 150  // Can exceed max!
```

**Why it's wrong:** 
- No validation (fuel can exceed 100)
- No dirty flag set (won't save to database)
- Not rate-limited (potential exploit)

**Correct approach:**
```lua
xVehicle.SetFuel(150)  // Clamped to 100, validated, dirty flag set
```

### ❌ Anti-Pattern 3: Manual Inventory Manipulation
```lua
-- WRONG - Direct table manipulation without sync
xObject.Inventory[1].Quantity = 10
```

**Why it's wrong:**
- State bag not updated (clients see old value)
- No dirty flag (won't save)
- No validation

**Correct approach:**
```lua
-- Remove old item
xObject.RemoveItem(item_name, 1)
-- Add new quantity
xObject.AddItem({item_name, 10, quality, weapon, meta})
```

### ❌ Anti-Pattern 4: Creating Entity Without Class
```lua
-- WRONG - Raw entity without class methods
local entity = CreateObject(hash, x, y, z, true, false)
local netId = NetworkGetNetworkIdFromEntity(entity)
// No class, no methods, no state bag management!
```

**Why it's wrong:**
- No inventory management
- No state bag synchronization
- No persistence to database

**Correct approach:**
```lua
local entity, netId = ig.func.CreateObject(model, x, y, z, false)
local xObject = ig.data.GetObject(netId)
// Full class with all methods and state bag sync
```

---

## Client-Side Reading

Clients read from state bags (never write to protected keys):

```lua
-- Client-side: Read-only access
local veh = GetVehiclePedIsIn(PlayerPedId(), false)
local fuel = Entity(veh).state.Fuel
local inventory = Entity(veh).state.Inventory

-- Listen for changes
AddStateBagChangeHandler("Fuel", nil, function(bagName, key, value)
    print("Fuel updated to: " .. tostring(value))
end)
```

**Protected Keys** (clients cannot modify):
- Cash, Bank, Keys, Inventory
- Health, Armour, Hunger, Thirst, Stress
- Fuel, Owner, Job, Character_ID

See `server/[Security]/_statebag_protection.lua` for full list.

---

## Summary: The Golden Rules

1. **Use class methods** - Never directly assign state bags in business logic
2. **Methods sync automatically** - AddItem, SetFuel, SetKeys, etc. handle state bags
3. **Trust the class** - Creation functions initialize state bags correctly
4. **Avoid redundancy** - Don't manually sync after method calls
5. **Read the docs** - Each class documents which methods update state

**When in doubt:** If you're about to write `self.State.X = Y` or `xObject.State.X = Y` in server-side code, ask yourself: "Is there a class method that should handle this instead?"

The answer is almost always **yes**.

---

## Related Documentation

- [Class System Architecture](./Class%20System%20Architecture.md) - Comprehensive overview of the class system
- [Security Guide](./Security_Guide.md) - State bag protection and security measures
- [Validation Architecture](./Validation_Architecture.md) - Input validation patterns

---

**Version**: 1.0.0  
**Last Updated**: 2026-01-01  
**Author**: Ingenium Development Team
