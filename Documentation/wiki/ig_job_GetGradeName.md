# ig.job.GetGradeName

## Description

Retrieves and returns gradename data

## Signature

```lua
function ig.job.GetGradeName(jobName, grade)
```

## Parameters

- **`jobName`**: any
- **`grade`**: number

## Example

```lua
-- Get gradename data
local result = ig.job.GetGradeName(value, 100)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Objects]/_jobs.lua`
