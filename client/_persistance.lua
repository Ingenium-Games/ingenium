--[[
	
ig.persistance = {}

AddStateBagChangeHandler("Condition", nil, function(bagName, key, value, _unused, replicated)
	if (bagName:find("entity") == nil) then
		return
	end
    --
	local string = bagName:gsub("entity:", "")
	local net = tonumber(string)
	--
    if (ig.funig.WaitUntilNetIdExists(net, 5000)) then
		local vehicle = NetToVeh(net)
		if (ig.funig.WaitUntilPlayerIsOwner(vehicle, 5000)) then
			ig.funig.SetVehicleCondition(vehicle, value)
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
    if (ig.funig.WaitUntilNetIdExists(net, 5000)) then
		local vehicle = NetToVeh(net)
		if (ig.funig.WaitUntilPlayerIsOwner(vehicle, 5000)) then
            ig.funig.SetVehicleModifications(vehicle, value)
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
	local modifications	= ig.funig.GetVehicleModifications(vehicle)
	local condition	= ig.funig.GetVehicleCondition(vehicle)

	TriggerServerEvent("Vehicle:Update", net, model, modifications, condition)
end

    -- [C]
    AddEventHandler("Client:LeftVehicle", function(vehicle, seat, name, net)
        ig.persistance.UpdateVehicle(vehicle)
    end)

	]]--