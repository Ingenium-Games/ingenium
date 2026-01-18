# Job Management UI - Visual Preview

## Main Job Menu (JobMenu.vue)

```
╔════════════════════════════════════════════════════════════════════════════╗
║ Police Department                                          Chief of Police ║
║                                                                          ✕ ║
╠════════════════════════════════════════════════════════════════════════════╣
║ Organization: Police Department    Position: Chief of Police              ║
║ Safe: $5,000.00    Bank: $150,000.00    Members: 15                       ║
╠════════════════════════════════════════════════════════════════════════════╣
║ [Overview] [Employees] [Locations] [Pricing] [Financials] [Memos]        ║
╠════════════════════════════════════════════════════════════════════════════╣
║                                                                            ║
║  [Content Area - Changes based on selected tab]                           ║
║                                                                            ║
║                                                                            ║
║                                                                            ║
╚════════════════════════════════════════════════════════════════════════════╝
```

## Overview Tab (OverviewTab.vue)

```
╔════════════════════════════════════════════════════════════════════════════╗
║ Job Information                                                            ║
║ ────────────────────────────────────────────────────────────────────────  ║
║                                                                            ║
║  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐       ║
║  │ Job Name         │  │ Your Position    │  │ Total Members    │       ║
║  │ Police Dept      │  │ Chief            │  │ 15               │       ║
║  └──────────────────┘  └──────────────────┘  └──────────────────┘       ║
║                                                                            ║
║ Description                                                                ║
║ ────────────────────────────────────────────────────────────────────────  ║
║  Law enforcement agency serving the city...                               ║
║                                                                            ║
║ Quick Actions                                                              ║
║ ────────────────────────────────────────────────────────────────────────  ║
║  [👥 Manage Employees]  [📊 View Financials]                             ║
║  [📍 Manage Locations]  [💰 Edit Prices]                                 ║
╚════════════════════════════════════════════════════════════════════════════╝
```

## Employee List Tab (EmployeeList.vue)

```
╔════════════════════════════════════════════════════════════════════════════╗
║ Employee Management                              [➕ Invite Employee]     ║
║ ────────────────────────────────────────────────────────────────────────  ║
║                                                                            ║
║  ┌────────────────────────────────────────────────────────────────────┐  ║
║  │ John Doe                                         ⬆️  ⬇️  🗑️       │  ║
║  │ Chief • ID: C01:xxxxx                                              │  ║
║  │ ● Online                                                            │  ║
║  └────────────────────────────────────────────────────────────────────┘  ║
║                                                                            ║
║  ┌────────────────────────────────────────────────────────────────────┐  ║
║  │ Jane Smith                                       ⬆️  ⬇️  🗑️       │  ║
║  │ Officer • ID: C01:yyyyy                                            │  ║
║  │ ○ Last seen: 2 days ago                                            │  ║
║  └────────────────────────────────────────────────────────────────────┘  ║
║                                                                            ║
║ Employee Statistics                                                        ║
║ ────────────────────────────────────────────────────────────────────────  ║
║  Total Employees: 15    Online Now: 8    Offline: 7                      ║
╚════════════════════════════════════════════════════════════════════════════╝
```

## Location Manager Tab (LocationManager.vue)

```
╔════════════════════════════════════════════════════════════════════════════╗
║ Location Management                                                        ║
║ Set important locations for your business operations                      ║
║ ────────────────────────────────────────────────────────────────────────  ║
║                                                                            ║
║ Sales Points                                                               ║
║  ┌────────────────────────────────────────────────────────────────────┐  ║
║  │ Armory                                                 🗑️          │  ║
║  │ X: 450.0, Y: -990.0, Z: 30.0                                       │  ║
║  └────────────────────────────────────────────────────────────────────┘  ║
║  [➕ Add Sales Point]                                                     ║
║                                                                            ║
║ Delivery Points                                                            ║
║  No delivery points configured                                            ║
║  [➕ Add Delivery Point]                                                  ║
║                                                                            ║
║ Safe Location                                                              ║
║  ┌────────────────────────────────────────────────────────────────────┐  ║
║  │ Evidence Locker                                        🗑️          │  ║
║  │ X: 460.0, Y: -985.0, Z: 30.0                                       │  ║
║  └────────────────────────────────────────────────────────────────────┘  ║
║  [📍 Set Safe Location]                                                   ║
║                                                                            ║
║ 💡 Tip: These locations will be used for business operations...          ║
╚════════════════════════════════════════════════════════════════════════════╝
```

## Price Editor Tab (PriceEditor.vue)

```
╔════════════════════════════════════════════════════════════════════════════╗
║ Price Management                                                           ║
║ Set prices for items sold at your business                                ║
║ ────────────────────────────────────────────────────────────────────────  ║
║                                                                            ║
║  ┌────────────────────────────────────────────────────────────────────┐  ║
║  │ Health Kit                               $ [50.00]          🗑️     │  ║
║  └────────────────────────────────────────────────────────────────────┘  ║
║                                                                            ║
║  ┌────────────────────────────────────────────────────────────────────┐  ║
║  │ Armor Vest                               $ [150.00]         🗑️     │  ║
║  └────────────────────────────────────────────────────────────────────┘  ║
║                                                                            ║
║  ┌────────────────────────────────────────────────────────────────────┐  ║
║  │ Weapon Pistol                            $ [500.00]         🗑️     │  ║
║  └────────────────────────────────────────────────────────────────────┘  ║
║                                                                            ║
║  [➕ Add Item]                        [💾 Save Prices]                    ║
║                                                                            ║
║ 💡 Tip: Prices will be synced to all clients and used for sales...       ║
╚════════════════════════════════════════════════════════════════════════════╝
```

## Financial Report Tab (FinancialReport.vue)

```
╔════════════════════════════════════════════════════════════════════════════╗
║ Financial Report                                                           ║
║ Income and expense overview                                               ║
║ ────────────────────────────────────────────────────────────────────────  ║
║                                                                            ║
║  ┌────────────────┐  ┌────────────────┐  ┌────────────────┐             ║
║  │ 💰             │  │ 📉             │  │ 📊             │             ║
║  │ Total Income   │  │ Total Expenses │  │ Net Profit     │             ║
║  │ $25,000.00     │  │ $5,000.00      │  │ $20,000.00     │             ║
║  └────────────────┘  └────────────────┘  └────────────────┘             ║
║                                                                            ║
║ Recent Income                                                              ║
║ ────────────────────────────────────────────────────────────────────────  ║
║  │ Vehicle Sales                                      +$25,000.00        ║
║  │ 01/17/2026 10:00 AM                                                   ║
║                                                                            ║
║ Recent Expenses                                                            ║
║ ────────────────────────────────────────────────────────────────────────  ║
║  │ Payroll                                            -$5,000.00         ║
║  │ 01/17/2026 12:00 PM                                                   ║
╚════════════════════════════════════════════════════════════════════════════╝
```

## Memo Manager Tab (MemoManager.vue)

```
╔════════════════════════════════════════════════════════════════════════════╗
║ Staff Memos                                          [✍️ New Memo]        ║
║ ────────────────────────────────────────────────────────────────────────  ║
║                                                                            ║
║  ┌────────────────────────────────────────────────────────────────────┐  ║
║  │ [📌 Pinned]  Today at 12:00 PM                   📍  🗑️            │  ║
║  │                                                                      │  ║
║  │ New Policy                                                           │  ║
║  │ All officers must file reports within 24 hours of any incident.     │  ║
║  │                                                                      │  ║
║  │ — Chief Smith                                                        │  ║
║  └────────────────────────────────────────────────────────────────────┘  ║
║                                                                            ║
║  ┌────────────────────────────────────────────────────────────────────┐  ║
║  │ 2 days ago                                           📌  🗑️         │  ║
║  │                                                                      │  ║
║  │ Shift Changes                                                        │  ║
║  │ New shift rotation starts next week. Check the schedule...          │  ║
║  │                                                                      │  ║
║  │ — Management                                                         │  ║
║  └────────────────────────────────────────────────────────────────────┘  ║
╚════════════════════════════════════════════════════════════════════════════╝
```

## Employee View (Non-Boss)

When an employee (non-boss grade) opens the menu, they see a restricted view:

```
╔════════════════════════════════════════════════════════════════════════════╗
║ Police Department                                                  Officer ║
║                                                                          ✕ ║
╠════════════════════════════════════════════════════════════════════════════╣
║ Organization: Police Department    Position: Officer                      ║
║ Members: 15                                                                ║
╠════════════════════════════════════════════════════════════════════════════╣
║ [Overview] [Memos]                                                         ║
╠════════════════════════════════════════════════════════════════════════════╣
║                                                                            ║
║  Job Information                                                           ║
║  ────────────────────────────────────────────────────────────────────────║
║  • Job: Police Department                                                 ║
║  • Position: Officer                                                      ║
║  • Members: 15                                                            ║
║                                                                            ║
║  Employee Actions                                                          ║
║  ────────────────────────────────────────────────────────────────────────║
║  Check the Memos tab for important information from management.           ║
║                                                                            ║
╚════════════════════════════════════════════════════════════════════════════╝
```

## Color Scheme

- **Background**: Dark gradient (rgba(26,26,26,0.98) to rgba(42,42,42,0.98))
- **Primary Color**: Blue (#4287f5) - Used for active tabs, primary buttons
- **Success Color**: Green (#4ade80) - Used for positive values, income
- **Warning Color**: Orange (#fb923c) - Used for expenses
- **Danger Color**: Red (#ef4444) - Used for delete buttons, negative values
- **Text**: White with various opacities for hierarchy

## Responsive Design

The UI automatically adjusts for different screen sizes:
- Desktop: 900px width, full feature display
- Tablet: Flexible grid layouts
- Mobile: Single column layouts, stacked elements

## Animations

- Fade-in transition when opening (0.3s)
- Hover effects on buttons (scale, color change)
- Tab switching with smooth fade animation
- Loading states with spinner animations
