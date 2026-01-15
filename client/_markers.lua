-- ====================================================================================--
-- Marker management (ig.marker, ig.markers initialized in client/_var.lua)
-- ====================================================================================--
-- https://docs.fivem.net/docs/game-references/markers/

--- Select a premade marker style.
---@param v number "A number to select corresponding local array value."
---@param ords table "{x,y,z}"
function ig.marker.Place(ords, v)
    if v == 1 then
        -- Blue Static Circle.
        DrawMarker(27, ords[1], ords[2], ords[3] - 0.45, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.7001, 0, 55, 240, 100, 0, 0, 2, 0)
    elseif v == 2 then
        -- Blue Static $.
        DrawMarker(29, ords[1], ords[2], ords[3] - 0.45, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.3001, 0, 55, 240, 100, 0, 0, 2, 0)
    elseif v == 3 then
        -- Blue Static ?.
        DrawMarker(32, ords[1], ords[2], ords[3] - 0.45, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.3001, 0, 55, 240, 100, 0, 0, 2, 0)
    elseif v == 4 then
        -- Blue Static Chevron.
        DrawMarker(20, ords[1], ords[2], ords[3] - 0.45, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.0001, 0, 55, 240, 100, 0, 0, 2, 0)
    elseif v == 5 then
        -- Small White Rotating Circle + Bouncing ? (on Ground)
        DrawMarker(27, ords[1], ords[2], ords[3] - 0.90, 0, 0, 0, 0, 0, 0, 0.4001, 0.4001, 0.4001, 240, 240, 240, 100, 0, 0, 2, 1)
        DrawMarker(32, ords[1], ords[2], ords[3] - 0.32, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.0001, 240, 240, 240, 100, 1, 0, 2, 1)
    elseif v == 6 then
        DrawMarker(32, ords[1], ords[2], ords[3] - 0.45, 0, 0, 0, 0, 0, 0, 0.2001, 1.0001, 0.8001, 240, 240, 240, 100, 1, 1, 2, 0)
    elseif v == 7 then
        -- White Rotating Chevron Bouncing.
        DrawMarker(29, ords[1], ords[2], ords[3] - 0.45, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.0001, 240, 240, 240, 100, 1, 0, 2, 1)
    elseif v == 8 then
        -- Blue Static $.
        DrawMarker(29, ords[1], ords[2], ords[3] - 0.45, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 1.7001, 0, 55, 240, 100, 0, 0, 2, 0)
    elseif v == 9 then
        -- White Rotating Chevron Bouncing.
        DrawMarker(1, ords[1], ords[2], ords[3] - 0.90, 0, 0, 0, 0, 0, 0, 18.4001, 18.4001, 18.4001, 240, 240, 240, 255, 0, 0, 2, 1)
    end
end

--- Example to use it in a loop with other functions etig.
--[[
    Citizen.CreateThread(function()
        while true do
            local tab = GETTABLEDATAHERE
            local ped = PlayerPedId()
            local pos = vector3(GetEntityCoords(ped))
            local found = false
            local near = false
            local open = false
            Citizen.Wait(0)
            if ig.data.GetLoadedStatus() then
                for i = 1, #tab, 1 do
                    local ords = tab[i].coords
                    local style = tab[i].number
                    local text = tab[i].notification
                    local cb = tab[i].callback
                    -- no point calculating distance twice in a loop, derp me.
                    local dist = #(pos - ords)
                    if dist < 20 then
                        found = true
                        -- Draw marker
                        ig.marker.Place(style, ords)
                        if dist < 5 then
                            near = true
                            -- Show help
                            ig.text.DisplayHelp(text[1], text[2])
                            if IsControlJustPressed(0, 38) then
                                open = true
                                -- Do action.
                                cb()
                            else
                                open = false
                            end
                        else
                            near = false
                        end
                    else
                        found = false
                    end
                end
            else
                Citizen.Wait(150 * #tab)
            end
        end
    end)
]]-- 