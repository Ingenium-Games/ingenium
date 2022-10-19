-- ====================================================================================--

c.vehicle = {} -- function level
c.vehicles = exports["ig.dump"]:GetVehicles()
c.vdex = {} -- vehicles...

-- ====================================================================================--

---@param plate string "Plate of vehicle."
function c.vehicle.GetByPlate(plate)
    for k,v in pairs(c.vdex) do
        if v.Plate == plate then
            return v
        end
    end 
    return false
end

--- func desc
function c.vehicle.GetDumpedHashes()
    local t = {}
    for k,v in pairs(c.vehicles) do
        table.insert(t, v.SignedHash)
    end  
    return t
end

--- func desc
---@param source any
---@param net any
---@param playerid any
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

--- func desc
---@param xVehicle any
function c.vehicle.AllExit(xVehicle)
    if DoesEntityExist(xVehicle.GetEntity()) then
        for i=-1, 8, 1 do
            local ped = GetPedInVehicleSeat(xVehicle.GetEntity(), i)
            TaskLeaveVehicle(ped, xVehicle.GetEntity(), 1)
        end
    end
end