# ig.job.IsBoss

## Description

Checks if a specific grade within a job is marked as a boss grade.

## Signature

```lua
function ig.job.IsBoss(jobName, grade)
```

## Parameters

- **`jobName`**: string - The name of the job
- **`grade`**: string - The grade to check

## Returns

- **`boolean`** - `true` if the grade is a boss grade, `false` otherwise

## Example

```lua
-- Check if a grade is boss
local isBoss = ig.job.IsBoss("police", "chief")
if isBoss then
    print("This grade has boss permissions")
end
```

## Notes

This function is a wrapper for `ig.job.IsBossGrade()`.

## Source

Defined in: `server/[Objects]/_jobs.lua`
