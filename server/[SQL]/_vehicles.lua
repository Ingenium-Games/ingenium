-- ====================================================================================--

if not c.sql then c.sql = {} end
--
c.sql.veh = {}
--[[
NOTES.
    - All sql querys should have a call back as a function at the end to chain code execution upon completion.
    - All data should be encoded or decoded here, if possible. the fetchALL commands are decoded in the _data.lua
]] --

-- ====================================================================================--


function c.sql.veh.GetAll(Character_ID, cb)
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchAll("SELECT * FROM vehicles WHERE `Character_ID` = @Character_ID;", {
        ["@Character_ID"] = Character_ID
    }, function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

function c.sql.veh.GetByPlate(Plate, cb)
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchAll("SELECT * FROM vehicles WHERE `Plate` = @Plate LIMIT 1;", {
        ["@Plate"] = Plate
    }, function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

function c.sql.veh.Add(data, cb)
    local IsBusy = true
    local Data = data
    MySQL.Async.execute("INSERT INTO `vehicles` (`Character_ID`, `Model`, `Plate`) VALUES (@Character_ID, @Model, @Plate);",{
        ["@Character_ID"] = Data.Character_ID,
        ["@Model"] = Data.Model,
        ["@Plate"] = Data.Plate,
    }, function(r)
        IsBusy = false
        TriggerEvent("txaLogger:CommandExecuted", " [DB] -- Adding Vehicle: "..Data.Plate.." | Owner "..Data.Character_ID)
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
end

function c.sql.veh.ChangeOwner(data, cb)
    local IsBusy = true
    local Data = data
    MySQL.Async.execute("UPDATE `vehicles` SET `Character_ID` = @Character_ID WHERE `Plate` = @Plate;",{
        ["@Character_ID"] = Data.Character_ID,
        ["@Plate"] = Data.Plate,
    }, function(r)
        IsBusy = false
        TriggerEvent("txaLogger:CommandExecuted", " [DB] -- Changing Vehicle : "..Data.Plate.." | Owner "..Data.Character_ID)
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
end

---@param cb function "Callback function if any, called after the SQL statement."
function c.sql.veh.Regenerate(cb)
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchAll("SELECT * FROM `vehicles`", {
    }, function(data)
        for i=1, #data, 1 do
            local i = data[i]
            local ords = i.Coords
            local ent = CreateVehicle(i.Model, ords.x, ords.y, ords.z, ords.h, true, false)
            while not DoesEntityExist(ent) do
                Citizen.Wait(0)
            end
            SetVehicleNumberPlateText(ent, i.Plate)
            c.data.AddPlayerVehicle(i.Plate, c.class.PlayerVehicle, ent, i)
        end
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
end