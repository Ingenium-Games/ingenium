# ig.ui.Notify

## Description

Displays a notification message to the player with customizable color and fade duration.

## Signature

```lua
function ig.ui.Notify(text, colour, fade)
```

## Parameters

- **`text`**: string - The notification message text
- **`colour`**: string - The color of the notification (e.g., "green", "red", "blue")
- **`fade`**: number - The duration in milliseconds before the notification fades

## Returns

None

## Example

```lua
-- Show a success notification
ig.ui.Notify("Action completed successfully!", "green", 3000)

-- Show an error notification
ig.ui.Notify("An error occurred", "red", 5000)
```

## Source

Defined in: `client/_ui.lua`
