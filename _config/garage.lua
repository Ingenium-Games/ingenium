-- ====================================================================================--
-- Garage System Configuration
-- ====================================================================================--

if not conf then conf = {} end
if not conf.garage then conf.garage = {} end

-- Version check URL
conf.garage.version_check_url = ""

-- Enable/disable garage system
conf.garage.enabled = true

-- Parking machine prop model
conf.garage.machine_prop = `prop_parkingpay`

-- Distance settings
conf.garage.interaction_distance = 2.5  -- Distance to interact with parking machine
conf.garage.parking_spot_radius = 2.0   -- Radius for parking spot detection

-- Parking spots will be loaded from client/[Garage]/_var.lua
-- This allows for dynamic spot management

-- Garage UI settings
conf.garage.ui = {
    show_blips = false,  -- Show blips for parking locations
    blip_sprite = 50,    -- Blip sprite ID
    blip_color = 3,      -- Blip color
}

-- Vehicle retrieval settings
conf.garage.retrieval = {
    spawn_in_vehicle = true,  -- Spawn player in vehicle when retrieved
    repair_on_spawn = false,  -- Repair vehicle when spawning
    fuel_on_spawn = 100,      -- Fuel level when spawning (0-100)
}

-- Parking fees (optional - set to 0 to disable)
conf.garage.fees = {
    enabled = false,
    parking_fee = 0,      -- Fee to park vehicle
    retrieval_fee = 0,    -- Fee to retrieve vehicle
}

-- Integration settings
conf.garage.integration = {
    use_sql_vehicles = true,  -- Integrate with ingenium vehicle SQL system
    sync_parked_state = true,  -- Sync parked state to database
}

-- ====================================================================================--
