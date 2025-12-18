-- ====================================================================================--
if not ig.sql then ig.sql = {} end
ig.sql.user = {}
-- ====================================================================================--

--[[
NOTES.
    - All sql querys should have a call back as a function at the end to chain code execution upon completion.
    - All data should be encoded or decoded here, if possible. the fetchALL commands are decoded in the _data.lua
]] --

function ig.sql.user.Find(license_id, cb)
    local result = ig.sql.FetchScalar("SELECT `License_ID` FROM `users` WHERE `License_ID` = ? LIMIT 1;", {license_id})
    if cb then
        cb()
    end
    return result
end

function ig.sql.user.Add(usermame, license_id, fivem_id, steam_id, discord_id, ip, cb)
    ig.sql.Insert(
        "INSERT INTO `users` (`Join_Date`, `Last_Login`, `Username`, `Steam_ID`, `License_ID`, `FiveM_ID`, `Discord_ID`, `Ace`, `Locale`, `IP_Address`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);",
        {ig.funig.Timestamp(), ig.funig.Timestamp(), usermame, steam_id, license_id, fivem_id, discord_id, conf.ace, conf.locale, ip},
        function(insertId)
            TriggerEvent("txaLogger:CommandExecuted", "Adding new User "..usermame)
            if cb then
                cb(insertId)
            end
        end)
end

function ig.sql.user.Update(usermame, license_id, fivem_id, steam_id, discord_id, ip, cb)
    ig.sql.Update(
        "UPDATE `users` SET `Last_Login` = ?, `Username` = ?, `Steam_ID` = IFNULL(`Steam_ID`,?), `FiveM_ID` = IFNULL(`FiveM_ID`,?), `Discord_ID` = IFNULL(`Discord_ID`,?), `IP_Address` = ? WHERE `License_ID` = ?;",
        {ig.funig.Timestamp(), usermame, steam_id, fivem_id, discord_id, ip, license_id},
        function(affectedRows)
            if cb then
                cb(affectedRows)
            end
        end)
end

--- Get - The entire ROW of data from Characters table where the Character_ID is the character id.
-- @Primary_ID
function ig.sql.user.Get(license_id, cb)
    local data = ig.sql.Query("SELECT * FROM `users` WHERE `License_ID` = ? LIMIT 1;", {license_id})
    local result = data[1]
    if cb then
        cb()
    end
    return result
end

--- Get - `Locale` from the users License_ID
-- @License_ID
function ig.sql.user.GetLastLogin(license_id, cb)
    local result = ig.sql.FetchScalar("SELECT `Last_Login` FROM `users` WHERE `License_ID` = ? LIMIT 1;", {license_id})
    if cb then
        cb()
    end
    return result
end

--- Get - `Locale` from the users License_ID
-- @License_ID
function ig.sql.user.GetLocale(license_id, cb)
    local result = ig.sql.FetchScalar("SELECT `Locale` FROM `users` WHERE `License_ID` = ? LIMIT 1;", {license_id})
    if cb then
        cb()
    end
    return result
end

--- Set - Prefered locale or `Locale` for the users License_ID
-- @License_ID
function ig.sql.user.SetLocale(locale, license_id, cb)
    ig.sql.Update("UPDATE `users` SET `Locale` = ? WHERE `License_ID` = ?;", {locale, license_id}, function(affectedRows)
        TriggerEvent("txaLogger:CommandExecuted", "Locale set to "..locale.." on Primary ID :"..license_id)
        if cb then
            cb(affectedRows)
        end
    end)
end

--- Get - `Ace` from the users License_ID identifier
-- @License_ID
function ig.sql.user.GetAce(license_id, cb)
    local result = ig.sql.FetchScalar("SELECT `Ace` FROM `users` WHERE `License_ID` = ? LIMIT 1;", {license_id})
    if cb then
        cb()
    end
    return result
end

--- Set - `Ace` for the users License_ID
-- @License_ID
function ig.sql.user.SetAce(ace, license_id, cb)
    ig.sql.Update("UPDATE `users` SET `Ace` = ? WHERE `License_ID` = ?;", {ace, license_id}, function(affectedRows)
        TriggerEvent("txaLogger:CommandExecuted", "Ace set to "..ace.." on Primary ID :"..license_id)
        if cb then
            cb(affectedRows)
        end
    end)
end

--- Get - `Ban` from the users License_ID identifier
-- @License_ID
function ig.sql.user.GetBan(license_id, cb)
    local result = ig.sql.FetchScalar("SELECT `Ban` FROM `users` WHERE `License_ID` = ? LIMIT 1;", {license_id})
    if cb then
        cb()
    end
    return result
end

--- Get - `Ban` from the users License_ID identifier
-- @License_ID
function ig.sql.user.GetBanReason(license_id, cb)
    local data = ig.sql.FetchScalar("SELECT `Ban_Reason` FROM `users` WHERE `License_ID` = ? LIMIT 1;", {license_id})
    local result = json.decode(data)
    if cb then
        cb()
    end
    return result
end

--- Get/Set - `Ban` = bool from the users License_ID identifier
-- @License_ID
function ig.sql.user.SetBan(license_id, bool, reason, cb)
    if type(bool) ~= "boolean" then ig.funig.Debug_1("ig.sql.user.SetBan, boolean was not passed") return end
    ig.sql.Update("UPDATE `users` SET `Ban` = ?, `Ban_Reason` = ? WHERE `License_ID` = ? LIMIT 1;", {bool, json.encode(reason), license_id}, function(affectedRows)
        TriggerEvent("txaLogger:CommandExecuted", "Ban set to "..tostring(bool).." on Primary ID :"..license_id)
        if cb then
            cb(affectedRows)
        end
    end)
end

--- Get - `Priority` from the users License_ID identifier
-- @License_ID
function ig.sql.user.GetPriority(license_id, cb)
    local result = ig.sql.FetchScalar("SELECT `Priority` FROM `users` WHERE `License_ID` = ? LIMIT 1;", {license_id})
    if cb then
        cb()
    end
    return result
end

--- Get/Set - `Priority`
-- @FiveM_ID
function ig.sql.user.SetPriority(fivem_id, bool, cb)
    if type(bool) ~= "boolean" then ig.funig.Debug_1("ig.sql.user.SetPriority, boolean was not passed") return end
    local FiveM_ID = ("fivem:%s"):format(fivem_id)
    ig.sql.Update("UPDATE `users` SET `Priority` = ? WHERE `FiveM_ID` = ? LIMIT 1;", {bool, FiveM_ID}, function(affectedRows)
        TriggerEvent("txaLogger:CommandExecuted", "Priority set to "..tostring(bool).." on FiveM_ID : "..FiveM_ID)
        if cb then
            cb(affectedRows)
        end
    end)
end

--- Get - `Slots` from the users License_ID identifier
-- @License_ID
function ig.sql.user.GetSlots(license_id, cb)
    local result = ig.sql.FetchScalar("SELECT `Slots` FROM `users` WHERE `License_ID` = ? LIMIT 1;", {license_id})
    if cb then
        cb()
    end
    return result
end

--- Add Character Slot
-- @FiveM_ID
function ig.sql.user.AddCharacterSlot(fivem_id, cb)
    local FiveM_ID = ("fivem:%s"):format(fivem_id)
    ig.sql.Update("UPDATE `users` SET `Slots` = Slots + 1 WHERE `FiveM_ID` = ? LIMIT 1;", {FiveM_ID}, function(affectedRows)
        TriggerEvent("txaLogger:CommandExecuted", "AddCharacterSlot + 1 on FiveM_ID : "..FiveM_ID)
        if cb then
            cb(affectedRows)
        end
    end)
end

