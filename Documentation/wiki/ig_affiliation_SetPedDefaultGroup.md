# ig.affiliation.SetPedDefaultGroup

Sets the default group that a ped is perceived as. This affects how NPCs interact with the ped when relationships between the ped's group and other groups are not explicitly set.

## Syntax

```lua
local success = ig.affiliation.SetPedDefaultGroup(ped, groupName)
```

## Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `ped` | number | The ped entity handle |
| `groupName` | string | Name of the group to set as default |

## Return Value

`boolean` - True if default group was set successfully, false otherwise

## Examples

### Set player default group
```lua
local player = PlayerPedId()
ig.affiliation.SetPedDefaultGroup(player, "PLAYER")
```

### Set civilian default
```lua
local npc = CreatePed(4, GetHashKey("a_m_m_business_1"), 0, 0, 0, 0, false, false)
ig.affiliation.SetPedDefaultGroup(npc, "CIVMALE")
```

## Difference from SetPedGroup

| Function | Purpose |
|----------|---------|
| SetPedGroup | Assigns ped to a specific group |
| SetPedDefaultGroup | Sets how ped is perceived by default |

## Notes

- Used to define the ped's default perception category
- Complements [SetPedGroup](ig_affiliation_SetPedGroup.md) for more nuanced behavior
- Important for NPC AI decision-making

## Related Functions

- [SetPedGroup](ig_affiliation_SetPedGroup.md) - Assign ped to group
- [GroupExists](ig_affiliation_GroupExists.md) - Check if group exists
