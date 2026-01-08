local Config = {}

Config.VehicleEnterKey = 49 -- they button you press when entering a vehicle / Default 'F - 49'
Config.SecondKey = 19 -- Default '19 - ALT' is used to access hanging spots on cars

Config.ShuffCommand = 'shuff'

Config.SeatIcon = '🔺' -- the emoji you want to see

local stopShuffle = true

CreateThread(function()
    while true do
        Wait(100) -- Check every 100ms instead of every frame
        local playerPed = PlayerPedId()
        local plyCoords = GetEntityCoords(playerPed)
        local vehicle = GetClosestVehicle(plyCoords, 7.5, 0, 2175)
        
        if vehicle ~= 0 then
            local vehicleCoords = GetEntityCoords(vehicle)
            local dist = #(vehicleCoords - plyCoords)

            if dist < 5.0 then
                if IsVehicleDriveable(vehicle, false) and not IsPedInAnyVehicle(playerPed, true) then
                    if IsEntityAVehicle(vehicle) and DoesEntityExist(vehicle) then

                        -- Driver Side
                        local seatdside_fBone, seatdside_rBone = GetEntityBoneIndexByName(vehicle, 'seat_dside_f'), GetEntityBoneIndexByName(vehicle, 'seat_dside_r')
                       
                        local seat_dside_f, seat_dside_r = GetWorldPositionOfEntityBone(vehicle, seatdside_fBone), GetWorldPositionOfEntityBone(vehicle, seatdside_rBone)
                        
                        local dist_seat_dside_f, dist_seat_dside_r = #(seat_dside_f - plyCoords), #(seat_dside_r - plyCoords)
    
                        -- Driver Side
                        if dist_seat_dside_f < 1.3 then
                            DrawText3D(seat_dside_f.x, seat_dside_f.y, seat_dside_f.z + 0.7, Config.SeatIcon)
    
                            if IsControlJustPressed(1, Config.VehicleEnterKey) then
                                TaskEnterVehicle(playerPed, vehicle, 10000, -1, 1.0, 1, 0)
                            end
                        elseif dist_seat_dside_r < 1.7 then
                            DrawText3D(seat_dside_r.x, seat_dside_r.y, seat_dside_r.z + 0.7, Config.SeatIcon)
    
                            if IsControlJustPressed(1, Config.VehicleEnterKey) then
                                TaskEnterVehicle(playerPed, vehicle, 10000, 1, 1.0, 1, 0)
                            end
                        end
    
                        -- Passenger Side
                        local seatpside_fBone, seatpside_rBone = GetEntityBoneIndexByName(vehicle, 'seat_pside_f'), GetEntityBoneIndexByName(vehicle, 'seat_pside_r')
    
                        local seat_pside_f, seat_pside_r = GetWorldPositionOfEntityBone(vehicle, seatpside_fBone), GetWorldPositionOfEntityBone(vehicle, seatpside_rBone)
    
                        local dist_seat_pside_f, dist_seat_pside_r = #(seat_pside_f - plyCoords), #(seat_pside_r - plyCoords)
    
                        if dist_seat_pside_f < 1.3 then
                            DrawText3D(seat_pside_f.x, seat_pside_f.y, seat_pside_f.z + 0.7, Config.SeatIcon)
    
                            if IsControlJustPressed(1, Config.VehicleEnterKey) then
                                TaskEnterVehicle(playerPed, vehicle, 10000, 0, 1.0, 1, 0)
                            end
                        elseif dist_seat_pside_r < 1.7 then
                            DrawText3D(seat_pside_r.x, seat_pside_r.y, seat_pside_r.z + 0.7, Config.SeatIcon)
    
                            if IsControlJustPressed(1, Config.VehicleEnterKey) then
                                TaskEnterVehicle(playerPed, vehicle, 10000, 2, 1.0, 1, 0)
                            end
                        end
                        
                        if IsControlPressed(0, Config.SecondKey) then
                            -- Avoid creating nested loop, handle alternate seats in same loop
                            local seatdside_r1Bone = GetEntityBoneIndexByName(vehicle, 'seat_dside_r1')
                            local seatdside_r2Bone = GetEntityBoneIndexByName(vehicle, 'seat_dside_r2')
    
                            local seat_dside_r1 = GetWorldPositionOfEntityBone(vehicle, seatdside_r1Bone)
                            local seat_dside_r2 = GetWorldPositionOfEntityBone(vehicle, seatdside_r2Bone)
                            
                            local dist_seat_dside_r1 = #(seat_dside_r1 - plyCoords)
                            local dist_seat_dside_r2 = #(seat_dside_r2 - plyCoords)
    
                            -- Passenger Side
                            local seatpside_r1Bone = GetEntityBoneIndexByName(vehicle, 'seat_pside_r1')
                            local seatpside_r2Bone = GetEntityBoneIndexByName(vehicle, 'seat_pside_r2')
    
                            local seat_pside_r1 = GetWorldPositionOfEntityBone(vehicle, seatpside_r1Bone)
                            local seat_pside_r2 = GetWorldPositionOfEntityBone(vehicle, seatpside_r2Bone)
    
                            local dist_seat_pside_r1 = #(seat_pside_r1 - plyCoords)
                            local dist_seat_pside_r2 = #(seat_pside_r2 - plyCoords)
    
                            
                            if dist_seat_dside_r1 < 0.8 then
                                DrawText3D(seat_dside_r1.x, seat_dside_r1.y, seat_dside_r1.z + 0.7, Config.SeatIcon)
    
                                if IsControlJustPressed(1, Config.VehicleEnterKey) then
                                    TaskEnterVehicle(playerPed, vehicle, 10000, 3, 1.0, 1, 0)
                                end
                            elseif dist_seat_dside_r2 < 0.8 then
                                DrawText3D(seat_dside_r2.x, seat_dside_r2.y, seat_dside_r2.z + 0.7, Config.SeatIcon)
    
                                if IsControlJustPressed(1, Config.VehicleEnterKey) then
                                    TaskEnterVehicle(playerPed, vehicle, 10000, 5, 1.0, 1, 0)
                                end
                            end
                            
                            if dist_seat_pside_r1 < 0.8 then
                                DrawText3D(seat_pside_r1.x, seat_pside_r1.y, seat_pside_r1.z + 0.7, Config.SeatIcon)
                
                                if IsControlJustPressed(1, Config.VehicleEnterKey) then
                                    TaskEnterVehicle(playerPed, vehicle, 10000, 4, 1.0, 1, 0)
                                end
                            elseif dist_seat_pside_r2 < 0.8 then
                                DrawText3D(seat_pside_r2.x, seat_pside_r2.y, seat_pside_r2.z + 0.7, Config.SeatIcon)
                
                                if IsControlJustPressed(1, Config.VehicleEnterKey) then
                                    TaskEnterVehicle(playerPed, vehicle, 10000, 6, 1.0, 1, 0)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

function denyShuffle()
    stopShuffle = true
end

function allowShuffle()
    stopShuffle = false
end

RegisterNetEvent('shuff')
AddEventHandler('shuff', function()
	local playerPed = PlayerPedId()

    if IsPedInAnyVehicle(playerPed, false) then
		allowShuffle()

		Wait(5000)

		denyShuffle()
	else
		CancelEvent()
	end
end)

RegisterCommand(Config.ShuffCommand, function(source, args, raw)
    TriggerEvent('shuff')
end, false)

CreateThread(function()
	while true do
        Wait(100) -- Check every 100ms instead of every frame or 500ms
        local playerPed = PlayerPedId() 
        local vehicle = GetVehiclePedIsIn(playerPed, false)

		if IsPedInAnyVehicle(playerPed, false) and stopShuffle then
			if GetPedInVehicleSeat(vehicle, 0) == playerPed then
				if GetIsTaskActive(playerPed, 165) then
					SetPedIntoVehicle(playerPed, vehicle, 0)
				end
			end
		end
	end
end)

function DrawText3D(x,y,z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z - 0.7)

    if onScreen then
          SetTextScale(0.2, 0.2)
          SetTextFont(6)
          SetTextProportional(1)
          SetTextColour(0, 255, 0, 255)
          SetTextEntry('STRING')
          SetTextCentre(1)
          AddTextComponentString(text)
          DrawText(_x,_y)
      end
  end