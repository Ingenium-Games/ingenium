-- ====================================================================================--
c.camera = {}
c.cameras = {}
-- ====================================================================================--

--- func desc
---@param . any
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

--- func desc
---@param px any
---@param py any
---@param pz any
---@param rx any
---@param ry any
---@param rz any
---@param fov any
---@param l1 any
---@param l2 any
function c.camera.Basic(px, py, pz, rx, ry, rz, fov, l1, l2)
    if not l1 then l1 = false end
    if not l2 then l2 = 0 end
    local t = {
        ["type"] = "DEFAULT_SCRIPTED_CAMERA",
        ["px"] = px,
        ["py"] = py,
        ["pz"] = pz,
        ["rx"] = rx,
        ["ry"] = ry,
        ["rz"] = rz,
        ["fov"] = fov
    }
    local name = c.camera.NewName(t)
    name = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", px, py, pz, rx, ry, rz, fov, l1,l2)
    return name
end

--- func desc
---@param type any
---@param px any
---@param py any
---@param pz any
---@param rx any
---@param ry any
---@param rz any
---@param fov any
---@param l1 any
---@param l2 any
function c.camera.Advanced(type, px, py, pz, rx, ry, rz, fov, l1, l2)
    if not l1 then l1 = false end
    if not l2 then l2 = 0 end
    local t = {
        ["type"] = type,
        ["px"] = px,
        ["py"] = py,
        ["pz"] = pz,
        ["rx"] = rx,
        ["ry"] = ry,
        ["rz"] = rz,
        ["fov"] = fov
    }
    local name = c.camera.NewName(t)
    name = CreateCamWithParams(type, px, py, pz, rx, ry, rz, fov, l1, l2)
    return name
end

--- func desc
---@param camera any
function c.camera.CleanUp(camera)
    SetCamActive(camera, false)
    DestroyCam(camera)
end