-- ====================================================================================--

function core_Queue(source, name, data, reject, defferals)
    local src = source
    local name = name
    Citizen.Wait(0)
    defferals.update("Adding "..name..", to queue system and checking for priotity")
    Citizen.Wait(1000)
    local ids = Queue:GetIds(src)
    local connectTime = os_time()
    local connecting = true

    Citizen.CreateThread(function()
        while connecting do
            Citizen.Wait(100)
            if not connecting then return end
            deferrals.update(QConfig.Language.connecting)
        end
    end)

    if data.Priority then
        Queue:AddPriority(tostring(data.Steam_ID), 1)
    end
    Citizen.Wait(500)

    local function done(msg, _deferrals)
        connecting = false

        local deferrals = _deferrals or deferrals

        if msg then deferrals.update(tostring(msg) or "") end

        Citizen.Wait(500)

        if not msg then
            deferrals.done()
            if QConfig.EnableGrace then Queue:AddPriority(ids[1], QConfig.GracePower, QConfig.GraceTime) end
        else
            deferrals.done(tostring(msg) or "") CancelEvent()
        end

        return
    end

    local function update(msg, _deferrals)
        local deferrals = _deferrals or deferrals
        connecting = false
        deferrals.update(tostring(msg) or "")
    end

    if not ids then
        -- prevent joining
        done(QConfig.Language.iderr)
        CancelEvent()
        Queue:DebugPrint("Dropped " .. name .. ", couldn't retrieve any of their id's")
        return
    end

    if QConfig.RequireSteam and not Queue:IsSteamRunning(src) then
        -- prevent joining
        done(QConfig.Language.steam)
        CancelEvent()
        return
    end

    local allow

    Queue:CanJoin(src, function(reason)
        if reason == nil or allow ~= nil then return end
        if reason == false or #_Queue.JoinCbs <= 0 then allow = true return end

        if reason then
            -- prevent joining
            allow = false
            done(reason and tostring(reason) or "You were blocked from joining")
            Queue:RemoveFromQueue(ids)
            Queue:RemoveFromConnecting(ids)
            Queue:DebugPrint(string_format("%s[%s] was blocked from joining; Reason: %s", name, ids[1], reason))
            CancelEvent()
            return
        end

        allow = true
    end) 

    while allow == nil do Citizen.Wait(0) end
    if not allow then return end

    if QConfig.PriorityOnly and not Queue:IsPriority(ids) then done(QConfig.Language.wlonly) return end

    local rejoined = false

    if Queue:IsInConnecting(ids, false, true) then
        Queue:RemoveFromConnecting(ids)

        if Queue:NotFull() then
            -- let them in the server

            if not Queue:IsInQueue(ids) then
                Queue:AddToQueue(ids, connectTime, name, src, deferrals)
            end

            local added = Queue:AddToConnecting(ids, true, true, done)
            if not added then CancelEvent() return end
            done()

            return
        else
            rejoined = true
        end
    end

    if Queue:IsInQueue(ids) then
        rejoined = true
        Queue:UpdatePosData(src, ids, deferrals)
        Queue:DebugPrint(string_format("%s[%s] has rejoined queue after cancelling", name, ids[1]))
    else
        Queue:AddToQueue(ids, connectTime, name, src, deferrals)

        if rejoined then
            Queue:SetPos(ids, 1)
            rejoined = false
        end
    end

    local pos, data = Queue:IsInQueue(ids, true)
    
    if not pos or not data then
        done(QConfig.Language.err .. " [1]")

        Queue:RemoveFromQueue(ids)
        Queue:RemoveFromConnecting(ids)

        CancelEvent()
        return
    end

    if Queue:NotFull(true) and _Queue.JoinDelay <= GetGameTimer() then
        -- let them in the server
        local added = Queue:AddToConnecting(ids, true, true, done)
        if not added then CancelEvent() return end

        done()
        Queue:DebugPrint(name .. "[" .. ids[1] .. "] is loading into the server")

        return
    end
    
    update(string_format(QConfig.Language.pos .. ((Queue:TempSize() and QConfig.ShowTemp) and " (" .. Queue:TempSize() .. " temp)" or "00:00:00"), pos, Queue:GetSize(), ""))

    if rejoined then return end

    while true do
        Citizen.Wait(500)

        local pos, data = Queue:IsInQueue(ids, true)

        local function remove(msg)
            if data then
                if msg then
                    update(msg, data.deferrals)
                end

                Queue:RemoveFromQueue(data.source, true)
                Queue:RemoveFromConnecting(data.source, true)
            else
                Queue:RemoveFromQueue(ids)
                Queue:RemoveFromConnecting(ids)
            end
        end

        if not data or not data.deferrals or not data.source or not pos then
            remove("[Queue] Removed from queue, queue data invalid :(")
            Queue:DebugPrint(tostring(name .. "[" .. ids[1] .. "] was removed from the queue because they had invalid data"))
            return
        end

        local endPoint = GetPlayerEndpoint(data.source)
        if not endPoint then data.timeout = data.timeout + 0.5 else data.timeout = 0 end

        if data.timeout >= QConfig.QueueTimeOut and os_time() - connectTime > 5 then
            remove("[Queue] Removed due to timeout")
            Queue:DebugPrint(name .. "[" .. ids[1] .. "] was removed from the queue because they timed out")
            return
        end

        if pos <= 1 and Queue:NotFull() and _Queue.JoinDelay <= GetGameTimer() then
            -- let them in the server
            local added = Queue:AddToConnecting(ids)

            update(QConfig.Language.joining, data.deferrals)
            Citizen.Wait(500)

            if not added then
                done(QConfig.Language.connectingerr)
                CancelEvent()
                return
            end

            done(nil, data.deferrals)

            if QConfig.EnableGrace then Queue:AddPriority(ids[1], QConfig.GracePower, QConfig.GraceTime) end

            Queue:RemoveFromQueue(ids)
            Queue:DebugPrint(name .. "[" .. ids[1] .. "] is loading into the server")
            return
        end

        local seconds = data.queuetime()
        local qTime = string_format("%02d", math_floor((seconds % 86400) / 3600)) .. ":" .. string_format("%02d", math_floor((seconds % 3600) / 60)) .. ":" .. string_format("%02d", math_floor(seconds % 60))

        local msg = string_format(QConfig.Language.pos .. ((Queue:TempSize() and QConfig.ShowTemp) and " (" .. Queue:TempSize() .. " temp)" or ""), pos, Queue:GetSize(), qTime)
        update(msg, data.deferrals)
    end
end