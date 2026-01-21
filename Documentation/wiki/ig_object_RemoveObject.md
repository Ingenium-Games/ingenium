# ig.object.RemoveObject

## Description

Removes an object entity from the server's object registry (`ig.odex`).

## Signature

```lua
function ig.object.RemoveObject(uuid)
```

## Parameters

- **`uuid`**: string - The unique identifier of the object to remove

## Returns

None

## Example

```lua
-- Remove an object by UUID
ig.object.RemoveObject("abc-123-def-456")
```

## Source

Defined in: `server/[Objects]/_objects.lua`
