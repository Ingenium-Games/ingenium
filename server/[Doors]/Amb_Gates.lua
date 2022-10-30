local Doors = {
{
['Info'] = {
    ['Arch'] = "prop_sec_barrier_ld_01a",
    ['Matrix'] = vec3(0.350332, 0.936625, 0.000000),
    ['Rotation'] = vec3(-0.000000, -0.000000, -20.507648),
    },
['Name'] = "ParkingBoom",
['State'] = 0,
['Item'] = false,
['Model'] = -1184516519,
['Time'] = false,
['Ords'] = vec3(206.527405, -803.479675, 30.953550),
['Job'] = "city",
},
{
['Info'] = {
    ['Arch'] = "prop_sec_barrier_ld_01a",
    ['Matrix'] = vec3(-0.349843, -0.936808, 0.000000),
    ['Rotation'] = vec3(0.000000, -0.000000, 159.522293),
    },
['Name'] = "ParkingBoom",
['State'] = 0,
['Item'] = false,
['Model'] = -1184516519,
['Time'] = false,
['Ords'] = vec3(230.921799, -816.153015, 30.168970),
['Job'] = "city",
},
}


local added = false
AddEventHandler("onServerResourceStart", function()
    if not added then
        c.door.Add(Doors)
    end
    added = true
end)