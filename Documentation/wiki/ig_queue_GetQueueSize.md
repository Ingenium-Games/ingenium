# ig.queue.GetQueueSize

## Description

Returns the current number of players in the queue.

## Signature

```lua
function ig.queue.GetQueueSize()
```

## Parameters

None

## Returns

- **`number`** - The number of players currently in the queue

## Example

```lua
-- Check queue size
local size = ig.queue.GetQueueSize()
print("Players in queue:", size)
```

## Source

Defined in: `server/[Third Party]/_queue_system.lua`
