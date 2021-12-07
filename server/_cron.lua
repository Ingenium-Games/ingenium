-- ====================================================================================--

c.cron = {} -- functions
c.crons = {} -- table of jobs to action @ times.
--[[
NOTES.
    - Simple Cron Handler based on hours and minutes only.
    - No need to add days intot he mix as generally all time based events within
    - FiveM Game modes are not relyant on days.
]]--

-- ====================================================================================--

--- [F] - Add Functino be be called back @ Hour and Minute.
function c.cron.Add(h, m, cb)
	local h = c.check.Number(h, 0, 23)
	local m = c.check.Number(m, 0, 59)
	table.insert(c.crons, {
		h  = h,
		m  = m,
		cb = cb
	})
end

-- Can be found within the c.time.Update() function.
--- Internal [F] - Add a function to be called once @ Hour and Minute. 
---@param h number "0-23"
---@param m number "0-59"
function c.cron.Action(h, m)
	for i=1, #c.crons, 1 do
		if c.crons[i].h == h and c.crons[i].m == m then
			c.crons[i].cb(h, m)
		end
	end
end

