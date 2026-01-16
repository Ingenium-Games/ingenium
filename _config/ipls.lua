-- ====================================================================================--
conf.ipls = {}
-- ====================================================================================--
--[[
IPL CONFIGURATIONS:
    Define IPL (Interior Prop List) configurations with optional zone-based loading.
    Each configuration can include:
    - name: Unique identifier for the IPL config
    - ipls: Array of IPL identifiers to load/unload
    - autoload: Whether to load immediately on resource start
    - zone: Optional zone configuration for proximity-based loading
        - type: "circle", "box", or "poly"
        - coords: Center position (vector2/vector3)
        - radius: For circle zones
        - length/width/heading: For box zones
        - points: For polygon zones
        - minZ/maxZ: Height boundaries
        - dynamicLoad: Enable auto load/unload on zone enter/exit
        - debug: Enable zone visualization for debugging
    
    Example configurations are provided below. Uncomment and modify as needed.
]]--
-- ====================================================================================--

-- Example: Car Showroom (always loaded)
--[[
conf.ipls.carshowroom = {
    name = "carshowroom",
    ipls = {
        "v_carshowroom",
        "shutter_open",
        "csr_afterMission"
    },
    autoload = true
}
]]

-- Example: Nightclub (After Hours DLC) with dynamic loading
--[[
conf.ipls.nightclub = {
    name = "afterhours_nightclub",
    ipls = {
        "ba_barriers_case0",
        "ba_case_0",
        "ba_clubname_01",
        "ba_equipment_setup",
        "ba_equipment_upgrade",
        "ba_security_upgrade",
        "ba_style01",
        "ba_trophy01"
    },
    zone = {
        type = "circle",
        coords = vector2(-1569.0, -3017.0),
        radius = 200.0,
        dynamicLoad = true,
        debug = false
    }
}
]]

-- Example: Aircraft Carrier with dynamic loading
--[[
conf.ipls.carrier = {
    name = "aircraft_carrier",
    ipls = {
        "hei_carrier",
        "hei_carrier_DistantLights",
        "hei_Carrier_int1",
        "hei_Carrier_int2",
        "hei_carrier_LODLights"
    },
    zone = {
        type = "circle",
        coords = vector2(3084.0, -4700.0),
        radius = 500.0,
        dynamicLoad = true,
        debug = false
    }
}
]]

-- Example: FIB Building Interior
--[[
conf.ipls.fib = {
    name = "fib_interior",
    ipls = {
        "FIBlobby"
    },
    zone = {
        type = "circle",
        coords = vector2(136.0, -750.0),
        radius = 100.0,
        dynamicLoad = true,
        debug = false
    }
}
]]

-- Example: Casino (always loaded, no dynamic zone)
--[[
conf.ipls.casino = {
    name = "casino",
    ipls = {
        "vw_casino_main",
        "vw_casino_garage",
        "vw_casino_carpark",
        "vw_casino_door"
    },
    autoload = true
}
]]

-- Example: Yacht with box zone
--[[
conf.ipls.yacht = {
    name = "yacht",
    ipls = {
        "hei_yacht_heist",
        "hei_yacht_heist_Bar",
        "hei_yacht_heist_Bedrm",
        "hei_yacht_heist_Bridge",
        "hei_yacht_heist_DistantLights",
        "hei_yacht_heist_enginrm",
        "hei_yacht_heist_LODLights",
        "hei_yacht_heist_Lounge",
        "hei_yacht_heist_slod_03",
        "hei_yacht_heist_slod_05",
        "hei_yacht_heist_Spa",
        "hei_yacht_heist_sr"
    },
    zone = {
        type = "box",
        coords = vector3(-2027.0, -1036.0, 5.0),
        length = 100.0,
        width = 50.0,
        heading = 0.0,
        minZ = 0.0,
        maxZ = 20.0,
        dynamicLoad = true,
        debug = false
    }
}
]]

-- Example: Custom polygon zone for complex area
--[[
conf.ipls.custom_building = {
    name = "custom_building",
    ipls = {
        "interior_01",
        "interior_props"
    },
    zone = {
        type = "poly",
        points = {
            vector2(100.0, 100.0),
            vector2(200.0, 100.0),
            vector2(200.0, 200.0),
            vector2(150.0, 250.0),
            vector2(100.0, 200.0)
        },
        minZ = 0.0,
        maxZ = 100.0,
        dynamicLoad = true,
        debug = false
    }
}
]]

-- ====================================================================================--
-- Common IPL Reference
-- ====================================================================================--
--[[
    PROPERTIES:
    - v_carshowroom (Car showroom)
    - v_bahama (Bahama Mamas nightclub)
    - v_michael (Michael's house)
    - v_franklins (Franklin's house)
    
    FACILITIES:
    - gr_case0_bunkerclosed (Bunker closed)
    - ba_barriers_case0 (Nightclub After Hours)
    - hei_carrier (Aircraft carrier)
    - FIBlobby (FIB building interior)
    
    CASINO:
    - vw_casino_main (Main casino interior)
    - vw_casino_garage (Casino garage)
    - vw_casino_carpark (Casino parking)
    
    HEIST LOCATIONS:
    - hei_yacht_heist (Yacht heist)
    - id2_14_during_door (Jewel store)
    
    For comprehensive IPL lists, refer to community IPL databases.
]]--
-- ====================================================================================--
