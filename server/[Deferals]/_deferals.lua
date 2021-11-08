-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
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
                size = 'Medium',
                weight = 'Bolder',
                text = 'Welcome '..name,
            }),
            DeferralCards.CardElement:TextBlock({
                text = '__**Notice:**__ If you see any _Issues_ below this line, then you may need to take a screenshot and report it to __**THIS SERVER**__, as they are preventing you from joining. General Contact information can be found here: '..conf.discordlink,
                wrap = true
            })
        }})
    )
    local id = c.identifier(src)
    --    
    local namecheck = name:match("%W")
    if namecheck then
        drop = true
        table.insert(facts.facts, DeferralCards.Container:Fact({
            title = "Issue",
            value = "Your name contains forbidden characters."
        }))
    end

    local ban = c.sql.user.GetBan(id)
    if ban then
        drop = true
        table.insert(facts.facts, DeferralCards.Container:Fact({
            title = "Issue",
            value = "You have been banned by command or automatic event."
        }))
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
                    title = "Issue",
                    value = "You have not joined our discord."
                }))
            end
        end)
    end
    --
    table.insert(connecting.body, facts)
    if not drop then
        table.insert(connecting.body,
        DeferralCards.Container:ActionSet({
            actions = {
                DeferralCards.Action:Submit({
                    id = 'Submit',
                    title = 'Click to Join',
                    data = {Submit = true}
                })
            }
        }))
    else
        table.insert(connecting.body,
        DeferralCards.Container:ActionSet({
            actions = {
                DeferralCards.Action:Submit({
                    id = 'Submit',
                    title = 'Click to Leave',
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
                reject("You saw the reasons a moment ago, on an adaptive card. It renders all the reasons why you cannot join.")
                CancelEvent()
            else
                -- Send to the queue.
                Citizen.Wait(0)
                -- Too alter and present cards from _queue.lua
                d.done()
            end
        end 
    end)
end)