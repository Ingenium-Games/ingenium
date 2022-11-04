-- ====================================================================================--

c.object = {} -- function level
c.objects = {} -- database pull 
c.odex = {} -- the odex/store for currently used objects prior to storage

-- ====================================================================================--

--[[
[       script:ig.dev] {
[       script:ig.dev] ['c8459048-bfbc-415c-bc70-dbba4ff56a58'] = {
[       script:ig.dev]     ['Coords'] = {"h":136.06,"x":-185.62,"y":6363.13,"z":31.47,"rx":0.00,"ry":0.00,"rz":0.00},
[       script:ig.dev]     ['Updated'] = 1667124410,
[       script:ig.dev]     ['Model'] = prop_medstation_04,
[       script:ig.dev]     ['Created'] = 1667124410,
[       script:ig.dev]     ['Meta'] = {},
[       script:ig.dev]     ['Inventory'] = {
[       script:ig.dev]         },
[       script:ig.dev]     },
[       script:ig.dev] }
]]--

function c.object.Generate()
	for uuid, data in pairs(c.objects) do
        local found = c.data.FindObjectFromUUID(uuid)
        c.func.Debug_1(found)
        if (not found) then
            if (c.func.GetClosestPlayer(vec3(data.Coords.x,data.Coords.y,data.Coords.z), 100)) then
                -- vehicle not found, spawn it when player is close
                Citizen.CreateThread(function()
                    local entity, net = c.func.CreateObject(data.Model, data.Coords.x, data.Coords.y, data.Coords.z, false, data)
                    FreezeEntityPosition(entity, true)
                end)
            end
        end
	end
end

