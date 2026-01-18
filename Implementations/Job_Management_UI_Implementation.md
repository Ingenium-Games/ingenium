# Job Management UI - Implementation Guide

## Overview

This document provides implementation examples for integrating the Job Management UI with the Ingenium server-side code.

## Server-Side Implementation

### 1. Command to Open Job Menu

Add this to your server commands file (e.g., `server/_commands.lua` or create `server/[Commands]/_job.lua`):

```lua
-- Command to open job management menu
ig.cmd.Add("jobmenu", function(source, args, raw)
    local xPlayer = ig.data.GetPlayer(source)
    if not xPlayer then return end
    
    local job = xPlayer.GetJob()
    if not job or job.Name == "none" then
        ig.log.Info("COMMAND", "Player has no job")
        return
    end
    
    -- Load job data and send to client
    TriggerClientEvent("Client:Job:OpenMenu", source, job.Name)
end, {
    description = "Open job management menu",
    restricted = false
})
```

### 2. Client Event Handler

Add this to a client file (e.g., `client/[Job]/_menu.lua`):

```lua
-- Client event to open job menu
RegisterNetEvent("Client:Job:OpenMenu")
AddEventHandler("Client:Job:OpenMenu", function(jobName)
    -- Request job data from server
    ig.callback.TriggerServer("Server:Job:GetMenuData", function(data)
        if data and data.success then
            exports['ingenium']:ShowJobMenu(data.menuData)
        else
            print("Failed to load job data: " .. (data.error or "Unknown error"))
        end
    end, jobName)
end)
```

### 3. Server Callback to Load Job Data

Add this to a server callback file (e.g., `server/[Callbacks]/_job.lua`):

```lua
-- Server callback to get job menu data
ig.callback.Register("Server:Job:GetMenuData", function(source, cb, jobName)
    local xPlayer = ig.data.GetPlayer(source)
    if not xPlayer then
        cb({ success = false, error = "Player not found" })
        return
    end
    
    local job = xPlayer.GetJob()
    local xJob = ig.data.GetJob(job.Name)
    
    if not xJob or job.Name ~= jobName then
        cb({ success = false, error = "Invalid job" })
        return
    end
    
    -- Check if player is boss/owner
    local isBoss = ig.job.IsBossGrade(job.Name, job.Grade)
    
    -- Build job data
    local jobData = {
        name = job.Name,
        label = xJob.Label or job.Name,
        description = xJob.GetDescription() or "No description available",
        boss = xJob.Boss,
        grades = {},
        members = xJob.Members or {},
        accounts = {
            safe = xJob.GetSafe() or 0,
            bank = xJob.GetBank() or 0
        },
        prices = LoadJobPrices(job.Name),
        locations = LoadJobLocations(job.Name),
        memos = LoadJobMemos(job.Name),
        settings = {
            showFinancials = true, -- Make this configurable
            allowEmployeeActions = true
        }
    }
    
    -- Convert grades
    for gradeName, gradeData in pairs(xJob.GetGrades()) do
        table.insert(jobData.grades, {
            rank = gradeData.rank or 0,
            name = gradeName,
            pay = gradeData.Grade_Salary or 0
        })
    end
    
    -- Sort grades by rank
    table.sort(jobData.grades, function(a, b) return a.rank < b.rank end)
    
    -- User info
    local userData = {
        characterId = xPlayer.GetCharacter_ID(),
        characterName = xPlayer.GetFirstName() .. " " .. xPlayer.GetLastName(),
        jobName = job.Name,
        jobGrade = job.Grade,
        isBoss = isBoss
    }
    
    -- Load employees if boss
    local employees = {}
    if isBoss then
        employees = LoadEmployeeList(job.Name)
    end
    
    -- Load financial data
    local financials = {
        income = {},
        expenses = {},
        totalIncome = 0,
        totalExpenses = 0,
        netProfit = 0
    }
    
    if isBoss or jobData.settings.showFinancials then
        financials = LoadFinancialData(job.Name)
    end
    
    cb({
        success = true,
        menuData = {
            job = jobData,
            user = userData,
            employees = employees,
            financials = financials
        }
    })
end)

-- Helper function to load employee list
function LoadEmployeeList(jobName)
    local employees = {}
    
    -- Get online employees
    for _, xPlayer in pairs(ig.pdex or {}) do
        if xPlayer and xPlayer.GetJob().Name == jobName then
            local job = xPlayer.GetJob()
            local gradeName = ig.job.GetGradeName(jobName, job.Grade)
            
            table.insert(employees, {
                characterId = xPlayer.GetCharacter_ID(),
                name = xPlayer.GetFirstName() .. " " .. xPlayer.GetLastName(),
                gradeName = gradeName,
                grade = job.Grade,
                online = true,
                lastSeen = os.date("!%Y-%m-%dT%H:%M:%SZ")
            })
        end
    end
    
    -- TODO: Load offline employees from database
    -- This would require querying the characters table for all members
    
    return employees
end

-- Helper function to load job prices
function LoadJobPrices(jobName)
    -- TODO: Implement price loading from JSON or database
    -- For now, return sample data
    return {
        ["health_kit"] = 50.00,
        ["armor_vest"] = 150.00,
        ["weapon_pistol"] = 500.00
    }
end

-- Helper function to load job locations
function LoadJobLocations(jobName)
    -- TODO: Implement location loading from JSON or database
    return {
        sales = {},
        delivery = {},
        safe = nil
    }
end

-- Helper function to load job memos
function LoadJobMemos(jobName)
    -- TODO: Implement memo loading from JSON or database
    return {
        {
            title = "Welcome",
            content = "Welcome to the team! Check this section for important updates.",
            date = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            author = "Management",
            pinned = true
        }
    }
end

-- Helper function to load financial data
function LoadFinancialData(jobName)
    -- TODO: Implement financial data loading from database
    -- Query banking_transactions or similar table
    return {
        income = {
            { description = "Sales", amount = 5000, date = os.date("!%Y-%m-%dT%H:%M:%SZ") }
        },
        expenses = {
            { description = "Payroll", amount = 2000, date = os.date("!%Y-%m-%dT%H:%M:%SZ") }
        },
        totalIncome = 5000,
        totalExpenses = 2000,
        netProfit = 3000
    }
end
```

### 4. Employee Management Actions

Add these callbacks to handle employee actions:

```lua
-- Promote employee
ig.callback.Register("Server:Job:PromoteEmployee", function(source, cb, data)
    local xPlayer = ig.data.GetPlayer(source)
    if not xPlayer then
        cb({ success = false, error = "Player not found" })
        return
    end
    
    local job = xPlayer.GetJob()
    if not ig.job.IsBossGrade(job.Name, job.Grade) then
        cb({ success = false, error = "Insufficient permissions" })
        return
    end
    
    -- TODO: Implement promote logic
    -- Get target player, check if they're in the same job, promote them
    
    cb({ success = true })
end)

-- Fire employee
ig.callback.Register("Server:Job:FireEmployee", function(source, cb, data)
    local xPlayer = ig.data.GetPlayer(source)
    if not xPlayer then
        cb({ success = false, error = "Player not found" })
        return
    end
    
    local job = xPlayer.GetJob()
    if not ig.job.IsBossGrade(job.Name, job.Grade) then
        cb({ success = false, error = "Insufficient permissions" })
        return
    end
    
    -- TODO: Implement fire logic
    -- Set employee job to "none"
    
    cb({ success = true })
end)
```

### 5. Update NUI Callbacks

Update `nui/lua/NUI-Client/_job.lua` to call server callbacks:

```lua
-- Example: Fire employee with server callback
RegisterNUICallback("NUI:Client:JobFireEmployee", function(data, cb)
    ig.callback.TriggerServer("Server:Job:FireEmployee", function(result)
        if result.success then
            -- Refresh employee list
            TriggerServerEvent("Server:Job:RefreshEmployees", data.jobName)
        else
            print("Failed to fire employee: " .. (result.error or "Unknown error"))
        end
    end, data)
    
    cb('ok')
end)
```

## Data Persistence

### JSON-Based Approach (Recommended for Locations, Prices, Memos)

Create a file structure like:
```
data/
└── jobs/
    ├── police_locations.json
    ├── police_prices.json
    └── police_memos.json
```

Load/save using:
```lua
-- Load
local locations = ig.json.Read('police_locations')

-- Save
ig.json.Write('police_locations', locationData)
```

### Database Approach (Recommended for Financial Data, Employees)

For transactional data, use the existing `banking_job_accounts` table or create new tables:

```sql
-- Example table for job transactions
CREATE TABLE IF NOT EXISTS `job_transactions` (
  `ID` INT(11) NOT NULL AUTO_INCREMENT,
  `Job` VARCHAR(255) NOT NULL,
  `Type` ENUM('income', 'expense') NOT NULL,
  `Description` VARCHAR(255) NOT NULL,
  `Amount` DECIMAL(10,2) NOT NULL,
  `Date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `Job` (`Job`),
  KEY `Date` (`Date`)
) ENGINE=InnoDB;
```

## Testing the Implementation

1. **Open job menu**: `/jobmenu`
2. **Verify data loads correctly**
3. **Test boss actions** (as boss-grade player)
4. **Test employee view** (as lower-grade player)
5. **Verify permissions** (employee shouldn't see boss tabs)

## Next Steps

1. Implement server callbacks for all actions
2. Create database tables for persistent data
3. Add data validation and error handling
4. Implement permission checks
5. Add real-time updates when data changes
6. Test with multiple players

## Notes

- The UI is complete and functional
- All server-side logic needs to be implemented
- The callback structure is in place
- Data structures are documented
- Follow the existing Ingenium patterns for consistency
