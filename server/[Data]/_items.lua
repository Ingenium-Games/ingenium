-- ====================================================================================--
local weapon_dump = exports["ig.dump"]:GetWeapons()
-- ====================================================================================--

--[[
    [""] = {
        Name = "",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 1,
        Value = 1,
        Weight = 0,
        Weapon = false,
        Meta = false,
        Data = false,
        Craftable = false,
        Recipe = false,
        Materials = false,
        Stackable = true,
        Consumeable = false,
        Hotkey = false,
        Image = ".png"
    },
]] --

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
        Meta = false,
        Data = false,
        Craftable = false,
        Recipe = false,
        Materials = false,
        Stackable = true,
        Consumeable = false,
        Hotkey = false,
        Image = "Cash.png"
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
            Attachments = {},
            SerialNumber = false,
            BatchNumber = false,
            Crafted = false,
            Registered = false,
            About = "A sharp tool used for skinning."
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
        Consumeable = false,
        Image = "WEAPON_KNIFE.png"
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
            Attachments = {},

            SerialNumber = false,
            BatchNumber = false,
            Crafted = false,
            Registered = false,
            About = "A beat stick, for the typical beat cop."
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
        Consumeable = false,
        Image = "WEAPON_NIGHTSTICK.png"
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
            Attachments = {},

            SerialNumber = false,
            BatchNumber = false,
            Crafted = false,
            Registered = false,
            About = "Crafty and useful for many situations."
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
        Consumeable = false,
        Image = "WEAPON_HAMMER.png"
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
            Attachments = {},

            SerialNumber = false,
            BatchNumber = false,
            Crafted = false,
            Registered = false,
            About = "Home invader? Hit them like a home run!."
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
        Consumeable = false,
        Image = "WEAPON_BAT.png"
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
            Attachments = {},

            SerialNumber = false,
            BatchNumber = false,
            Crafted = false,
            Registered = false,
            About = "PGA certified for an extra $50."
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
        Consumeable = false,
        Image = "WEAPON_GOLFCLUB.png"
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
            Attachments = {},

            SerialNumber = false,
            BatchNumber = false,
            Crafted = false,
            Registered = false,
            About = "Tool of choice for many."
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
        Consumeable = false,
        Image = "WEAPON_CROWBAR.png"
    },
    ["WEAPON_SWITCHBLADE"] = {
        Name = "Switchblade",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 75,
        Value = 120,
        Weight = 3,
        Weapon = "3756226112",
        Meta = {
            Ammo = false,
            Attachments = {},

            SerialNumber = false,
            BatchNumber = false,
            Crafted = false,
            Registered = false,
            About = "Kids play with these."
        },
        Data = weapon_dump["3756226112"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 1
        }, {
            ItemRequired = "Spring",
            Quantity = 1
        }, {
            ItemRequired = "Scrap Metal",
            Quantity = 2
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_SWITCHBLADE.png"
    },
    ["WEAPON_STONE_HATCHET"] = {
        Name = "Stone Hatchet",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 150,
        Value = 500,
        Weight = 3,
        Weapon = "940833800",
        Meta = {
            Ammo = false,
            Attachments = {},

            SerialNumber = false,
            BatchNumber = false,
            Crafted = false,
            Registered = false,
            About = "Rust, v2"
        },
        Data = weapon_dump["940833800"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Stick",
            Quantity = 1
        }, {
            ItemRequired = "Rock",
            Quantity = 1
        }, {
            ItemRequired = "Animal Parts",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_STONE_HATCHET.png"
    },
    ["WEAPON_BOTTLE"] = {
        Name = "Broken Bottle",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 75,
        Value = 120,
        Weight = 3,
        Weapon = "4192643659",
        Meta = {
            Ammo = false,
            Attachments = {},

            SerialNumber = false,
            BatchNumber = false,
            Crafted = false,
            Registered = false,
            About = "Drunks and Bums love to fight with these."
        },
        Data = weapon_dump["4192643659"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 1
        }, {
            ItemRequired = "Spring",
            Quantity = 1
        }, {
            ItemRequired = "Scrap Metal",
            Quantity = 2
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_BOTTLE.png"
    },
    ["WEAPON_BATTLEAXE"] = {
        Name = "Battleaxe",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 435,
        Value = 650,
        Weight = 3,
        Weapon = "4192643659",
        Meta = {
            Ammo = false,
            Attachments = {},

            SerialNumber = false,
            BatchNumber = false,
            Crafted = false,
            Registered = false,
            About = "There is roleplaying, then there is DnD"
        },
        Data = weapon_dump["4192643659"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Metal Rod",
            Quantity = 1
        }, {
            ItemRequired = "Scrap Metal",
            Quantity = 4
        }, {
            ItemRequired = "Carbon Alloy",
            Quantity = 2
        }, {
            ItemRequired = "Rubber",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_BATTLEAXE.png"
    },
    ["WEAPON_POOLCUE"] = {
        Name = "Poolcue",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 135,
        Value = 250,
        Weight = 3,
        Weapon = "2484171525",
        Meta = {
            Ammo = false,
            Attachments = {},

            SerialNumber = false,
            BatchNumber = false,
            Crafted = false,
            Registered = false,
            About = "A friendly game until it's not."
        },
        Data = weapon_dump["2484171525"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Stick",
            Quantity = 1
        }, {
            ItemRequired = "Paint",
            Quantity = 1
        }, {
            ItemRequired = "Sand Paper",
            Quantity = 2
        }, {
            ItemRequired = "Rubber",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_POOLCUE.png"
    },
    ["WEAPON_WRENCH"] = {
        Name = "Wrench",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 135,
        Value = 250,
        Weight = 3,
        Weapon = "419712736",
        Meta = {
            Ammo = false,
            Attachments = {},

            SerialNumber = false,
            BatchNumber = false,
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["419712736"],
        Craftable = true,
        Recipe = true,
        Materials = {},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_WRENCH.png"
    },
    ["WEAPON_DAGGER"] = {
        Name = "Dagger",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 135,
        Value = 250,
        Weight = 3,
        Weapon = "2460120199",
        Meta = {
            Ammo = false,
            Attachments = {},

            SerialNumber = false,
            BatchNumber = false,
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["2460120199"],
        Craftable = true,
        Recipe = true,
        Materials = {},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_DAGGER.png"
    },
    ["WEAPON_MACHETE"] = {
        Name = "Dagger",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 135,
        Value = 250,
        Weight = 3,
        Weapon = "3713923289",
        Meta = {
            Ammo = false,
            Attachments = {},

            SerialNumber = false,
            BatchNumber = false,
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["3713923289"],
        Craftable = true,
        Recipe = true,
        Materials = {},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_MACHETE.png"
    },
    ["WEAPON_HATCHET"] = {
        Name = "Dagger",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 135,
        Value = 250,
        Weight = 3,
        Weapon = "4191993645",
        Meta = {
            Ammo = false,
            Attachments = {},

            SerialNumber = false,
            BatchNumber = false,
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["4191993645"],
        Craftable = true,
        Recipe = true,
        Materials = {},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_HATCHET.png"
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
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "Fires standard 9mm rounds."
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
        Consumeable = false,
        Image = "WEAPON_PISTOL.png"
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
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "Commonly contained in a cigerrete packet."
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
        Consumeable = false,
        Image = "WEAPON_SNSPISTOL.png"
    },
    ["WEAPON_COMBATPISTOL"] = {
        Name = "Combat Pistol",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "1593441988",
        Meta = {
            Ammo = "9mm",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "Fires standard 9mm rounds."
        },
        Data = weapon_dump["1593441988"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_COMBATPISTOL.png"
    },
    ["WEAPON_APPISTOL"] = {
        Name = "Combat Pistol",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "584646201",
        Meta = {
            Ammo = "9mm",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "Fires standard 9mm rounds."
        },
        Data = weapon_dump["584646201"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_APPISTOL.png"
    },
    ["WEAPON_PISTOL50"] = {
        Name = "Combat Pistol",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "2578377531",
        Meta = {
            Ammo = "9mm",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "Fires standard 9mm rounds."
        },
        Data = weapon_dump["2578377531"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_PISTOL50.png"
    },
    -- SMG
    ["WEAPON_MICROSMG"] = {
        Name = "Scorpion",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "324215364",
        Meta = {
            Ammo = "9mm",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "Fires standard 9mm rounds."
        },
        Data = weapon_dump["324215364"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_MICROSMG.png"
    },
    ["WEAPON_SMG"] = {
        Name = "Submachine Gun",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "736523883",
        Meta = {
            Ammo = "9mm",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "Fires standard 9mm rounds."
        },
        Data = weapon_dump["736523883"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_SMG.png"
    },
    ["WEAPON_ASSAULTSMG"] = {
        Name = "Assault Submachine Gun",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "736523883",
        Meta = {
            Ammo = "9mm",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "Fires standard 9mm rounds."
        },
        Data = weapon_dump["736523883"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_ASSAULTSMG.png"
    },
    -- Assualt Rifles
    ["WEAPON_ASSAULTRIFLE"] = {
        Name = "Assault Rifle",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "3220176749",
        Meta = {
            Ammo = "5.56mm",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "Fires standard 5.56mm rounds."
        },
        Data = weapon_dump["3220176749"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_ASSAULTRIFLE.png"
    },
    ["WEAPON_CARBINERIFLE"] = {
        Name = "Carbine Assault Rifle",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "2210333304",
        Meta = {
            Ammo = "5.56mm",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "Fires standard 5.56mm rounds."
        },
        Data = weapon_dump["2210333304"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_CARBINERIFLE.png"
    },
    ["WEAPON_ADVANCEDRIFLE"] = {
        Name = "Advanced Assualt Rifle",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "2937143193",
        Meta = {
            Ammo = "5.56mm",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "Fires standard 5.56mm rounds."
        },
        Data = weapon_dump["2937143193"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_ADVANCEDRIFLE.png"
    },
    ["WEAPON_MG"] = {
        Name = "Machine Gun",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "2634544996",
        Meta = {
            Ammo = "5.56mm",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "Fires standard 5.56mm rounds."
        },
        Data = weapon_dump["2634544996"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_MG.png"
    },
    ["WEAPON_COMBATMG"] = {
        Name = "Combat Machine Gun",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "2144741730",
        Meta = {
            Ammo = "5.56mm",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "Fires standard 5.56mm rounds."
        },
        Data = weapon_dump["2144741730"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_COMBATMG.png"
    },
    ["WEAPON_PUMPSHOTGUN"] = {
        Name = "Pump Shotgun",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "487013001",
        Meta = {
            Ammo = "20g",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["487013001"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_PUMPSHOTGUN.png"
    },
    ["WEAPON_SAWNOFFSHOTGUN"] = {
        Name = "Sawnoff Shotgun",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "2017895192",
        Meta = {
            Ammo = "20g",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = ""
        },
        Data = weapon_dump["2017895192"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_SAWNOFFSHOTGUN.png"
    },
    ["WEAPON_ASSAULTSHOTGUN"] = {
        Name = "Assault Shotgun",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "3800352039",
        Meta = {
            Ammo = "20g",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["3800352039"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_ASSAULTSHOTGUN.png"
    },
    ["WEAPON_BULLPUPSHOTGUN"] = {
        Name = "Bullpup Shotgun",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "2640438543",
        Meta = {
            Ammo = "20g",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["2640438543"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_BULLPUPSHOTGUN.png"
    },
    ["WEAPON_STUNGUN"] = {
        Name = "Stun Gun",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "911657153",
        Meta = {
            Ammo = "Electrodes",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["911657153"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_STUNGUN.png"
    },
    ["WEAPON_SNIPERRIFLE"] = {
        Name = "Sniper Rifle",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "100416529",
        Meta = {
            Ammo = ".223",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["100416529"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_SNIPERRIFLE.png"
    },
    ["WEAPON_HEAVYSNIPER"] = {
        Name = "Heavy Sniper Rifle",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "205991906",
        Meta = {
            Ammo = ".308",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["205991906"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_HEAVYSNIPER.png"
    },
    ["WEAPON_GRENADELAUNCHER"] = {
        Name = "Grenade Launcher",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "2726580491",
        Meta = {
            Ammo = "30oz",
            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["2726580491"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_GRENADELAUNCHER.png"
    },

    ["WEAPON_GRENADELAUNCHER_SMOKE"] = {
        Name = "Smoke Grenade Launcher",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "1305664598",
        Meta = {
            Ammo = "30oz",
            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["1305664598"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_GRENADELAUNCHER_SMOKE.png"
    },

    ["WEAPON_RPG"] = {
        Name = "Rocket Propelled Grenade Launcher",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "2982836145",
        Meta = {
            Ammo = "Rockets",
            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["2982836145"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_RPG.png"
    },
    ["WEAPON_MINIGUN"] = {
        Name = "Gattling Gun",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "1119849093",
        Meta = {
            Ammo = "5mm",
            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["1119849093"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_MINIGUN.png"
    },
    ["WEAPON_GRENADE"] = {
        Name = "Grenade",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "2481070269",
        Meta = {
            Ammo = "Grenade",
            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["2481070269"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_GRENADE.png"
    },
    ["WEAPON_STICKYBOMB"] = {
        Name = "Sticky Bombs",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "741814745",
        Meta = {
            Ammo = "Sticky Bombs",
            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["741814745"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_STICKYBOMB.png"
    },
    ["WEAPON_SMOKEGRENADE"] = {
        Name = "Smoke Grenades",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "4256991824",
        Meta = {
            Ammo = "Smoke Grenades",
            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["4256991824"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_SMOKEGRENADE.png"
    },
    ["WEAPON_BZGAS"] = {
        Name = "BZ Smoke Grenades",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "2694266206",
        Meta = {
            Ammo = "BZ Gas",
            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["2694266206"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_BZGAS.png"
    },
    ["WEAPON_MOLOTOV"] = {
        Name = "Molotov",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "615608432",
        Meta = {
            Ammo = "Vodka",
            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["615608432"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_MOLOTOV.png"
    },
    ["WEAPON_FIREEXTINGUISHER"] = {
        Name = "Fire Extinguisher",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "101631238",
        Meta = {
            Ammo = "Fire Extinguisher",
            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["101631238"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_FIREEXTINGUISHER.png"
    },
    ["WEAPON_PETROLCAN"] = {
        Name = "Petrol Can",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "883325847",
        Meta = {
            Ammo = "Petrol",
            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["883325847"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_PETROLCAN.png"
    },
    ["WEAPON_BALL"] = {
        Name = "Ball",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "600439132",
        Meta = {
            Ammo = "Balls",
            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["600439132"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_BALL.png"
    },
    ["WEAPON_REVOLVER"] = {
        Name = "Heavy Revolver",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "3249783761",
        Meta = {
            Ammo = ".308",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["3249783761"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_REVOLVER.png"
    },
    ["WEAPON_AUTOSHOTGUN"] = {
        Name = "Sweeper Shotgun",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "317205821",
        Meta = {
            Ammo = ".308",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["317205821"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_AUTOSHOTGUN.png"
    },
    ["WEAPON_COMPACTLAUNCHER"] = {
        Name = "Compact Grenade Launcher",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "125959754",
        Meta = {
            Ammo = ".308",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["125959754"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_COMPACTLAUNCHER.png"
    },
    ["WEAPON_PIPEBOMB"] = {
        Name = "Pipe Bomb",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "3125143736",
        Meta = {
            Ammo = ".308",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["3125143736"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_PIPEBOMB.png"
    },
    ["WEAPON_HEAVYPISTOL"] = {
        Name = "Heavy Pistol",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "3523564046",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["3523564046"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_HEAVYPISTOL.png"
    },
    ["WEAPON_SPECIALCARBINE"] = {
        Name = "Special Carbine",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "3231910285",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["3231910285"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_SPECIALCARBINE.png"
    },
    ["WEAPON_BULLPUPRIFLE"] = {
        Name = "Bullpup Rifle",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "2132975508",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["2132975508"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_BULLPUPRIFLE.png"
    },
    ["WEAPON_HOMINGLAUNCHER"] = {
        Name = "Homing Launcher",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "1672152130",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["1672152130"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_HOMINGLAUNCHER.png"
    },
    ["WEAPON_PROXMINE"] = {
        Name = "Proximity Mine",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "2874559379",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["2874559379"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_PROXMINE.png"
    },
    ["WEAPON_SNOWBALL"] = {
        Name = "Snowball",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "126349499",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["126349499"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_SNOWBALL.png"
    },
    ["WEAPON_BULLPUPRIFLE_MK2"] = {
        Name = "Bullpup Rifle Mk II",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "2228681469",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["2228681469"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_BULLPUPRIFLE_MK2.png"
    },
    ["WEAPON_DOUBLEACTION"] = {
        Name = "Double-Action Revolver",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "2548703416",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["2548703416"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_DOUBLEACTION.png"
    },
    ["WEAPON_MARKSMANRIFLE_MK2"] = {
        Name = "Marksman Rifle Mk II",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "1785463520",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["1785463520"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_MARKSMANRIFLE_MK2.png"
    },
    ["WEAPON_PUMPSHOTGUN_MK2"] = {
        Name = "Pump Shotgun Mk II",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "1432025498",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["1432025498"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_PUMPSHOTGUN_MK2.png"
    },
    ["WEAPON_REVOLVER_MK2"] = {
        Name = "Heavy Revolver Mk II",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "3415619887",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["3415619887"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_REVOLVER_MK2.png"
    },
    ["WEAPON_SNSPISTOL_MK2"] = {
        Name = "SNS Pistol Mk II",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "2285322324",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["2285322324"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_SNSPISTOL_MK2.png"
    },
    ["WEAPON_SPECIALCARBINE_MK2"] = {
        Name = "Special Carbine Mk II",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "2526821735",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["2526821735"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_SPECIALCARBINE_MK2.png"
    },
    ["WEAPON_RAYPISTOL"] = {
        Name = "Up-n-Atomizer",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "2939590305",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["2939590305"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_RAYPISTOL.png"
    },
    ["WEAPON_RAYCARBINE"] = {
        Name = "Unholy Hellbringer",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "1198256469",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["1198256469"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_RAYCARBINE.png"
    },
    ["WEAPON_RAYMINIGUN"] = {
        Name = "Widowmaker",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "3056410471",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["3056410471"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_RAYMINIGUN.png"
    },
    ["WEAPON_ASSAULTRIFLE_MK2"] = {
        Name = "Assault Rifle Mk II",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "961495388",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["961495388"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_ASSAULTRIFLE_MK2.png"
    },
    ["WEAPON_CARBINERIFLE_MK2"] = {
        Name = "Carbine Rifle Mk II",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "4208062921",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["4208062921"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_CARBINERIFLE_MK2.png"
    },
    ["WEAPON_COMBATMG_MK2"] = {
        Name = "Combat MG Mk II",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "3686625920",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["3686625920"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_COMBATMG_MK2.png"
    },
    ["WEAPON_HEAVYSNIPER_MK2"] = {
        Name = "Heavy Sniper Mk II",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "177293209",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["177293209"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_HEAVYSNIPER_MK2.png"
    },
    ["WEAPON_PISTOL_MK2"] = {
        Name = "Pistol Mk II",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "3219281620",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["3219281620"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_PISTOL_MK2.png"
    },
    ["WEAPON_SMG_MK2"] = {
        Name = "SMG Mk II",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "2024373456",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["2024373456"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_SMG_MK2.png"
    },
    ["WEAPON_FLASHLIGHT"] = {
        Name = "Flashlight",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "2343591895",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["2343591895"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 1
        }, {
            ItemRequired = "Steel",
            Quantity = 1
        }, {
            ItemRequired = "SmallFuse",
            Quantity = 1
        }, {
            ItemRequired = "Batteries",
            Quantity = 2
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_FLASHLIGHT.png"
    },
    ["WEAPON_FLAREGUN"] = {
        Name = "Flare Gun",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "1198879012",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["1198879012"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 1
        }, {
            ItemRequired = "CarbonAlloy",
            Quantity = 1
        }, {
            ItemRequired = "ShortBarrel",
            Quantity = 1
        }, {
            ItemRequired = "PistolPin",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_FLAREGUN.png"
    },
    ["WEAPON_CERAMICPISTOL"] = {
        Name = "Ceramic Pistol",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "727643628",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["727643628"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 1
        }, {
            ItemRequired = "CeramicShards",
            Quantity = 2
        }, {
            ItemRequired = "ShortBarrel",
            Quantity = 1
        }, {
            ItemRequired = "PistolPin",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_CERAMICPISTOL.png"
    },
    ["WEAPON_HAZARDCAN"] = {
        Name = "Hazardous Jerry Can",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "3126027122",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["3126027122"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Steel",
            Quantity = 2
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_HAZARDCAN.png"
    },
    ["WEAPON_COMBATSHOTGUN"] = {
        Name = "Combat Shotgun",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "94989220",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["94989220"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
        }, {
            ItemRequired = "CarbonAlloy",
            Quantity = 2
        }, {
            ItemRequired = "LongBarrel",
            Quantity = 1
        }, {
            ItemRequired = "PistolPin",
            Quantity = 1
        }, {
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_COMBATSHOTGUN.png"
    },
    ["WEAPON_GADGETPISTOL"] = {
        Name = "Perico Pistol",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "1470379660",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["1470379660"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_GADGETPISTOL.png"
    },
    ["WEAPON_MILITARYRIFLE"] = {
        Name = "Military Rifle",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "2636060646",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["2636060646"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_MILITARYRIFLE.png"
    },
    ["WEAPON_FIREWORK"] = {
        Name = "Firework Launcher",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "2138347493",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["2138347493"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_FIREWORK.png"
    },
    ["WEAPON_VINTAGEPISTOL"] = {
        Name = "Vintage Pistol",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "137902532",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["137902532"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_VINTAGEPISTOL.png"
    },
    ["WEAPON_MUSKET"] = {
        Name = "Musket",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "2828843422",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["2828843422"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_MUSKET.png"
    },
    ["WEAPON_MACHINEPISTOL"] = {
        Name = "Machine Pistol",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "3675956304",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["3675956304"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_MACHINEPISTOL.png"
    },
    ["WEAPON_COMPACTRIFLE"] = {
        Name = "Compact Rifle",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "1649403952",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["1649403952"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_COMPACTRIFLE.png"
    },
    ["WEAPON_DBSHOTGUN"] = {
        Name = "Double Barrel Shotgun",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "4019527611",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["4019527611"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_DBSHOTGUN.png"
    },
    ["WEAPON_HEAVYSHOTGUN"] = {
        Name = "Heavy Shotgun",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "984333226",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["984333226"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_HEAVYSHOTGUN.png"
    },
    ["WEAPON_MARKSMANRIFLE"] = {
        Name = "Marksman Rifle",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "3342088282",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["3342088282"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_MARKSMANRIFLE.png"
    },
    ["WEAPON_COMBATPDW"] = {
        Name = "Combat PDW",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "171789620",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["171789620"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_COMBATPDW.png"
    },
    ["WEAPON_KNUCKLE"] = {
        Name = "Knuckle Duster",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "3638508604",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["3638508604"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_KNUCKLE.png"
    },
    ["WEAPON_MARKSMANPISTOL"] = {
        Name = "Marksman Pistol",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "3696079510",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["3696079510"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_MARKSMANPISTOL.png"
    },
    ["WEAPON_GUSENBERG"] = {
        Name = "Gusenberg Sweeper",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "1627465347",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["1627465347"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_GUSENBERG.png"
    },
    ["WEAPON_RAILGUN"] = {
        Name = "Railgun",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "1834241177",
        Meta = {
            Ammo = "",
            Attachments = {},

            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "."
        },
        Data = weapon_dump["1834241177"],
        Craftable = true,
        Recipe = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 3
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
            ItemRequired = "SMGFrame",
            Quantity = 1
        }, {
            ItemRequired = "Reciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = true,
        Consumeable = false,
        Image = "WEAPON_RAILGUN.png"
    },

-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------

    ["Coffee"] = {
        Name = "Cup-o-Joe",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 1,
        Value = 3,
        Weight = 0,
        Weapon = false,
        Meta = {
            About = "Just a cup of Joe's finest."
        },
        Data = {    
            Buff = true,
            Nerf = false,
            Type = "",
            Hunger = -1,
            Thirst = 18,
            Stress = -5,
        },
        Craftable = false,
        Recipe = false,
        Materials = false,
        Stackable = true,
        Consumeable = true,
        Hotkey = true,
        Image = "Coffee.png"
    },

}

c.json.Write(conf.file.items, c.items)
