# ig.object.AddObject

## Description

Adds a new object entity to the server's object registry (`ig.odex`).

## Signature

```lua
function ig.object.AddObject(net, cb, ...)
```

## Parameters

- **`net`**: number - The network ID of the object
- **`cb`**: function - Constructor callback function for creating the object instance
- **`...`**: any - Additional arguments passed to the constructor callback

## Returns

None

## Example

```lua
-- Add an object to the registry
ig.object.AddObject(netId, ig.class.BlankObject, objectData)
```

## Source

Defined in: `server/[Objects]/_objects.lua`
