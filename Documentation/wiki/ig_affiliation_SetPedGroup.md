# ig.affiliation.SetPedGroup

Assigns a ped (NPC or player) to a specific relationship group. This determines how other groups perceive and interact with the ped.

## Syntax

```lua
local success = ig.affiliation.SetPedGroup(ped, groupName)
```

## Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `ped` | number | The ped entity handle |
| `groupName` | string | Name of the group to assign to (uppercase) |

## Return Value

`boolean` - True if ped was assigned successfully, false otherwise

## Examples

### Assign player to PLAYER group
```lua
local player = PlayerPedId()
ig.affiliation.SetPedGroup(player, "PLAYER")
```

### Assign NPC to police group
```lua
local cop = GetNearbyPed()
ig.affiliation.SetPedGroup(cop, "POLICE")
```

### Assign spawned gang member to gang group
```lua
local modelHash = GetHashKey("a_m_m_business_1")
RequestModel(modelHash)
while not HasModelLoaded(modelHash) do
    Wait(0)
end

local ped = CreatePed(4, modelHash, 0, 0, 0, 0, false, false)
ig.affiliation.SetPedGroup(ped, "GANG_1")
```

### Assign multiple peds to groups
```lua
local peds = {
    {handle = CreatePed(...), group = "POLICE"},
    {handle = CreatePed(...), group = "MEDIC"},
    {handle = CreatePed(...), group = "GANG_1"},
}

for _, entry in ipairs(peds) do
    ig.affiliation.SetPedGroup(entry.handle, entry.group)
end
```

## Common Groups

| Group | Usage |
|-------|--------|
| POLICE | Law enforcement |
| MEDIC | Medical personnel |
| PLAYER | Player character |
| GANG_1 - GANG_10 | Criminal factions |
| CIVMALE | Male civilians |
| CIVFEMALE | Female civilians |
| SECURITY_GUARD | Security forces |

## Important Notes

- **Assign immediately after spawning** - Do this before the ped interacts with others
- **Group must exist** - Use existing groups or create new ones
- **Affects all interactions** - Group assignment changes how NPCs react to the ped
- **Valid only while ped exists** - Assignment is lost when ped is deleted

## Related Functions

- [SetPedDefaultGroup](ig_affiliation_SetPedDefaultGroup.md) - Set default group perception
- [GroupExists](ig_affiliation_GroupExists.md) - Check if group exists
- [CreateGroup](ig_affiliation_CreateGroup.md) - Create new relationship group
