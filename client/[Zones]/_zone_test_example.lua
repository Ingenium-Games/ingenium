-- ====================================================================================--
-- Zone System Example/Test
-- This file demonstrates and tests the ig.zone and ig.ipls functionality
-- 
-- TO USE THIS TEST:
-- 1. Rename file from _zone_test_example.lua to zone_test_example.lua (remove leading underscore)
-- 2. Start the server and join the game
-- 3. Check console for test results
-- 4. Use /zonetest command to see current zone info
-- 5. Visit test locations to trigger callbacks
-- 
-- TO DISABLE THIS TEST:
-- Keep the leading underscore in the filename (_zone_test_example.lua) - it won't load
-- ====================================================================================--

-- DISABLED BY DEFAULT - Rename this file by removing the leading underscore to enable
--[=[

-- Wait for game to be loaded
CreateThread(function()
    Wait(5000)  -- Wait for game and Ingenium to fully load
    
    if ig and ig.log and ig.log.Debug then
        ig.log.Debug("Zone Test", "Starting zone system tests...")
    else
        ig.debug.Info("[Zone Test] Starting zone system tests...")
    end
    
    -- ====================================================================================--
    -- Test 1: Basic Zone Creation
    -- ====================================================================================--
    ig.debug.Debug("[Zone Test] Test 1: Creating basic zones")
    
    -- Create a circle zone at Legion Square
    local legionSquareZone = ig.zone.Circle:Create(
        vector2(195.0, -933.0),
        50.0,
        {
            name = "legion_square_test",
            debugPoly = false  -- Set to true to visualize
        }
    )
    
    if legionSquareZone then
        ig.debug.Info("[Zone Test] ✓ Circle zone created successfully")
    else
        ig.debug.Error("[Zone Test] ✗ Failed to create circle zone")
    end
    
    -- Create a box zone at LSPD
    local lspdZone = ig.zone.Box:Create(
        vector3(441.0, -982.0, 30.0),
        60.0,  -- length
        60.0,  -- width
        {
            name = "lspd_test",
            heading = 90.0,
            minZ = 25.0,
            maxZ = 35.0,
            debugPoly = false
        }
    )
    
    if lspdZone then
        ig.debug.Info("[Zone Test] ✓ Box zone created successfully")
    else
        ig.debug.Error("[Zone Test] ✗ Failed to create box zone")
    end
    
    -- ====================================================================================--
    -- Test 2: Point Checking
    -- ====================================================================================--
    ig.debug.Debug("[Zone Test] Test 2: Testing point checking")
    
    -- Test point inside Legion Square zone
    local testPoint1 = vector3(195.0, -933.0, 28.0)
    if legionSquareZone:isPointInside(testPoint1) then
        ig.debug.Info("[Zone Test] ✓ Point inside Legion Square detected correctly")
    else
        ig.debug.Error("[Zone Test] ✗ Failed to detect point inside zone")
    end
    
    -- Test point outside zone
    local testPoint2 = vector3(1000.0, 1000.0, 28.0)
    if not legionSquareZone:isPointInside(testPoint2) then
        ig.debug.Info("[Zone Test] ✓ Point outside Legion Square detected correctly")
    else
        ig.debug.Error("[Zone Test] ✗ False positive: point detected as inside when outside")
    end
    
    -- ====================================================================================--
    -- Test 3: Player In/Out Callbacks
    -- ====================================================================================--
    ig.debug.Debug("[Zone Test] Test 3: Setting up player in/out callbacks")
    
    legionSquareZone:onPlayerInOut(function(isInside, point)
        if isInside then
            ig.debug.Info("[Zone Test] Player entered Legion Square!")
        else
            ig.debug.Debug("[Zone Test] Player left Legion Square.")
        end
    end, 1000)  -- Check every second
    
    if ig and ig.log and ig.log.Debug then
        ig.log.Debug("Zone Test", "Callbacks registered (visit Legion Square to test)")
    else
        ig.debug.Info("[Zone Test] ✓ Callbacks registered (visit Legion Square to test)")
    end
    
    -- ====================================================================================--
    -- Test 4: IPL System
    -- ====================================================================================--
    ig.debug.Debug("[Zone Test] Test 4: Testing IPL system")
    
    -- Test basic IPL loading
    ig.ipl.Load("v_carshowroom")
    
    if ig.ipl.IsLoaded("v_carshowroom") then
        if ig and ig.log and ig.log.Debug then
            ig.log.Debug("Zone Test", "IPL loaded successfully")
        else
            ig.debug.Info("[Zone Test] ✓ IPL loaded successfully")
        end
    else
        if ig and ig.log and ig.log.Warn then
            ig.log.Warn("Zone Test", "Failed to load IPL")
        else
            ig.debug.Error("[Zone Test] ✗ Failed to load IPL")
        end
    end
    
    -- Test IPL registry with zone
    ig.ipls.Register({
        name = "test_nightclub",
        ipls = {
            "ba_barriers_case0",
            "ba_case_0"
        },
        zone = {
            type = "circle",
            coords = vector2(-1569.0, -3017.0),
            radius = 200.0,
            dynamicLoad = true,
            debug = false
        }
    })
    
    local config = ig.ipls.Get("test_nightclub")
    if config then
        ig.debug.Info("[Zone Test] ✓ IPL configuration registered")
        if config.zone then
            ig.debug.Info("[Zone Test] ✓ Zone configuration attached")
        end
    else
        ig.debug.Error("[Zone Test] ✗ Failed to register IPL configuration")
    end
    
    -- ====================================================================================--
    -- Test 5: ComboZone
    -- ====================================================================================--
    ig.debug.Debug("[Zone Test] Test 5: Testing ComboZone")
    
    local comboZones = {
        ig.zone.Circle:Create(vector2(200.0, -900.0), 30.0, {name = "combo_zone_1"}),
        ig.zone.Circle:Create(vector2(250.0, -900.0), 30.0, {name = "combo_zone_2"}),
        ig.zone.Circle:Create(vector2(225.0, -850.0), 30.0, {name = "combo_zone_3"})
    }
    
    local comboZone = ig.zone.Combo:Create(comboZones, {
        name = "legion_area_combo",
        debugPoly = false
    })
    
    if comboZone then
        if ig and ig.log and ig.log.Debug then
            ig.log.Debug("Zone Test", "ComboZone created with 3 zones")
        else
            ig.debug.Info("[Zone Test] ✓ ComboZone created with 3 zones")
        end
        
        -- Test if point is in any zone
        local testPoint = vector3(200.0, -900.0, 28.0)
        local isInside, zone = comboZone:isPointInside(testPoint)
        if isInside and zone then
            if ig and ig.log and ig.log.Debug then
                ig.log.Debug("Zone Test", "Point found in combo zone: %s", zone.name)
            else
                ig.debug.Info("[Zone Test] ✓ Point found in combo zone: " .. zone.name)
            end
        else
            if ig and ig.log and ig.log.Warn then
                ig.log.Warn("Zone Test", "Failed to detect point in combo zone")
            else
                ig.debug.Error("[Zone Test] ✗ Failed to detect point in combo zone")
            end
        end
    else
        if ig and ig.log and ig.log.Error then
            ig.log.Error("Zone Test", "Failed to create ComboZone")
        else
            ig.debug.Error("[Zone Test] ✗ Failed to create ComboZone")
        end
    end
    
    -- ====================================================================================--
    -- Test 6: Zone Modifications
    -- ====================================================================================--
    ig.debug.Debug("[Zone Test] Test 6: Testing zone modifications")
    
    -- Test box zone modifications
    lspdZone:setLength(80.0)
    if lspdZone:getLength() == 80.0 then
        ig.debug.Info("[Zone Test] ✓ Box zone length modification works")
    else
        ig.debug.Error("[Zone Test] ✗ Failed to modify box zone length")
    end
    
    lspdZone:setHeading(45.0)
    if lspdZone:getHeading() == 45.0 then
        ig.debug.Info("[Zone Test] ✓ Box zone heading modification works")
    else
        ig.debug.Error("[Zone Test] ✗ Failed to modify box zone heading")
    end
    
    -- Test circle zone modifications
    legionSquareZone:setRadius(75.0)
    if legionSquareZone:getRadius() == 75.0 then
        ig.debug.Info("[Zone Test] ✓ Circle zone radius modification works")
    else
        ig.debug.Error("[Zone Test] ✗ Failed to modify circle zone radius")
    end
    
    -- ====================================================================================--
    -- Test Summary
    -- ====================================================================================--
    if ig and ig.log and ig.log.Debug then
        ig.log.Debug("Zone Test", "Test suite completed!")
        ig.log.Debug("Zone Test", "Visit Legion Square to test player callbacks")
        ig.log.Debug("Zone Test", "Visit Nightclub (-1569, -3017) to test dynamic IPL loading")
    else
        ig.debug.Info("[Zone Test] ======================")
        ig.debug.Info("[Zone Test] Test suite completed!")
        ig.debug.Info("[Zone Test] Visit Legion Square to test player callbacks")
        ig.debug.Info("[Zone Test] Visit Nightclub (-1569, -3017) to test dynamic IPL loading")
        ig.debug.Info("[Zone Test] ======================")
    end
    
    -- Set up a command to show zone info
    RegisterCommand("zonetest", function()
        ig.debug.Debug("[Zone Test] === Zone Test Info ===")
        ig.debug.Debug("[Zone Test] Legion Square Zone:")
        print("  - Center: 195, -933")
        print("  - Radius: " .. legionSquareZone:getRadius())
        print("  - Inside: " .. tostring(legionSquareZone:isPointInside(GetEntityCoords(PlayerPedId()))))
        
        ig.debug.Debug("[Zone Test] LSPD Zone:")
        print("  - Center: 441, -982, 30")
        print("  - Length: " .. lspdZone:getLength())
        print("  - Width: " .. lspdZone:getWidth())
        print("  - Heading: " .. lspdZone:getHeading())
        print("  - Inside: " .. tostring(lspdZone:isPointInside(GetEntityCoords(PlayerPedId()))))
        
        ig.debug.Debug("[Zone Test] IPL Configs:")
        local allConfigs = ig.ipls.GetAll()
        for name, config in pairs(allConfigs) do
            print("  - " .. name .. " (loaded: " .. tostring(config.loaded) .. ")")
        end
    end, false)
    
    if ig and ig.log and ig.log.Debug then
        ig.log.Debug("Zone Test", "Command registered: /zonetest")
    else
        ig.debug.Info("[Zone Test] Command registered: /zonetest")
    end
    
    -- Cleanup after 5 minutes (optional, for testing purposes)
    -- Uncomment to auto-cleanup
    --[[
    SetTimeout(300000, function()
        ig.debug.Debug("[Zone Test] Cleaning up test zones...")
        legionSquareZone:destroy()
        lspdZone:destroy()
        comboZone:destroy()
        ig.ipls.UnloadByName("test_nightclub")
        ig.ipl.Unload("v_carshowroom")
        ig.debug.Info("[Zone Test] Cleanup complete")
    end)
    ]]
end)
--]=]
