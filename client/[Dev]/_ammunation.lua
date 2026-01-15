locations = {{
    x = 16.39,
    y = -1109.12,
    z = 29.79,
    h = 340.16
}, {
    x = 843.35,
    y = -1030.3,
    z = 28.18,
    h = 87.87
}, {
    x = 248.81,
    y = -49.77,
    z = 69.94,
    h = 189.92
}, {
    x = -661.44,
    y = -938.44,
    z = 21.82,
    h = 269.29
}, {
    x = -3169.24,
    y = 1085.5,
    z = 20.84,
    h = 337.32
}, {
    x = -328.95,
    y = 6080.64,
    z = 31.45,
    h = 314.65
}, {
    x = 1695.24,
    y = 3756.83,
    z = 34.69,
    h = 317.48
}}

delivery = { 
    -- Name: ammunationdel1 | 2022-08-25T02:13:01Z
{
    x = -7.83,
    y = -1110.86,
    z = 28.62,
    h = 155.91
}, -- Name: ammunationdel2 | 2022-08-25T02:13:58Z
{
    x = 860.36,
    y = -1025.26,
    z = 29.99,
    h = 0.0
}, -- Name: ammunationdel3 | 2022-08-25T02:15:10Z
{
    x = 239.54,
    y = -37.66,
    z = 69.75,
    h = 155.91
}, -- Name: ammunationdel4 | 2022-08-25T02:15:48Z
{
    x = 1688.91,
    y = 3748.33,
    z = 34.2,
    h = 232.44
}, -- Name: ammunationdel5 | 2022-08-25T02:17:15Z
{
    x = -329.05,
    y = 6099.73,
    z = 31.45,
    h = 221.1
}}

local blips = {}

-- Wait for blip system to be available
local function InitializeBlips()
    while not c or not c.blip or not c.blip.CreateBlip do
        Wait(100)
    end

for i = 1, #locations do
    blips[i] = c.blip.CreateBlip(vector3(locations[i].x, locations[i].y, locations[i].z), 110, 55, "Ammunation", 0.6)
end
end

CreateThread(InitializeBlips)

AddEventHandler("onResourceStop", function()
    for i = 1, #blips do
        c.blip.Remove(blips[i])
    end
end)
