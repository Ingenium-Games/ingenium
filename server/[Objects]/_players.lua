--
-- Player management (ig.player, ig.players, ig.pdex initialized in server/_var.lua)
--

--- Adds player to the player index.
---@wiki:ignore
---@param source number "source [server_id]"
function ig.player.AddPlayer(source)
    local num = tonumber(source)
    ig.pdex[num] = false
end

--- Gets player from the player table.
---@param source number
function ig.player.GetPlayer(source)
    if type(ig.pdex[tonumber(source)]) == "table" then
        return ig.pdex[tonumber(source)]
    else
        return false
    end
end

--- Set the player id to the table.
---@wiki:ignore
---@param source number
---@param data table
function ig.player.SetPlayer(source, data)
    ig.pdex[tonumber(source)] = data
end

--- Set to nil for garbage collection.
---@wiki:ignore
---@param source number
function ig.player.RemovePlayer(source)
    ig.pdex[tonumber(source)] = nil
end

--- Get the player table
function ig.player.GetPlayers()
    return ig.pdex
end

--- Get player by Character_ID
---@param characterId string
function ig.player.GetPlayerByCharacterId(characterId)
    for k, v in pairs(ig.pdex) do
        if v and type(v) == "table" and v.GetCharacter_ID and v.GetCharacter_ID() == characterId then
            return v
        end
    end
    return nil
end

--- func desc
---@param character_id any
function ig.player.GetOfflinePlayer(character_id)
    if character_id then
        local data = ig.sql.char.Get(character_id)
        if data then
            local temp = ig.class.OfflinePlayer(data)
            return temp
        end
    end
    return nil
end

--- Return corresponding player data from character_id
---@param id string "Character_ID"
function ig.player.GetPlayerByCharacterID(id)
    for k, v in pairs(ig.pdex) do
        if v then
            if v.GetCharacter_ID() == tostring(id) then
                return ig.player.GetPlayer(k)
            end
        end
    end
    return nil
end

--- func desc
function ig.player.ArePlayersActive()
    local ptbl = GetPlayers()
    if type(ptbl) == "table" and #ptbl >= 1 then
        return true
    end
    return false
end