-- ====================================================================================--
ig.persistance = {}
ig.persistant = {}
-- ====================================================================================--
--
local SPAWN_TIMEOUT = 10000
local SPAWN_DISTANCE = 200
--
local persistance_objects = false
--
function ig.persistance.ObjectThread()
	Citizen.CreateThread(function()
		while (true) do
            Citizen.Wait(SPAWN_TIMEOUT)
			if ig.funig.HasPlayers() then
				ig.object.Generate(SPAWN_DISTANCE)
			end
		end
	end)
	persistance_objects = true
end

--[[
	
local persistance_vehicles = false
--
function ig.persistance.VehicleThread()
	Citizen.CreateThread(function()
		while (true) do
            Citizen.Wait(10000)
			if ig.funig.HasPlayers() then
				ig.vehicle.Generate(SPAWN_DISTANCE)
			end
		end
	end)
	persistance_vehicles = true
end

]]