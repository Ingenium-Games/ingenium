-- ====================================================================================--

c.persistance = {}

local SPAWN_TIMEOUT = 30000
local SPAWN_DISTANCE = 200



local persistance_objects = false
--
function c.persistance.ObjectThread()
	Citizen.CreateThread(function()
		while (true) do
            Citizen.Wait(5000)
			if c.func.HasPlayers() then
				c.object.SyncCheck()
				Citizen.Wait(2000)
				c.object.Generate(SPAWN_TIMEOUT, SPAWN_DISTANCE)
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
            Citizen.Wait(5000)
			if c.func.HasPlayers() then
				c.vehicle.SyncCheck()
				Citizen.Wait(2000)
				c.vehicle.Generate(SPAWN_TIMEOUT, SPAWN_DISTANCE)
			end
		end
	end)
	persistance_vehicles = true
end

]]--