--[[
	Persistence (ig.persistance initialized in client/_var.lua)

AddStateBagChangeHandler("Condition", nil, function(bagName, key, value, _unused, replicated)
	if (bagName:find("entity") == nil) then
		return
	end
    --
	local string = bagName:gsub("entity:", "")
	local net = tonumber(string)
	--
    if (ig.func.WaitUntilNetIdExists(net, 5000)) then
		local vehicle = NetToVeh(net)
		if (ig.func.WaitUntilPlayerIsOwner(vehicle, 5000)) then
			ig.func.SetVehicleCondition(vehicle, value)
			if not Entity(vehicle).state.Spawned then
				Entity(vehicle).state:set("Spawned", true)
			end
		end
	end
end)

AddStateBagChangeHandler("Modifications", nil, function(bagName, key, value, _unused, replicated)
	if (bagName:find("entity") == nil) then
		return
	end
    --
	local string = bagName:gsub("entity:", "")
	local net = tonumber(string)
	--
    if (ig.func.WaitUntilNetIdExists(net, 5000)) then
		local vehicle = NetToVeh(net)
		if (ig.func.WaitUntilPlayerIsOwner(vehicle, 5000)) then
            ig.func.SetVehicleModifications(vehicle, value)
			if not Entity(vehicle).state.Spawned then
				Entity(vehicle).state:set("Spawned", true)
			end
		end
	end
end)

-- update vehicle on server side
function ig.persistance.UpdateVehicle(vehicle)
	if (not DoesEntityExist(vehicle) or not NetworkGetEntityIsNetworked(vehicle)) then
		return
	end

	local net = NetworkGetNetworkIdFromEntity(vehicle)
	local model	= GetEntityModel(vehicle)
	local modifications	= ig.func.GetVehicleModifications(vehicle)
	local condition	= ig.func.GetVehicleCondition(vehicle)

	TriggerServerEvent("Vehicle:Update", net, model, modifications, condition)
end

    -- [C]
    AddEventHandler("Client:LeftVehicle", function(vehicle, seat, name, net)
        ig.persistance.UpdateVehicle(vehicle)
    end)

	]]--