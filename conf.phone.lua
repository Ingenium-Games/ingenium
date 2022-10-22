conf.phone = {
    police = 911,
    medic = 919,
    bank = 100,
    mechanic = 800,
    logistics = 660,

    
}

function GetJobNumbers()
    return conf.phone
end

exports("GetJobNumbers", GetJobNumbers)

function GetJobNumber(job)
    return conf.phone[job]
end

exports("GetJobNumber", GetJobNumber)