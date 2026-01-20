# ig.queue.InitiateShutdown

## Description

Initiates a server shutdown by setting shutdown mode, clearing the queue, and optionally delaying the shutdown process.

## Signature

```lua
function ig.queue.InitiateShutdown(reason, delay)
```

## Parameters

- **`reason`**: string (optional) - Reason for shutdown
- **`delay`**: number (optional) - Delay in seconds before shutdown

## Returns

None

## Example

```lua
-- Initiate immediate shutdown
ig.queue.InitiateShutdown("Server maintenance")

-- Initiate shutdown with 60 second delay
ig.queue.InitiateShutdown("Scheduled restart", 60)
```

## Source

Defined in: `server/[Third Party]/_queue_system.lua`
