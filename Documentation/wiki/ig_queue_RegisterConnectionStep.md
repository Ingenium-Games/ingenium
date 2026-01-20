# ig.queue.RegisterConnectionStep

## Description

Registers a custom connection step that will be executed during player connection processing.

## Signature

```lua
function ig.queue.RegisterConnectionStep(stepConfig)
```

## Parameters

- **`stepConfig`**: table - Configuration object with fields:
  - **`id`**: string - Unique step identifier
  - **`title`**: string - Display title for the step
  - **`handler`**: function - Handler function `(src, name, identifiers, deferrals)` that returns `(success, message)`

## Returns

None

## Example

```lua
-- Register a custom connection step
ig.queue.RegisterConnectionStep({
    id = "custom_validation",
    title = "Validating account...",
    handler = function(src, name, identifiers, deferrals)
        -- Custom validation logic
        local isValid = CheckAccountValid(identifiers)
        if isValid then
            return true, "Account validated"
        else
            return false, "Invalid account"
        end
    end
})
```

## Source

Defined in: `server/[Third Party]/_queue_system.lua`
