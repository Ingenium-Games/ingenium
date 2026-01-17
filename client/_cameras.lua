-- ====================================================================================--
-- Camera management (ig.camera, ig.cameras initialized in client/_var.lua)
-- ====================================================================================--

--- func desc
function ig.camera.NewName()
    local val = ig.rng.UUID()
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
    local name = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", px, py, pz, rx, ry, rz, fov, l1,l2)
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
    local name = CreateCamWithParams(type, px, py, pz, rx, ry, rz, fov, l1, l2)
    return name
end

--- func desc
---@param camera any
function ig.camera.CleanUp(camera)
    SetCamActive(camera, false)
    DestroyCam(camera)
end