# ig.voip.GetNextVoiceMode

## Description

Retrieves and returns nextvoicemode data

## Signature

```lua
function ig.voip.GetNextVoiceMode(currentIndex)
```

## Parameters

- **`currentIndex`**: number

## Example

```lua
-- Get nextvoicemode data
local result = ig.voip.GetNextVoiceMode(100)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `shared/[Voice]/_voip.lua`
