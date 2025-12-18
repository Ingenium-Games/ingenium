-- ====================================================================================--
ig.object = {} -- function level
ig.objects = {} -- database pull 
ig.odex = {} -- the odex/store for currently used objects prior to storage
-- ====================================================================================--

--[[
[       script:ig.dev] {
[       script:ig.dev] [1] = {
[       script:ig.dev]     ['Coords'] = {"h":136.06,"x":-185.62,"y":6363.13,"z":31.47},
[       script:ig.dev]     ['Created'] = 1667124410,
[       script:ig.dev]     ['Meta'] = [],
[       script:ig.dev]     ['ID'] = 1,
[       script:ig.dev]     ['Updated'] = 1667124410,
[       script:ig.dev]     ['Inventory'] = [],
[       script:ig.dev]     ['Model'] = prop_medstation_04,
[       script:ig.dev]     ['UUID'] = c8459048-bfbc-415c-bc70-dbba4ff56a58,
[       script:ig.dev]     },
[       script:ig.dev] }
]]--

function ig.object.Generate(distance)
	for uuid, data in pairs(ig.objects) do
        local found = ig.data.FindObjectFromUUID(data.UUID)
        if (not found) then
            local Coords = json.decode(data.Coords)
            if (ig.funig.GetClosestPlayer(vec3(Coords.x,Coords.y,Coords.z), distance)) then
                -- vehicle not found, spawn it when player is close
                Citizen.CreateThread(function()
                    local entity, net = ig.funig.CreateObject(data.Model, Coords.x, Coords.y, Coords.z, false, data)
                    SetEntityRotation(Coords.rx, Coords.ry, Coords.rz)
                    FreezeEntityPosition(entity, true)
                end)
            end
        end
	end
end

function ig.object.AddObject(data)
    local id = ig.objects
end