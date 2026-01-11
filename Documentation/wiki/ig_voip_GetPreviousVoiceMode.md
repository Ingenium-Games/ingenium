# ig.voip.GetPreviousVoiceMode

## Description

Retrieves and returns previousvoicemode data

## Signature

```lua
function ig.voip.GetPreviousVoiceMode(currentIndex)
```

## Parameters

- **`currentIndex`**: number

## Example

```lua
-- Get previousvoicemode data
local result = ig.voip.GetPreviousVoiceMode(100)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `shared/[Voice]/_voip.lua`
