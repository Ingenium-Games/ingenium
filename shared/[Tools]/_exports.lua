-- Local server or Client sided.
function GetLocale()
    return c.locale
end
exports("GetLocale", GetLocale)
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
