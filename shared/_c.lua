-- ====================================================================================--
c = {}
-- ====================================================================================--
-- Core Export
exports("c", function()
	return c
end)
-- ====================================================================================--
-- Phone Numbers Exports
function GetJobNumbers()
    return conf.phone
end
exports("GetJobNumbers", GetJobNumbers)
--
function GetJobNumber(job)
    return conf.phone[job]
end
exports("GetJobNumber", GetJobNumber)
--
