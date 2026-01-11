-- ====================================================================================--

AddEventHandler("playerConnecting", function(name, reject, d)
    local src = source
    --
    d.defer()    
    --
    Citizen.Wait(0)
    d.update(_("defer_checking_account"))
    --
    local drop = false
    local name = GetPlayerName(src)
    --
    local connecting = DeferralCards.Card:Create()
    local facts = DeferralCards.Container:FactSet({facts = {}})
    table.insert(connecting.body, DeferralCards.Container:Create({
        items = {
            DeferralCards.CardElement:TextBlock({
                size = "Medium",
                weight = "Bolder",
                text = string.format(_("defer_welcome"), name),
            }),
            DeferralCards.CardElement:TextBlock({
                text = _("defer_loading"),
                wrap = true
            }),
            DeferralCards.CardElement:TextBlock({
                text = _("defer_rules_agreement"),
                wrap = true
            }),
            DeferralCards.Container:Create({
                items = {
                    DeferralCards.CardElement:TextBlock({
                        text = "",
                        wrap = true
                    })
                }})
        }})
    )
    --
    local id = ig.func.identifier(src)
    local data = ig.sql.user.Get(id)
    if data ~= nil then
        if data.Priority ~= nil then
            Queue.AddPriority(data.Steam_ID)
        end
    end
    
    -- Add Discord-based priority to queue
    if conf.discord.priority_enabled then
        local discordPrioritySet = false
        ig.discord.HasAnyRole(src, 
            (function()
                local roleIds = {}
                if conf.discord.priority_roles then
                    for _, role in ipairs(conf.discord.priority_roles) do
                        table.insert(roleIds, role.id)
                    end
                end
                return roleIds
            end)(),
            function(hasAnyRole, matchedRoles)
                if hasAnyRole and #matchedRoles > 0 then
                    -- Find highest priority from matched roles
                    local highestPower = 0
                    for _, matchedRoleId in ipairs(matchedRoles) do
                        for _, priorityRole in ipairs(conf.discord.priority_roles) do
                            if priorityRole.id == matchedRoleId and priorityRole.power > highestPower then
                                highestPower = priorityRole.power
                            end
                        end
                    end
                    
                    if highestPower > 0 then
                        -- Get player identifiers for queue priority
                        local ids = Queue:GetIds(src)
                        if ids and ids[1] then
                            Queue.AddPriority(ids[1], highestPower)
                        end
                    end
                end
                discordPrioritySet = true
            end
        )
        
        -- Wait for Discord priority check to complete
        while not discordPrioritySet do
            Citizen.Wait(100)
        end
    end
    --[[ 

        This section detects any non alphanumeric characters in usernames. 
        This was to help in conjunciton with the whole, people useing innerHTML rather than innerText in NUI resources. 
        Becasue people would run scripts for names and crash your shit. 
        Well, since this also stops people with spaces in their names from joining, Im commenting it out.
    
    local namecheck = name:match("%W")
    if namecheck then
        drop = true
        table.insert(facts.facts, DeferralCards.Container:Fact({
            title = _("defer_issue"),
            value = _("defer_forbidden_characters")
        }))
    end
    if data ~= nil then
        if data.Ban then
            drop = true
            table.insert(facts.facts, DeferralCards.Container:Fact({
                title = _("defer_issue"),
                value = _("defer_banned")
            }))
        end
    end
    ]]--
    --
    Citizen.Wait(0)
    d.update(_("defer_stuck_message"))
    --
    local discord = false
    local discordCheckComplete = false
    
    if conf.discord.permissions then
        -- Use internal Discord module
        ig.discord.HasMemberRole(src, function(hasMemberRole)
            discord = hasMemberRole
            discordCheckComplete = true
            
            if not hasMemberRole then
                drop = true
                table.insert(facts.facts, DeferralCards.Container:Fact({
                    title = _("defer_issue"),
                    value = _("defer_no_discord")
                }))
            end
        end)
        
        -- Wait for Discord check to complete
        while not discordCheckComplete do
            Citizen.Wait(100)
        end
    else
        discordCheckComplete = true
    end
    --
    Citizen.Wait(0)
    d.update(_("defer_loading_server"))
    --
    table.insert(connecting.body, facts)
    if not drop then
        table.insert(connecting.body,
        DeferralCards.Container:ActionSet({
            actions = {
                DeferralCards.Action:Submit({
                    id = "Submit",
                    title = _("defer_click_to_join"),
                    data = {Submit = true}
                })
            }
        }))
    else
        table.insert(connecting.body,
        DeferralCards.Container:ActionSet({
            actions = {
                DeferralCards.Action:Submit({
                    id = "Submit",
                    title = _("defer_click_to_leave"),
                    data = {Submit = true}
                })
            }
        }))
    end
    --
    Citizen.Wait(2000)
    d.presentCard(json.encode(connecting), function(data, raw)
        if data.Submit then
            if drop then
                Citizen.Wait(0)
                d.done(_("defer_rejection_message"))
                CancelEvent()
            else
                Citizen.Wait(0)
                ig.queue.Join(src, name, reject, d)
            end
        end 
    end)
end)