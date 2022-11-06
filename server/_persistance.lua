-- ====================================================================================--
c.persistance = {}
--
local SPAWN_TIMEOUT = 30000
local SPAWN_DISTANCE = 200
--
local persistance_sync = false
--
function c.persistance.TableSync()
	Citizen.CreateThread(function()
		while (true) do
			Citizen.Wait(SPAWN_TIMEOUT)
			c.sql.obj.GetObjects()
			c.sql.veh.GetVehicles()
		end
	end)
	persistance_sync = true
end

local persistance_objects = false
--
function c.persistance.ObjectThread()
	Citizen.CreateThread(function()
		while (true) do
            Citizen.Wait(5000)
			if c.func.HasPlayers() then
				c.object.Generate(SPAWN_TIMEOUT, SPAWN_DISTANCE)
			end
		end
	end)
	persistance_objects = true
end

local persistance_vehicles = false
--
function c.persistance.VehicleThread()
	Citizen.CreateThread(function()
		while (true) do
            Citizen.Wait(5000)
			if c.func.HasPlayers() then
				c.vehicle.Generate(SPAWN_TIMEOUT, SPAWN_DISTANCE)
			end
		end
	end)
	persistance_vehicles = true
end
