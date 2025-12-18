-- ====================================================================================--
ig.cron = {} -- functions
ig.crons = {} -- table of jobs to action @ times.
-- ====================================================================================--

-- https://github.com/esx-framework/esx-legacy/blob/main/%5Besx%5D/cron/server/main.lua

function ig.cron.RunAt(h, m, cb, ...)
	table.insert(ig.crons, {
		h  = h,
		m  = m,
		cb = cb,
		args = {...}
	})
end

function ig.cron.OnTime(h, m)
	for i=1, #ig.crons, 1 do
		if ig.crons[i].h == h and ig.crons[i].m == m then
			ig.crons[i].cb(table.unpack(ig.crons[i].args))
		end
	end
end

--[[
local added = false
AddEventHandler("onServerResourceStart", function()
    if not added then
        ig.door.Add(Doors)
    end
    added = true
end)
]]--