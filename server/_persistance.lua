-- ====================================================================================--

c.persistance = {}

local SPAWN_TIMEOUT = 30000
local SPAWN_DISTANCE = 200

local persistance_objects = true

function c.persistance.ObjectThread()
	persistance_objects = true
	Citizen.CreateThread(function()
		while (true) do
            Citizen.Wait(5000)
			if c.func.HasPlayers() then
				c.object.Generate()
			end
		end
	end)
end
