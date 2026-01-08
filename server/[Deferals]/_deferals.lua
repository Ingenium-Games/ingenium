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
    if conf.discord.permissions then
        exports["discordroles"]:isRolePresent(src, conf.discord.role, function(hasRole, roles)
            if hasRole then
                discord = true
            else
                discord = false
                drop = true
                table.insert(facts.facts, DeferralCards.Container:Fact({
                    title = _("defer_issue"),
                    value = _("defer_no_discord")
                }))
            end
        end)
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