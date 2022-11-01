-- ====================================================================================--
c.ace = {}
c.aces = {}

-- ====================================================================================--

c.ace.public = function()
    -- public
    --
    TriggerEvent("chat:addSuggestion", "/switch", "Use to change your character(s).")
    --
end

c.ace.mod = function()
    -- public
    c.ace.public()
    -- mod
    --
    TriggerEvent("chat:addSuggestion", "/setjob", "Mod Permission(s) Required.", {{
        name = "1",
        help = "ID"
    }, {
        name = "2",
        help = "Name"
    }, {
        name = "3",
        help = "Grade"
    }})
    --
    TriggerEvent("chat:addSuggestion", "/revive", "Mod Permission(s) Required.", {{
        name = "1",
        help = "* ID"
    }})
    --
    TriggerEvent("chat:addSuggestion", "/heal", "Mod Permission(s) Required.", {{
        name = "1",
        help = "* ID"
    }})

end

c.ace.admin = function()
    -- mod
    c.ace.mod()
    -- admin
    --
    TriggerEvent("chat:addSuggestion", "/car", "Mod Permission(s) Required.", {{
        name = "1",
        help = "Name or Hash"
    }})
    --
    TriggerEvent("chat:addSuggestion", "/ban", "Admin Permission(s) Required.", {{
        name = "1",
        help = "Server ID"
    }})
    --
    TriggerEvent("chat:addSuggestion", "/kick", "Admin Permission(s) Required.", {{
        name = "1",
        help = "Server ID"
    }})
    --
    TriggerEvent("chat:addSuggestion", "/bring", "Admin Permission(s) Required.", {{
        name = "1",
        help = "Server ID"
    }})
    --
    TriggerEvent("chat:addSuggestion", "/return", "Admin Permission(s) Required.", {{
        name = "1",
        help = "Server ID"
    }})
    --
    TriggerEvent("chat:addSuggestion", "/freeze", "Admin Permission(s) Required.", {{
        name = "1",
        help = "Server ID"
    }})

end

c.ace.superadmin = function()
    -- admin
    c.ace.admin()
    -- superadmin
    --

end

c.ace.developer = function()
    -- superadmin
    c.ace.superadmin()
    -- developer
    --       
    TriggerEvent("chat:addSuggestion", "/fx", "Developer Permission(s) Required.", {{
        name = "1",
        help = "FX Name"
    }, {
        name = "2",
        help = "* Duration"
    }})
    --
    TriggerEvent("chat:addSuggestion", "/noclip", "Developer Permission(s) Required.", {})
    --
    TriggerEvent("chat:addSuggestion", "/cam", "Developer Permission(s) Required.", {{
        name = "1",
        help = "* Name"
    }})
    --
    TriggerEvent("chat:addSuggestion", "/addoor", "Developer Permission(s) Required.", {{
        name = "1",
        help = "* Name"
    }, {
        name = "2",
        help = "* 0 = Unlocked, 1 = Locked"
    }, {
        name = "3",
        help = "* Job"
    }, {
        name = "4",
        help = "* Item"
    }, {
        name = "5",
        help = "* Time"
    }, {
        name = "6",
        help = "* At Time: 0 = Unlocked, 1 = Locked"
    }})
end

c.ace.owner = function()
    -- developer
    --    
    c.ace.developer()

end

for k, v in pairs(c.ace) do
    table.insert(c.aces, k)
end

