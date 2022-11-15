-- ====================================================================================--
c.persistance = {}
c.persistant = {}
--
local SPAWN_TIMEOUT = 10000
local SPAWN_DISTANCE = 200
--
local persistance_objects = false
--
function c.persistance.ObjectThread()
	Citizen.CreateThread(function()
		while (true) do
            Citizen.Wait(SPAWN_TIMEOUT)
			if c.func.HasPlayers() then
				c.object.Generate(SPAWN_DISTANCE)
			end
		end
	end)
	persistance_objects = true
end

--[[
	
local persistance_vehicles = false
--
function c.persistance.VehicleThread()
	Citizen.CreateThread(function()
		while (true) do
            Citizen.Wait(10000)
			if c.func.HasPlayers() then
				c.vehicle.Generate(SPAWN_DISTANCE)
			end
		end
	end)
	persistance_vehicles = true
end

]]