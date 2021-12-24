-- ====================================================================================--

c.ace = {}
c.aces = {}
--[[
NOTES
    - Aces are now run based off the xPlayer (Player(id).state) table containing the Ace.
]] --

-- ====================================================================================--

c.ace.public = function()
    -- public
    TriggerEvent("chat:addSuggestion", "/switch", "Use to change your character(s).")

end

c.ace.mod = function()
    -- public
    c.ace.public()

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

    TriggerEvent("chat:addSuggestion", "/car", "Admin Permission(s) Required.", {{
        name = "1",
        help = "Vehicle Name or Hash"
    }})
    
end

c.ace.admin = function()
    -- mod
    c.ace.mod()

    -- admin

    TriggerEvent("chat:addSuggestion", "/ban", "Admin Permission(s) Required.", {{
        name = "1",
        help = "Server ID"
    }})

    TriggerEvent("chat:addSuggestion", "/kick", "Admin Permission(s) Required.", {{
        name = "1",
        help = "Server ID"
    }})

    TriggerEvent("chat:addSuggestion", "/bring", "Admin Permission(s) Required.", {{
        name = "1",
        help = "Server ID"
    }})

    TriggerEvent("chat:addSuggestion", "/return", "Admin Permission(s) Required.", {{
        name = "1",
        help = "Server ID"
    }})

    TriggerEvent("chat:addSuggestion", "/freeze", "Admin Permission(s) Required.", {{
        name = "1",
        help = "Server ID"
    }})
    
end

c.ace.superadmin = function()   
    -- admin
    c.ace.admin()

end

c.ace.developer = function()     
    -- admin
    c.ace.superadmin()
    
end

c.ace.owner = function()     
    -- admin
    c.ace.developer()
    

end

for k,v in pairs(c.ace) do
    table.insert(c.aces, k)
end

