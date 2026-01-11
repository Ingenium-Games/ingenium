-- ====================================================================================--
-- Job-Specific Vehicle Spawning Configuration
-- ====================================================================================--

if not conf then conf = {} end
if not conf.job_vehicles then conf.job_vehicles = {} end

-- Enable/disable job vehicle spawning system
conf.job_vehicles.enabled = true

-- Distance settings
conf.job_vehicles.interaction_distance = 2.5  -- Distance to interact with spawn props
conf.job_vehicles.spawn_offset = 5.0          -- Distance from prop to spawn vehicle

-- Prop model for vehicle spawners (default: traffic cone)
conf.job_vehicles.spawner_prop = `prop_roadcone02a`

-- Job vehicle spawner locations
-- Each spawner defines:
-- - job: The job name required to use this spawner
-- - grade: Minimum grade required (nil = any grade)
-- - prop: Location of the interaction prop {x, y, z, h}
-- - spawn: Location where vehicle will spawn {x, y, z, h}
-- - vehicles: Array of vehicle models available at this spawner
conf.job_vehicles.spawners = {
    -- Mission Row Police Department
    {
        job = "police",
        grade = nil,  -- Any police grade can use
        label = "Police Vehicle Spawner",
        prop = {x=438.42, y=-1018.09, z=28.59, h=90.0},
        spawn = {x=438.42, y=-1026.35, z=28.48, h=90.0},
        vehicles = {
            {model = "police", label = "Police Cruiser"},
            {model = "police2", label = "Police Buffalo"},
            {model = "police3", label = "Police Interceptor"},
            {model = "sheriff", label = "Sheriff Cruiser"},
            {model = "policeb", label = "Police Bike"},
        }
    },
    
    -- Davis Police Station
    {
        job = "police",
        grade = nil,
        label = "Police Vehicle Spawner",
        prop = {x=361.32, y=-1584.56, z=29.29, h=230.0},
        spawn = {x=354.63, y=-1576.34, z=28.9, h=230.0},
        vehicles = {
            {model = "police", label = "Police Cruiser"},
            {model = "police2", label = "Police Buffalo"},
            {model = "sheriff", label = "Sheriff Cruiser"},
        }
    },
    
    -- Sandy Shores Sheriff
    {
        job = "police",
        grade = nil,
        label = "Police Vehicle Spawner",
        prop = {x=1851.26, y=3690.73, z=34.27, h=210.0},
        spawn = {x=1856.87, y=3683.93, z=33.67, h=210.0},
        vehicles = {
            {model = "sheriff", label = "Sheriff Cruiser"},
            {model = "sheriff2", label = "Sheriff SUV"},
            {model = "police", label = "Police Cruiser"},
        }
    },
    
    -- Paleto Bay Sheriff
    {
        job = "police",
        grade = nil,
        label = "Police Vehicle Spawner",
        prop = {x=-448.49, y=6007.82, z=31.72, h=315.0},
        spawn = {x=-455.39, y=6002.07, z=31.34, h=315.0},
        vehicles = {
            {model = "sheriff", label = "Sheriff Cruiser"},
            {model = "sheriff2", label = "Sheriff SUV"},
        }
    },
    
    -- Example: EMS Station (Pillbox Hospital)
    {
        job = "ems",
        grade = nil,
        label = "EMS Vehicle Spawner",
        prop = {x=307.68, y=-1433.26, z=29.97, h=230.0},
        spawn = {x=297.09, y=-1429.01, z=29.75, h=230.0},
        vehicles = {
            {model = "ambulance", label = "Ambulance"},
        }
    },
    
    -- Example: Mechanic Shop
    {
        job = "mechanic",
        grade = nil,
        label = "Mechanic Vehicle Spawner",
        prop = {x=-197.69, y=-1339.39, z=34.89, h=180.0},
        spawn = {x=-197.69, y=-1344.88, z=34.02, h=180.0},
        vehicles = {
            {model = "towtruck", label = "Tow Truck"},
            {model = "towtruck2", label = "Flatbed Tow Truck"},
            {model = "utillitruck3", label = "Utility Truck"},
        }
    },
}

-- ====================================================================================--
