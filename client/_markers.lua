-- ====================================================================================--

c.marker = {}
c.markers = {}
--[[
NOTES.
    -
    -
    -
]] --

-- ====================================================================================--
-- https://docs.fivem.net/docs/game-references/markers/

--- Select a premade marker style.
---@param v number "A number to select corresponding local array value."
---@param ords table "a vector3() or {x,y,z}"
function c.marker.SelectMarker(ords, v)
    if not v then v = 0 end
    if v == 0 then
        return
    end
    if type(ords) ~= vector3 then
        local ords = {
            [1] = ords.x,
            [2] = ords.y,
            [3] = ords.z
        }
    end
    if v == 1 then
        -- Blue Static Circle.
        DrawMarker(27, ords[1], ords[2], ords[3]-0.45, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.7001, 0, 55, 240, 35, 0, 0, 2, 0)
    elseif v == 2 then
        -- Blue Static $.
        DrawMarker(29, ords[1], ords[2], ords[3]-0.45, 0, 0, 0, 0, 0, 0, 0.7001, 1.0001, 0.3001, 0, 55, 240, 35, 0, 0, 2, 0)
    elseif v == 3 then
        -- Blue Static ?.
        DrawMarker(32, ords[1], ords[2], ords[3]-0.45, 0, 0, 0, 0, 0, 0, 0.7001, 1.0001, 0.3001, 0, 55, 240, 35, 0, 0, 2, 0)
    elseif v == 4 then
        -- Blue Static Chevron.
        DrawMarker(20, ords[1], ords[2], ords[3]-0.45, 0, 0, 0, 0, 0, 0, 0.7001, 1.0001, 0.3001, 0, 55, 240, 35, 0, 0, 2, 0)
    elseif v == 5 then
        -- Small White Rotating Circle + Bouncing ? (on Ground)
        DrawMarker(27, ords[1], ords[2], ords[3] - 0.45, 0, 0, 0, 0, 0, 0, 0.4001, 0.4001, 0.4001, 240, 240, 240, 35, 0,
            0, 2, 1)
        DrawMarker(32, ords[1], ords[2], ords[3] - 0.32, 0, 0, 0, 0, 0, 0, 0.7001, 1.0001, 0.3001, 240, 240, 240, 35, 1, 0, 2,
          1)
    elseif v == 6 then
        DrawMarker(32, ords[1], ords[2], ords[3] - 0.45, 0, 0, 0, 0, 0, 0, 0.2001, 0.4001, 0.8001, 240, 240, 240, 35, 1,
            1, 2, 0)
    elseif v == 7 then
        -- White Rotating Chevron Bouncing.
        DrawMarker(29, ords[1], ords[2], ords[3] - 0.45, 0, 0, 0, 0, 0, 0, 0.7001, 1.0001, 0.3001, 240, 240, 240, 35, 1, 0, 2,
            1)
    elseif v == 8 then
        -- Blue Static $.
        DrawMarker(29, ords[1], ords[2], ords[3] - 0.45, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 1.7001, 0, 55, 240, 35, 0, 0, 2, 0)
    end
end

-- This one is for some reason broken, but, if you take it from the Citizen.Thread, it works fine. So ??

--- Produce A loop of markers to generate based on criteria.
---@param t table "Contains coords as vector3, number for marker selection with c.marker functions, notification for dynamic entry with c.text functions and a func for callback function to do. {["coords"] = vector3(), ["number"] = 0,X, ["notification"] = {"KEYBOARD_USE", "DO X Y Z"}, ["callback"] = cb()}"
function c.marker.CreateThreadLoop(t)
    local tab = c.check.Table(t)
    -- Create the loop based on the Coordinates and marker style provided.
    
    
    
    Citizen.CreateThread(function()
        local tab = tab
        while true do
            local ped = PlayerPedId()
            local pos = vector3(GetEntityCoords(ped))
            local found = false
            local near = false
            local open = false
            Citizen.Wait(0)
            if c.data.GetLoadedStatus() then
                for i = 1, #tab, 1 do
                    local ords = tab[i].coords
                    local style = tab[i].number
                    local text = tab[i].notification
                    local cb = tab[i].callback
                    -- no point calculating distance twice in a loop, derp me.
                    local dist = Vdist(pos, ords)
                    if dist < 20 then
                        found = true
                        -- Draw marker
                        c.marker.SelectMarker(style, ords)
                        if dist < 5 then
                            near = true
                            -- Show help
                            c.text.DisplayHelp(text[1], text[2])
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


  end
