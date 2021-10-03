-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.ace = {"public","mod","admin","superadmin","developer","owner"}
c.aces = {}
--[[
NOTES
    - Aces are now run based off the xPlayer (Player(id).state) table containing the Ace.
]] --
math.randomseed(c.Seed)
-- ====================================================================================--

c.aces.public = function()
    -- public
    TriggerEvent("chat:addSuggestion", "/switch", "Use to change your character(s).")
end

c.aces.mod = function()
    -- public
    c.aces.public()

    -- mod

    TriggerEvent("chat:addSuggestion", "/setjob", "Admin Permission(s) Required.", {{
        name = "1",
        help = "Server ID"
    }, {
        name = "2",
        help = "Job Name"
    }, {
        name = "3",
        help = "Job Grade"
    }})
    
end

c.aces.admin = function()
    -- mod
    c.aces.mod()

    -- admin

    TriggerEvent("chat:addSuggestion", "/ban", "Admin Permission(s) Required.", {{
        name = "1",
        help = "Server ID"
    }})

    TriggerEvent("chat:addSuggestion", "/kick", "Admin Permission(s) Required.", {{
        name = "1",
        help = "Server ID"
    }})
end

c.aces.superadmin = function()   
    -- admin
    c.aces.admin()

end

c.aces.developer = function()     
    -- admin
    c.aces.superadmin()
    
end

c.aces.owner = function()     
    -- admin
    c.aces.developer()
    

end