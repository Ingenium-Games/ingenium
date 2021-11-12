-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
-- ====================================================================================--
c.camera = {}
c.cameras = {}

--[[
NOTES.
    - The purpose of this is simple. Everyone who scripts a camera makes the name CAM. I think that fucking stupid.
    - What happens when others all use the name CAM? It means that when they DONT DESTROY the CAM...
    - You have overlapping issues when ending cameras from different angles rather than snapping to the ped
    - Even if you don't destroy the camera, if its a different name, it should resolve the issues of weird cam shit happening.
]]--

-- ====================================================================================--

function c.camera.NewName(t)
    local val
    local find = false
    repeat
        val = "CAM-"..c.rng.chars(5).."-"..c.rng.chars(5).."-"..c.rng.chars(5).."-"..c.rng.chars(5)..""
        if c.cameras[val] then
            find = true
        else
            c.cameras[val] = t
            find = false
        end
    until find == false
    return val
end

-- ====================================================================================--

function c.camera.Basic(px, py, pz, rx, ry, rz, fov)
    local t = {
        ['type'] = "DEFAULT_SCRIPTED_CAMERA",
        ['px'] = px,
        ['py'] = py,
        ['pz'] = pz,
        ['rx'] = rx,
        ['ry'] = ry,
        ['rz'] = rz,
        ['fov'] = fov
    }
    local name = c.camera.NewName(t)
    name = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", px, py, pz, rx, ry, rz, fov, false, 0)
    return name
end

function c.camera.Advanced(type, px, py, pz, rx, ry, rz, fov)
    local t = {
        ['type'] = type,
        ['px'] = px,
        ['py'] = py,
        ['pz'] = pz,
        ['rx'] = rx,
        ['ry'] = ry,
        ['rz'] = rz,
        ['fov'] = fov
    }
    local name = c.camera.NewName(t)
    name = CreateCamWithParams(type, px, py, pz, rx, ry, rz, fov, false, 0)
    return name
end

function c.camera.CleanUp(camera)
    table.remove(c.cameras, camera)
end