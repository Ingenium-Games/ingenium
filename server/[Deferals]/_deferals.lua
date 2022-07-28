-- ====================================================================================--


AddEventHandler("playerConnecting", function(name, reject, d)
    local src = source
    --
    d.defer()    
    --
    Citizen.Wait(0)
    d.update("Checking User Account: Please Wait...")
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
                text = "Welcome "..name,
            }),
            DeferralCards.CardElement:TextBlock({
                text = "\nWebsite - "..conf.websitelink.." \nDiscord - "..conf.discordlink,
                wrap = true
            }),
            DeferralCards.CardElement:TextBlock({
                text = "By joinging, you have agreed to our rules as found on our website. \n",
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
    local id = c.func.identifier(src)
    local data = c.sql.user.Get(id)
    if data ~= nil then
        if data.Priority ~= nil then
            Queue.AddPriority(data.Steam_ID)
        end
    end
    --    
    local namecheck = name:match("%W")
    if namecheck then
        drop = true
        table.insert(facts.facts, DeferralCards.Container:Fact({
            title = "Issue ⁉️",
            value = "Your name contains forbidden characters."
        }))
    end
    if data ~= nil then
        if data.Ban then
            drop = true
            table.insert(facts.facts, DeferralCards.Container:Fact({
                title = "Issue ⁉️",
                value = "You have been banned by command or automatic event."
            }))
        end
    end
    --
    Citizen.Wait(0)
    d.update("If you get stuck here, please open Discord and try again...")
    --
    local discord = false
    if conf.discordperms then
        exports["discordroles"]:isRolePresent(src, conf.discordrole, function(hasRole, roles)
            if hasRole then
                discord = true
            else
                discord = false
                drop = true
                table.insert(facts.facts, DeferralCards.Container:Fact({
                    title = "Issue ⁉️",
                    value = "You have not joined our discord."
                }))
            end
        end)
    end
    --
    Citizen.Wait(0)
    d.update("Loading Awesome Server: Please Wait...")
    --
    table.insert(connecting.body, facts)
    if not drop then
        table.insert(connecting.body,
        DeferralCards.Container:ActionSet({
            actions = {
                DeferralCards.Action:Submit({
                    id = "Submit",
                    title = " 👋 - Click to Join",
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
                    title = " ✋ - Click to Leave",
                    data = {Submit = true}
                })
            }
        }))
    end
    --
    Citizen.Wait(2000)
    d.presentCard(json.encode(connecting), function(dete, raw)
        if dete.Submit then
            if drop then
                Citizen.Wait(0)
                d.done("You saw the reasons a moment ago, on an adaptive card. It renders all the reasons why you cannot join.")
                CancelEvent()
            else
                Citizen.Wait(0)
                joiningqueue(src, name, reject, d)
            end
        end 
    end)
end)