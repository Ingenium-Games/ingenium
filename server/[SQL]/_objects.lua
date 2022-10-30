-- ====================================================================================--

if not c.sql then c.sql = {} end
c.sql.objects = {}

-- ====================================================================================--

--- Takes Job information from the Database and imports it into the Server Upon the Initialise() function.
---@param cb function "Callback function if any, called after the SQL statement."
function c.sql.objects.GetAll(cb)
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchAll("SELECT * FROM `objects`", {
    }, function(data)
        for i=1, #data, 1 do
            local i = data[i]
            if not c.objects[i.UUID] then
                c.objects[i.UUID] = {}
                c.objects[i.UUID].Model = i.Model
                c.objects[i.UUID].Coords = i.Coords
                c.objects[i.UUID].Inventory = json.decode(i.Inventory)
                c.objects[i.UUID].Created = i.Created
                c.objects[i.UUID].Updated = i.Updated
            end
        end
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    print(c.table.Dump(c.objects))
end

