# ig.death.PlayerKilled

## Description

Handles player death events. Detects the cause of death (weapon, vehicle, object, or unknown), logs attacker information, broadcasts the death event, and triggers server callback for secure reporting and respawn positioning.

## Signature

```lua
function ig.death.PlayerKilled()
```

## Parameters

None

## Returns

None

## Behavior

- Detects death cause and attacker entity
- Logs attacker name and weapon information
- Broadcasts `ig:client:death:PlayerKilled` event
- Triggers server callback for death processing and respawn

## Example

```lua
-- This function is typically called automatically by the death system
-- Manual invocation is not recommended
AddEventHandler('gameEventTriggered', function(name, args)
    if name == 'CEventNetworkEntityDamage' then
        local victim = args[1]
        if victim == PlayerPedId() and IsEntityDead(victim) then
            ig.death.PlayerKilled()
        end
    end
end)
```

## Source

Defined in: `client/_death.lua`
