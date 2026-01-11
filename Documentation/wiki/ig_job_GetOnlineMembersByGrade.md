# ig.job.GetOnlineMembersByGrade

## Description

Retrieves and returns onlinemembersbygrade data

## Signature

```lua
function ig.job.GetOnlineMembersByGrade(jobName, grade)
```

## Parameters

- **`jobName`**: any
- **`grade`**: number

## Example

```lua
-- Get onlinemembersbygrade data
local result = ig.job.GetOnlineMembersByGrade(value, 100)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Objects]/_jobs.lua`
