-- ====================================================================================--
local weapon_dump = exports["ig.dump"]:GetWeapons()
-- ====================================================================================--
    
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
        Image = "WEAPON_MICROSMG.png"
    },
    ["WEAPON_SMG"] = {
        Name = "SMG",
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
        Image = "WEAPON_SMG.png"
    },
    ["WEAPON_ASSAULTSMG"] = {
        Name = "SMG",
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
        Image = "WEAPON_ASSAULTSMG.png"
    },
    -- Assualt Rifles
    ["WEAPON_ASSAULTRIFLE"] = {
        Name = "SMG",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "3220176749",
        Meta = {
            Ammo = "9mm",
            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "Fires standard 9mm rounds."
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
        Image = "WEAPON_ASSAULTRIFLE.png"
    },
    ["WEAPON_CARBINERIFLE"] = {
        Name = "SMG",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "2210333304",
        Meta = {
            Ammo = "9mm",
            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "Fires standard 9mm rounds."
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
        Image = "WEAPON_CARBINERIFLE.png"
    },
    ["WEAPON_ADVANCEDRIFLE"] = {
        Name = "SMG",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "2937143193",
        Meta = {
            Ammo = "9mm",
            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "Fires standard 9mm rounds."
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
        Image = "WEAPON_ADVANCEDRIFLE.png"
    },
    ["WEAPON_MG"] = {
        Name = "SMG",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "2634544996",
        Meta = {
            Ammo = "9mm",
            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "Fires standard 9mm rounds."
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
        Image = "WEAPON_MG.png"
    },
    ["WEAPON_COMBATMG"] = {
        Name = "SMG",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "2144741730",
        Meta = {
            Ammo = "9mm",
            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "Fires standard 9mm rounds."
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
        Image = "WEAPON_COMBATMG.png"
    },
    ["WEAPON_PUMPSHOTGUN"] = {
        Name = "SMG",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "487013001",
        Meta = {
            Ammo = "9mm",
            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "Fires standard 9mm rounds."
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
        Image = "WEAPON_PUMPSHOTGUN.png"
    },
    ["WEAPON_SAWNOFFSHOTGUN"] = {
        Name = "SMG",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "2017895192",
        Meta = {
            Ammo = "9mm",
            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "Fires standard 9mm rounds."
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
        Image = "WEAPON_SAWNOFFSHOTGUN.png"
    },
    ["WEAPON_ASSAULTSHOTGUN"] = {
        Name = "SMG",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "3800352039",
        Meta = {
            Ammo = "9mm",
            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "Fires standard 9mm rounds."
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
        Image = "WEAPON_ASSAULTSHOTGUN.png"
    },
    ["WEAPON_BULLPUPSHOTGUN"] = {
        Name = "SMG",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "2640438543",
        Meta = {
            Ammo = "9mm",
            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "Fires standard 9mm rounds."
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
        Image = "WEAPON_BULLPUPSHOTGUN.png"
    },
    ["WEAPON_STUNGUN"] = {
        Name = "SMG",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "911657153",
        Meta = {
            Ammo = "9mm",
            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "Fires standard 9mm rounds."
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
        Image = "WEAPON_STUNGUN.png"
    },
    ["WEAPON_SNIPERRIFLE"] = {
        Name = "SMG",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "100416529",
        Meta = {
            Ammo = "9mm",
            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "Fires standard 9mm rounds."
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
        Image = "WEAPON_SNIPERRIFLE.png"
    },
    ["WEAPON_HEAVYSNIPER"] = {
        Name = "SMG",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 345,
        Value = 525,
        Weight = 3,
        Weapon = "205991906",
        Meta = {
            Ammo = "9mm",
            SerialNumber = "",
            BatchNumber = "",
            Crafted = false,
            Registered = false,
            About = "Fires standard 9mm rounds."
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
        Image = "WEAPON_HEAVYSNIPER.png"
    },
}

c.json.Write(conf.file.items, c.items)