-- ====================================================================================--
if not c.sql then c.sql = {} end
--
c.sql.user = {}
--[[
NOTES.
    - All sql querys should have a call back as a function at the end to chain code execution upon completion.
    - All data should be encoded or decoded here, if possible. the fetchALL commands are decoded in the _data.lua
]] --

-- ====================================================================================--

function c.sql.user.Find(license_id, cb)
    local License_ID = license_id
    local result = nil
    local IsBusy = true
    MySQL.Async.fetchScalar('SELECT `License_ID` FROM `users` WHERE `License_ID` = @License_ID LIMIT 1;', {
        ['@License_ID'] = License_ID
    }, function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

function c.sql.user.Add(usermame, license_id, fivem_id, steam_id, discord_id, ip, cb)
    local Username = usermame
    local License_ID = license_id
    local FiveM_ID = fivem_id
    local Steam_ID = steam_id
    local Discord_ID = discord_id
    local IP_Address = ip
    local IsBusy = true
    MySQL.Async.execute('INSERT INTO `users` (`Username`, `Steam_ID`, `License_ID`, `FiveM_ID`, `Discord_ID`, `Ace`, `Locale`, `IP_Address`) VALUES (@Username, @Steam_ID, @License_ID, @FiveM_ID, @Discord_ID, @Ace, @Locale, @IP_Address);',{
        ["@Username"] = Username,
        ["@License_ID"] = License_ID,
        ["@FiveM_ID"] = FiveM_ID,
        ["@Steam_ID"] = Steam_ID,
        ["@Discord_ID"] = Discord_ID,
        ["@IP_Address"] = IP_Address,
        ["Ace"] = conf.ace,
        ["Locale"] = conf.locale,
    }, function(r)
        IsBusy = false
        TriggerEvent('txaLogger:CommandExecuted', "Adding new User "..Username)
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
end

function c.sql.user.Update(usermame, license_id, fivem_id, steam_id, discord_id, ip, cb)
    local Username = usermame
    local License_ID = license_id
    local FiveM_ID = fivem_id
    local Steam_ID = steam_id
    local Discord_ID = discord_id
    local IP_Address = ip
    local IsBusy = true
    MySQL.Async.execute('UPDATE `users` SET `Username` = @Username, `Steam_ID` = IFNULL(`Steam_ID`,@Steam_ID), `FiveM_ID` = IFNULL(`FiveM_ID`,@FiveM_ID), `Discord_ID` = IFNULL(`Discord_ID`,@Discord_ID), `IP_Address` = @IP_Address WHERE `License_ID` = @License_ID;', {
        ["@Username"] = Username,
        ["@License_ID"] = License_ID,
        ["@FiveM_ID"] = FiveM_ID,
        ["@Steam_ID"] = Steam_ID,
        ["@Discord_ID"] = Discord_ID,
        ["@IP_Address"] = IP_Address
    }, function(r)
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
end

--- Get - The entire ROW of data from Characters table where the Character_ID is the character id.
-- @Primary_ID
function c.sql.user.Get(license_id, cb)
    local License_ID = license_id
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchAll('SELECT * FROM `users` WHERE `License_ID` = @License_ID LIMIT 1;', {
        ['@License_ID'] = License_ID
    }, function(data)
        result = data[1]
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

--- Get - `Locale` from the users License_ID
-- @License_ID
function c.sql.user.GetLastLogin(license_id, cb)
    local License_ID = license_id
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchScalar('SELECT `Last_Login` FROM `users` WHERE `License_ID` = @License_ID LIMIT 1;', {
        ['@License_ID'] = License_ID
    }, function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

--- Get - `Locale` from the users License_ID
-- @License_ID
function c.sql.user.GetLocale(license_id, cb)
    local License_ID = license_id
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchScalar('SELECT `Locale` FROM `users` WHERE `License_ID` = @License_ID LIMIT 1;', {
        ['@License_ID'] = License_ID
    }, function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

--- Set - Prefered locale or `Locale` for the users License_ID
-- @License_ID
function c.sql.user.SetLocale(locale, license_id, cb)
    local License_ID = license_id
    local Locale = locale
    MySQL.Async.execute('UPDATE `users` SET `Locale` = @Locale WHERE `License_ID` = @License_ID;', {
        ['@Locale'] = Locale,
        ['@License_ID'] = License_ID
    }, function(data)
        if data then
            TriggerEvent('txaLogger:CommandExecuted', "Locale set to "..Locale.." on Primary ID :"..License_ID)
        end
    end)
    if cb then
        cb()
    end
end

--- Get - `Ace` from the users License_ID identifier
-- @License_ID
function c.sql.user.GetAce(license_id, cb)
    local License_ID = license_id
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchScalar('SELECT `Ace` FROM `users` WHERE `License_ID` = @License_ID LIMIT 1;', {
        ['@License_ID'] = License_ID
    }, function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

--- Set - `Ace` for the users License_ID
-- @License_ID
function c.sql.user.SetAce(ace, license_id, cb)
    local License_ID = license_id
    local Ace = ace
    MySQL.Async.execute('UPDATE `users` SET `Ace` = @Ace WHERE `License_ID` = @License_ID;', {
        ['@Ace'] = Ace,
        ['@License_ID'] = License_ID
    }, function(data)
        if data then
            TriggerEvent('txaLogger:CommandExecuted', "Ace set to "..Ace.." on Primary ID :"..License_ID)
        end
        if cb then
            cb()
        end
    end)
end

--- Get - `Ban` from the users License_ID identifier
-- @License_ID
function c.sql.user.GetBan(license_id, cb)
    local License_ID = license_id
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchScalar('SELECT `Ban` FROM `users` WHERE `License_ID` = @License_ID LIMIT 1;', {
        ['@License_ID'] = License_ID
    }, function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

--- Get/Set - `Ban` = bool from the users License_ID identifier
-- @License_ID
function c.sql.user.SetBan(license_id, bool, cb)
    if type(bool) ~= "boolean" then c.debug_1("c.sql.user.SetBan, boolean was not passed") return end
    local License_ID = license_id
    local Bool = bool
    MySQL.Async.execute('UPDATE `users` SET `Ban` = @Bool WHERE `License_ID` = @License_ID LIMIT 1;', {
        ['@Bool'] = Bool,
        ['@License_ID'] = License_ID
    }, function(data)
        if data then
            TriggerEvent('txaLogger:CommandExecuted', "Ban set to "..tostring(Bool).." on Primary ID :"..License_ID)
        end
        if cb then
            cb()
        end
    end)
end


--- Get/Set
-- @FiveM_ID
function c.sql.user.SetPriority(fivem_id, bool, cb)
    if type(bool) ~= "boolean" then c.debug_1("c.sql.user.SetBan, boolean was not passed") return end
    local FiveM_ID = ("fivem:%s"):format(fivem_id)
    local Bool = bool
    MySQL.Async.execute('UPDATE `users` SET `Priority` = @Bool WHERE `FiveM_ID` = @FiveM_ID LIMIT 1;', {
        ['@Bool'] = Bool,
        ['@FiveM_ID'] = FiveM_ID
    }, function(data)
        if data then
            TriggerEvent('txaLogger:CommandExecuted', "Priority set to "..tostring(Bool).." on FiveM_ID : "..FiveM_ID)
        end
        if cb then
            cb()
        end
    end)
end

--- Add
-- @FiveM_ID
function c.sql.user.AddCharacterSlot(fivem_id, cb)
    local FiveM_ID = ("fivem:%s"):format(fivem_id)
    MySQL.Async.execute('UPDATE `users` SET `Slots` = Slots + 1 WHERE `FiveM_ID` = @FiveM_ID LIMIT 1;', {
        ['@FiveM_ID'] = FiveM_ID
    }, function(data)
        if data then
            TriggerEvent('txaLogger:CommandExecuted', "AddCharacterSlot + 1 on FiveM_ID : "..FiveM_ID)
        end
        if cb then
            cb()
        end
    end)
end

