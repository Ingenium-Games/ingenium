local Doors = {{
    ['Model'] = -903733315,
    ['Info'] = {
        ['Rotation'] = vec3(0.000000, -0.000000, -135.878677),
        ['Arch'] = "gabz_firedept_wooden_door",
        ['Matrix'] = vec3(0.696180, -0.717867, 0.000000)
    },
    ['Ords'] = vec3(200.405685, -1645.355225, 28.797325),
    ['Job'] = "fire",
    ['Name'] = "FireDept",
    ['State'] = 1,
    ['Item'] = false,
    ['Time'] = false
}, {
    ['Model'] = -903733315,
    ['Info'] = {
        ['Rotation'] = vec3(0.000000, -0.000000, 49.726936),
        ['Arch'] = "gabz_firedept_wooden_door",
        ['Matrix'] = vec3(-0.762972, 0.646431, 0.000000)
    },
    ['Ords'] = vec3(201.885544, -1643.591431, 28.797325),
    ['Job'] = "fire",
    ['Name'] = "FireDept",
    ['State'] = 1,
    ['Item'] = false,
    ['Time'] = false
}, {
    ['Model'] = -585526495,
    ['Info'] = {
        ['Rotation'] = vec3(0.000000, -0.000000, -40.288116),
        ['Arch'] = "gabz_firedept_reception_door",
        ['Matrix'] = vec3(0.646632, 0.762802, 0.000000)
    },
    ['Ords'] = vec3(199.292038, -1634.487305, 29.022600),
    ['Job'] = "fire",
    ['Name'] = "FireDept",
    ['State'] = 1,
    ['Item'] = false,
    ['Time'] = false
}, {
    ['Model'] = 1934132135,
    ['Info'] = {
        ['Rotation'] = vec3(-1.540226, 0.000033, 140.000000),
        ['Arch'] = "gabz_firedept_garage_door",
        ['Matrix'] = vec3(-0.642555, -0.765768, -0.026879)
    },
    ['Ords'] = vec3(212.104355, -1643.714355, 30.815550),
    ['Job'] = "fire",
    ['Name'] = "FireDept",
    ['State'] = 1,
    ['Item'] = false,
    ['Time'] = false
}, {
    ['Model'] = 1934132135,
    ['Info'] = {
        ['Rotation'] = vec3(-10.923844, 0.000178, 139.999863),
        ['Arch'] = "gabz_firedept_garage_door",
        ['Matrix'] = vec3(-0.631142, -0.752163, -0.189504)
    },
    ['Ords'] = vec3(215.249176, -1646.306152, 31.079149),
    ['Job'] = "fire",
    ['Name'] = "FireDept",
    ['State'] = 1,
    ['Item'] = false,
    ['Time'] = false
}, {
    ['Model'] = 1934132135,
    ['Info'] = {
        ['Rotation'] = vec3(-1.433714, 0.000024, 140.000015),
        ['Arch'] = "gabz_firedept_garage_door",
        ['Matrix'] = vec3(-0.642586, -0.765805, -0.025020)
    },
    ['Ords'] = vec3(208.976593, -1641.090820, 30.812597),
    ['Job'] = "fire",
    ['Name'] = "FireDept",
    ['State'] = 1,
    ['Item'] = false,
    ['Time'] = false
}, {
    ['Model'] = 1934132135,
    ['Info'] = {
        ['Rotation'] = vec3(-5.235569, 0.000090, 140.000015),
        ['Arch'] = "gabz_firedept_garage_door",
        ['Matrix'] = vec3(-0.640105, -0.762849, -0.091251)
    },
    ['Ords'] = vec3(208.989471, -1641.075439, 30.918621),
    ['Job'] = "fire",
    ['Name'] = "FireDept",
    ['State'] = 1,
    ['Item'] = false,
    ['Time'] = false
}, {
    ['Model'] = 1934132135,
    ['Info'] = {
        ['Rotation'] = vec3(-30.229565, 0.000497, 139.999649),
        ['Arch'] = "gabz_firedept_garage_door",
        ['Matrix'] = vec3(-0.555379, -0.661873, -0.503466)
    },
    ['Ords'] = vec3(212.087646, -1643.734375, 31.621038),
    ['Job'] = "fire",
    ['Name'] = "FireDept",
    ['State'] = 1,
    ['Item'] = false,
    ['Time'] = false
}}


local added = false
AddEventHandler("onServerResourceStart", function()
    if not added then
        c.door.Add(Doors)
    end
    added = true
end)