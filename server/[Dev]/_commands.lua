--
ExecuteCommand("add_ace group.developer command.vdex allow")
RegisterCommand("vdex", function(source, args, rawCommand)
    local src = source
    local dex = ig.data.GetVehicles()
    print(ig.table.Dump(dex))
end, true)

ExecuteCommand("add_ace group.developer command.pdex allow")
RegisterCommand("pdex", function(source, args, rawCommand)
    local src = source
    local dex = ig.data.GetPlayers()
    print(ig.table.Dump(dex))
end, true)

ExecuteCommand("add_ace group.developer command.odex allow")
RegisterCommand("odex", function(source, args, rawCommand)
    local src = source
    local dex = ig.odex
    print(ig.table.Dump(dex))
end, true)

ExecuteCommand("add_ace group.developer command.jdex allow")
RegisterCommand("jdex", function(source, args, rawCommand)
    local src = source
    local dex = ig.data.GetJobs()
    print(ig.table.Dump(dex))
end, true)

ExecuteCommand("add_ace group.developer command.ndex allow")
RegisterCommand("ndex", function(source, args, rawCommand)
    local src = source
    local dex = ig.data.GetNpcs()
    print(ig.table.Dump(dex))
end, true)

ExecuteCommand("add_ace group.developer command.ddex allow")
RegisterCommand("ddex", function(source, args, rawCommand)
    local src = source
    local dex = ig.door.GetDoors()
    print(ig.table.Dump(dex))
end, true)

--
ExecuteCommand("add_ace group.developer command.fx allow")
RegisterCommand("fx", function(source, args, rawCommand)
    local src = source
    local tbl = TriggerClientCallback({
        source = src,
        eventName = "Developer:Fx",
        args = args or {}
    })
end, true)

--
ExecuteCommand("add_ace group.developer command.fix allow")
RegisterCommand("fix", function(source, args, rawCommand)
    local src = source
    local tbl = TriggerClientCallback({
        source = src,
        eventName = "Developer:FixVehicle",
        args = args or {}
    })
end, true)

ExecuteCommand("add_ace group.developer command.noclip allow")
RegisterCommand("noclip", function(source, args, rawCommand)
    local src = source
    local tbl = TriggerClientCallback({
        source = src,
        eventName = "Developer:Noclip",
        args = {}
    })
end, true)

ExecuteCommand("add_ace group.developer command.additem allow")
RegisterCommand("additem", function(source, args, rawCommand)
    local src = source
    local string = args[1]
    local xPlayer = ig.data.GetPlayer(src)
    xPlayer.AddItem({string,1,100})
end, true)

ExecuteCommand("add_ace group.developer command.addbank allow")
RegisterCommand("addbank", function(source, args, rawCommand)
    local src = source
    local number = tonumber(args[1])
    local xPlayer = ig.data.GetPlayer(src)
    xPlayer.AddBank(number)
end, true)

ExecuteCommand("add_ace group.developer command.addcash allow")
RegisterCommand("addcash", function(source, args, rawCommand)
    local src = source
    local number = tonumber(args[1])
    local xPlayer = ig.data.GetPlayer(src)
    xPlayer.AddCash(number)
end, true)

ExecuteCommand("add_ace group.developer command.pos allow")
RegisterCommand("pos", function(source, args, rawCommand)
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    local Coords = xPlayer.GetCoords()
    local name = args[1] or "NoName"
    local file = io.open('pos.lua', "a")
    io.output(file)
    local output = "--Name: " .. name .. " |\n{x=" .. Coords.x .. ", y=" ..
    Coords.y .. ", z=" .. Coords.z .. ", h="..Coords.h.."},\n"
    io.write(output)
    io.close(file)
    print("Added pos to pos.lua")
    xPlayer.Notify("Added pos to pos.lua")
end, true)

ExecuteCommand("add_ace group.developer command.debug allow")
RegisterCommand("debug", function(source, args, rawCommand)
    local src = source
    local tbl = TriggerClientCallback({
        source = src,
        eventName = "Developer:Debug",
        args = {}
    })
end, true)

ExecuteCommand("add_ace group.developer command.dv allow")
RegisterCommand("dv", function(source, args, rawCommand)
    local src = source
    local tbl = TriggerClientCallback({
        source = src,
        eventName = "Developer:DeleteVehicle",
        args = {}
    })
end, true)

ExecuteCommand("add_ace group.developer command.cam allow")
RegisterCommand("cam", function(source, args, rawCommand)
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    local name = args[1] or "NoName"
    local table = TriggerClientCallback({
        source = src,
        eventName = "Developer:GetCam",
        args = {}
    })
    local file = io.open('cams.lua', "a")
    io.output(file)
    local output = "--Name: " .. name .. " | " .. os.date("!%Y-%m-%dT%H:%M:%SZ\n").. "GetFreecamFov: \n" .. table.fov .. "\nGetFreecamPosition: \n{x=" .. table.pos.x .. ", y=" ..
    table.pos.y .. ", z=" .. table.pos.z .. "}\nGetFreecamRotation:\n {x=" .. table.rot.x .. ", y=" ..
    table.rot.y .. ", z=" .. table.rot.z .. "}\nGetFreecamMatrix:\n {x=" .. table.mat.x .. ", y=" .. table.mat.y ..
    ", z=" .. table.mat.z .. "}\n\n"
    io.write(output)
    io.close(file)
    print("Added cam to cams.lua")
    xPlayer.Notify("Added cam to cams.lua")
end, true)

ExecuteCommand("add_ace group.developer command.spot allow")
RegisterCommand("spot", function(source, args, rawCommand)
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    local ords = xPlayer.GetCoords()
    local file = io.open('parkingspots.lua', "a")
    io.output(file)
    local output = "{x="..ords.x..",y="..ords.y..",z="..ords.z..",h="..ords.h.."},\n"
    io.write(output)
    io.close(file)
    print("Added Spot to parkingspots.lua")
    xPlayer.Notify("Added Spot to parkingspots.lua")
end, true)

ExecuteCommand("add_ace group.developer command.prop allow")
RegisterCommand("prop", function(source, args, rawCommand)
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    local ords = xPlayer.GetCoords()
    local file = io.open('props.lua', "a")
    io.output(file)
    local output = "{x="..ords.x..",y="..ords.y..",z="..ords.z..",h="..ords.h.."},\n"
    io.write(output)
    io.close(file)
    print("Added ords to props.lua")
    xPlayer.Notify("Added ords to props.lua")
end, true)

ExecuteCommand("add_ace group.developer command.vehiclelist allow")
RegisterCommand("vehiclelist", function(source, args, rawCommand)
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    local table = Dump:GetVehicles()
    local file = io.open('vehicle_list.lua', "a")
    io.output(file)
    for k,v in pairs(table) do
        local output = "('"..tostring(v.DisplayName).."','"..tostring(v.Name).."',"..tonumber(v.MonetaryValue)..",'"..tostring(v.Class).."', 0)\n"
        io.write(output)
    end
    io.close(file)
    print("Created vehicles_list.lua")
    xPlayer.Notify("Created vehicles_list.lua")
end, true)

ExecuteCommand("add_ace group.developer command.doordev allow")
RegisterCommand("doordev", function(source, args, rawCommand)
    local src = source
    TriggerClientCallback({
        source = src,
        eventName = "Developer:DoorDev",
        args = args or {}
    })
end, true)

ExecuteCommand("add_ace group.developer command.addoor allow")
RegisterCommand("addoor", function(source, args, rawCommand)
    local src = source
    local name = args[1] or "NoName"
    local state = tonumber(args[2]) or 0
    local job = args[3] or false
    local item = args[4] or false
    local time = args[5] or false
    local timestate = tonumber(args[6]) or nil
    local xPlayer = ig.data.GetPlayer(src)
    local tbl = TriggerClientCallback({
        source = src,
        eventName = "Developer:GetDoor",
        args = {name, state, job, item, time, timestate}
    })
    local file = io.open('doors.lua', "a")
    io.output(file)
    local output = ig.table.Dump(tbl)..",\n"
    io.write(output)
    io.close(file)
    print("Added door to doors.lua")
    xPlayer.Notify("Added to doors.lua")
end, true)


ExecuteCommand("add_ace group.developer command.uuid allow")
RegisterCommand("uuid", function(source, args, rawCommand)
    print(ig.rng.UUID())
    print(ig.funig.Timestamp())
end, true)

ExecuteCommand("add_ace group.developer command.objects allow")
RegisterCommand("objects", function(source, args, rawCommand)
    print(ig.table.Dump(ig.objects))
end, true)

ExecuteCommand("add_ace group.developer command.vdata allow")
RegisterCommand("vdata", function(source, args, rawCommand)
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(source), false)
    local net = NetworkGetNetworkIdFromEntity(vehicle)
    local xVehicle = ig.data.GetVehicle(net)
    print(ig.table.Dump(xVehicle))
end, true)

ExecuteCommand("add_ace group.developer command.vsave allow")
RegisterCommand("vsave", function(source, args, rawCommand)
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(source), false)
    local net = NetworkGetNetworkIdFromEntity(vehicle)
    local xVehicle = ig.data.GetVehicle(net)
    ig.sql.save.Vehicle(xVehicle)
end, true)

ExecuteCommand("add_ace group.developer bnl_housing:admin allow")
