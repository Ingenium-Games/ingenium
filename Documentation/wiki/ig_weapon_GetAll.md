# ig.weapon.GetAll

## Description

Retrieves all weapon data from the cache or server. Calls the provided callback function with the weapon data. Uses cached data if available, otherwise fetches from server.

## Signature

```lua
function ig.weapon.GetAll(callback)
```

## Parameters

- **`callback`**: function - Callback function that receives the weapon data

## Example

```lua
-- Get all weapons with callback
ig.weapon.GetAll(function(weapons)
    print("Loaded weapons:", #weapons)
    for _, weapon in ipairs(weapons) do
        print("Weapon:", weapon.name, weapon.hash)
    end
end)

-- Use in async context
ig.weapon.GetAll(function(data)
    if data then
        -- Process weapon data
        print("Total weapons:", #data)
    end
end)
```

## Source

Defined in: `client/[Data]/_game_data_helpers.lua`
