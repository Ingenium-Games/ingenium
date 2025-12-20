local Doors = {{
    ['Model'] = -427498890,
    ['Info'] = {
        ['Rotation'] = vec3(0.000000, 0.000000, 69.999924),
        ['Arch'] = "lr_prop_supermod_door_01",
        ['Matrix'] = vec3(-0.939692, 0.342021, 0.000000)
    },
    ['Ords'] = vec3(-44.188396, -1043.553833, 27.801605),
    ['Job'] = "mechanic",
    ['Name'] = "BennysMotorHub",
    ['State'] = 1,
    ['Item'] = false,
    ['Time'] = false
}}


local added = false
AddEventHandler("onServerResourceStart", function()
    if not added then
        ig.door.Add(Doors)
    end
    added = true
end)