#!/usr/bin/env lua

-- ====================================================================================--
-- Refactoring Validation Script
-- Tests the refactored code for basic functionality
-- ====================================================================================--

print("=== Ingenium Refactoring Validation ===\n")

local tests_passed = 0
local tests_failed = 0

-- Helper function to test
local function test(name, fn)
    io.write(string.format("Testing: %s... ", name))
    local success, err = pcall(fn)
    if success then
        print("✅ PASS")
        tests_passed = tests_passed + 1
    else
        print("❌ FAIL: " .. tostring(err))
        tests_failed = tests_failed + 1
    end
end

-- Mock ig namespace
_G.ig = _G.ig or {}
_G.ig.fileLog = _G.ig.fileLog or {}
_G.conf = _G.conf or {}

print("Phase 1: File Logging Utility Tests\n")

-- Test 1: File logging utility exists
test("File logging utility file exists", function()
    local f = io.open("server/[Tools]/_file_logging.lua", "r")
    assert(f, "File not found")
    f:close()
end)

-- Test 2: Main logging uses shared utility
test("Main logging refactored correctly", function()
    local f = io.open("server/[Tools]/_logging.lua", "r")
    assert(f, "File not found")
    local content = f:read("*all")
    f:close()
    
    -- Should use ig.fileLog.Create
    assert(content:match("ig%.fileLog%.Create"), "Should use ig.fileLog.Create")
    
    -- Should NOT have old queue code
    assert(not content:match("local logQueue = {}"), "Should not have old local logQueue")
    assert(not content:match("local isWriting = false"), "Should not have old isWriting flag")
end)

-- Test 3: Chat logging uses shared utility
test("Chat logging refactored correctly", function()
    local f = io.open("server/_chat.lua", "r")
    assert(f, "File not found")
    local content = f:read("*all")
    f:close()
    
    -- Should use ig.fileLog.Create
    assert(content:match("ig%.fileLog%.Create"), "Should use ig.fileLog.Create")
    
    -- Should NOT use io.open (FiveM incompatible)
    assert(not content:match("io%.open"), "Should not use io.open")
    
    -- Should NOT have old queue code
    assert(not content:match("local chatLogQueue = {}"), "Should not have old chatLogQueue")
end)

print("\nPhase 2: Gamemode Handler Tests\n")

-- Test 4: Gamemode handlers use registry pattern
test("Gamemode handlers refactored correctly", function()
    local f = io.open("client/[Events]/_gamemode.lua", "r")
    assert(f, "File not found")
    local content = f:read("*all")
    f:close()
    
    -- Should have registry table
    assert(content:match("local gameModeHandlers"), "Should have gameModeHandlers registry")
    
    -- Should NOT have multiple if blocks
    local count = 0
    for _ in content:gmatch('if conf%.gamemode == "RP"') do count = count + 1 end
    assert(count == 0, "Should not have old if conf.gamemode == 'RP' blocks")
    
    -- Should have single unified handlers
    local handler_count = 0
    for _ in content:gmatch('AddEventHandler%("Client:EnteredVehicle"') do 
        handler_count = handler_count + 1 
    end
    assert(handler_count == 1, "Should have exactly 1 Client:EnteredVehicle handler, found " .. handler_count)
end)

print("\nPhase 3: Event Documentation Tests\n")

-- Test 5: HUD events have documentation
test("HUD events documented", function()
    local f = io.open("nui/lua/hud.lua", "r")
    assert(f, "File not found")
    local content = f:read("*all")
    f:close()
    
    -- Should have NOTE comments
    assert(content:match("NOTE:.*no registered handlers"), "Should document orphaned events")
    assert(content:match("TODO:"), "Should have TODO for future handlers")
end)

-- Test 6: Drop events documented
test("Drop events documented", function()
    local f = io.open("client/[Drops]/_drop_integration.lua", "r")
    assert(f, "File not found")
    local content = f:read("*all")
    f:close()
    
    -- Should have NOTE comment
    assert(content:match("NOTE:"), "Should document event pairing")
end)

print("\nPhase 4: Documentation Tests\n")

-- Test 7: New documentation files exist
test("File logging documentation exists", function()
    local f = io.open("Documentation/FILE_LOGGING_REFACTOR.md", "r")
    assert(f, "Documentation not found")
    f:close()
end)

test("Gamemode handler documentation exists", function()
    local f = io.open("Documentation/GAMEMODE_HANDLER_REFACTOR.md", "r")
    assert(f, "Documentation not found")
    f:close()
end)

test("Event analysis documentation exists", function()
    local f = io.open("Documentation/EVENT_REGISTRATION_ANALYSIS.md", "r")
    assert(f, "Documentation not found")
    f:close()
end)

-- Test 8: Main README updated
test("Documentation README updated", function()
    local f = io.open("Documentation/README.md", "r")
    assert(f, "File not found")
    local content = f:read("*all")
    f:close()
    
    -- Should link to new docs
    assert(content:match("FILE_LOGGING_REFACTOR"), "Should link to file logging docs")
    assert(content:match("GAMEMODE_HANDLER_REFACTOR"), "Should link to gamemode docs")
    assert(content:match("EVENT_REGISTRATION_ANALYSIS"), "Should link to event analysis")
end)

print("\nPhase 5: fxmanifest.lua Tests\n")

-- Test 9: fxmanifest includes new file
test("fxmanifest includes file logging utility", function()
    local f = io.open("fxmanifest.lua", "r")
    assert(f, "File not found")
    local content = f:read("*all")
    f:close()
    
    -- Should include new file
    assert(content:match("server/%[Tools%]/_file_logging%.lua"), 
        "Should include server/[Tools]/_file_logging.lua")
end)

print("\n=== Validation Summary ===")
print(string.format("✅ Tests Passed: %d", tests_passed))
print(string.format("❌ Tests Failed: %d", tests_failed))
print(string.format("Total: %d", tests_passed + tests_failed))

if tests_failed > 0 then
    os.exit(1)
else
    print("\n🎉 All validation tests passed!")
    os.exit(0)
end
