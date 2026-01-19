#!/usr/bin/env python3
"""
Refactoring Validation Script
Tests the refactored code for basic functionality
"""

import os
import sys
import re

print("=== Ingenium Refactoring Validation ===\n")

tests_passed = 0
tests_failed = 0

def test(name, fn):
    """Run a test and track results"""
    global tests_passed, tests_failed
    
    print(f"Testing: {name}... ", end="")
    try:
        fn()
        print("✅ PASS")
        tests_passed += 1
    except AssertionError as e:
        print(f"❌ FAIL: {e}")
        tests_failed += 1
    except Exception as e:
        print(f"❌ ERROR: {e}")
        tests_failed += 1

def read_file(path):
    """Read file content"""
    with open(path, 'r', encoding='utf-8') as f:
        return f.read()

print("Phase 1: File Logging Utility Tests\n")

# Test 1: File logging utility exists
def test1():
    path = "server/[Tools]/_file_logging.lua"
    assert os.path.exists(path), f"File not found: {path}"

test("File logging utility file exists", test1)

# Test 2: Main logging uses shared utility
def test2():
    content = read_file("server/[Tools]/_logging.lua")
    assert "ig.fileLog.Create" in content, "Should use ig.fileLog.Create"
    assert "local logQueue = {}" not in content, "Should not have old local logQueue"
    assert "local isWriting = false" not in content, "Should not have old isWriting flag"

test("Main logging refactored correctly", test2)

# Test 3: Chat logging uses shared utility
def test3():
    content = read_file("server/_chat.lua")
    assert "ig.fileLog.Create" in content, "Should use ig.fileLog.Create"
    assert "io.open" not in content, "Should not use io.open (FiveM incompatible)"
    assert "local chatLogQueue = {}" not in content, "Should not have old chatLogQueue"

test("Chat logging refactored correctly", test3)

print("\nPhase 2: Gamemode Handler Tests\n")

# Test 4: Gamemode handlers use registry pattern
def test4():
    content = read_file("client/[Events]/_gamemode.lua")
    assert "local gameModeHandlers" in content, "Should have gameModeHandlers registry"
    
    # Should NOT have multiple if blocks
    count = content.count('if conf.gamemode == "RP"')
    assert count == 0, f"Should not have old if conf.gamemode == 'RP' blocks, found {count}"
    
    # Should have single unified handlers
    handler_count = content.count('AddEventHandler("Client:EnteredVehicle"')
    assert handler_count == 1, f"Should have exactly 1 Client:EnteredVehicle handler, found {handler_count}"

test("Gamemode handlers refactored correctly", test4)

print("\nPhase 3: Event Documentation Tests\n")

# Test 5: HUD events have documentation
def test5():
    content = read_file("nui/lua/hud.lua")
    assert "NOTE:" in content and "no registered handlers" in content, "Should document orphaned events"
    assert "TODO:" in content, "Should have TODO for future handlers"

test("HUD events documented", test5)

# Test 6: Drop events documented
def test6():
    content = read_file("client/[Drops]/_drop_integration.lua")
    assert "NOTE:" in content, "Should document event pairing"

test("Drop events documented", test6)

print("\nPhase 4: Documentation Tests\n")

# Test 7: New documentation files exist
def test7a():
    assert os.path.exists("Documentation/FILE_LOGGING_REFACTOR.md"), "Documentation not found"

test("File logging documentation exists", test7a)

def test7b():
    assert os.path.exists("Documentation/GAMEMODE_HANDLER_REFACTOR.md"), "Documentation not found"

test("Gamemode handler documentation exists", test7b)

def test7c():
    assert os.path.exists("Documentation/EVENT_REGISTRATION_ANALYSIS.md"), "Documentation not found"

test("Event analysis documentation exists", test7c)

# Test 8: Main README updated
def test8():
    content = read_file("Documentation/README.md")
    assert "FILE_LOGGING_REFACTOR" in content, "Should link to file logging docs"
    assert "GAMEMODE_HANDLER_REFACTOR" in content, "Should link to gamemode docs"
    assert "EVENT_REGISTRATION_ANALYSIS" in content, "Should link to event analysis"

test("Documentation README updated", test8)

print("\nPhase 5: fxmanifest.lua Tests\n")

# Test 9: fxmanifest includes new file
def test9():
    content = read_file("fxmanifest.lua")
    assert "server/[Tools]/_file_logging.lua" in content, "Should include server/[Tools]/_file_logging.lua"

test("fxmanifest includes file logging utility", test9)

print("\n=== Validation Summary ===")
print(f"✅ Tests Passed: {tests_passed}")
print(f"❌ Tests Failed: {tests_failed}")
print(f"Total: {tests_passed + tests_failed}")

if tests_failed > 0:
    sys.exit(1)
else:
    print("\n🎉 All validation tests passed!")
    sys.exit(0)
