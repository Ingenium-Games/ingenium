# Code Review - Stage 1A: Shared Code Patterns

**Status**: IN PROGRESS  
**Date**: 2024  
**Scope**: Identifying shared patterns, core utilities, and common code structures

---

## I. Core Shared Framework

### 1. **Global Instance (`ig`)**
**Location**: [shared/_ig.lua](../shared/_ig.lua)

```lua
ig = {}  -- Global instance container
exports("GetIngenium", function() return ig end)
exports("GetLocale", function() return conf.locale end)
```

**Purpose**: Central namespace for all Ingenium framework functions  
**Used By**: Both client and server can access via `local ig = exports[conf.resourcename]:GetIngenium()`  
**Exports**:
- `GetIngenium()` - Returns the global `ig` object
- `GetLocale()` - Returns current locale from config

---

### 2. **Locale System (`_L`)**
**Location**: [shared/_locale.lua](../shared/_locale.lua)

```lua
function _L(key, ...)
    -- Locale lookup with fallback to English
    -- Format: _L("key.name", arg1, arg2)
    -- Capitalizes first character
end
exports("_L", _L)
```

**Pattern**: String localization with UTF-8 awareness  
**Usage**: Text strings in menus, notifications, chat  
**Key Features**:
- Fallback to English if translation missing
- String formatting support
- First-character capitalization
- Returns key name if translation not found (safe fallback)

---

### 3. **Callback System (TriggerServerCallback)**
**Location**: [shared/[Third Party]/_callbacks.lua](../shared/[Third%20Party]/_callbacks.lua)

#### Server-Side Callback Handler
```lua
-- SERVER: Defines callback event listener
RegisterNetEvent("Server:Callback:eventName", function(packed, src, cb)
    local args = msgpack_unpack(packed)
    -- Handle callback with security validation
    cb(result)  -- Sends response back to client
end)

-- SERVER exports
exports("TriggerServerCallback", TriggerServerCallback)
```

#### Client-Side Callback Invoker
```lua
-- CLIENT: Calls server with callback
TriggerServerCallback({
    eventName = "eventName",
    args = {arg1, arg2},
    source = GetPlayerServerId(PlayerId()),
    callback = function(result)
        -- Receives server response
    end
})
```

**Key Security Features**:
- Ticket validation system (30-second expiration by default)
- Rate limiting (configurable, default: 100 req/sec)
- Source validation (GetInvokingResource checks)
- Message packing/unpacking (msgpack for efficiency)

**Configuration** (in _config/defaults.lua):
```lua
conf.callback = {
    ticketValidity = 30000,        -- Ticket valid for 30 seconds
    ticketLength = 20,              -- Random ticket string length
    rateLimitEnabled = true,        -- Enable request rate limiting
    maxRequestsPerSecond = 100,    -- Max requests per second per client
    rateLimitWindow = 1000         -- Rate limit window in milliseconds
}
```

---

## II. Event Naming Convention

### **Directional Naming System**

All events follow a strict naming pattern to indicate direction and source:

#### Pattern 1: `Client:System:Event`
- **Triggered By**: Server via `TriggerClientEvent` or Server callback
- **Handled By**: Client `RegisterNetEvent`
- **Example**: `Client:Banking:OpenMenu` - Server tells client to open banking menu

#### Pattern 2: `Server:System:Event`
- **Triggered By**: Client via `TriggerServerEvent` or `TriggerServerCallback`
- **Handled By**: Server `RegisterNetEvent`
- **Example**: `Server:Bank:Deposit` - Client requests server to deposit money

#### Pattern 3: `Client:NUI:Event` / `NUI:Client:Event`
- **Triggered By**: NUI (Vue/JavaScript) with `post` method
- **Handled By**: Client `RegisterNUICallback`
- **Example**: `NUI:Client:InventorySelect` - NUI sends item selection to client

#### Pattern 4: `Server:Callback:EventName`
- **Triggered By**: Client with `TriggerServerCallback`
- **Handled By**: Server with callback handler
- **Used For**: Request-response patterns (client waits for answer)

---

## III. Common Client Patterns

### 1. **NUI Communication Bridge**
**Location**: [nui/src/utils/nui.js](../nui/src/utils/nui.js)

```javascript
// Client sends to NUI
const SendMessage = (message, data, focus = false) => {
    window.postMessage({
        type: "NUI_ACTION",
        payload: { type: message, ...data }
    }, "*");
}

// NUI sends to Client
post(action, data, focus) {
    fetch(`https://${GetResourceName()}/YOUR_ACTION`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
    })
}
```

**Pattern**: HTTP POST method for NUI→Client communication  
**Used By**: All Vue components (Inventory, Banking, Menu, HUD)

### 2. **Position Persistence**
**Across Files**: inventory.lua, hud.lua, Vue components

```lua
-- Save position to localStorage
local function SavePosition(key, x, y)
    SendNUIMessage({ type = "SavePosition", key = key, data = { x = x, y = y } })
end

-- Load position from localStorage
local function LoadPosition(key)
    SendNUIMessage({ type = "LoadPosition", key = key })
end
```

**Locations Persisted**:
- Inventory position (nui/lua/inventory.lua)
- HUD position (nui/lua/hud.lua)
- All draggable menus (Banking, Menu, Garage)

---

## IV. Common Server Patterns

### 1. **Secure Callback Handling**
**Pattern Across Files**: _banking.lua, _appearance.lua, _vehicle.lua, etc.

```lua
RegisterNetEvent("Server:System:CallbackName")
AddEventHandler("Server:System:CallbackName", function(packed, source, cb)
    -- 1. Validate source
    if source ~= source then return end
    
    -- 2. Unpack client arguments safely
    local args = msgpack.unpack(packed)
    
    -- 3. Validate input
    if not args or not args.playerId then
        return cb(false, "Invalid input")
    end
    
    -- 4. Perform operation
    local result = PerformOperation(args)
    
    -- 5. Send response back to client
    cb(result)
end)
```

**Security Layers**:
- Source validation
- Input validation
- Callback response verification
- Rate limiting per client

### 2. **Player Data Management**
**Pattern Across Files**: _character.lua, _appearance.lua, _banking.lua

```lua
-- Player object structure
Players[playerId] = {
    id = playerId,
    name = playerName,
    job = jobName,
    balance = bankBalance,
    inventory = {...},
    -- ... other properties
}

-- Update tracking for client sync
TriggerClientEvent("Client:Data:Updated", playerId, key, value)
```

### 3. **Configuration-Driven Features**
**Location**: _config/defaults.lua

```lua
conf = {
    resourcename = "ingenium",
    
    inventory = {
        openKey = "I",
        maxSlots = 50,
        maxWeight = 100
    },
    
    banking = {
        enabled = true,
        maxWithdrawal = 10000
    },
    
    vehicles = {
        enabled = true,
        respawnDelay = 300
    }
    -- ... more configs
}
```

**Pattern**: All feature flags and limits configured here  
**Access**: Both client and server read via `conf.*`

---

## V. Common Utility Patterns

### 1. **Random Number Generation**
**Used For**: Ticket generation, item distribution, random events  
**Implementation**: `ig.rng.chars(length)` - Alphanumeric random string

### 2. **String Formatting**
**Used For**: Chat messages, notifications, error messages  
**Function**: `string.format()` with locale system (`_L()`)

### 3. **Table Utilities**
**Common Patterns**:
- `table.insert()` - Add to inventory
- `table.remove()` - Remove from inventory
- Iteration with `pairs()` and `ipairs()`
- Deep copying for state management

### 4. **Timer Management**
**Pattern**: `SetTimeout()` and coroutines for async operations

```lua
Citizen.CreateThread(function()
    while true do
        Wait(100)  -- Check every 100ms
        -- Process something
    end
end)
```

---

## VI. Security Patterns Across Codebase

### 1. **Source Validation**
```lua
local source = source  -- Client's server ID
if source ~= source then return end  -- Verify source matches
```

### 2. **Resource Name Validation**
```lua
if GetInvokingResource() ~= conf.resourcename then
    return error("Unauthorized resource")
end
```

### 3. **Input Sanitization**
```lua
-- Validate types
if type(args) ~= "table" then return end
if not tonumber(amount) then return end
```

### 4. **Rate Limiting** (Server-side)
```lua
if rateLimitConfig.enabled then
    local requestCount = requestCounts[source] or 0
    if requestCount > rateLimitConfig.maxRequestsPerSecond then
        return cb(false, "Rate limited")
    end
end
```

---

## VII. File Organization Summary

### Shared Files (Both Client & Server Access)
```
shared/
├── _ig.lua                    -- Core global instance
├── _locale.lua                -- Localization system
└── [Third Party]/_callbacks.lua -- Request-response callbacks
```

### Client Files (231 Total)
```
client/
├── _functions.lua             -- Core utility functions
├── _var.lua                   -- Global client variables
├── _data.lua                  -- Local player data cache
├── [System Files]/_*.lua      -- Feature implementations
└── [Subdirectories]/          -- Organized by feature
    ├── [Banking]/
    ├── [Inventory]/
    ├── [Garage]/
    ├── [Commands]/
    ├── [Events]/
    ├── [Callbacks]/
    └── ... 10+ more
```

### Server Files
```
server/
├── _functions.lua             -- Core server utilities
├── _character.lua             -- Player character management
├── [System Files]/_*.lua      -- Feature implementations
└── [Subdirectories]/          -- Organized by feature
    ├── [Banking]/
    ├── [Inventory]/
    ├── [Jobs]/
    └── ... more
```

### NUI Files
```
nui/lua/
├── _c.lua                     -- Main NUI handler
├── hud.lua                    -- HUD system (195 lines, NEW)
├── ui.lua                     -- UI system exports
├── inventory.lua              -- Inventory system
├── notification.lua           -- Notification system
├── chat.lua                   -- Chat system
├── character-select.lua       -- Character select screen
├── examples.lua               -- Usage examples
└── [Other lua files]          -- Various implementations
```

---

## VIII. Configuration System Overview

**File**: [_config/defaults.lua](../_config/defaults.lua)

**Sections** (14+ configuration categories):

1. **Control Mapping**
   ```lua
   conf.inventory.openKey = "I"
   conf.hud.focusToggleKey = "F2"
   conf.banking.openKey = "E"
   ```

2. **Feature Flags**
   ```lua
   conf.banking.enabled = true
   conf.inventory.enabled = true
   conf.vehicles.enabled = true
   ```

3. **Limits & Constraints**
   ```lua
   conf.inventory.maxSlots = 50
   conf.banking.maxWithdrawal = 10000
   conf.vehicles.respawnDelay = 300
   ```

4. **Callback Configuration**
   ```lua
   conf.callback.ticketValidity = 30000
   conf.callback.rateLimitEnabled = true
   conf.callback.maxRequestsPerSecond = 100
   ```

5. **Locale Settings**
   ```lua
   conf.locale = "en"  -- English
   -- Supports: en, es, fr, de, pt, etc.
   ```

---

## IX. Next Steps (Stages 1B-1C)

### Stage 1B: Systematic Client Code Review
- Review each client file following the patterns identified here
- Check for:
  - Proper event naming convention
  - Secure callback usage
  - Configuration references
  - NUI communication correctness

### Stage 1C: Add Comments & JSDoc
- Add comprehensive comments to all client code
- Document function signatures
- Explain business logic
- Note server-side calls for cross-reference

### Stage 2A-2B: Server Code Review & Comments
- Repeat client process for server files
- Verify security (GetInvokingResource checks)
- Document data models
- Add LuaDoc comments

### Stage 3A-3B: Extract APIs & Create Wiki
- List all `exports()` calls
- Identify public vs internal APIs
- Filter exposed events (no GetInvoking check)
- Create wiki pages for each public API

---

## X. Summary Statistics

| Metric | Count |
|--------|-------|
| Total Lua Files | 231 |
| Shared Pattern Files | 3 |
| Exports Found | 72+ |
| Event Naming Pattern Types | 4 |
| Configuration Categories | 14+ |
| Security Validation Types | 4 |
| Core Shared Functions | 5+ |

---

**STAGE 1A COMPLETE** - Ready for Stage 1B: Client Code Systematic Review
