-- ====================================================================================--

c.vehicle = {} -- function level
c.vehicles = exports["ig.dump"]:GetVehicles()
c.vdex = {} -- npc vehicles...
c.pvdex = {} -- the index/store for currently used vehciles prior to writing to db.
--[[
NOTES.
    - Some natives use entity
    - Some natives use NetworkID.
    - Network ID should be for the server and entity for the individual user is different.
    - data getters within the _data file.
]]--

-- ====================================================================================--

---@param plate string "Plate of vehicle."
function c.vehicle.GetByPlate(plate)
    for k,v in pairs(c.vdex) do
        if v.Plate == plate then
            return v
        end
    end 
    for k,v in pairs(c.pvdex) do
        if k == plate then
            return v
        end
    end 
    return false
end

function c.vehicle.GetDumpedHashes()
    local t = {}
    for k,v in pairs(c.vehicles) do
        table.insert(t, v.SignedHash)
    end  
    return t
end

function c.vehicle.ChangeOwner(source, net, playerid) 
    local src = source
    local xPlayer = c.data.GetPlayer(src)
    local zPlayer = c.data.GetPlayer(playerid)
    local veh = c.data.GetVehicle(net)
    if veh.GetOwner() == xPlayer.GetItentifier() then
        local plate = veh.GetPlate()
        local char = zPlayer.GetIdentifier()
        local name = zPlayer.GetFull_Name()
        local data = {Plate=plate, Character_ID=char}
        c.sql.veh.ChangeOwner(data, function()
            veh.SetOwner(char)
            TriggerClientEvent("Client:Notify", src, "Changed Ownership of Vehicle to "..name)
            TriggerClientEvent("Client:Notify", playerid, "Recieved Ownership of Vehicle "..plate)
        end)
    elseif veh.GetOwner() == false then
        TriggerClientEvent("Client:Notify", src, "You dont own this vehicle.")
    end
end

function c.vehicle.Respawn(plate, ords)

end

function c.vehicle.Remove(net)
    if DoesEntityExist(net) then
        DeleteEntity(net)
        c.data.RemoveVehicle(net)
    end
end

function c.vehicle.AllExit(ent)
    if DoesEntityExist(ent) then
        for i=-1, 8, 1 do
            local ped = GetPedInVehicleSeat(ent, i)
            TaskLeaveVehicle(ped, ent, 1)
        end
    end
end