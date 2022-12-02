-- ====================================================================================--
c.bank = {}
-- ====================================================================================--

local payments = false

-- Pulls all characters with loans and deducts money to pay the loan, can go negitive.
--- func desc
function c.bank.CalculatePayments()
    local xJob = c.data.GetJob("bank")

    -- To run independant of active players and debit accounts via sql.
    c.func.Debug_1("Pulls all characters with loans and deducts money to pay the loan, can go negitive.")
end

-- queued to add
AddEventHandler("onServerResourceStart", function()
    if not payments then
        c.cron.RunAt(conf.loanpayment.h, conf.loanpayment.m, c.bank.CalculatePayments)
        payments = true
    end -- c.func.Debug_1("[E] Added Cron Job [F] c.bank.CalculatePayments()")
end)
--

-- Updates the characters loan to add the interest on the outstanding amount each day.
--- func desc
function c.bank.CalculateInterest()
    local xJob = c.data.GetJob("bank")

    -- To run independant of active players and debit accounts via sql.
    c.func.Debug_1("Updates the characters loan to add the interest on the outstanding amount each day.")
end

local interest = false
-- queued to add
AddEventHandler("onServerResourceStart", function()
    if not interest then
        c.cron.RunAt(conf.loaninterest.h, conf.loaninterest.m, c.bank.CalculateInterest)
        interest = true
    end -- c.func.Debug_1("[E] Added Cron Job [F] c.bank.CalculateInterest()")
end)
--

--- func desc
function c.bank.CheckNegativeBalances()
    local xJob = c.data.GetJob("bank")
    local xPlayers = c.data.GetPlayers()
    for k, v in pairs(xPlayers) do
        if v then
            local xPlayer = v
            local bank = xPlayer.GetBank()
            if bank < 0 then
                TriggerClientEvent("Client:Notify", xPlayer.GetID(),
                    "Your Bank account is in negative. \nCurrent Balance is: $ " .. bank ..
                        ". \nOver Draw Fee Charged at: $" .. conf.bankoverdraw ..
                        ". \nThese fees apply every hour, on the hour, until balanced.", "error", 17500)
                xPlayer.RemoveBank(conf.bankoverdraw)
                xJob.AddBank(conf.bankoverdraw)
            end
        end
    end
    -- c.func.Debug_1("Active clients notified of negative bank balances and Fees charged at $"..conf.bankoverdraw)
end

local negative = false
-- queued to add
-- Set so the server will debit bank accounts on the hour every hour if in negative balance.
AddEventHandler("onServerResourceStart", function()
    if not negative then
        for i = 0, 23, 1 do
            c.cron.RunAt(i, 0, c.bank.CheckNegativeBalances)
        end
        negative = true
    end
    -- c.func.Debug_1("[E] Added Cron Job: [F] c.bank.CheckNegativeBalances()")
end)
