-- ====================================================================================--
c.bank = {}

--[[
NOTES.
    - These Banking functions utlizie the cron resource to plan and execute events or funtions 
    - at a specific time each day, to run on a schedual.
    - 
]]--

-- ====================================================================================--

-- Pulls all characters with loans and deducts money to pay the loan, can go negitive.
function c.bank.CalculatePayments()
    local xJob = c.data.GetJob("bank")
    -- To run independant of active players and debit accounts via sql.
end

-- queued to add
AddEventHandler("onServerResourceStart", function()
    c.cron.Add(conf.loanpayment.h, conf.loanpayment.m, c.bank.CalculatePayments)
    -- c.debug_1("[E] Added Cron Job [F] c.bank.CalculatePayments()")
end)
--

-- Updates the characters loan to add the interest on the outstanding amount each day.
function c.bank.CalculateInterest()
    local xJob = c.data.GetJob("bank")
    -- To run independant of active players and debit accounts via sql.
end

-- queued to add
AddEventHandler("onServerResourceStart", function()
    c.cron.Add(conf.loaninterest.h, conf.loaninterest.m, c.bank.CalculateInterest)
    -- c.debug_1("[E] Added Cron Job [F] c.bank.CalculateInterest()")
end)
--

--- func desc
function c.bank.CheckNegativeBalances()
    local xJob = c.data.GetJob("bank")
    local xPlayers = c.data.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = c.data.GetPlayer(i)
        if xPlayer then
            local bank = xPlayer.GetBank()
            if bank < 0 then
                TriggerClientEvent("Client:Notify", i, "Your Bank account is in negative. \nCurrent Balance is: $ "..bank..". \nOver Draw Fee Charged at: $"..conf.bankoverdraw..". \nThese fees apply every hour, on the hour, until balanced.", "error", 17500)
                xPlayer.RemoveBank(conf.bankoverdraw)
                xJob.AddBank(conf.bankoverdraw)
            end
        end
    end
    -- c.debug_1("Active clients notified of negative bank balances and Fees charged at $"..conf.bankoverdraw)
end

-- queued to add
-- Set so the server will debit bank accounts on the hour every hour if in negative balance.
AddEventHandler("onServerResourceStart", function()
    for i=0,23 do
        c.cron.Add(i, 0, c.bank.CheckNegativeBalances)
    end
    -- c.debug_1("[E] Added Cron Job: [F] c.bank.CheckNegativeBalances()")
end)