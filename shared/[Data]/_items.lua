-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
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
            Registered = false,
            About = "A tangable form of currency.",
        },
        Data = {  -- This is the generic game data such as 
            "HashKey": "WEAPON_KNIFE",
            "NameGXT": "WT_KNIFE",
            "DescriptionGXT": "WTD_KNIFE",
            "Name": "Knife",
            "Description": "This carbon steel 7\" bladed knife is dual edged with a serrated spine to provide improved stabbing and thrusting capabilities.",
            "Group": "GROUP_MELEE",
            "ModelHashKey": "w_me_knife_01",
            "DefaultClipSize": 0,
            "Components": {},
            "Tints": [],
            "LiveryColors": [],
            "DLC": "core"
        }
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

local weapon_dump = exports["ig.dump"].GetWeapons()

c.items = { -- table of items

-- ====================================================================================--
-- Misc
-- ====================================================================================--

    ["Cash"] = {
        Name = "Cash",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 1,
        Value = 1,
        Weight = 0,
        Weapon = false,
        Meta = {
            Ammo = false,
            SerialNumber = false,
            BatchNumber = false,
            Crafted = false,
            Registered = false,
            About = "A tangable form of currency.",
        },
        Data = false,
        Craftable = false,
        Recipe = false,
        Materials = false,
        Stackable = true,
        Hotkey = false,
        Image = "Cash.png",
    },

-- ====================================================================================--
-- Weapons
-- ====================================================================================--

    -- ====================================================================================--
    -- Melee
    -- ====================================================================================--
    ["WEAPON_KNIFE"] = {
        Name = "Knife",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 20,
        Value = 35,
        Weight = 1,
        Weapon = "2578778090",
        Meta = {
            Ammo = false,
            SerialNumber = false,
            BatchNumber = false,
            Crafted = false,
            Registered = false,
            About = "A sharp tool used for skinning.",
        },
        Data = weapon_dump["2578778090"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 1
        }, {
            ItemRequired = "Blade",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Image = "WEAPON_KNIFE.png",
    },
    ["WEAPON_NIGHTSTICK"] = {
        Name = "Nightstick",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 30,
        Value = 50,
        Weight = 2,
        Weapon = "1737195953",
        Meta = {
            Ammo = false,
            SerialNumber = false,
            BatchNumber = false,
            Crafted = false,
            Registered = false,
            About = "A beat stick, for the typical beat cop.",
        },
        Data = weapon_dump["1737195953"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 1
        }, {
            ItemRequired = "Metal Rod",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Image = "WEAPON_NIGHTSTICK.png",
    },
    ["WEAPON_HAMMER"] = {
        Name = "Hammer",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 20,
        Value = 32,
        Weight = 1.35,
        Weapon = "1317494643",
        Meta = {
            Ammo = false,
            SerialNumber = false,
            BatchNumber = false,
            Crafted = false,
            Registered = false,
            About = "Crafty and useful for many situations.",
        },
        Data = weapon_dump["1317494643"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 1
        }, {
            ItemRequired = "Scrap Metal",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Image = "WEAPON_HAMMER.png",
    },
    ["WEAPON_BAT"] = {
        Name = "Baseball Bat",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 30,
        Value = 50,
        Weight = 2,
        Weapon = "2508868239",
        Meta = {
            Ammo = false,
            SerialNumber = false,
            BatchNumber = false,
            Crafted = false,
            Registered = false,
            About = "Home invader? Hit them like a home run!.",
        },
        Data = weapon_dump["2508868239"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 1
        }, {
            ItemRequired = "Scrap Metal",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Image = "WEAPON_BAT.png",
    },
    ["WEAPON_GOLFCLUB"] = {
        Name = "Golf Club",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 65,
        Value = 100,
        Weight = 1.65,
        Weapon = "1141786504",
        Meta = {
            Ammo = false,
            SerialNumber = false,
            BatchNumber = false,
            Crafted = false,
            Registered = false,
            About = "PGA certified for an extra $50.",
        },
        Data = weapon_dump["1141786504"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 1
        }, {
            ItemRequired = "Metal Rod",
            Quantity = 1
        }, {
            ItemRequired = "Scrap Metal",
            Quantity = 2
        }},
        Stackable = false,
        Hotkey = true,
        Image = "WEAPON_GOLFCLUB.png",
    },
    ["WEAPON_CROWBAR"] = {
        Name = "Crowbar",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 45,
        Value = 85,
        Weight = 3,
        Weapon = "2508868239",
        Meta = {
            Ammo = false,
            SerialNumber = false,
            BatchNumber = false,
            Crafted = false,
            Registered = false,
            About = "Tool of choice for many.",
        },
        Data = weapon_dump["2508868239"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Metal Rod",
            Quantity = 1
        }, {
            ItemRequired = "Scrap Metal",
            Quantity = 2
        }},
        Stackable = false,
        Hotkey = true,
        Image = "WEAPON_CROWBAR.png",
    },

    -- ====================================================================================--
    -- Pistol
    -- ====================================================================================--

    ["WEAPON_PISTOL"] = {
        Name = "Pistol",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 285,
        Value = 425,
        Weight = 3,
        Weapon = "453432689",
        Meta = {
            Ammo = "9mm",
            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "Fires standard 9mm rounds.",
        },
        Data = weapon_dump["453432689"],
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
        Image = "WEAPON_PISTOL.png",
    },


    ["WEAPON_SNSPISTOL"] = {
        Name = "SNS Pistol",
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
            Registered = false,
            About = "Commonly contained in a cigerrete packet.",
        },
        Data = weapon_dump["3218215474"],
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
        Image = "WEAPON_SNSPISTOL.png",
    },










}

if IsDuplicityVersion() then
    c.json.Write(conf.file.items, c.items)
end
setmetatable(c.items, c.meta)