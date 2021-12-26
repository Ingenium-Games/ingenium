-- ====================================================================================--
c.scene = {} -- function level
c.scenes = false -- dropped items table
-- ====================================================================================--

--[[    
            {
                [ID] = {
                    ["Coords"] = {0,0,0} -- Vecotr3
                    ["Flag"] = NUMBER (0,1,2) -- 0 = normal, 1 = permenant,  
                    ["Time"] = TIME  -- os.time() when created,
                    ["Name"] = Character_ID,
                    ["Ace"] = 
                },
    
            }
]]--

function c.scene.Load()
    if c.json.Exists(conf.file.scenes) then
        local file = c.json.Read(conf.file.scenes)
        c.scenes = file
    else
        c.scenes = {}
        c.json.Write(conf.file.scenes, c.scenes)
    end
    c.scene.Update()
end

function c.scene.Update()
    local function Do()
        c.json.Write(conf.file.scenes, c.scenes)
        SetTimeout(c.min, Do)    
    end
    SetTimeout(c.min, Do)
end

function c.scene.Exist(id)
    if c.scenes[id] then
        return true
    end
    return false
end

function c.scene.Add(data)
    if type(data) == "table" then
        table.insert(c.scenes, data)
    else
        c.debug_1("Scene to be added, please check data sent.")
    end
    return #c.scenes
end

function c.scene.Remove(id)
    local found = c.scenes.Exist(id)
    if found then
        table.remove(c.scenes, id)
    end
end

function c.scene.Clean()
    if type(c.scenes) == "table" then
        for k, v in pairs(c.scenes) do
            if v then
                if v.Flag == 0 then
                    if (v.Time - os.time()) <= conf.file.clean then
                        table.remove(c.scenes, k)
                    end
                end
            end
        end
    end
end

function c.scene.CleanUp()
    local function Do()
        c.scene.Clean()
        TriggerClientEvent("Client:Scenes:Update", -1, c.scenes)
        SetTimeout(conf.file.cleanup, Do)
    end
    SetTimeout(conf.file.cleanup, Do)
end

RegisterNetEvent("Server:Scenes:Fetch", function()
    local src = source
    TriggerClientEvent("Client:Scenes:Update", src, c.scenes)
end)

RegisterNetEvent("Server:Scenes:Add", function(x, y, z, message, flag)
    local src = source
    local xPlayer = c.data.GetPlayer(src)
    if not x or not y or not z or not message then return end
    local flag = flag or 0
    c.scene.Add({Coords = {x=x,y=y,z=z}, Message = message, Flag = flag, Time = os.time(), Character = xPlayer.GetCharacter_ID()})
    TriggerClientEvent("Client:Scenes:Update", -1, c.scenes)
end)

RegisterNetEvent("Server:Scenes:Delete", function(key)
    local src = source
    local xPlayer = c.data.GetPlayer(src)
    local Ace = xPlayer.GetAce()
    if c.scene.Exists(key) then
        if c.scenes[key].Character == xPlayer.GetCharacter_ID() or Ace == "mod" or Ace == "admin" or Ace == "superadmin" or Ace == "developer" or Ace == "owner" then
            table.remove(c.scenes, key)
            TriggerClientEvent("Client:Scenes:Update", -1, c.scenes)
        else
            TriggerClientEvent("Client:Notify", "No Permissions to Delete.")
        end
    end
end)