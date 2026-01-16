-- ====================================================================================--
-- Banking Configuration
-- Defines all banking system properties including loans and interest
-- ====================================================================================--

-- Banking System Configuration
conf.banking = {}

--[[
BANK LOANS STARTING AMOUNT :
    -- What do you want in bank accounts in terms of a LOAN from the bank.
    -- You can really ruin lives with debt.
]]--
conf.banking.startingloan = false
conf.banking.startingloanamount = 0
conf.banking.overdrawfee = 10

--[[
BANK LOANS TIMES TO PAY: 
    -- Repayment Time to take money from bank account
    -- Loan interest calculation time to apply interest.
    -- Interest rate applied daily as percentage
]]--
conf.banking.overdrafttime = {h = 9, m = 0}
conf.banking.loanpaymenttime = {h = 12, m = 0}
conf.banking.loaninteresttime = {h = 15, m = 0}
conf.banking.interestrate = 3.5 -- Daily interest rate in percentage
conf.banking.startingloanduration = 30 -- days if enabled

--[[
Daily Banking Cycle:

9:00 AM - Overdraft fees applied to all negative accounts
12:00 PM - Loan payments deducted
3:00 PM - Interest calculated and added
]]--