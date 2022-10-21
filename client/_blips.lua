-- ====================================================================================--
c.blip = {} -- functions
c.blips = {} -- stored made blips.
SetThisScriptCanRemoveBlipsCreatedByAnyScript(true)
-- ====================================================================================--

-- https://docs.fivem.net/docs/game-references/blips/
-- https://runtime.fivem.net/doc/natives/?_0x9029B2F3DA924928

--[[
-- Category
1 = No distance shown in legend
2 = Distance shown in legend
7 = "Other Players" category, also shows distance in legend
10 = "Property" category
11 = "Owned Property" category
]] --

--- func desc
---@param coords table ""
---@param sprite number
---@param colour number
---@param text string
---@param scale number
---@param flash table
---@param fade table
---@param short boolean
---@param high boolean
---@param display number
---@param category number
---@param legend boolean
function c.blip.Blip(coords, sprite, colour, text, scale, flash, fade, short, high, display, category, legend)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, (sprite or 1))
    SetBlipDisplay(blip, (display or 6))
    SetBlipScale(blip, (scale or 0.82))
    SetBlipColour(blip, (colour or 4))
    if flash then
        SetBlipFlashes(blip, (flash.state or false))
        if flash.state then
            SetBlipFlashInterval(blip, flash.interval)
            SetBlipFlashTimer(blip, flash.timer)
        end
    end
    if fade then
        if fade.state then
            SetBlipFade(blip, fade.state, fade.duration)
        end
    end
    SetBlipCategory(blip, (category or 1))
    SetBlipAsShortRange(blip, (short or true))
    SetBlipHighDetail(blip, (high or true))
    SetBlipHiddenOnLegend(blip, (legend or false))
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString((text or "Blip " .. tostring(blip)))
    EndTextCommandSetBlipName(blip)

    return {
        handle = blip,
        coords = (coords or vector3(0.0, 0.0, 0.0)),
        sprite = (sprite or 1),
        display = (display or 6),
        scale = (scale or 0.82),
        color = (colour or 4),
        short = (short or false),
        high = (high or true),
        text = (text or "Blip " .. tostring(blip)),
        legend = (legend or false),
        category = (category or 1),
        flash = (flash or false),
        fade = (fade or false)
    }
end

--- func desc
---@param coords table ""
---@param sprite number
---@param colour number
---@param text string
---@param scale number
---@param flash table
---@param fade table
---@param short boolean
---@param high boolean
---@param display number
---@param category number
---@param legend boolean
function c.blip.EntityBlip(entity, sprite, colour, text, scale, flash, fade, short, high, display, category, legend)
    local blip = AddBlipForEntity(entity)
    SetBlipSprite(blip, (sprite or 1))
    SetBlipDisplay(blip, (display or 6))
    SetBlipScale(blip, (scale or 0.82))
    SetBlipColour(blip, (colour or 4))
    if flash then
        SetBlipFlashes(blip, (flash.state or false))
        if flash.state then
            SetBlipFlashInterval(blip, flash.interval)
            SetBlipFlashTimer(blip, flash.timer)
        end
    end
    if fade then
        if fade.state then
            SetBlipFade(blip, fade.state, fade.duration)
        end
    end
    SetBlipCategory(blip, (category or 1))
    SetBlipAsShortRange(blip, (short or true))
    SetBlipHighDetail(blip, (high or true))
    SetBlipHiddenOnLegend(blip, (legend or false))
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString((text or "Blip " .. tostring(blip)))
    EndTextCommandSetBlipName(blip)

    return {
        handle = blip,
        coords = (coords or vector3(0.0, 0.0, 0.0)),
        sprite = (sprite or 1),
        display = (display or 6),
        scale = (scale or 0.82),
        color = (colour or 4),
        short = (short or false),
        high = (high or true),
        text = (text or "Blip " .. tostring(blip)),
        legend = (legend or false),
        category = (category or 1),
        flash = (flash or false),
        fade = (fade or false)
    }
end

--- func desc
---@param coords any
---@param range any
---@param color any
---@param alpha any
---@param high any
function c.blip.RadiusBlip(coords, range, color, alpha, high)
    local blip = AddBlipForRadius(coords(range or 100.0))
    SetBlipColour(blip, (color or 1))
    SetBlipAlpha(blip, (alpha or 80))
    SetBlipHighDetail(blip, (high or true))

    return {
        handle = blip,
        coords = (coords or 0.0),
        range = (range or 100.0),
        color = (color or 1),
        alpha = (alpha or 80),
        high = (high or true)
    }
end

--- func desc
---@param coords any
---@param width any
---@param height any
---@param heading any
---@param color any
---@param alpha any
---@param high any
---@param display any
---@param short any
function c.blip.AreaBlip(coords, width, height, heading, color, alpha, high, display, short)
    local blip = AddBlipForArea(coords, (width or 100.0), (height or 100.0))
    SetBlipColour(blip, (color or 1))
    SetBlipAlpha(blip, (alpha or 80))
    SetBlipHighDetail(blip, (high or true))
    SetBlipRotation(blip, (heading or 0.0))
    SetBlipDisplay(blip, (display or 4))
    SetBlipAsShortRange(blip, (short or true))

    return {
        handle = blip,
        coords = (coords or vector3(0.0, 0.0, 0.0)),
        width = (width or 100.0),
        display = (display or 4),
        height = (height or 100.0),
        heading = (heading or 0.0),
        color = (color or 1),
        alpha = (alpha or 80),
        high = (high or true),
        short = (short or true)
    }
end

--- func desc
function c.blip.CreateBlip(...)
    local handle = #c.blips + 1
    local blip = c.blip.Blip(...)
    c.blips[handle] = blip
    return handle
end

--- func desc
function c.blip.CreateRadius(...)
    local handle = #c.blips + 1
    local blip = c.blip.RadiusBlip(...)
    c.blips[handle] = blip
    return handle
end

--- func desc
function c.blip.CreateArea(...)
    local handle = #c.blips + 1
    local blip = c.blip.AreaBlip(...)
    c.blips[handle] = blip
    return handle
end

--- func desc
---@param handle any
function c.blip.GetBlip(handle)
    return c.blips[handle]
end

--- func desc
---@param handle any
function c.blip.Remove(handle)
    local blip = c.blips[handle]
    if blip then
        RemoveBlip(blip["handle"])
    end
end

--[[
-- Example for in resource useage to had a toggle for the blips.

local store_blips = {}

local Blips = {
    {["coords"] = vector3(-1108.4, 2708.9, 18.1), ["sprite"] = 73, ["colour"] = 24, ["size"] = 0.7, ["title"] = "Clothes Store"},
}

function activateblips()
    for i=1, #Blips do
        local handle = c.blip.CreateBlip(Blips[i].coords, Blips[i].sprite, Blips[i].colour, Blips[i].title, Blips[i].size)
        store_blips[Blips[i].title] = handle
    end
end

function deactiveateblips()
    for k,v in pairs(store_blips) do
        c.blip.Remove(v)
    end
end

activateblips()

]] -- 
