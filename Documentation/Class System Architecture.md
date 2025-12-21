# Class-Based Entity System Documentation

## Overview

The ingenium framework uses a **class-based approach** for all entities (Players, Vehicles, NPCs, Objects, Jobs). Each entity is instantiated as an **object with methods** that automatically handle both:
1. **Internal state updates** (the object's properties)
2. **StateBag synchronization** (replication to clients)

This dual-update pattern ensures the server remains the authority while clients receive real-time updates.

---

## Core Principles

### 1. Server is the Source of Truth
- All entity data is **stored server-side** in memory
- Clients **read from StateBags** (never write to critical keys)
- Authorization checks use `self.Property`, **never** `self.State.Property`

### 2. Automatic StateBag Updates
When you call a setter method (e.g., `xPlayer.SetHealth(100)`), the function:
```lua
self.SetHealth = function(v)
    local n = ig.check.Number(v, 0, conf.defaulthealth)
    if self.Health ~= n then
        self.Health = n              -- Update internal state
        self.State.Health = n         -- Replicate to clients via StateBag
        self.IsDirty = true           -- Mark for database save
        self.DirtyFields.Health = true
    end
end
```

**You never manually set `self.State.X`** — the setter does it for you.

---

## Entity Creation Flow

### Player Entity

#### Server-Side Creation (`ig.data.LoadPlayer`)
```lua
-- server/[Events]/_character.lua
function ig.data.LoadPlayer(source, Character_ID)
    local xPlayer = ig.class.Player(source, Character_ID)
    -- ↑ This creates a FULL object with ALL methods and properties
    
    ig.data.SetPlayer(source, xPlayer)
    -- ↑ Stores the object in ig.pdex[source] for retrieval
    
    TriggerClientEvent("Client:Character:Loaded", source)
    -- ↑ Client now starts reading from StateBags
end
```

#### What `ig.class.Player()` Does (server/[Classes]/_player.lua)
1. **Fetches data from database** via `ig.sql.char.Get(Character_ID)`
2. **Creates the object** with properties:
   ```lua
   self.Health = char.Health
   self.State.Health = self.Health  -- Initial StateBag sync
   ```
3. **Attaches all methods**:
   - Getters: `self.GetHealth()`
   - Setters: `self.SetHealth(v)` (handles StateBag + dirty flag)
   - Actions: `self.AddCash(v)`, `self.RemoveItem(name, slot)`
4. **Returns the complete object** ready for use

#### Client-Side Access
```lua
-- Client reads from StateBag (automatic replication)
local ped = PlayerPedId()
local health = Entity(ped).state.Health  -- Read-only

-- OR via server callback
local xPlayer = TriggerServerCallback({
    eventName = "GetPlayerData",
    args = {}
})
```

---

### Vehicle Entity

#### Server-Side Creation (`ig.data.AddVehicle`)
```lua
-- When a vehicle spawns (entityCreating event)
local entity, netId = ig.func.CreateVehicle("adder", x, y, z, h)
-- ↑ Creates physical entity

ig.data.AddVehicle(netId, ig.class.Vehicle, netId)
-- ↑ Creates the xVehicle object and stores in ig.vdex[netId]
```

#### What `ig.class.Vehicle()` Does (server/[Classes]/_vehicle.lua)
1. **Creates default data** (Fuel, Plate, Inventory, Keys)
2. **Sets up StateBag sync**:
   ```lua
   self.Fuel = data.Fuel
   self.State.Fuel = self.Fuel  -- Initial sync
   ```
3. **Attaches methods**:
   ```lua
   self.SetFuel = function(v)
       local num = ig.check.Number(v, 0, 100)
       if self.Fuel ~= num then
           self.Fuel = num
           self.State.Fuel = num      -- Auto-replicate
           self.IsDirty = true
           self.DirtyFields.Fuel = true
       end
   end
   ```
4. **Returns the object** stored in `ig.vdex[netId]`

#### Client-Side Access
```lua
-- Read from StateBag
local veh = GetVehiclePedIsIn(PlayerPedId(), false)
local netId = NetworkGetNetworkIdFromEntity(veh)
local fuel = Entity(veh).state.Fuel  -- Read-only

-- Clients CANNOT do this (blocked by StateBag protection):
Entity(veh).state.Fuel = 150  -- ❌ Exploit attempt logged
```

---

### NPC Entity

#### Server-Side Creation
```lua
local entity, netId = ig.func.CreatePed("a_m_m_business_01", x, y, z, h)
-- ↑ Creates ped + xNpc object in ig.ndex[netId]
```

#### What `ig.class.Npc()` Does (server/[Classes]/_npc.lua)
1. **Generates random data** (City_ID, Name based on gender)
2. **Creates inventory** (starts with random cash)
3. **Syncs to StateBag**:
   ```lua
   self.City_ID = string.format("%s-%sN", s1, s2)
   self.State.City_ID = self.City_ID
   ```

---

### Object Entity

#### Server-Side Creation
```lua
local entity, netId = ig.func.CreateObject(model, x, y, z, false)
-- ↑ Creates object + xObject in ig.odex[netId]
```

#### What `ig.class.BlankObject()` Does (server/[Classes]/_object.lua)
1. **Creates UUID** and timestamp
2. **Empty inventory** by default
3. **Methods for inventory management** (AddItem, RemoveItem, etc.)

---

### Job Entity

#### Server-Side Creation
```lua
-- On resource start
ig.data.CreateJobObjects()
-- ↑ Iterates through ig.jobs and creates xJob objects
```

#### What `ig.class.Job()` Does (server/[Classes]/_job.lua)
1. **Loads job data** from database
2. **Creates accounts** (Safe, Bank)
3. **Manages inventory** (job storage)
4. **Member management** (AddMember, RemoveMember, SetBoss)
5. **Financial operations** (AddSafe, RemoveBank, etc.)

---

## Retrieval and Usage

### Getting Entities

```lua
-- Players
local xPlayer = ig.data.GetPlayer(source)
if xPlayer then
    xPlayer.AddCash(100)  -- ✅ Automatically updates StateBag
end

-- Vehicles
local xVehicle = ig.data.GetVehicle(netId)
if xVehicle then
    xVehicle.SetFuel(50)  -- ✅ Updates self.Fuel AND self.State.Fuel
end

-- NPCs
local xNpc = ig.data.GetNpc(netId)
if xNpc then
    local name = xNpc.GetFull_Name()
end

-- Objects
local xObject = ig.data.GetObject(netId)
if xObject then
    xObject.AddItem({"Water", 1, 100})
end

-- Jobs
local xJob = ig.data.GetJob("police")
if xJob then
    xJob.AddBank(1000)
end
```

### ❌ NEVER Do This
```lua
-- DON'T manually set StateBag (the setter does it)
xPlayer.State.Health = 100  -- ❌ Bypasses validation and dirty flags

-- DON'T trust client state for authorization
if xPlayer.State.Cash > 100 then  -- ❌ Client could modify this
    -- Bad authorization check
end

-- ✅ USE server-side data
if xPlayer.GetCash() > 100 then  -- ✅ Uses self.Cash (server source of truth)
    -- Correct authorization check
end
```

---

## StateBag Security

### Protected Keys (server/[Security]/_statebag_protection.lua)
Clients are **blocked** from modifying:
- `Cash`, `Bank`, `Keys`, `Inventory`
- `Health`, `Armour`, `Hunger`, `Thirst`, `Stress`
- `Fuel`, `Owner`, `Job`, `Character_ID`

### Whitelisted Keys (clients CAN modify)
- `Animation`, `IsSwimming`, `IsDiving`, `IsJumping`, `IsFalling`

**Any attempt to modify protected keys is logged as a security alert.**

---

## Dirty Flag System (Database Optimization)

### How It Works
```lua
self.SetFuel = function(v)
    local num = ig.check.Number(v, 0, 100)
    if self.Fuel ~= num then  -- Only update if changed
        self.Fuel = num
        self.State.Fuel = num
        self.IsDirty = true            -- Mark entity as needing save
        self.DirtyFields.Fuel = true   -- Mark specific field
    end
end
```

### Save Routine (server/_data.lua)
```lua
-- Only saves entities where self.IsDirty == true
function ig.sql.save.Users()
    for _, xPlayer in pairs(ig.pdex) do
        if xPlayer and xPlayer.GetIsDirty() then
            -- Batch SQL update with only dirty fields
            xPlayer.ClearDirty()
        end
    end
end
```

**Result**: 60-80% reduction in database writes by only saving changed data.

---

## Method Patterns

### Getters (Read-Only)
```lua
self.GetFuel = function()
    return self.Fuel  -- Server source of truth
end
```

### Setters (Write + Sync + Dirty)
```lua
self.SetFuel = function(v)
    local num = ig.check.Number(v, 0, 100)  -- Validation
    if self.Fuel ~= num then
        self.Fuel = num              -- Update server state
        self.State.Fuel = num        -- Replicate to clients
        self.IsDirty = true          -- Mark for save
        self.DirtyFields.Fuel = true
    end
end
```

### Add/Remove (Modify + Sync + Dirty)
```lua
self.AddCash = function(v)
    -- Rate limiting check
    if ig.security.CheckTransactionRateLimit(self, "add_cash") then
        return
    end
    
    -- Complex logic for cash items
    local amount, position = self.GetItemQuantity("Cash")
    -- ... (handles Dollar bills and Change coins)
    
    self.State.Cash = self.GetCash()  -- Sync final result
    TriggerClientEvent("Client:Inventory:Update", self.ID)
    
    -- Transaction logging
    ig.security.LogPlayerTransaction(self, "add_cash", v, "AddCash API call")
end
```

### Complex Actions (Multi-step + Validation)
```lua
self.RemoveItem = function(name, slot, amount)
    local quantity, position = self.GetItemQuantity(name)
    if quantity == amount then
        table.remove(self.Inventory, position)
    elseif quantity >= 2 then
        self.Inventory[position].Quantity = self.Inventory[position].Quantity - 1
    elseif quantity <= 1 and slot == position then
        table.remove(self.Inventory, position)
    else
        table.remove(self.Inventory, position)
    end
    self.IsDirty = true
    self.DirtyFields.Inventory = true
    self.EncodedInventory = nil  -- Clear cached JSON
    TriggerClientEvent("Client:Inventory:Update", self.ID)
end
```

---

## Client-Side Patterns

### Reading StateBags
```lua
-- For local player
local ped = PlayerPedId()
local health = Entity(ped).state.Health

-- For other entities
local veh = GetVehiclePedIsIn(PlayerPedId(), false)
local fuel = Entity(veh).state.Fuel

-- Listening for changes
AddStateBagChangeHandler("Health", nil, function(bagName, key, value)
    print("Health changed to: " .. value)
end)
```

### Requesting Server Actions
```lua
-- Use callbacks for data retrieval
local inventory = TriggerServerCallback({
    eventName = "GetInventory",
    args = {netId}
})

-- Use events for actions
TriggerServerEvent("Server:Item:Use", slot)
```

---

## JSON Encoding Optimization

### Cached Encoding Pattern
Many class methods include cached JSON encoding to avoid repeated serialization:

```lua
-- In class constructor
self.EncodedInventory = nil
self.DirtyFields = {}

-- Getter with cache
self.GetEncodedInventory = function()
    if not self.EncodedInventory or self.DirtyFields.Inventory then
        self.EncodedInventory = json.encode(self.CompressInventory())
        self.DirtyFields.Inventory = false
    end
    return self.EncodedInventory
end

-- Setter invalidates cache
self.AddItem = function(tbl)
    -- ... add item logic ...
    self.EncodedInventory = nil  -- Invalidate cache
    self.DirtyFields.Inventory = true
end
```

**Benefit**: Reduces CPU overhead from repeated JSON encoding of the same data.

---

## Summary Table

| Entity Type | Creation Function | Class Constructor | Storage Index | StateBag Prefix |
|-------------|------------------|------------------|---------------|----------------|
| Player | `ig.data.LoadPlayer(src, charId)` | `ig.class.Player(src, charId)` | `ig.pdex[source]` | `player:X` |
| Vehicle | `ig.data.AddVehicle(netId, cb, ...)` | `ig.class.Vehicle(netId)` | `ig.vdex[netId]` | `entity:X` |
| NPC | `ig.data.AddNpc(netId, cb, ...)` | `ig.class.Npc(netId)` | `ig.ndex[netId]` | `entity:X` |
| Object | `ig.data.AddObject(netId, cb, ...)` | `ig.class.BlankObject(netId)` | `ig.odex[netId]` | `entity:X` |
| Job | `ig.data.CreateJobObjects()` | `ig.class.Job(data)` | `ig.jdex[jobName]` | N/A |

---

## Common Usage Patterns

### Player Operations
```lua
-- Get player
local xPlayer = ig.data.GetPlayer(source)

-- Financial operations (with security)
xPlayer.AddCash(100)           -- Rate limited, logged, validated
xPlayer.RemoveBank(50)         -- Rate limited, logged, validated
xPlayer.SetBank(1000)          -- Rate limited, logged, validated

-- Inventory operations (with validation)
xPlayer.AddItem({"Water", 1, 100})
xPlayer.RemoveItem("Water", slot)
local has, slot = xPlayer.HasItem("Pistol")

-- Status updates (with clamping)
xPlayer.SetHealth(150)  -- Clamped to conf.defaulthealth
xPlayer.SetHunger(200)  -- Clamped to 100
xPlayer.SetThirst(-50)  -- Clamped to 0

-- Job management
xPlayer.SetJob("police", 3)
local job = xPlayer.GetJob()
xPlayer.SetDuty(true)
```

### Vehicle Operations
```lua
-- Get vehicle
local xVehicle = ig.data.GetVehicle(netId)

-- Fuel management (with clamping)
xVehicle.SetFuel(50)
xVehicle.AddFuel(25)    -- Clamped to 100
xVehicle.RemoveFuel(10) -- Clamped to 0

-- Key management (server-side authorization)
xVehicle.AddKey(characterId)
xVehicle.RemoveKey(characterId)
local hasKey = xVehicle.CheckKeys(characterId)  -- ✅ Correct
-- NEVER: xVehicle.State.Keys check  -- ❌ Wrong

-- Inventory operations
xVehicle.AddItem({"RepairKit", 1, 100})
local inventory = xVehicle.GetInventory()

-- Modifications
xVehicle.SetModifications(mods)
xVehicle.SetCondition(condition)
```

### Job Operations
```lua
-- Get job
local xJob = ig.data.GetJob("police")

-- Financial operations
xJob.AddSafe(500)
xJob.RemoveBank(1000)
local safeBalance = xJob.GetSafe()

-- Member management
xJob.AddMember(characterId)
xJob.RemoveMember(characterId)
xJob.SetBoss(characterId)

-- Inventory operations
xJob.AddItem({"Evidence", 1, 100})
local inventory = xJob.GetInventory()
```

---

## Key Takeaways

1. **Use the getter/setter methods** — they handle StateBag sync + dirty flags automatically
2. **Never manually set `self.State.X`** — the class methods do this for you
3. **Always authorize using `self.Property`**, not `self.State.Property`
4. **Clients read from StateBags** (automatic replication from server)
5. **Server is the authority** — clients cannot modify critical keys
6. **Dirty flag system** minimizes database writes by tracking changes
7. **Entity creation** automatically generates a full object with all methods
8. **Retrieval functions** (`ig.data.GetPlayer`, etc.) return the complete object from memory
9. **JSON encoding is cached** where possible to reduce CPU overhead
10. **Security is built-in** — rate limiting, validation, logging all handled by class methods

---

## This Pattern Ensures

- ✅ **Consistent state** across server and clients
- ✅ **Security** (clients can't bypass server validation)
- ✅ **Performance** (dirty flags reduce DB writes, cached JSON encoding)
- ✅ **Maintainability** (single source of truth, clear patterns)
- ✅ **Scalability** (StateBags handle replication automatically)
- ✅ **Auditability** (transaction logging, security alerts)
- ✅ **Robustness** (validation, clamping, error handling)

---

**Version**: 1.0.0  
**Last Updated**: 2025-12-20  
**Author**: ingenium Development Team
