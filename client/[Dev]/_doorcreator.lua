local raycast_active = false
local target_entity = nil
local target_coords = nil
local target_model = nil
local target_matrix = nil
local target_rotation = nil
local target_archtype = nil

local function RaycastCamera(flag)
	local cam = GetGameplayCamCoord()
	local direction = GetGameplayCamRot()
	direction = vec2(math.rad(direction.x), math.rad(direction.z))
	local num = math.abs(math.cos(direction.x))
	direction = vec3((-math.sin(direction.y) * num), (math.cos(direction.y) * num), math.sin(direction.x))
	local destination = vec3(cam.x + direction.x * 30, cam.y + direction.y * 30, cam.z + direction.z * 30)
	local rayHandle = StartShapeTestLosProbe(cam, destination, flag or -1, playerPed or PlayerPedId(), 0)
	while true do
		Wait(10) -- Reduce busy waiting from 1ms to 10ms
		local result, _, endCoords, _, materialHash, entityHit = GetShapeTestResultIncludingMaterial(rayHandle)
		if result ~= 1 then
			return entityHit, endCoords
		end
	end
end

local function Target()
    raycast_active = not raycast_active
    print("Raycast is ", raycast_active)
    if not raycast_active then
        return
    else
        Citizen.CreateThread(function()
            while raycast_active do
                Wait(100) -- Reduce frequency from 250ms to 100ms for better responsiveness while still being efficient
                local entity = RaycastCamera(-1)
                local etype = GetEntityType(entity)
                if etype == 3 and IsEntityAnObject(entity) then
                    if target_entity == nil then
                        target_entity = entity
                        target_coords = GetEntityCoords(target_entity)
                        target_matrix = GetEntityMatrix(target_entity)
                        target_rotation = GetEntityRotation(target_entity)
                        target_model = GetEntityModel(target_entity)
                        target_archtype = GetEntityArchetypeName(target_entity)
                    end
                    if target_entity == entity then
                        SetEntityDrawOutlineShader(1)
                        SetEntityDrawOutlineColor(255.0, 0.0, 0.0, 0.3)
                        SetEntityDrawOutline(target_entity, true)
                    end
                    if target_entity ~= entity then
                        SetEntityDrawOutline(target_entity, false)
                        target_entity = entity
                        target_coords = GetEntityCoords(target_entity)
                        target_matrix = GetEntityMatrix(target_entity)
                        target_rotation = GetEntityRotation(target_entity)
                        target_model = GetEntityModel(target_entity)
                        target_archtype = GetEntityArchetypeName(target_entity)
                    end
                end
            end
        end)
    end
end

local DoorDev = RegisterClientCallback({
    eventName = "Developer:DoorDev",
    eventCallback = function()
        Target()
    end
})

local GetDoor = RegisterClientCallback({
    eventName = "Developer:GetDoor",
    eventCallback = function(name, state, job, item, time, timestate)
        if job then
            job = '"'..job..'"'
        end
        if time then
            time = {h=tonumber(time:gsub(1,2)), m=tonumber(time:gsub(3,4)), s=timestate}
        end
        local tbl = {
            Name = '"'..name..'"',
            Job = job,
            Item = item,
            Time = time,
            State = 0,
            Model = target_model,
            Ords = target_coords,
            Info = {
                Arch = '"'..target_archtype..'"',
                Matrix = target_matrix,
                Rotation = target_rotation,
            }
        }
        return tbl
    end
})

