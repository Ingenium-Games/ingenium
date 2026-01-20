# ig.queue.RemovePlayer

## Description

Removes a player from the queue and connecting list based on their identifiers.

## Signature

```lua
function ig.queue.RemovePlayer(identifiers)
```

## Parameters

- **`identifiers`**: table - Player identifiers object

## Returns

None

## Example

```lua
-- Remove player from queue
local identifiers = ig.func.identifiers(source)
ig.queue.RemovePlayer(identifiers)
```

## Source

Defined in: `server/[Third Party]/_queue_system.lua`
