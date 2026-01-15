-- ====================================================================================--
-- Camera management (ig.camera, ig.cameras initialized in client/_var.lua)
-- ====================================================================================--

--- func desc
---@param t any
function ig.camera.NewName(t)
    local val
    local find = false
    repeat
        val = "CAM-"..ig.rng.chars(5).."-"..ig.rng.chars(5).."-"..ig.rng.chars(5).."-"..ig.rng.chars(5)..""
        if ig.cameras[val] then
            find = true
        else
            ig.cameras[val] = t
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
function ig.camera.Basic(px, py, pz, rx, ry, rz, fov, l1, l2)
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
    local name = ig.camera.NewName(t)
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
function ig.camera.Advanced(type, px, py, pz, rx, ry, rz, fov, l1, l2)
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
    local name = ig.camera.NewName(t)
    name = CreateCamWithParams(type, px, py, pz, rx, ry, rz, fov, l1, l2)
    return name
end

--- func desc
---@param camera any
function ig.camera.CleanUp(camera)
    SetCamActive(camera, false)
    DestroyCam(camera)
end