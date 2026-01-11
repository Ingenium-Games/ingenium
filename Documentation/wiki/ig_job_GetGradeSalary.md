# ig.job.GetGradeSalary

## Description

Retrieves and returns gradesalary data

## Signature

```lua
function ig.job.GetGradeSalary(jobName, grade)
```

## Parameters

- **`jobName`**: any
- **`grade`**: number

## Example

```lua
-- Get gradesalary data
local result = ig.job.GetGradeSalary(value, 100)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Objects]/_jobs.lua`
