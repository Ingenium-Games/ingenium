# ig.job.GetGradeInfo

## Description

Retrieves and returns gradeinfo data

## Signature

```lua
function ig.job.GetGradeInfo(jobName, grade)
```

## Parameters

- **`jobName`**: any
- **`grade`**: number

## Example

```lua
-- Get gradeinfo data
local result = ig.job.GetGradeInfo(value, 100)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Objects]/_jobs.lua`
