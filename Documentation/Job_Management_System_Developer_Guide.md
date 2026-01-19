# Job Management System - Developer Guide

## Overview

The job management system has been completely restructured to support the Job Management UI with rich metadata including pricing, locations, memos, and employee management.

## Architecture Changes

### From SQL to JSON-Based Storage

**Old System:**
- Jobs stored in `job_accounts` SQL table
- Only contained `Accounts` field for financial data
- Limited to basic grade definitions

**New System:**
- Jobs stored in `data/jobs.json`
- Rich metadata: label, description, boss, members, prices, locations, memos, settings
- Grades include pay rate and boss flag
- Real-time save system with dirty flag tracking
- Automatic persistence every 10 minutes (configurable via `conf.jobsync`)

### Data Structure

```lua
{
  "jobName": {
    "label": "Job Display Name",           -- UI display name
    "description": "Job description",      -- Full description text
    "boss": "characterId or null",         -- Character_ID of current boss/owner
    "grades": {                            -- Grade definitions
      "gradeName": {
        "org": "Organization Name",        -- Organization/department name
        "rank": 1,                         -- Hierarchy rank (1=lowest)
        "pay": 15,                         -- Hourly/salary pay rate
        "isBoss": false                    -- Can manage job (hire/fire/etc)
      }
    },
    "members": ["char1", "char2"],         -- Array of Character_IDs employed here
    "prices": {                            -- Item pricing configuration
      "ItemName": 50.00
    },
    "locations": {                         -- Job locations
      "sales": [                           -- Sales locations (array)
        {"name": "...", "coords": {x, y, z}}
      ],
      "delivery": [],                      -- Delivery locations (array)
      "safe": null                         -- Safe location (single object or null)
    },
    "memos": [                             -- Staff memos/announcements
      {
        "title": "Memo Title",
        "content": "Memo content",
        "date": "2025-01-16T12:00:00Z",    -- ISO8601 format
        "author": "authorName",
        "pinned": false
      }
    ],
    "settings": {                          -- Job configuration
      "showFinancials": true,              -- Show financial data to employees
      "allowEmployeeActions": true         -- Allow employees to perform actions
    }
  }
}
```

## Job Class API

### Core Methods

```lua
local xJob = ig.data.GetJob("police")

-- Identity
xJob.GetName()           -- Returns job key/identifier
xJob.GetLabel()          -- Returns display name
xJob.GetDescription()    -- Returns description text
xJob.SetDescription(str) -- Update description (max 1500 chars)

-- Organization
xJob.GetBoss()           -- Returns Character_ID of boss
xJob.SetBoss(characterId)-- Set boss and add to members
xJob.GetMembers()        -- Returns array of Character_IDs
xJob.AddMember(characterId)  -- Add employee
xJob.RemoveMember(characterId)-- Remove employee
xJob.FindMember(characterId) -- Check if member exists (returns boolean)

-- Grades
xJob.GetGrades()         -- Returns grades table
-- Note: Grade management uses existing GetGrades() pattern

-- Settings
xJob.GetSettings()       -- Returns settings table
xJob.SetSettings(settings) -- Update settings object

-- Dirty Flag System
xJob.GetIsDirty()        -- Check if job needs saving
xJob.SetUpdated()        -- Mark job as dirty (auto-saves on next sync)
xJob.ClearDirty()        -- Clear dirty flag (called after save)
```

### Price Management

```lua
-- Get all prices
local prices = xJob.GetPrices()

-- Set item price
xJob.SetPrice("ItemName", 50.00)

-- Remove item price
xJob.RemovePrice("ItemName")
```

### Location Management

```lua
-- Sales Locations
local sales = xJob.GetSalesLocations()
xJob.AddSalesLocation({
    name = "Downtown Shop",
    coords = {x = 123.4, y = 456.7, z = 28.3}
})
xJob.RemoveSalesLocation(1) -- Remove by array index

-- Delivery Locations
local delivery = xJob.GetDeliveryLocations()
xJob.AddDeliveryLocation({
    name = "North Warehouse",
    coords = {x = -100.5, y = 200.3, z = 30.1}
})
xJob.RemoveDeliveryLocation(2)

-- Safe Location (single)
local safe = xJob.GetSafeLocation()
xJob.SetSafeLocation({
    name = "Main Vault",
    coords = {x = 50.0, y = 100.0, z = 25.0}
})
xJob.SetSafeLocation(nil) -- Remove safe location
```

### Memo Management

```lua
-- Get all memos
local memos = xJob.GetMemos()

-- Add memo
xJob.AddMemo({
    title = "Staff Meeting",
    content = "All hands meeting Friday at 3pm",
    author = "John Doe",
    pinned = false
})

-- Update memo
xJob.UpdateMemo(1, {
    title = "Updated Meeting",
    content = "Meeting moved to 4pm",
    author = "John Doe",
    pinned = true
})

-- Remove memo
xJob.RemoveMemo(2)

-- Toggle pinned status
xJob.ToggleMemoPinned(1)
```

## Admin Commands

### ACE Permissions Required

Add to `server.cfg`:
```bash
# Allow admin group to manage jobs
add_ace group.admin command.createjob allow
add_ace group.admin command.deletejob allow
add_ace group.admin command.listjobs allow

# Or for specific players
add_ace identifier.license:abc123 command.createjob allow
```

### Create Job

```bash
/createjob [jobName] [label] [description]
```

**Example:**
```bash
/createjob realestate "Real Estate Agency" "Buy and sell properties"
```

Creates a new job with default structure:
- 3 grades: Employee, Manager, Owner
- Default pay rates: 15, 25, 35
- Empty members, prices, locations, memos
- Default settings enabled

### Delete Job

```bash
/deletejob [jobName]
```

**Example:**
```bash
/deletejob realestate
```

**Protections:**
- Cannot delete core jobs: `none`, `police`, `medic`
- Removes from runtime and JSON file
- TODO: Reassign affected players to "none"

### List Jobs

```bash
/listjobs
```

Prints formatted list to server console (F8) with:
- Job number
- Label and identifier
- Member count

## Exports for Other Resources

### Create Job Dynamically

```lua
local success, message = exports['ingenium']:CreateJob("realestate", {
    label = "Real Estate Agency",
    description = "Buy and sell properties",
    boss = nil,
    grades = {
        ["Agent"] = {org = "Real Estate Agency", rank = 1, pay = 20, isBoss = false},
        ["Broker"] = {org = "Real Estate Agency", rank = 2, pay = 30, isBoss = true}
    },
    members = {},
    prices = {},
    locations = {sales = {}, delivery = {}, safe = nil},
    memos = {},
    settings = {showFinancials = true, allowEmployeeActions = true}
})

if success then
    print("Job created successfully")
else
    print("Failed: " .. message)
end
```

### Delete Job Dynamically

```lua
local success, message = exports['ingenium']:DeleteJob("realestate")

if success then
    print("Job deleted successfully")
else
    print("Failed: " .. message)
end
```

## Save System

### Automatic Persistence

Jobs are automatically saved to `data/jobs.json` via the consolidated save loop:

- **Interval**: Every 10 minutes (default, configurable via `conf.jobsync`)
- **Trigger**: Only dirty jobs are saved (modified since last save)
- **Method**: `ig.sql.save.Jobs()` (despite the name, saves to JSON not SQL)

### Manual Save

```lua
-- Mark job as dirty
xJob.SetUpdated()

-- Or force save immediately
ig.json.Write(conf.file.jobs, ig.jobs)
```

### Dirty Flag System

Jobs automatically track changes via dirty flags:

```lua
-- Any setter method automatically marks job as dirty
xJob.SetDescription("New description")  -- Sets IsDirty = true
xJob.AddMember("ABC123")                -- Sets IsDirty = true
xJob.SetPrice("Water", 5.00)            -- Sets IsDirty = true

-- Check dirty status
if xJob.GetIsDirty() then
    print("Job has unsaved changes")
end

-- Clear dirty flag (called automatically after save)
xJob.ClearDirty()
```

## Data Loading

### Startup Sequence

1. `ig.data.LoadJSONData()` - Loads `jobs.json` into `ig.jobs` table
2. `ig.data.CreateJobObjects()` - Creates `ig.class.Job` instances in `ig.jdex`
3. Jobs are now available via `ig.data.GetJob(jobName)`

### Runtime Access

```lua
-- Get job object instance
local xJob = ig.data.GetJob("police")

-- Get all jobs
local allJobs = ig.data.GetJobs() -- Returns ig.jdex

-- Check if job exists
if ig.jobs["police"] then
    -- Job definition exists
end

if ig.jdex["police"] then
    -- Job object instance exists
end
```

## Migration from Old System

### SQL Table Removal

The `job_accounts` SQL table is **no longer used** for job data. Financial data has moved to:
- **Items**: Cash/money as inventory items
- **Banking**: SQL-based bank accounts (see `Documentation/BANKING_LOAN_SYSTEM_IMPLEMENTATION.md`)

### Accounts Field Removed

Old structure:
```lua
{
  "police": {
    "accounts": {          -- ❌ REMOVED
      "society": 50000,
      "black": 10000
    },
    "Cadet": {...}
  }
}
```

New structure:
```lua
{
  "police": {
    "label": "Police Department",  -- ✅ NEW
    "description": "...",           -- ✅ NEW
    "boss": null,                   -- ✅ NEW
    "members": [],                  -- ✅ NEW
    "prices": {},                   -- ✅ NEW
    "locations": {...},             -- ✅ NEW
    "memos": [],                    -- ✅ NEW
    "settings": {...},              -- ✅ NEW
    "grades": {
      "Cadet": {
        "org": "Police Department",
        "rank": 1,
        "pay": 17,               -- ✅ NEW
        "isBoss": false          -- ✅ NEW
      }
    }
  }
}
```

## Job Management UI Integration

The Job Management UI expects specific data structures:

### Required Server Callbacks

Implement these callbacks to connect the UI:

```lua
-- Get job overview
RegisterNUICallback("Server:Job:GetOverview", function(data, cb)
    local xPlayer = ig.data.GetPlayer(source)
    local xJob = ig.data.GetJob(xPlayer.GetJobName())
    
    cb({
        name = xJob.GetName(),
        label = xJob.GetLabel(),
        description = xJob.GetDescription(),
        boss = xJob.GetBoss(),
        members = xJob.GetMembers(),
        settings = xJob.GetSettings(),
        playerGrade = xPlayer.GetGrade(),
        isBoss = -- Check if player's grade has isBoss = true
    })
end)

-- Hire employee
RegisterNUICallback("Server:Job:HireEmployee", function(data, cb)
    local xPlayer = ig.data.GetPlayer(source)
    local xJob = ig.data.GetJob(xPlayer.GetJobName())
    local targetPlayer = ig.data.GetPlayerByCharacterId(data.characterId)
    
    -- Permission check
    if not -- player is boss then
        cb({success = false, error = "Insufficient permissions"})
        return
    end
    
    -- Set job and add member
    targetPlayer.SetJob(xJob.GetName(), data.grade)
    xJob.AddMember(data.characterId)
    
    cb({success = true})
end)

-- Update prices
RegisterNUICallback("Server:Job:UpdatePrices", function(data, cb)
    local xPlayer = ig.data.GetPlayer(source)
    local xJob = ig.data.GetJob(xPlayer.GetJobName())
    
    for itemName, price in pairs(data.prices) do
        xJob.SetPrice(itemName, price)
    end
    
    cb({success = true})
end)

-- Add sales location
RegisterNUICallback("Server:Job:AddSalesLocation", function(data, cb)
    local xPlayer = ig.data.GetPlayer(source)
    local xJob = ig.data.GetJob(xPlayer.GetJobName())
    
    xJob.AddSalesLocation(data.location)
    
    cb({success = true})
end)

-- Add memo
RegisterNUICallback("Server:Job:AddMemo", function(data, cb)
    local xPlayer = ig.data.GetPlayer(source)
    local xJob = ig.data.GetJob(xPlayer.GetJobName())
    
    xJob.AddMemo({
        title = data.title,
        content = data.content,
        author = xPlayer.GetFullName(),
        pinned = data.pinned or false
    })
    
    cb({success = true})
end)
```

See `Documentation/Job_Management_UI.md` for complete callback reference.

## Security Considerations

### Permission Checks

Always verify permissions before allowing job modifications:

```lua
-- Check if player is boss
local xPlayer = ig.data.GetPlayer(source)
local xJob = ig.data.GetJob(xPlayer.GetJobName())
local grade = xPlayer.GetGrade()
local gradeData = xJob.GetGrades()[grade]

if not gradeData or not gradeData.isBoss then
    -- Player is not a boss, deny action
    return
end
```

### Input Validation

Use `ig.check.*` module for all user inputs:

```lua
-- Validate price
local price = ig.check.Number(data.price, 0, 999999)

-- Validate string length
local description = ig.check.String(data.description)
if #description > 1500 then
    -- Reject, too long
end

-- Validate item exists
if not ig.item.Exists(itemName) then
    -- Reject, invalid item
end
```

### Rate Limiting

Consider implementing rate limits for:
- Job creation (max X per hour)
- Member additions (max X per day)
- Price updates (max X per minute)

## Performance

### Memory Usage

- Jobs are loaded once at startup and kept in memory
- ~25 jobs = ~50KB memory footprint
- Dirty flag system prevents unnecessary saves

### Save Performance

- Only modified jobs are saved (dirty flag check)
- Batched save every 10 minutes
- Typical save time: 5-15ms for 5-10 modified jobs

### Lookup Performance

- `ig.data.GetJob(name)` - O(1) hash table lookup
- Member checks - O(n) array iteration (consider indexing for large orgs)

## Testing

### Manual Testing

```lua
-- In server console or command
/createjob testjob "Test Job" "Testing job system"

-- Get job
local xJob = ig.data.GetJob("testjob")

-- Test methods
xJob.SetDescription("Updated description")
xJob.AddMember("ABC123")
xJob.SetPrice("Water", 10.00)

-- Check dirty flag
print(xJob.GetIsDirty()) -- Should be true

-- Force save
ig.json.Write(conf.file.jobs, ig.jobs)

-- Verify file updated
-- Check data/jobs.json for "testjob"

-- Delete job
/deletejob testjob
```

### Automated Testing

Create test script in `server/[Dev]/test_jobs.lua`:

```lua
RegisterCommand("testjobs", function()
    -- Test job creation
    local success, msg = exports['ingenium']:CreateJob("testjob", {
        label = "Test Job",
        description = "Test",
        grades = {
            ["Worker"] = {org = "Test", rank = 1, pay = 15, isBoss = false}
        }
    })
    assert(success, "Failed to create job: " .. tostring(msg))
    
    -- Test methods
    local xJob = ig.data.GetJob("testjob")
    assert(xJob ~= nil, "Job not found after creation")
    
    xJob.SetDescription("New description")
    assert(xJob.GetDescription() == "New description", "Description not updated")
    
    xJob.AddMember("TEST123")
    assert(xJob.FindMember("TEST123"), "Member not added")
    
    xJob.SetPrice("Water", 5.00)
    local prices = xJob.GetPrices()
    assert(prices["Water"] == 5.00, "Price not set")
    
    -- Test cleanup
    exports['ingenium']:DeleteJob("testjob")
    assert(ig.data.GetJob("testjob") == nil, "Job not deleted")
    
    print("✅ All job tests passed")
end, true)
```

## Troubleshooting

### Jobs not loading

1. Check `data/jobs.json` exists and is valid JSON
2. Verify `ig.data.LoadJSONData()` runs during startup
3. Check console for JSON parse errors
4. Ensure `conf.file.jobs` points to correct path

### Jobs not saving

1. Check job has `IsDirty = true` flag set
2. Verify `conf.jobsync` interval in config
3. Check `ig.sql.save.Jobs()` is called by save loop
4. Look for file write errors in console

### "Job already exists" error

1. Job key already in `ig.jobs` table
2. Check `data/jobs.json` for duplicate entries
3. Restart resource to reload jobs
4. Use `/deletejob` to remove duplicate

### "Job does not exist" error

1. Job not in `ig.jobs` or `ig.jdex`
2. Check spelling of job name (case-sensitive)
3. Verify `ig.data.CreateJobObjects()` ran
4. Restart resource to reload jobs

## Related Documentation

- [Job Management UI](./Job_Management_UI.md) - UI component documentation
- [Job Management UI Implementation](../Implementations/Job_Management_UI_Implementation.md) - Technical implementation
- [Banking System](./BANKING_LOAN_SYSTEM_IMPLEMENTATION.md) - Financial integration
- [SQL Architecture](./SQL_Architecture.md) - Save system details

---

**Last Updated**: 2025-01-16
**Version**: 2.0.0 (Complete restructure from SQL to JSON-based system)

