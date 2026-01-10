--[[
for i=1, #conf.garage.parkingspots do
    c.blip.Blip(vector3(conf.garage.parkingspots[i].x, conf.garage.parkingspots[i].y, conf.garage.parkingspots[i].z), 1, 2, "carpark", 0.5)
end
]]--