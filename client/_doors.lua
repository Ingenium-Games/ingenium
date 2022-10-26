-- ====================================================================================--

c.door = {} -- functions
c.doors = {} -- from server

-- ====================================================================================--


--[[
0: UNLOCKED
1: LOCKED
2: DOORSTATE_FORCE_LOCKED_UNTIL_OUT_OF_AREA
3: DOORSTATE_FORCE_UNLOCKED_THIS_FRAME
4: DOORSTATE_FORCE_LOCKED_THIS_FRAME
5: DOORSTATE_FORCE_OPEN_THIS_FRAME
6: DOORSTATE_FORCE_CLOSED_THIS_FRAME
]]--
DoorSystemSetDoorState(doorHash, state, 1)

local bool, doorHash = DoorSystemFindExistingDoor(x,y,z,modelHash)
IsDoorRegisteredWithSystem(doorHash)
AddDoorToSystem(doorHash, modelHash, x, y, z, false, false, false)