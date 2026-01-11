# ig.job.GetRichest

## Description

Sort by online members (highest first)

## Signature

```lua
function ig.job.GetRichest(limit)
```

## Parameters

- **`limit`**: any

## Example

```lua
-- Get richest data
local result = ig.job.GetRichest(value)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Objects]/_jobs.lua`
