# ig.queue.Join

## Description

Handles player connection to the queue system. This is the main entry point for players joining the server queue. Manages queue position, priority calculation, and connection flow.

## Signature

```lua
function ig.queue.Join(source, name, setKickReason, deferrals)
```

## Example

```lua
-- This function is called internally by the queue system
-- when a player attempts to join the server
-- It handles priority calculation and queue management automatically
```

## Source

Defined in: `server/[Third Party]/_queue_connect.lua`
