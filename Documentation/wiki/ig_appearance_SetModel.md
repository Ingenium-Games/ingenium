# ig.appearance.SetModel

## Description

Changes the player ped model. Use with callback to ensure model is loaded before applying appearance customization. Commonly used with freemode models for character creation.

## Signature

```lua
function ig.appearance.SetModel(model, callback)
```

## Parameters

- **`model`**: string|number Ped model name or hash
- **`callback`**: function|nil Optional callback when model is loaded

## Example

```lua
-- Example 1: Set player to male freemode model
ig.appearance.SetModel("mp_m_freemode_01", function()
    print("Model changed successfully")
    -- Apply appearance after model change
end)

-- Example 2: Set player to female freemode model
ig.appearance.SetModel("mp_f_freemode_01", function()
    -- Now safe to set appearance data
    ig.appearance.SetComponents(components)
end)

-- Example 3: Set player to specific ped model
ig.appearance.SetModel("a_m_y_business_01", function()
    print("Changed to business ped")
end)

-- Example 4: Using with model hash
local modelHash = GetHashKey("s_f_y_cop_01")
ig.appearance.SetModel(modelHash, function()
    print("Model set via hash")
end)
```

## Important Notes

> 📋 **Parameter**: `callback` - Function to execute upon completion

## Related Functions

- [ig.appearance.ApplyAppearanceData](ig_appearance_ApplyAppearanceData.md)
- [ig.appearance.ApplyTattoo](ig_appearance_ApplyTattoo.md)
- [ig.appearance.ApplyTattoos](ig_appearance_ApplyTattoos.md)
- [ig.appearance.ClearTattoos](ig_appearance_ClearTattoos.md)
- [ig.appearance.CreateCamera](ig_appearance_CreateCamera.md)

## Source

Defined in: `client/_appearance.lua`
