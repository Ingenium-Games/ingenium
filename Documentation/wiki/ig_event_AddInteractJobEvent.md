# ig.event.AddInteractJobEvent

## Description

Registers server-side interaction events that are bound to job-based ACL permissions. This function creates events that can only be triggered by players who have the appropriate job permissions, providing a secure way to handle job-specific interactions without relying on client-side validation alone.

The function automatically sets up ACE permissions for the specified job(s), ensuring that only authorized players can trigger the associated network events. Permissions are applied at the character level when a player selects a character, and persist across character switches for the same user account.

This is particularly useful for actions that have significant server-side implications, such as arrests, escorts, or other job-restricted interactions, where you want to ensure the server validates permissions before executing the callback logic.

## Signature

```lua
function ig.event.AddInteractJobEvent(job, name, cb)
```

## Parameters

- **`job`**: `string` or `table` - Job name(s) used for role permissions. Can be a single job as a string (e.g., `"police"`) or an array of job names (e.g., `{"police", "sheriff"}`). The function will create ACE permissions for each job in the array.
- **`name`**: `string` - The event identifier that will be used to create the network event name (`Server:Interact:{name}`)
- **`cb`**: `function` - The callback function to execute when the event is triggered. Receives `(source, options)` where `source` is the player server ID and `options` is the data passed from the client.

## Returns

- **`string`**: The registered event name (`Server:Interact:{name}`), or `false` if invalid job parameter type is provided.

## Use Case

This function is designed for job-specific server interactions that require permission validation before execution. Unlike regular events, these are protected by ACE permissions that are:

1. **Database-driven**: Permissions are tied to the user's account and applied when characters are loaded
2. **Character-specific**: Each character gets job-specific ACL settings upon selection
3. **Persistent**: Permissions remain active across character switches for the same user
4. **Secure**: Server validates permissions before allowing callback execution

Common use cases include:
- Law enforcement actions (arrest, search, impound)
- Medical interactions (revive, treat)
- Emergency services (tow, repair)
- Administrative actions (ban, kick, moderate)

## Examples

### Single Job Example

```lua
-- Register arrest event for police
ig.event.AddInteractJobEvent("police", "Arrest", function(source, options)
    local src = source
    local targetNetId = options.net
    
    local xPlayer = ig.data.GetPlayer(src)
    local targetEntity = NetworkGetEntityFromNetworkId(targetNetId)
    
    if IsPedAPlayer(targetEntity) then
        local targetPlayerId = NetworkGetEntityOwner(targetEntity)
        local xTarget = ig.data.GetPlayer(targetPlayerId)
        
        -- Toggle cuff status
        local isCuffed = xTarget.GetCuffed()
        xTarget.SetCuffed(not isCuffed)
        
        -- Notify client of the action
        exports["ingenium"]:TriggerClientCallback({
            eventName = "Client:Interact:Arrest", 
            source = src, 
            args = {not isCuffed, targetNetId, true}
        })
    end
end)
```

### Multiple Jobs Example

```lua
-- Register escort event for multiple law enforcement jobs
ig.event.AddInteractJobEvent({"police", "sheriff"}, "Escort", function(source, options)
    local src = source
    local targetNetId = options.net
    
    local xPlayer = ig.data.GetPlayer(src)
    local targetEntity = NetworkGetEntityFromNetworkId(targetNetId)
    
    if IsPedAPlayer(targetEntity) then
        local targetPlayerId = NetworkGetEntityOwner(targetEntity)
        local xTarget = ig.data.GetPlayer(targetPlayerId)
        
        -- Toggle escort status
        local isEscorted = xTarget.GetEscorted()
        if isEscorted then
            xPlayer.SetEscorting(false)
            xTarget.SetEscorted(false)
        else
            xPlayer.SetEscorting(targetPlayerId)
            xTarget.SetEscorted(src)
        end
        
        -- Notify client
        exports["ingenium"]:TriggerClientCallback({
            eventName = "Client:Interact:Escort", 
            source = src, 
            args = {not isEscorted, targetPlayerId, true}
        })
    end
end)
```

### Error Handling

```lua
-- Invalid job type returns false
local result = ig.event.AddInteractJobEvent(123, "Test", function() end)
if not result then
    print("Invalid job parameter - must be string or table")
end
```

## Source

Defined in: `server/_events.lua`
