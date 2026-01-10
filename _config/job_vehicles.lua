-- ====================================================================================--
-- Job-Owned Vehicle Configuration
-- ====================================================================================--
-- This config defines vehicles that can be spawned by players with specific jobs.
-- Vehicles spawn at no cost and are tied to job rank/grade and optionally roles.
--
-- Integration:
-- - This file is loaded via the shared_scripts section in fxmanifest.lua
-- - Server script (server/[Garage]/garage_job_vehicles.lua) reads this config
-- - Client UI (nui/src/components/GarageJobVehicles.vue) displays allowed vehicles
--
-- Configuration Format:
-- [job_name] = {
--   vehicles = {
--     {
--       model = "vehicle_model_name",    -- Vehicle spawn name
--       label = "Display Name",           -- Name shown in UI
--       minGrade = 1,                     -- (Optional) Minimum numeric grade/rank required
--       roles = {"role1", "role2"},       -- (Optional) List of role names allowed
--       spawnProps = {}                   -- (Optional) Additional spawn properties
--     }
--   }
-- }
--
-- Notes:
-- - job_name should match your server's job identifier (e.g., "police", "ambulance")
-- - If both minGrade and roles are specified, BOTH conditions must be met
-- - If neither is specified, any player with that job can spawn the vehicle
-- ====================================================================================--

if not conf then conf = {} end
if not conf.garage then conf.garage = {} end

conf.garage.job_vehicles = {
  -- Police Department Vehicles
  police = {
    vehicles = {
      { model = "police", label = "Police Cruiser", minGrade = 0 },
      { model = "police2", label = "Police Interceptor", minGrade = 2 },
      { model = "police3", label = "Police SUV", minGrade = 3 },
      { model = "policeb", label = "Police Motorcycle", minGrade = 1 },
      { model = "riot", label = "Riot Van", minGrade = 4 },
      { model = "fbi", label = "Unmarked Cruiser", minGrade = 5 },
      { model = "fbi2", label = "Federal Vehicle", minGrade = 6 }
    }
  },

  -- Emergency Medical Services
  ambulance = {
    vehicles = {
      { model = "ambulance", label = "Standard Ambulance", minGrade = 0 },
      { model = "firetruk", label = "Fire Truck", minGrade = 2 }
    }
  },

  -- Alternative EMS name (some servers use "ems" instead of "ambulance")
  ems = {
    vehicles = {
      { model = "ambulance", label = "Standard Ambulance", minGrade = 0 },
      { model = "firetruk", label = "Fire Truck", minGrade = 2 }
    }
  },

  -- Sheriff Department (if your server uses sheriff as separate job)
  sheriff = {
    vehicles = {
      { model = "sheriff", label = "Sheriff Cruiser", minGrade = 0 },
      { model = "sheriff2", label = "Sheriff SUV", minGrade = 2 }
    }
  },

  -- Mechanic/Tow Service
  mechanic = {
    vehicles = {
      { model = "towtruck", label = "Tow Truck", minGrade = 0 },
      { model = "towtruck2", label = "Large Tow Truck", minGrade = 2 },
      { model = "flatbed", label = "Flatbed Truck", minGrade = 1 }
    }
  },

  -- Example: Role-based vehicle access
  -- Uncomment and modify as needed for your server
  --[[
  swat = {
    vehicles = {
      { model = "riot", label = "SWAT Van", roles = {"swat_member", "swat_leader"} },
      { model = "insurgent2", label = "Armored Vehicle", roles = {"swat_leader"} }
    }
  },
  ]]--

  -- Add your custom jobs here following the same format
  -- Example:
  --[[
  taxi = {
    vehicles = {
      { model = "taxi", label = "Standard Taxi", minGrade = 0 },
      { model = "stretch", label = "Luxury Limo", minGrade = 3 }
    }
  },
  ]]--
}

-- ====================================================================================--
