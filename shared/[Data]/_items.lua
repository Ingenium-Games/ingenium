-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[

Ok so this is the block of code for all you people to copy, paste, and prefill at the bottom of this page.

    COPY START BELOW HERE!

    ["Scorpion"] = {
        Label = "Scorpion", -- name
        Degrade = false,    -- boolean
        DegradeRate = 0.0,  -- rate
        Quality = 100,  -- Starting Quality
        Quantity = 1,   -- Is one? or many?
        Cost = 850,    -- Cost to make
        Value = 1520,   -- Sell Value
        Weight = 4, -- Weight
        Weapon = "-1121678507", -- Becasue anything other than false or 0 is true. G G
        Meta = {    -- Any data you want, Weapons MUST have the three below.
            Ammo = "9mm",
            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false
        },
        Data = "",  -- Displayable string on inventory.
        Craftable = true,   -- can this be made? if so, add materials.
        Recipe = true, -- require the know how
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 4
        }, {
            ItemRequired = "CarbonAlloy",
            Quantity = 2
        }, {
            ItemRequired = "ShortBarrel",
            Quantity = 1
        }, {
            ItemRequired = "PistolPin",
            Quantity = 1
        }, {
            ItemRequired = "PistolFrame",
            Quantity = 1
        }, {
            ItemRequired = "AutoReciever",
            Quantity = 1
        }},
        Stackable = false, -- Can you put them on top of each other?
        Hotkey = false, -- can it be used with 1-5 slots?
        Image = "Scorpion.png", -- image to render client side.
    },

    ^ COPY END HERE OK, OK!

    Let me break it down for you guys, becasue all your economy servers are a joke.
    Life needs to be hard. People need to struggle to make a story real and genuine.
    Stop giving your players a million dollars a day, because they are self entitled pricks.
    Im not important, you're not important, get over it.

    Want to be different? - Find a cure for cancer cunt.
    I'll suck your dick if you do.

]]--

-- ====================================================================================--

c.items = { -- table of items

-- Weapons

    ["SNS"] = {
        Name = "SNS",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 160,
        Value = 324,
        Weight = 1,
        Weapon = "3218215474",
        Meta = {
            Ammo = "9mm",
            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false
        },
        Data = "",
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 2
        }, {
            ItemRequired = "PistolPin",
            Quantity = 1
        }, {
            ItemRequired = "PistolFrame",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Image = "SNS.png",
    },

    ["Pistol"] = {
        Name = "Pistol",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 285,
        Value = 425,
        Weight = 3,
        Weapon = "-1075685676",
        Meta = {
            Ammo = "9mm",
            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false
        },
        Data = "",
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 2
        }, {
            ItemRequired = "CarbonAlloy",
            Quantity = 1
        }, {
            ItemRequired = "ShortBarrel",
            Quantity = 1
        }, {
            ItemRequired = "PistolPin",
            Quantity = 1
        }, {
            ItemRequired = "PistolFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Image = "Pistol.png",
    },








}


-- ====================================================================================--
-- If this is the server,,,
-- Wait until the resources are hopefully finished loading by reading the console output fot the cfx.re tebex line.
-- We may have to make a final resource to jerry rig this if not the case.
if IsDuplicityVersion() then
    RegisterConsoleListener(function(channel, string)
        if channel == conf.consolechannel and string == conf.lock then
            c.json.Write(conf.file.items, c.items)
            setmetatable(c.items, c.meta)
            c.debug_2("Item's table locked")        
        end
    end)
end
-- ====================================================================================--