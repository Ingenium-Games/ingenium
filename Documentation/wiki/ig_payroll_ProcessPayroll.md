# ig.payroll.ProcessPayroll

## Description

Processes payroll for all on-duty players every 30 minutes. Validates job account balances, checks minimum duty time (20+ minutes), and processes batch payments via SQL. Requires `conf.enablepayroll = true` to be enabled.

## Signature

```lua
function ig.payroll.ProcessPayroll()
```

## Parameters

None

## Returns

None

## Behavior

- Groups on-duty players by job
- Validates minimum duty time (20 minutes)
- Checks job account balance sufficiency
- Processes batch payments via SQL transactions
- Sends notification to players on successful payment
- Logs insufficient balance warnings

## Example

```lua
-- This function is typically called automatically by the payroll system
-- Manual invocation for testing:
ig.payroll.ProcessPayroll()
```

## Source

Defined in: `server/_payroll.lua`
