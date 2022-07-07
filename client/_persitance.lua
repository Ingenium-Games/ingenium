--[[
Creates a script vehicle generator at the given coordinates. Most parameters after the model hash are unknown.  
Parameters:  
a/w/s - Generator position  
heading - Generator heading  
p4 - Unknown (always 5.0)  
p5 - Unknown (always 3.0)  
modelHash - Vehicle model hash  
p7/8/9/10 - Unknown (always -1)  
p11 - Unknown (usually TRUE, only one instance of FALSE)  
p12/13 - Unknown (always FALSE)  
p14 - Unknown (usally FALSE, only two instances of TRUE)  
p15 - Unknown (always TRUE)  
p16 - Unknown (always -1)  
Vector3 coords = GET_ENTITY_COORDS(PLAYER_PED_ID(), 0);	CREATE_SCRIPT_VEHICLE_GENERATOR(coords.x, coords.y, coords.z, 1.0f, 5.0f, 3.0f, GET_HASH_KEY("adder"), -1. -1, -1, -1, -1, true, false, false, false, true, -1);  

-- CREATE_SCRIPT_VEHICLE_GENERATOR
local retval = CreateScriptVehicleGenerator(x, y, z, heading, 5.0, 3.0, modelHash, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16)

-- DELETE_SCRIPT_VEHICLE_GENERATOR
DeleteScriptVehicleGenerator(vehicleGenerator)

-- DOES_SCRIPT_VEHICLE_GENERATOR_EXIST
local retval = DoesScriptVehicleGeneratorExist(vehicleGenerator)

-- SET_SCRIPT_VEHICLE_GENERATOR
SetScriptVehicleGenerator(vehicleGenerator, enabled)

]] --