# Callback & Event System

## Overview

Ingenium uses a **bidirectional callback system** with promises, timeouts, and security tickets for secure client-server communication. The system supports async/await patterns and automatic cleanup.

## Callback Registration

### Server-Side Registration

```lua
ig.callback.RegisterServer(eventName, handler)
```

Registers server-side callback handlers:

```lua
ig.callback.RegisterServer("Server:Bank:Open", function(source)
    local xPlayer = ig.data.GetPlayer(source)
    
    return {
        balance = xPlayer.GetBank(),
        transactions = xPlayer.GetTransactions()
    }
end)
```

### Client-Side Registration

```lua
ig.callback.RegisterClient(eventName, handler)
```

Registers client-side callback handlers:

```lua
ig.callback.RegisterClient("Client:GetVehicleData", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    
    return {
        model = GetEntityModel(vehicle),
        plate = GetVehicleNumberPlateText(vehicle)
    }
end)
```

### Unregister Callbacks

```lua
-- Unregister server callback
ig.callback.UnregisterServer(eventName)

-- Unregister client callback
ig.callback.UnregisterClient(eventName)
```

## Async/Await Patterns

### Synchronous Await

Blocks execution until response received:

```lua
-- Client calls server (blocking)
local data = ig.callback.Await('Server:GetPlayerData')
print('Player name:', data.name)

-- Server calls client (blocking)
local vehicleData = ig.callback.AwaitClient(source, 'Client:GetVehicleData')
print('Vehicle plate:', vehicleData.plate)
```

### Asynchronous Callback

Non-blocking with callback:

```lua
-- Client calls server (non-blocking)
ig.callback.Async('Server:GetPlayerData', function(data)
    print('Received data:', json.encode(data))
end)

-- Server calls client (non-blocking)
ig.callback.AsyncClient(source, 'Client:GetVehicleData', function(data)
    print('Vehicle data:', json.encode(data))
end)
```

### Async with Timeout

```lua
ig.callback.AsyncWithTimeout(
    'Server:SlowOperation',
    5,  -- Timeout in seconds
    function(result)
        print('Success:', json.encode(result))
    end,
    function(state)
        print('Timed out, state:', state)
    end,
    arg1, arg2  -- Optional arguments
)
```

### Promise-Based Architecture

Uses Lua promises for async flow control:

```lua
local promise = promise.new()

ig.callback.Async('Server:GetData', function(data)
    promise:resolve(data)
end)

local result = Citizen.Await(promise)
```

**Promise States:**
- `PENDING` (0) - Awaiting result
- `RESOLVING` (1) - Resolving promise
- `REJECTING` (2) - Rejecting promise
- `RESOLVED` (3) - Successfully resolved
- `REJECTED` (4) - Failed/timed out

## Timeout Handling

### Timeout Configuration

```lua
-- Specify timeout in seconds
ig.callback.AsyncWithTimeout(
    'Server:SlowOperation',
    10,  -- 10 second timeout
    successCallback,
    timeoutCallback
)
```

### Timeout Flow

```
1. Client sends request with timeout parameter
2. Server sets SetTimeout(timeout * 1000)
3. If promise not resolved by deadline:
   - Call timedout(state) callback
   - Reject promise if still pending
   - Remove event handler
   - Cleanup ticket
4. Auto-cleanup expired tickets
```

### Automatic Cleanup

```lua
-- Configuration
conf.callback = {
    ticketValidity = 30000,      -- 30 seconds
    cleanupInterval = 60000      -- Clean every 60 seconds
}
```

Expired tickets automatically removed to prevent memory leaks.

## Security System

### Ticket Generation

```lua
-- Generate secure ticket (20+ chars)
local ticket = ig.rng.chars(20)
```

### Ticket Validation

```lua
-- Validate source + ticket match
if not ValidateTicket(source, ticket) then
    return {error = "Invalid ticket"}
end
```

### Security Features

- **One-time use** - Tickets expire after use
- **Source validation** - Ticket bound to player source
- **Time-limited** - 30 second expiration
- **Cryptographic** - Random string generation

## Rate Limiting

### Configuration

```lua
conf.callback = {
    rateLimitEnabled = true,
    maxRequestsPerSecond = 10,
    rateLimitWindow = 1000  -- 1 second window
}
```

### Rate Limit Check

```lua
if IsRateLimited(source) then
    return {state = "rate_limited"}
end
```

Prevents spam/abuse by limiting requests per player.

## Character Lifecycle Events

### Character Selection

```lua
-- List available characters
ig.callback.RegisterServer("Server:Character:List", function(source)
    local license = ig.func.identifier(source)
    local chars = ig.sql.character.FetchByLicense(license)
    
    return {
        characters = chars,
        slots = conf.characterSlots
    }
end)
```

### Character Join

```lua
-- Select existing character
ig.callback.RegisterServer("Server:Character:Join", function(source, charId)
    -- Load character data
    local xPlayer = ig.data.LoadPlayer(source, charId)
    
    -- Trigger client load
    TriggerClientEvent('Client:Character:Loaded', source, xPlayer.GetAll())
    
    return {success = true}
end)
```

### Character Creation

```lua
-- Create new character
ig.callback.RegisterServer("Server:Character:Register", function(source, data)
    local license = ig.func.identifier(source)
    
    -- Validate input
    local firstName = ig.check.String(data.firstName, 1, 50)
    local lastName = ig.check.String(data.lastName, 1, 50)
    local gender = ig.check.String(data.gender, 4, 6)
    
    -- Create character
    local charId = ig.sql.character.Create({
        License_ID = license,
        First_Name = firstName,
        Last_Name = lastName,
        Gender = gender
    })
    
    -- Load character
    ig.data.LoadPlayer(source, charId)
    
    return {success = true, characterId = charId}
end)
```

### Character Ready

```lua
-- Final initialization
RegisterNetEvent('Server:Character:Ready', function()
    local source = source
    local xPlayer = ig.data.GetPlayer(source)
    
    -- Set ped config flags
    SetPedConfigFlag(GetPlayerPed(source), 35, false)  -- Can't be arrested
    SetPedConfigFlag(GetPlayerPed(source), 62, false)  -- Can't use fire extinguisher
    
    -- Update routing bucket
    SetPlayerRoutingBucket(source, 0)
    
    -- Re-assign ACL permissions
    ExecuteCommand(('add_principal player.%s group.user'):format(xPlayer.License_ID))
    
    -- Spawn persistent vehicles (first time only)
    if not xPlayer.HasSpawnedVehicles then
        ig.vehicle.LoadPersistentVehicles(xPlayer.Character_ID)
        xPlayer.HasSpawnedVehicles = true
    end
end)
```

## Character Lifecycle Flow

```
┌─ playerConnecting ───────────────────────────┐
│  └─ Validate license, add to index          │
│                                              │
├─ NUI: Character Select Screen               │
│  └─ SendNuiMessage("character:list")        │
│                                              │
├─ Server:Character:List (Callback)           │
│  ├─ Get player slots from database          │
│  ├─ Fetch available characters              │
│  └─ Place player in isolated instance       │
│                                              │
├─ Player Selects/Creates Character           │
│  │                                           │
│  ├─ NEW: Server:Character:Register          │
│  │   ├─ Create character + bank account     │
│  │   ├─ Generate IBAN, give phone           │
│  │   └─ ig.data.LoadPlayer()                │
│  │                                           │
│  └─ EXISTING: Server:Character:Join         │
│      └─ ig.data.LoadPlayer()                │
│          └─ Client:Character:Loaded         │
│                                              │
├─ Client:Character:Loaded (Client)           │
│  ├─ Spawn ped at coordinates                │
│  ├─ Apply appearance via SetAppearance      │
│  ├─ Wait for StateBag sync (5s timeout)     │
│  ├─ Initialize all systems:                 │
│  │  ├─ ig.data.SetLoadedStatus(true)        │
│  │  ├─ ig.chat.AddSuggestions()             │
│  │  ├─ ig.skill.SetSkills()                 │
│  │  └─ ig.status.SetPlayer()                │
│  └─ TriggerServerEvent("Ready")             │
│                                              │
├─ Server:Character:Ready (Final Init)        │
│  ├─ Set ped config flags                    │
│  ├─ Update routing bucket                   │
│  ├─ Re-assign ACL permissions               │
│  ├─ Trigger state sync (cash, bank)         │
│  └─ Spawn persistent vehicles (if first)    │
│                                              │
└─ ✓ CHARACTER FULLY LOADED AND READY ────────┘
```

## Vehicle Events

### Player Entered Vehicle

```lua
RegisterNetEvent('Server:Vehicle:PlayerEntered', function(vehicle, seat)
    local source = source
    local xPlayer = ig.data.GetPlayer(source)
    
    local plate = GetVehicleNumberPlateText(vehicle)
    local xVehicle = ig.vdex[NetworkGetNetworkIdFromEntity(vehicle)]
    
    if xVehicle then
        xVehicle.SetDriver(source)
    end
end)
```

### Player Left Vehicle

```lua
RegisterNetEvent('Server:Vehicle:PlayerLeft', function(vehicle, seat)
    local source = source
    local xPlayer = ig.data.GetPlayer(source)
    
    local xVehicle = ig.vdex[NetworkGetNetworkIdFromEntity(vehicle)]
    
    if xVehicle then
        xVehicle.SetDriver(nil)
        
        -- Save vehicle state
        ig.sql.save.Vehicle(xVehicle)
    end
end)
```

### Vehicle Persistence

```lua
-- Register condition on enter
RegisterNetEvent('Server:VehiclePersistence:RegisterCondition', function(netId)
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    local plate = GetVehicleNumberPlateText(vehicle)
    
    -- Store initial condition
    ig.vehicle.UpdateVehicleState(plate, {
        fuel = GetVehicleFuelLevel(vehicle),
        bodyHealth = GetVehicleBodyHealth(vehicle),
        engineHealth = GetVehicleEngineHealth(vehicle)
    })
end)

-- Update condition on exit
RegisterNetEvent('Server:VehiclePersistence:UpdateCondition', function(netId, condition)
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    local plate = GetVehicleNumberPlateText(vehicle)
    
    -- Update stored condition
    ig.vehicle.UpdateVehicleState(plate, condition)
    
    -- Mark vehicle dirty for save
    local xVehicle = ig.vehicle.GetVehicleByPlate(plate)
    if xVehicle then
        xVehicle.IsDirty = true
    end
end)
```

## Banking Events

### Open Banking Menu

```lua
ig.callback.RegisterServer("Server:Bank:Open", function(source)
    local xPlayer = ig.data.GetPlayer(source)
    
    return {
        account = xPlayer.GetIban(),
        balance = xPlayer.GetBank(),
        transactions = ig.sql.banking.GetTransactions(xPlayer.GetIban(), 20),
        favorites = ig.sql.banking.GetFavorites(xPlayer.GetIban())
    }
end)
```

### Transfer Money

```lua
ig.callback.RegisterServer("Server:Bank:Transfer", function(source, data)
    local xPlayer = ig.data.GetPlayer(source)
    
    -- Validate inputs
    local targetIban = ig.check.String(data.iban, 15, 34)
    local amount = ig.check.Number(data.amount, 1, xPlayer.GetBank())
    local reason = ig.check.String(data.reason, 0, 100)
    
    -- Check sufficient funds
    if xPlayer.GetBank() < amount then
        return {success = false, error = 'Insufficient funds'}
    end
    
    -- Execute transfer (transaction)
    local queries = {
        {query = "UPDATE banking_accounts SET Balance = Balance - ? WHERE Account_Number = ?", params = {amount, xPlayer.GetIban()}},
        {query = "UPDATE banking_accounts SET Balance = Balance + ? WHERE Account_Number = ?", params = {amount, targetIban}},
        {query = "INSERT INTO transactions (From_Account, To_Account, Amount, Reason) VALUES (?, ?, ?, ?)", params = {xPlayer.GetIban(), targetIban, amount, reason}}
    }
    
    ig.sql.Transaction(queries, function(success)
        if success then
            xPlayer.RemoveBank(amount)
            -- Notify target if online
        end
    end)
    
    return {success = true}
end)
```

## Client Events

### Character Loaded

```lua
RegisterNetEvent('Client:Character:Loaded', function(characterData)
    -- Spawn ped
    local model = GetHashKey(characterData.Model or 'mp_m_freemode_01')
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    
    local ped = PlayerPedId()
    SetPlayerModel(PlayerId(), model)
    SetModelAsNoLongerNeeded(model)
    
    -- Apply appearance
    ig.appearance.SetAppearance(characterData.Appearance)
    
    -- Wait for StateBag sync
    local timeout = GetGameTimer() + 5000
    while not Entity(ped).state.Character_ID and GetGameTimer() < timeout do
        Wait(100)
    end
    
    -- Initialize systems
    ig.data.SetLoadedStatus(true)
    ig.chat.AddSuggestions()
    ig.skill.SetSkills(characterData.Skills)
    ig.status.SetPlayer(characterData.Stats)
    
    -- Notify server ready
    TriggerServerEvent('Server:Character:Ready')
end)
```

### Character Switch

```lua
RegisterNetEvent('Client:Character:Switch', function()
    -- Cleanup current character
    ig.data.SetLoadedStatus(false)
    
    -- Clear UI
    SendNUIMessage({message = 'hud:hide'})
    
    -- Reset camera
    RenderScriptCams(false, false, 0, true, true)
    
    -- Freeze player
    FreezeEntityPosition(PlayerPedId(), true)
end)
```

## Event Best Practices

1. **Use callbacks for responses** - RegisterCallback for data requests
2. **Use net events for notifications** - TriggerEvent for one-way messages
3. **Validate all inputs** - Use ig.check.* on client data
4. **Check entity exists** - Verify player/vehicle not nil
5. **Handle timeouts** - Use AsyncWithTimeout for slow operations
6. **Clean up handlers** - Unregister callbacks when done
7. **Security tickets** - Automatic for callbacks
8. **Rate limit** - Enable rate limiting in config
9. **Promise chains** - Use promises for async sequences
10. **Log errors** - Catch and log callback failures

## Configuration

```lua
-- _config/config.lua
conf.callback = {
    -- Timeout settings
    ticketValidity = 30000,      -- 30 seconds
    cleanupInterval = 60000,     -- Clean every 60 seconds
    
    -- Rate limiting
    rateLimitEnabled = true,
    maxRequestsPerSecond = 10,
    rateLimitWindow = 1000,
    
    -- Security
    requireTicket = true,
    logCallbacks = false
}
```

## Related Documentation

- [NUI Architecture](NUI_Architecture.md) - NUI callback integration
- [Validation & Security](Validation_Security.md) - Input validation
- [Class System](Class_System.md) - Entity lifecycle events
