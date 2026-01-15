-- ====================================================================================--
-- Tattoo system (ig.tattoo, ig.tattoos initialized in client/_var.lua)
-- ====================================================================================--

---Get all tattoo data (cached from server)
---@param callback function Callback function(tattoos)
function ig.tattoo.GetAll(callback)
    if callback then
        callback(ig.tattoos)
    end
    return ig.tattoos
end
