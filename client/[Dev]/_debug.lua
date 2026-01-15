function _DrawText(x, y, width, height, scale, text, r, g, b, a)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(0.25, 0.25)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width / 2, y - height / 2 + 0.005)
end

function _DrawText3Ds(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end

function ShowVehicles()
    local playerped = PlayerPedId()
    local playerpos = GetEntityCoords(playerped)
    local vehs = c.func.GetVehiclesInArea(playerpos, 50, true)
    local distanceFrom
    for k, v in pairs(vehs) do
        if playerped ~= v then
            if DoesEntityExist(v) then
                local pos = GetEntityCoords(v)
                local distance = #(playerpos - pos)
                if distance < 30.0 and (distanceFrom == nil or distance < distanceFrom) then
                    distanceFrom = distance
                    local model = GetEntityModel(v)
                    local isTouching = IsEntityTouchingEntity(playerped, v)
                    if isTouching then
                        _DrawText3Ds(pos["x"], pos["y"], pos["z"] + 1,
                            "Veh: " .. v .. " Model: " .. model .. " IN CONTACT")
                    else
                        _DrawText3Ds(pos["x"], pos["y"], pos["z"] + 1,
                            "Veh: " .. v .. " Model: " .. model .. "")
                    end

                end
            end
        end
    end
end

function ShowObjects()
    local playerped = PlayerPedId()
    local playerpos = GetEntityCoords(playerped)
    local objs = c.func.GetObjectsInArea(playerpos, 50, true)
    local distanceFrom
    for k, v in pairs(objs) do
        if playerped ~= v then
            if DoesEntityExist(v) then
                local pos = GetEntityCoords(v)
                local distance = #(playerpos - pos)
                if distance < 30.0 and (distanceFrom == nil or distance < distanceFrom) then
                    distanceFrom = distance
                    local model = GetEntityModel(v)
                    local isTouching = IsEntityTouchingEntity(playerped, v)
                    if isTouching then
                        _DrawText3Ds(pos["x"], pos["y"], pos["z"] + 1,
                            "Obj: " .. v .. " Model: " .. model .. " IN CONTACT")
                    else
                        _DrawText3Ds(pos["x"], pos["y"], pos["z"] + 1,
                            "Obj: " .. v .. " Model: " .. model .. "")
                    end
                end
            end
        end
    end
end

function ShowNPCs()
    local playerped = PlayerPedId()
    local playerpos = GetEntityCoords(playerped)
    local peds = c.func.GetPedsInArea(playerpos, 50, true)
    local distanceFrom
    for k, v in pairs(peds) do
        if playerped ~= v then
            if DoesEntityExist(v) then
                local pos = GetEntityCoords(v)
                local distance = #(playerpos - pos)
                if distance < 30.0 and (distanceFrom == nil or distance < distanceFrom) then
                    distanceFrom = distance
                    local model = GetEntityModel(v)
                    local relationshipHash = GetPedRelationshipGroupHash(v)
                    local isTouching = IsEntityTouchingEntity(playerped, v)
                    if isTouching then
                        _DrawText3Ds(pos["x"], pos["y"], pos["z"],
                            "Ped: " .. v .. " Model: " .. model .. " Relationship HASH: " ..
                                relationshipHash .. " IN CONTACT")
                    else
                        _DrawText3Ds(pos["x"], pos["y"], pos["z"], "Ped: " .. v .. " Model: " .. model ..
                            " Relationship HASH: " .. relationshipHash)
                    end
                end
            end
        end
    end
end

Citizen.CreateThread(function()
    while true do
        if type(Debug) == "table" and Debug.Enable then
            Citizen.Wait(0)
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)

            local forPos = GetOffsetFromEntityInWorldCoords(ped, 0, 1.0, 0.0)
            local backPos = GetOffsetFromEntityInWorldCoords(ped, 0, -1.0, 0.0)
            local LPos = GetOffsetFromEntityInWorldCoords(ped, 1.0, 0.0, 0.0)
            local RPos = GetOffsetFromEntityInWorldCoords(ped, -1.0, 0.0, 0.0)

            local forPos2 = GetOffsetFromEntityInWorldCoords(ped, 0, 2.0, 0.0)
            local backPos2 = GetOffsetFromEntityInWorldCoords(ped, 0, -2.0, 0.0)
            local LPos2 = GetOffsetFromEntityInWorldCoords(ped, 2.0, 0.0, 0.0)
            local RPos2 = GetOffsetFromEntityInWorldCoords(ped, -2.0, 0.0, 0.0)

            local x, y, z = table.unpack(pos)
            local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z, currentStreetHash,
                intersectStreetHash)
            currentStreetName = GetStreetNameFromHashKey(currentStreetHash)

            _DrawText(0.8, 0.50, 0.4, 0.4, 0.30, "Heading: " .. GetEntityHeading(ped), 55, 155, 55, 255)
            _DrawText(0.8, 0.52, 0.4, 0.4, 0.30, "Coords: " .. pos, 55, 155, 55, 255)
            _DrawText(0.8, 0.54, 0.4, 0.4, 0.30, "Attached Ent: " .. GetEntityAttachedTo(ped), 55, 155, 55, 255)
            _DrawText(0.8, 0.56, 0.4, 0.4, 0.30, "Health: " .. GetEntityHealth(ped), 55, 155, 55, 255)
            _DrawText(0.8, 0.58, 0.4, 0.4, 0.30, "H a G: " .. GetEntityHeightAboveGround(ped), 55, 155, 55, 255)
            _DrawText(0.8, 0.60, 0.4, 0.4, 0.30, "Model: " .. GetEntityModel(ped), 55, 155, 55, 255)
            _DrawText(0.8, 0.62, 0.4, 0.4, 0.30, "Speed: " .. GetEntitySpeed(ped), 55, 155, 55, 255)
            _DrawText(0.8, 0.64, 0.4, 0.4, 0.30, "Frame Time: " .. GetFrameTime(), 55, 155, 55, 255)
            _DrawText(0.8, 0.66, 0.4, 0.4, 0.30, "Street: " .. currentStreetName, 55, 155, 55, 255)

            _DrawText(pos, forPos, 255, 0, 0, 115)
            _DrawText(pos, backPos, 255, 0, 0, 115)

            _DrawText(pos, LPos, 255, 255, 0, 115)
            _DrawText(pos, RPos, 255, 255, 0, 115)

            _DrawText(forPos, forPos2, 255, 0, 255, 115)
            _DrawText(backPos, backPos2, 255, 0, 255, 115)

            _DrawText(LPos, LPos2, 255, 255, 255, 115)
            _DrawText(RPos, RPos2, 255, 255, 255, 115)

            ShowNPCs()

            ShowVehicles()

            ShowObjects()

        else
            Citizen.Wait(1250)
        end
    end
end)
