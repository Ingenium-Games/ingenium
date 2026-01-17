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

--- Points a camera at a specific entity with optional offset
---@param camera number The camera handle
---@param entity number The entity to point at
---@param offsetX number X offset from entity center (default: 0.0)
---@param offsetY number Y offset from entity center (default: 0.0)
---@param offsetZ number Z offset from entity center (default: 0.0)
---@param smoothTransition boolean Whether to smoothly transition (default: true)
function ig.camera.PointAtEntity(camera, entity, offsetX, offsetY, offsetZ, smoothTransition)
    offsetX = offsetX or 0.0
    offsetY = offsetY or 0.0
    offsetZ = offsetZ or 0.0
    smoothTransition = smoothTransition ~= false -- default true
    PointCamAtEntity(camera, entity, offsetX, offsetY, offsetZ, smoothTransition)
end

--- Points a camera at specific world coordinates
---@param camera number The camera handle
---@param x number World X coordinate
---@param y number World Y coordinate
---@param z number World Z coordinate
function ig.camera.PointAtCoord(camera, x, y, z)
    PointCamAtCoord(camera, x, y, z)
end

--- Stops the camera from pointing at an entity or coordinate
---@param camera number The camera handle
function ig.camera.StopPointing(camera)
    StopCamPointing(camera)
end

--- func desc
---@param camera any
function ig.camera.CleanUp(camera)
    SetCamActive(camera, false)
    DestroyCam(camera)
end