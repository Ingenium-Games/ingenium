-- ====================================================================================--
-- Zone System Example/Test
-- This file demonstrates and tests the ig.zone and ig.ipls functionality
-- 
-- TO USE THIS TEST:
-- 1. Ensure this file is loaded (it's included by client/**/*.lua in fxmanifest)
-- 2. Start the server and join the game
-- 3. Check console for test results
-- 4. Use /zonetest command to see current zone info
-- 5. Visit test locations to trigger callbacks
-- 
-- TO DISABLE THIS TEST:
-- Rename this file with .disabled extension or move it out of client/[Zones]/
-- ====================================================================================--

-- Wait for game to be loaded
CreateThread(function()
    Wait(5000)  -- Wait for game and Ingenium to fully load
    
    if ig and ig.log and ig.log.Debug then
        ig.log.Debug("Zone Test", "Starting zone system tests...")
    else
        print("^2[Zone Test] Starting zone system tests...^0")
    end
    
    -- ====================================================================================--
    -- Test 1: Basic Zone Creation
    -- ====================================================================================--
    print("^3[Zone Test] Test 1: Creating basic zones^0")
    
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
        print("^2[Zone Test] ✓ Circle zone created successfully^0")
    else
        print("^1[Zone Test] ✗ Failed to create circle zone^0")
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
        print("^2[Zone Test] ✓ Box zone created successfully^0")
    else
        print("^1[Zone Test] ✗ Failed to create box zone^0")
    end
    
    -- ====================================================================================--
    -- Test 2: Point Checking
    -- ====================================================================================--
    print("^3[Zone Test] Test 2: Testing point checking^0")
    
    -- Test point inside Legion Square zone
    local testPoint1 = vector3(195.0, -933.0, 28.0)
    if legionSquareZone:isPointInside(testPoint1) then
        print("^2[Zone Test] ✓ Point inside Legion Square detected correctly^0")
    else
        print("^1[Zone Test] ✗ Failed to detect point inside zone^0")
    end
    
    -- Test point outside zone
    local testPoint2 = vector3(1000.0, 1000.0, 28.0)
    if not legionSquareZone:isPointInside(testPoint2) then
        print("^2[Zone Test] ✓ Point outside Legion Square detected correctly^0")
    else
        print("^1[Zone Test] ✗ False positive: point detected as inside when outside^0")
    end
    
    -- ====================================================================================--
    -- Test 3: Player In/Out Callbacks
    -- ====================================================================================--
    print("^3[Zone Test] Test 3: Setting up player in/out callbacks^0")
    
    legionSquareZone:onPlayerInOut(function(isInside, point)
        if isInside then
            print("^2[Zone Test] Player entered Legion Square!^0")
        else
            print("^3[Zone Test] Player left Legion Square.^0")
        end
    end, 1000)  -- Check every second
    
    if ig and ig.log and ig.log.Debug then
        ig.log.Debug("Zone Test", "Callbacks registered (visit Legion Square to test)")
    else
        print("^2[Zone Test] ✓ Callbacks registered (visit Legion Square to test)^0")
    end
    
    -- ====================================================================================--
    -- Test 4: IPL System
    -- ====================================================================================--
    print("^3[Zone Test] Test 4: Testing IPL system^0")
    
    -- Test basic IPL loading
    ig.ipl.Load("v_carshowroom")
    
    if ig.ipl.IsLoaded("v_carshowroom") then
        if ig and ig.log and ig.log.Debug then
            ig.log.Debug("Zone Test", "IPL loaded successfully")
        else
            print("^2[Zone Test] ✓ IPL loaded successfully^0")
        end
    else
        if ig and ig.log and ig.log.Warn then
            ig.log.Warn("Zone Test", "Failed to load IPL")
        else
            print("^1[Zone Test] ✗ Failed to load IPL^0")
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
        print("^2[Zone Test] ✓ IPL configuration registered^0")
        if config.zone then
            print("^2[Zone Test] ✓ Zone configuration attached^0")
        end
    else
        print("^1[Zone Test] ✗ Failed to register IPL configuration^0")
    end
    
    -- ====================================================================================--
    -- Test 5: ComboZone
    -- ====================================================================================--
    print("^3[Zone Test] Test 5: Testing ComboZone^0")
    
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
            print("^2[Zone Test] ✓ ComboZone created with 3 zones^0")
        end
        
        -- Test if point is in any zone
        local testPoint = vector3(200.0, -900.0, 28.0)
        local isInside, zone = comboZone:isPointInside(testPoint)
        if isInside and zone then
            if ig and ig.log and ig.log.Debug then
                ig.log.Debug("Zone Test", "Point found in combo zone: %s", zone.name)
            else
                print("^2[Zone Test] ✓ Point found in combo zone: " .. zone.name .. "^0")
            end
        else
            if ig and ig.log and ig.log.Warn then
                ig.log.Warn("Zone Test", "Failed to detect point in combo zone")
            else
                print("^1[Zone Test] ✗ Failed to detect point in combo zone^0")
            end
        end
    else
        if ig and ig.log and ig.log.Error then
            ig.log.Error("Zone Test", "Failed to create ComboZone")
        else
            print("^1[Zone Test] ✗ Failed to create ComboZone^0")
        end
    end
    
    -- ====================================================================================--
    -- Test 6: Zone Modifications
    -- ====================================================================================--
    print("^3[Zone Test] Test 6: Testing zone modifications^0")
    
    -- Test box zone modifications
    lspdZone:setLength(80.0)
    if lspdZone:getLength() == 80.0 then
        print("^2[Zone Test] ✓ Box zone length modification works^0")
    else
        print("^1[Zone Test] ✗ Failed to modify box zone length^0")
    end
    
    lspdZone:setHeading(45.0)
    if lspdZone:getHeading() == 45.0 then
        print("^2[Zone Test] ✓ Box zone heading modification works^0")
    else
        print("^1[Zone Test] ✗ Failed to modify box zone heading^0")
    end
    
    -- Test circle zone modifications
    legionSquareZone:setRadius(75.0)
    if legionSquareZone:getRadius() == 75.0 then
        print("^2[Zone Test] ✓ Circle zone radius modification works^0")
    else
        print("^1[Zone Test] ✗ Failed to modify circle zone radius^0")
    end
    
    -- ====================================================================================--
    -- Test Summary
    -- ====================================================================================--
    if ig and ig.log and ig.log.Debug then
        ig.log.Debug("Zone Test", "Test suite completed!")
        ig.log.Debug("Zone Test", "Visit Legion Square to test player callbacks")
        ig.log.Debug("Zone Test", "Visit Nightclub (-1569, -3017) to test dynamic IPL loading")
    else
        print("^2[Zone Test] ======================^0")
        print("^2[Zone Test] Test suite completed!^0")
        print("^2[Zone Test] Visit Legion Square to test player callbacks^0")
        print("^2[Zone Test] Visit Nightclub (-1569, -3017) to test dynamic IPL loading^0")
        print("^2[Zone Test] ======================^0")
    end
    
    -- Set up a command to show zone info
    RegisterCommand("zonetest", function()
        print("^3=== Zone Test Info ===^0")
        print("^3Legion Square Zone:^0")
        print("  - Center: 195, -933")
        print("  - Radius: " .. legionSquareZone:getRadius())
        print("  - Inside: " .. tostring(legionSquareZone:isPointInside(GetEntityCoords(PlayerPedId()))))
        
        print("^3LSPD Zone:^0")
        print("  - Center: 441, -982, 30")
        print("  - Length: " .. lspdZone:getLength())
        print("  - Width: " .. lspdZone:getWidth())
        print("  - Heading: " .. lspdZone:getHeading())
        print("  - Inside: " .. tostring(lspdZone:isPointInside(GetEntityCoords(PlayerPedId()))))
        
        print("^3IPL Configs:^0")
        local allConfigs = ig.ipls.GetAll()
        for name, config in pairs(allConfigs) do
            print("  - " .. name .. " (loaded: " .. tostring(config.loaded) .. ")")
        end
    end, false)
    
    if ig and ig.log and ig.log.Debug then
        ig.log.Debug("Zone Test", "Command registered: /zonetest")
    else
        print("^2[Zone Test] Command registered: /zonetest^0")
    end
    
    -- Cleanup after 5 minutes (optional, for testing purposes)
    -- Uncomment to auto-cleanup
    --[[
    SetTimeout(300000, function()
        print("^3[Zone Test] Cleaning up test zones...^0")
        legionSquareZone:destroy()
        lspdZone:destroy()
        comboZone:destroy()
        ig.ipls.UnloadByName("test_nightclub")
        ig.ipl.Unload("v_carshowroom")
        print("^2[Zone Test] Cleanup complete^0")
    end)
    ]]
end)
