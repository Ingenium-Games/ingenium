# Job Management UI System

## Overview

The Job Management UI is a comprehensive Vue 3-based interface for managing business/job operations in the Ingenium framework. It provides role-based access control, allowing owners/bosses to manage all aspects of their organization, while employees have restricted views.

## Features

### For Owners/Bosses
- **Employee Management**: Hire, fire, promote, and demote employees
- **Location Management**: Set sales points, delivery points, and safe locations
- **Price Management**: Configure item prices for sales
- **Financial Reports**: View income and expense transactions
- **Memo System**: Post announcements and memos for staff
- **Account Overview**: Monitor safe and bank balances

### For Employees
- **Overview**: View job information and position
- **Memos**: Read announcements from management
- **Financial Reports**: View financials (if permitted by boss)

## Architecture

The job system follows the established Ingenium NUI pattern:

```
nui/src/
├── stores/
│   └── job.js                    # Pinia store for job state
├── components/
│   └── job/
│       ├── JobMenu.vue           # Main container component
│       ├── OverviewTab.vue       # Overview dashboard
│       ├── EmployeeList.vue      # Employee management
│       ├── LocationManager.vue   # Location configuration
│       ├── PriceEditor.vue       # Price management
│       ├── FinancialReport.vue   # Financial overview
│       └── MemoManager.vue       # Staff memos
nui/lua/
├── ui.lua                        # Export API
└── NUI-Client/
    └── _job.lua                  # NUI callbacks
```

## Usage

### Opening the Job Menu (Lua)

```lua
-- From client-side script
exports['ingenium']:ShowJobMenu({
    job = {
        name = "police",
        label = "Police Department",
        description = "Law enforcement agency",
        boss = "C01:xxxxx",
        grades = {
            { rank = 1, name = "Cadet", pay = 17 },
            { rank = 2, name = "Officer", pay = 22 },
            { rank = 3, name = "Sergeant", pay = 26 },
            { rank = 4, name = "Lieutenant", pay = 29 },
            { rank = 5, name = "Chief", pay = 33 }
        },
        members = {"C01:xxxxx", "C01:yyyyy"},
        accounts = {
            safe = 5000.00,
            bank = 150000.00
        },
        prices = {
            ["health_kit"] = 50.00,
            ["armor_vest"] = 150.00
        },
        locations = {
            sales = {
                { name = "Armory", coords = { x = 450.0, y = -990.0, z = 30.0 } }
            },
            delivery = {},
            safe = { name = "Evidence Locker", coords = { x = 460.0, y = -985.0, z = 30.0 } }
        },
        memos = {
            {
                title = "New Policy",
                content = "All officers must file reports within 24 hours.",
                date = "2026-01-18T12:00:00Z",
                author = "Chief Smith",
                pinned = true
            }
        },
        settings = {
            showFinancials = true,
            allowEmployeeActions = true
        }
    },
    user = {
        characterId = "C01:xxxxx",
        characterName = "John Doe",
        jobName = "police",
        jobGrade = 5,
        isBoss = true
    },
    employees = {
        {
            characterId = "C01:xxxxx",
            name = "John Doe",
            gradeName = "Chief",
            grade = 5,
            online = true,
            lastSeen = "2026-01-18T12:00:00Z"
        }
    },
    financials = {
        income = {
            { description = "Vehicle Sales", amount = 25000, date = "2026-01-17T10:00:00Z" }
        },
        expenses = {
            { description = "Payroll", amount = 5000, date = "2026-01-17T12:00:00Z" }
        },
        totalIncome = 25000,
        totalExpenses = 5000,
        netProfit = 20000
    }
})
```

### Closing the Job Menu

```lua
exports['ingenium']:HideJobMenu()
```

### Updating Job Data Dynamically

```lua
-- Update account balances
exports['ingenium']:UpdateJobAccounts({
    safe = 6000.00,
    bank = 160000.00
})

-- Update memos
exports['ingenium']:UpdateJobMemos({
    {
        title = "Important Update",
        content = "New memo content",
        date = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        author = "Management",
        pinned = false
    }
})

-- Update employee list
exports['ingenium']:UpdateJobEmployees(employeeList)

-- Update prices
exports['ingenium']:UpdateJobPrices({
    ["health_kit"] = 60.00,
    ["armor_vest"] = 175.00
})

-- Update locations
exports['ingenium']:UpdateJobLocations(locationData)

-- Update financials
exports['ingenium']:UpdateJobFinancials(financialData)
```

## NUI Callbacks

The following callbacks are triggered when users interact with the job menu:

### Employee Management
- `NUI:Client:JobInviteEmployee` - Invite new employee
- `NUI:Client:JobPromoteEmployee` - Promote employee
- `NUI:Client:JobDemoteEmployee` - Demote employee
- `NUI:Client:JobFireEmployee` - Fire employee

### Location Management
- `NUI:Client:JobAddSalesPoint` - Add sales point
- `NUI:Client:JobAddDeliveryPoint` - Add delivery point
- `NUI:Client:JobSetSafe` - Set safe location
- `NUI:Client:JobRemoveLocation` - Remove location
- `NUI:Client:JobRemoveSafe` - Remove safe

### Price Management
- `NUI:Client:JobAddPrice` - Add price item
- `NUI:Client:JobRemovePrice` - Remove price item
- `NUI:Client:JobSavePrices` - Save all prices

### Memo Management
- `NUI:Client:JobCreateMemo` - Create new memo
- `NUI:Client:JobTogglePinMemo` - Pin/unpin memo
- `NUI:Client:JobDeleteMemo` - Delete memo

### General
- `NUI:Client:JobClose` - Close job menu

## Server Integration (TODO)

The following server-side functionality needs to be implemented:

### Data Loading
```lua
-- Example function to load job data for a player
function LoadJobDataForPlayer(source)
    local xPlayer = ig.data.GetPlayer(source)
    local job = xPlayer.GetJob()
    local xJob = ig.data.GetJob(job.Name)
    
    -- Check if player is boss
    local isBoss = ig.job.IsBossGrade(job.Name, job.Grade)
    
    -- Load employee data (bosses only)
    local employees = {}
    if isBoss then
        employees = LoadEmployeeList(job.Name)
    end
    
    -- Load financial data
    local financials = LoadFinancialData(job.Name, isBoss)
    
    return {
        job = {
            name = job.Name,
            label = xJob.Label or job.Name,
            description = xJob.GetDescription(),
            boss = xJob.Boss,
            grades = xJob.GetGrades(),
            members = xJob.Members,
            accounts = xJob.GetAccounts(true),
            prices = LoadJobPrices(job.Name),
            locations = LoadJobLocations(job.Name),
            memos = LoadJobMemos(job.Name),
            settings = LoadJobSettings(job.Name)
        },
        user = {
            characterId = xPlayer.GetCharacter_ID(),
            characterName = xPlayer.GetFullName(),
            jobName = job.Name,
            jobGrade = job.Grade,
            isBoss = isBoss
        },
        employees = employees,
        financials = financials
    }
end
```

### Callback Handlers
```lua
-- Register callback handlers in server-side code
RegisterNUICallback("NUI:Client:JobInviteEmployee", function(source, data, cb)
    local xPlayer = ig.data.GetPlayer(source)
    local job = xPlayer.GetJob()
    
    -- Verify player is boss
    if not ig.job.IsBossGrade(job.Name, job.Grade) then
        cb({ success = false, error = "Insufficient permissions" })
        return
    end
    
    -- Implement invite logic
    -- ...
    
    cb({ success = true })
end)
```

## Data Structures

### Job Data Structure
```typescript
interface JobData {
    name: string                    // Job identifier (e.g., "police")
    label: string                   // Display name
    description?: string            // Job description
    boss: string                    // Character ID of owner/boss
    grades: Array<{
        rank: number
        name: string
        pay: number
    }>
    members: string[]               // Array of character IDs
    accounts: {
        safe: number
        bank: number
    }
    prices: Record<string, number>  // Item name -> price
    locations: {
        sales: Array<{
            name?: string
            coords: { x: number, y: number, z: number }
        }>
        delivery: Array<{
            name?: string
            coords: { x: number, y: number, z: number }
        }>
        safe: {
            name?: string
            coords: { x: number, y: number, z: number }
        } | null
    }
    memos: Array<{
        title?: string
        content: string
        date: string                // ISO 8601 format
        author?: string
        pinned?: boolean
    }>
    settings: {
        showFinancials: boolean     // Show financials to employees
        allowEmployeeActions: boolean
    }
}
```

### Employee Data Structure
```typescript
interface Employee {
    characterId: string
    name: string
    gradeName: string
    grade: number
    online: boolean
    lastSeen?: string               // ISO 8601 format
}
```

### Financial Data Structure
```typescript
interface FinancialData {
    income: Array<{
        description: string
        amount: number
        date: string                // ISO 8601 format
    }>
    expenses: Array<{
        description: string
        amount: number
        date: string                // ISO 8601 format
    }>
    totalIncome: number
    totalExpenses: number
    netProfit: number
}
```

## Styling

The job UI uses consistent styling with the rest of the Ingenium NUI system:
- Dark theme with gradient backgrounds
- Blue accent color (#4287f5)
- Green for positive values (#4ade80)
- Orange/Red for negative values (#fb923c / #ef4444)
- Responsive design for different screen sizes

## Best Practices

1. **Permission Checks**: Always verify permissions server-side before executing actions
2. **Data Validation**: Validate all user input server-side
3. **Real-time Updates**: Use the update exports to keep UI in sync with server state
4. **Error Handling**: Provide user feedback for failed operations
5. **Loading States**: Consider adding loading indicators for async operations

## Testing Checklist

- [ ] Boss can open job menu
- [ ] Employee can open job menu (restricted view)
- [ ] All tabs display correctly
- [ ] Employee actions work (invite, promote, demote, fire)
- [ ] Location management works
- [ ] Price editor updates correctly
- [ ] Financial report displays data
- [ ] Memo system works (create, pin, delete)
- [ ] ESC key closes menu
- [ ] NUI focus properly set/cleared
- [ ] Data persists after menu close/reopen

## Future Enhancements

- [ ] Add graphical financial charts
- [ ] Implement job tasks/actions for employees
- [ ] Add employee attendance tracking
- [ ] Create shift scheduling system
- [ ] Add inventory management integration
- [ ] Implement job notifications system
- [ ] Add permission system beyond boss/employee
