-- ====================================================================================--
-- Chat ACE Suggestions (ig.ace, ig.aces initialized in client/_var.lua)
-- Chat Suggestions get added based on user ACE permissions / grade.
-- ====================================================================================--


ig.ace.public = function()
    -- public
    --
    TriggerEvent("chat:addSuggestion", "/switch", _L("switch"))
    --
end

ig.ace.mod = function()
    -- public
    ig.ace.public()
    -- mod
    --
    TriggerEvent("chat:addSuggestion", "/setjob", _L("setjob"), {{
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
    TriggerEvent("chat:addSuggestion", "/revive", _L("revive"), {{
        name = "1",
        help = "* ID"
    }})
    --
    TriggerEvent("chat:addSuggestion", "/heal", _L("heal"), {{
        name = "1",
        help = "* ID"
    }})

end

ig.ace.admin = function()
    -- mod
    ig.ace.mod()
    -- admin
    --
    TriggerEvent("chat:addSuggestion", "/car", _L("car"), {{
        name = "1",
        help = "Name or Hash"
    }})
    --
    TriggerEvent("chat:addSuggestion", "/ban", _L("ban"), {{
        name = "1",
        help = "Server ID"
    }})
    --
    TriggerEvent("chat:addSuggestion", "/kick", _L("kick"), {{
        name = "1",
        help = "Server ID"
    }})
    --
    TriggerEvent("chat:addSuggestion", "/bring", _L("bring"), {{
        name = "1",
        help = "Server ID"
    }})
    --
    TriggerEvent("chat:addSuggestion", "/return", _L("return"), {{
        name = "1",
        help = "Server ID"
    }})
    --
    TriggerEvent("chat:addSuggestion", "/freeze", _L("freeze"), {{
        name = "1",
        help = "Server ID"
    }})

end

ig.ace.superadmin = function()
    -- admin
    ig.ace.admin()
    -- superadmin
    --

end

ig.ace.developer = function()
    -- superadmin
    ig.ace.superadmin()
    -- developer
    --       
    TriggerEvent("chat:addSuggestion", "/fx", _L("fx"), {{
        name = "1",
        help = "FX Name"
    }, {
        name = "2",
        help = "* Duration"
    }})
    --
    TriggerEvent("chat:addSuggestion", "/noclip", _L("noclip"), {})
    --
    TriggerEvent("chat:addSuggestion", "/cam", _L("cam"), {{
        name = "1",
        help = "* Name"
    }})
    --
    TriggerEvent("chat:addSuggestion", "/addoor", _L("addoor"), {{
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

ig.ace.owner = function()
    -- developer
    --    
    ig.ace.developer()

end

for k, v in pairs(ig.ace) do
    table.insert(ig.aces, k)
end

