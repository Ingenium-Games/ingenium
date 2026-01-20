# ig.queue.GetQueueList

## Description

Retrieves the current queue list with detailed information about each queued player.

## Signature

```lua
function ig.queue.GetQueueList()
```

## Parameters

None

## Returns

- **`table`** - Array of queue entries, each containing:
  - **`position`**: number - Position in queue
  - **`name`**: string - Player name
  - **`priority`**: number - Queue priority value
  - **`queueTime`**: number - Time spent in queue (seconds)
  - **`identifiers`**: table - Player identifiers

## Example

```lua
-- Get queue list
local queue = ig.queue.GetQueueList()
for _, entry in ipairs(queue) do
    print(entry.position, entry.name, entry.priority)
end
```

## Source

Defined in: `server/[Third Party]/_queue_system.lua`
