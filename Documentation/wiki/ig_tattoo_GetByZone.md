# ig.tattoo.GetByZone

## Description

Returns all tattoos available for a specific body zone. Tattoos are organized by zones such as head, torso, arms, and legs. This function filters the tattoo collection to return only those applicable to the requested zone.

## Signature

```lua
function ig.tattoo.GetByZone(zone)
```

## Parameters

- **`zone`**: string - Body zone name (e.g., "ZONE_HEAD", "ZONE_TORSO", "ZONE_LEFT_ARM", "ZONE_RIGHT_ARM", "ZONE_LEFT_LEG", "ZONE_RIGHT_LEG")

## Returns

- **`table`** - Array of tattoo data tables for the specified zone (empty array if none found)

## Example

```lua
-- Get all head tattoos
local headTattoos = ig.tattoo.GetByZone("ZONE_HEAD")
print("Found " .. #headTattoos .. " head tattoos")

for _, tattoo in ipairs(headTattoos) do
    print(string.format("- %s (Hash: %s)", tattoo.label, tattoo.hash))
end

-- Get torso tattoos
local torsoTattoos = ig.tattoo.GetByZone("ZONE_TORSO")
```

## Related Functions

- [ig.tattoo.GetAll](ig_tattoo_GetAll.md) - Get all tattoos
- [ig.tattoo.GetByHash](ig_tattoo_GetByHash.md) - Get specific tattoo by hash
- [ig.tattoo.GetByCollection](ig_tattoo_GetByCollection.md) - Get tattoos by collection
- [ig.appearance.ApplyTattoo](ig_appearance_ApplyTattoo.md) - Apply tattoo to character

## Source

Defined in: `server/[Data - No Save Needed]/_tattoo.lua`
