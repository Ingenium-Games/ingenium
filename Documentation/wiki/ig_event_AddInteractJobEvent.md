# ig.event.AddInteractJobEvent

## Description

====================================================================================--

## Signature

```lua
function ig.event.AddInteractJobEvent(job, name, cb)
```

## Parameters

- **`job`**: string "Jobname used fro role permissions
- **`name`**: string "The final argument f the event
- **`cb`**: function "The function to call post event being triggered and once confirmed user is able to action event.

## Example

```lua
-- Example usage of ig.event.AddInteractJobEvent
ig.event.AddInteractJobEvent(item)
```

## Source

Defined in: `server/_events.lua`
