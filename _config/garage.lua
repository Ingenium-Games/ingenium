-- ====================================================================================--
-- ig.garage Configuration
-- Advanced Vehicle Parking System
-- ====================================================================================--
conf.garage = {}
-- ====================================================================================--

-- Garage locations and their parking spots
conf.garage.locations = {
    -- Legion Square Parking Garage
    ["legion_garage"] = {
        Name = "Legion Square Parking",
        Blip = {
            Enabled = true,
            Sprite = 50,
            Color = 3,
            Scale = 0.8,
            Label = "Parking Garage"
        },
        -- Parking machine prop location
        Machine = {
            Model = "prop_parksign_4",
            Coords = {x = 215.80, y = -809.50, z = 30.73, h = 250.0}
        },
        -- Individual parking spots
        Spots = {
            {x = 215.12, y = -805.17, z = 30.81, h = 250.0},
            {x = 214.35, y = -801.44, z = 30.81, h = 250.0},
            {x = 213.58, y = -797.71, z = 30.81, h = 250.0},
            {x = 212.81, y = -793.98, z = 30.81, h = 250.0},
            {x = 212.04, y = -790.25, z = 30.81, h = 250.0},
            {x = 229.70, y = -787.89, z = 30.81, h = 70.0},
            {x = 230.47, y = -791.62, z = 30.81, h = 70.0},
            {x = 231.24, y = -795.35, z = 30.81, h = 70.0},
            {x = 232.01, y = -799.08, z = 30.81, h = 70.0},
            {x = 232.78, y = -802.81, z = 30.81, h = 70.0}
        }
    },
    
    -- Pillbox Hill Garage
    ["pillbox_garage"] = {
        Name = "Pillbox Hill Parking",
        Blip = {
            Enabled = true,
            Sprite = 50,
            Color = 3,
            Scale = 0.8,
            Label = "Parking Garage"
        },
        Machine = {
            Model = "prop_parksign_4",
            Coords = {x = -340.66, y = -874.68, z = 31.08, h = 170.0}
        },
        Spots = {
            {x = -337.50, y = -874.42, z = 31.08, h = 170.0},
            {x = -333.50, y = -874.42, z = 31.08, h = 170.0},
            {x = -329.50, y = -874.42, z = 31.08, h = 170.0},
            {x = -325.50, y = -874.42, z = 31.08, h = 170.0},
            {x = -321.50, y = -874.42, z = 31.08, h = 170.0},
            {x = -337.50, y = -890.42, z = 31.08, h = 350.0},
            {x = -333.50, y = -890.42, z = 31.08, h = 350.0},
            {x = -329.50, y = -890.42, z = 31.08, h = 350.0},
            {x = -325.50, y = -890.42, z = 31.08, h = 350.0},
            {x = -321.50, y = -890.42, z = 31.08, h = 350.0}
        }
    },
    
    -- Sandy Shores Garage
    ["sandy_garage"] = {
        Name = "Sandy Shores Parking",
        Blip = {
            Enabled = true,
            Sprite = 50,
            Color = 3,
            Scale = 0.8,
            Label = "Parking Garage"
        },
        Machine = {
            Model = "prop_parksign_4",
            Coords = {x = 1737.69, y = 3710.20, z = 34.14, h = 20.0}
        },
        Spots = {
            {x = 1737.50, y = 3715.20, z = 34.04, h = 20.0},
            {x = 1741.50, y = 3716.20, z = 34.04, h = 20.0},
            {x = 1745.50, y = 3717.20, z = 34.04, h = 20.0},
            {x = 1749.50, y = 3718.20, z = 34.04, h = 20.0},
            {x = 1753.50, y = 3719.20, z = 34.04, h = 20.0}
        }
    },
    
    -- Paleto Bay Garage
    ["paleto_garage"] = {
        Name = "Paleto Bay Parking",
        Blip = {
            Enabled = true,
            Sprite = 50,
            Color = 3,
            Scale = 0.8,
            Label = "Parking Garage"
        },
        Machine = {
            Model = "prop_parksign_4",
            Coords = {x = 105.30, y = 6613.40, z = 32.39, h = 45.0}
        },
        Spots = {
            {x = 107.50, y = 6608.40, z = 32.39, h = 45.0},
            {x = 110.50, y = 6605.40, z = 32.39, h = 45.0},
            {x = 113.50, y = 6602.40, z = 32.39, h = 45.0},
            {x = 116.50, y = 6599.40, z = 32.39, h = 45.0},
            {x = 119.50, y = 6596.40, z = 32.39, h = 45.0}
        }
    }
}

-- ====================================================================================--
-- Garage Settings
-- ====================================================================================--
conf.garage.settings = {
    -- Distance to check for occupied spots (radius in meters)
    OccupancyCheckRadius = 3.0,
    
    -- Maximum distance to interact with garage
    InteractionDistance = 5.0,
    
    -- Save vehicle data when exiting driver seat
    AutoSaveOnExit = true,
    
    -- Spawn vehicle with collision check
    CollisionCheck = true,
    
    -- Timeout for collision check (ms)
    CollisionCheckTimeout = 2000
}
