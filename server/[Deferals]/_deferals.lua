-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--

AddEventHandler("playerConnecting", function(name, skr, d)
    --    
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
    local facts = DeferralCards.Container:FactSet()
    table.insert(connecting.body, DeferralCards.Container:Create({
        items = {
            DeferralCards.CardElement:TextBlock({
                size = 'Medium',
                weight = 'Bolder',
                text = 'Welcome '..name,
            }),
            DeferralCards.CardElement:TextBlock({
                text = 'Note: If you see any __**Issues**__ below this point, then you may need to take a screenshot and report it to __**THIS SERVER**__, as they are preventing you from joining.',
                wrap = true
            })
        }})
    )
    local id = c.identifier(src)
    --    
    local namecheck = name:match("%W")
    if namecheck then
        drop = true
        print('drop')
        table.insert(facts, DeferralCards.Container:Fact({
            title = "Issue",
            value = "Your name contains forbidden characters."
        }))
    end

    local ban = c.sql.user.GetBan(id)
    if ban then
        drop = true
        print('drop 2')
        table.insert(facts, DeferralCards.Container:Fact({
            title = "Issue",
            value = "You have been banned."
        }))
    end
    --
    local discord = false
    if conf.discordperms then
        exports["discordroles"]:isRolePresent(src, conf.discordrole, function(hasRole, roles)
            if hasRole then
                discord = true
            else
                discord = false
                print('drop 3')
                drop = true
                table.insert(facts, DeferralCards.Container:Fact({
                    title = "Issue",
                    value = "You have not joined our discord."
                }))
            end
        end)
    end
    --
    table.insert(connecting.body, facts)
    table.insert(connecting.body,
    DeferralCards.Container:ActionSet({
        actions = {
            DeferralCards.Action:Submit({
                id = 'Submit',
                title = 'Continue',
                data = {Submit = true}
            })
        }
    }))
    --
    Citizen.Wait(2000)
    d.presentCard(json.encode(connecting), function(data, raw)
        if data.Submit then
            if drop then
                Citizen.Wait(0)
                d.done("Connection canceled per the formentioned reasons.")
            else
                Citizen.Wait(0)
                d.done()
            end
        end 
    end)
end)