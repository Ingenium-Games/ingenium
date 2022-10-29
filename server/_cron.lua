-- ====================================================================================--

c.cron = {} -- functions
c.crons = {} -- table of jobs to action @ times.

-- ====================================================================================--

-- https://github.com/esx-framework/esx-legacy/blob/main/%5Besx%5D/cron/server/main.lua

function c.cron.RunAt(h, m, cb, ...)
	table.insert(c.crons, {
		h  = h,
		m  = m,
		cb = cb,
		args = {...}
	})
end

function c.cron.OnTime(h, m)
	for i=1, #c.crons, 1 do
		if c.crons[i].h == h and c.crons[i].m == m then
			c.crons[i].cb(table.unpack(c.crons[i].args))
		end
	end
end


RegisterCommand("crons", function()
    print(c.table.Dump(c.crons))
end, true)


--[[
local added = false
AddEventHandler("onServerResourceStart", function()
    if not added then
        c.door.Add(Doors)
    end
    added = true
end)
]]--