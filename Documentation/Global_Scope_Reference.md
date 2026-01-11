# Global Scope Reference

This document provides a comprehensive overview of all global variables in the Ingenium framework codebase. These are variables that exist in the global scope and are accessible across the entire codebase.

## Purpose

Understanding the global scope is important for:
- Avoiding naming conflicts
- Understanding framework architecture
- Proper code organization
- Debugging and maintenance

## Core Framework Globals

### `conf`
**Defined in:** `_config/config.lua`  
**Scope:** Shared (Client + Server)  
**Purpose:** Central configuration object containing all framework settings

**Key Configuration Categories:**
```lua
conf = {
    -- Time constants
    sec, min, hour, day
    
    -- Debug settings
    error, debug_1, debug_2, debug_3
    
    -- Core settings
    mapname, gamemode, locale, ace, identifier
    
    -- Sync intervals
    clientsync, charactersync, serversync, playersync, revivesync,
    vehiclesync, jobsync, objectsync, cleanup
    
    -- Spawn configuration
    spawn = {x, y, z, h}
    
    -- Instance/routing
    instancedefault
    
    -- Banking
    startingloan, bankoverdraw, loanpayment, loaninterest
    
    -- Player stats
    hungertime, thirsttime
    
    -- NUI sync
    nui = {sync}
    
    -- Time adjustment
    altertime
    
    -- Job system
    enablejobpayroll, enablejobcenter, enableduty, paycycle
    
    -- Callback security
    callback = {
        ticketValidity, ticketLength, rateLimitEnabled,
        maxRequestsPerSecond, rateLimitWindow,
        cleanupInterval, staleThreshold
    }
    
    -- Drop system
    drops = {
        cleanup_enabled, cleanup_time,
        default_model, active_timeout
    }
    
    -- Weapon thread timings
    weapon = {
        ammoSyncInterval,  -- Time between ammo syncs to server
        shotCooldown,      -- Wait after shot to avoid double-counting
        reloadDuration     -- Wait during reload animation
    }
    
    -- RP thread timings
    rp = {
        idleCameraInterval,   -- Idle camera check interval
        npcWeaponInterval,    -- NPC weapon drop check interval
        controlIdleInterval   -- Control state idle check interval
    }
    
    -- Chat system configuration
    chat = {
        logging = {
            enabled, logToFile, logDirectory, logToTxAdmin,
            logMessages, logCommands,
            includeCoordinates, includeIdentifiers,
            maxLogDays
        },
        messageSettings = {
            maxLength, allowEmptyMessages, filterProfanity
        }
    }
    
    -- Screenshot system configuration
    screenshot = {
        enabled, quality, encoding,
        outputs = {
            discord = {enabled, webhook, username, avatar_url},
            imageHost = {enabled, url, headers},
            discourse = {enabled, url, apiKey, apiUsername, categoryId}
        },
        autoScreenshot = {
            onReport, onError, onDeath, onBan
        },
        includeMetadata = {
            playerName, playerIdentifiers, coordinates,
            gameTime, vehicleInfo, nearbyPlayers
        }
    }
    
    -- System
    consolechannel, lock
}
```

**Usage:**
- Configuration values should be read from `conf` throughout the codebase
- Modify values in `_config/config.lua` or related config files
- Do not modify `conf` at runtime; it's a read-only configuration

---

### `ig`
**Defined in:** `shared/_ig.lua` (initialized), extended across codebase  
**Scope:** Shared (Client + Server)  
**Purpose:** Main framework object containing all Ingenium functions, classes, and data

**Note:** Internal structure details are documented separately in the wiki pages. This object serves as the primary namespace for the framework.

**High-Level Structure:**
```lua
ig = {
    -- Time constants (from conf)
    sec, min, hour, day, locale, imagehost
    
    -- GLM math library (if available)
    glm
    
    -- Core systems (examples, see wiki for full list)
    callback,  -- Callback wrapper system
    weapon,    -- Weapon management
    queue,     -- Queue system interface
    data,      -- Data management
    func,      -- Utility functions
    fx,        -- Visual effects
    game,      -- Game mode utilities
    rng,       -- Random number generation
    
    -- State variables (examples)
    _loaded,      -- (Client) Player loaded state
    _character,   -- (Client) Current character data
    _running,     -- (Server) Server running state
    _loading,     -- (Server) Loading state
    _dataloaded,  -- (Server) Data loaded state
    
    -- Additional modules documented in wiki
}
```

**Branches:** See individual wiki pages for detailed documentation of each `ig.*` module.

---

## Callback System Globals

**Defined in:** `shared/[Third Party]/_callbacks.lua`  
**Scope:** Shared (Client + Server)  
**Purpose:** Global callback functions for client-server communication

### Global Callback Functions

#### `TriggerServerCallback(args)`
**Scope:** Client  
**Purpose:** Trigger a server callback and optionally wait for response

**Parameters:**
```lua
{
    eventName = "string",      -- Name of the callback
    args = {...},              -- Arguments to pass
    timeout = number,          -- Optional timeout in seconds
    callback = function,       -- Optional async callback
    timedout = function        -- Optional timeout handler
}
```

**Usage:**
```lua
-- Synchronous (await)
local result = TriggerServerCallback({
    eventName = "GetPlayerData",
    args = {playerId}
})

-- Asynchronous
TriggerServerCallback({
    eventName = "GetPlayerData",
    args = {playerId},
    callback = function(data)
        print(data)
    end
})
```

---

#### `RegisterServerCallback(args)`
**Scope:** Server  
**Purpose:** Register a callback handler on the server

**Parameters:**
```lua
{
    eventName = "string",           -- Name of the callback
    eventCallback = function        -- Handler function(source, ...)
}
```

**Usage:**
```lua
RegisterServerCallback({
    eventName = "GetPlayerData",
    eventCallback = function(source, playerId)
        return GetPlayerDataFromDB(playerId)
    end
})
```

---

#### `TriggerClientCallback(args)`
**Scope:** Client  
**Purpose:** Trigger a local client callback (not networked)

**Parameters:** Same structure as `TriggerServerCallback`

---

#### `RegisterClientCallback(args)`
**Scope:** Client  
**Purpose:** Register a local client callback handler

**Parameters:** Same structure as `RegisterServerCallback`

---

#### `UnregisterServerCallback(eventData)`
**Scope:** Server  
**Purpose:** Unregister a server callback handler

---

#### `UnregisterClientCallback(eventData)`
**Scope:** Client  
**Purpose:** Unregister a client callback handler

---

## Queue System Globals

**Defined in:** `server/[Third Party]/_queue_config.lua` and `_queue_connect.lua`  
**Scope:** Server only  
**Purpose:** Player connection queue system

### `QConfig`
**Type:** Table  
**Purpose:** Queue configuration object

**Structure:**
```lua
QConfig = {
    Priority = {},              -- Priority list (identifier -> power)
    RequireSteam = false,       -- Require Steam to connect
    PriorityOnly = false,       -- Whitelist-only mode
    DisableHardCap = true,      -- Disable hardcap resource
    ConnectTimeOut = 600,       -- Connection timeout (seconds)
    QueueTimeOut = 90,          -- Queue timeout (seconds)
    EnableGrace = true,         -- Grace period for reconnects
    GracePower = 2,             -- Grace priority power
    GraceTime = 480,            -- Grace period duration (seconds)
    JoinDelay = 30000,          -- Delay before allowing joins (ms)
    ShowTemp = false,           -- Show temp priority count
    Language = {}               -- Localization strings
}
```

---

### `Queue`
**Type:** Table  
**Purpose:** Queue system API and state

**Public API:**
```lua
Queue = {
    -- State
    Ready = false,
    Exports = nil,
    MaxPlayers = 48,
    Debug = false,
    DisplayQueue = true,
    
    -- Methods
    OnReady(callback),
    OnJoin(callback),
    AddPriority(id, power, temp),
    RemovePriority(id),
    IsReady(),
    
    -- Internal methods (see _queue_connect.lua for full list)
}
```

**ig.queue Interface:**
```lua
ig.queue = {
    Join(source, name, setKickReason, deferrals)
}
```

---

## Zone System Globals (Third-Party)

**Defined in:** `client/[Zones]/*.lua`  
**Scope:** Client only  
**Purpose:** Third-party PolyZone integration for area detection

### `PolyZone`
**File:** `client/[Zones]/PolyZone.lua`  
**Purpose:** Main PolyZone library for polygon-based zones

### `BoxZone`
**File:** `client/[Zones]/BoxZone.lua`  
**Purpose:** Box-shaped zone definitions

### `CircleZone`
**File:** `client/[Zones]/CircleZone.lua`  
**Purpose:** Circular zone definitions

### `EntityZone`
**File:** `client/[Zones]/EntityZone.lua`  
**Purpose:** Entity-attached zone definitions

### `ComboZone`
**File:** `client/[Zones]/ComboZone.lua`  
**Purpose:** Combination of multiple zones

**Note:** These are third-party libraries integrated into the framework. See PolyZone documentation for usage details. Framework provides wrapper through `ig.zone` documented separately.

---

## Additional Context-Specific Globals

### Garage System
**Files:** `client/[Garage]/_*.lua`  
**Scope:** Client only  
**Defined globals:** (within garage system context)

```lua
-- These are module-specific and should ideally be localized
-- Listed here for awareness:
AtMachine       -- Boolean: player near machine
OpenMachine     -- Boolean: menu is open
UseMachine      -- Boolean: animation playing
MachinePosition -- Vector3: current machine position
VehicleBlip     -- Blip handle: spawned vehicle blip
VehicleData     -- Table: current vehicle data
TicketMachine   -- Hash: parking machine prop
```

**Note:** These globals are specific to the garage system and may be candidates for future refactoring into the `ig.garage` namespace.

---

## Third-Party Library Globals

### `Locales`
**File:** Various locale files  
**Scope:** Shared  
**Purpose:** Localization strings table

### `math` (GLM override)
**File:** Client side GLM import  
**Scope:** Client  
**Purpose:** Enhanced math library with vector/matrix operations (when glm is available)

---

## Best Practices

### DO:
✅ Use `conf` for all configuration values  
✅ Use `ig` namespace for framework functions  
✅ Use callback globals for client-server communication  
✅ Access Queue system through `Queue` API  
✅ Check `if conf.gamemode == "RP"` before using RP-specific features  

### DON'T:
❌ Create new global variables without team discussion  
❌ Modify `conf` at runtime  
❌ Override third-party globals (PolyZone, etc.)  
❌ Directly access internal `_Queue` table (use Queue API)  
❌ Pollute global scope with temporary variables

---

## Global Scope Hygiene

To maintain clean global scope:

1. **Always use `local` for temporary variables**
   ```lua
   local myVar = 123  -- Good
   myVar = 123        -- Bad (creates global)
   ```

2. **Namespace your module globals under `ig`**
   ```lua
   ig.myModule = {}   -- Good
   MyModule = {}      -- Bad (creates global)
   ```

3. **Check for existing globals before defining**
   ```lua
   ig = ig or {}      -- Good (preserves existing)
   ig = {}            -- Bad (overwrites existing)
   ```

4. **Document any new globals in this file**

---

## Configuration Variables

Variables that should be in `conf` rather than hardcoded:

### Timing Values
- ✅ Weapon ammo sync interval (`conf.weapon.ammoSyncInterval`)
- ✅ Weapon shot cooldown (`conf.weapon.shotCooldown`)
- ✅ Weapon reload duration (`conf.weapon.reloadDuration`)
- ✅ RP idle camera interval (`conf.rp.idleCameraInterval`)
- ✅ RP NPC weapon check interval (`conf.rp.npcWeaponInterval`)
- ✅ RP control idle check interval (`conf.rp.controlIdleInterval`)

### Sync Intervals
- ✅ Client sync (`conf.clientsync`)
- ✅ Character sync (`conf.charactersync`)
- ✅ Server sync (`conf.serversync`)
- ✅ Player sync (`conf.playersync`)
- ✅ Vehicle sync (`conf.vehiclesync`)
- ✅ Job sync (`conf.jobsync`)
- ✅ Object sync (`conf.objectsync`)

### System Timeouts
- ✅ Callback ticket validity (`conf.callback.ticketValidity`)
- ✅ Rate limit window (`conf.callback.rateLimitWindow`)
- ✅ Cleanup intervals (`conf.callback.cleanupInterval`)

---

## Summary

**Primary Globals:**
- `conf` - Configuration (read-only)
- `ig` - Framework namespace (see wiki)
- `TriggerServerCallback`, `RegisterServerCallback`, etc. - Callback system
- `Queue`, `QConfig` - Queue system (server)
- `PolyZone`, `BoxZone`, `CircleZone`, `EntityZone`, `ComboZone` - Zone system (client)

**Best Practice:** Keep global scope minimal. Use `local` for everything else. Extend `ig` namespace for new modules.

---

**Last Updated:** 2026-01-10  
**Maintained By:** Ingenium Development Team
