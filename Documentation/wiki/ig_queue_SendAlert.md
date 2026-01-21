# ig.queue.SendAlert

## Description

Adds a temporary administrative alert message to the queue display that all queued players can see.

## Signature

```lua
function ig.queue.SendAlert(message, duration)
```

## Parameters

- **`message`**: string - Alert message to display
- **`duration`**: number (optional) - Duration in seconds to display the alert (default: 10)

## Returns

None

## Example

```lua
-- Send alert to queue
ig.queue.SendAlert("Server restart in 5 minutes", 30)
```

## Source

Defined in: `server/[Third Party]/_queue_system.lua`
