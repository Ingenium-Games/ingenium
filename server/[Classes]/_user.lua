-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
-- ====================================================================================--
--[[
NOTES.
    - Why have the user and character classes seperate?
    - Becasue a player has different data to the character being played.
        - Not using the Player State, as still testing.
]] --


-- ====================================================================================--

function c.class.CreateUser(source)
    local src = tonumber(source)
    local Steam_ID, FiveM_ID, License_ID, Discord_ID, IP_Address = c.identifiers(src)
    local Ace = c.sql.user.GetAce(License_ID)
    local Locale = c.sql.user.GetLocale(License_ID)
    local self = {}
    --
    -- For the State to work
    self.ID = src
    self.State = Player(self.ID).state
    --
    -- Strings
    self.Name = GetPlayerName(self.ID)
    self.State.Name = self.Name
    --
    self.Steam_ID = Steam_ID
    self.State.Steam_ID = self.Steam_ID
    --
    self.FiveM_ID = FiveM_ID
    self.State.FiveM_ID = self.FiveM_ID
    --
    self.License_ID = License_ID
    self.State.License_ID = self.License_ID
    --
    self.Discord_ID = Discord_ID
    self.State.Discord_ID = self.Discord_ID
    --
    self.IP_Address = IP_Address -- Does not need to be within states.
    --
    self.Ace = Ace
    self.State.Ace = self.Ace
    --
    self.Locale = Locale
    self.State.Locale = self.Locale
    --
    self.Temp = c.rng.chars(15)
    self.State.Temp = self.Temp
    --
    ExecuteCommand(('remove_principal identifier.%s group.%s'):format(self.License_ID, self.Ace))
    ExecuteCommand(('add_principal identifier.%s group.%s'):format(self.License_ID, self.Ace))
    --
    -- Functions
    self.Kick = function(reason)
        DropPlayer(self.ID, reason)
    end
    --
    self.GetName = function()
        return self.State.Name or self.Name
    end
    --
    self.GetAce = function()
        return self.State.Ace or self.Ace
    end
    --
    self.GetLocale = function()
        return self.State.Locale or self.Locale
    end
    --
    self.GetID = function()
        return self.ID
    end
    --
    self.GetSteam_ID = function()
        return self.State.Steam_ID or self.Steam_ID
    end
    --
    self.GetFiveM_ID = function()
        return self.State.FiveM_ID or self.FiveM_ID
    end
    --
    self.GetLicense_ID = function()
        return self.State.License_ID or self.License_ID
    end
    --
    self.GetDiscord_ID = function()
        return self.State.Discord_ID or self.Discord_ID
    end
    --
    self.GetIP_Address = function()
        return self.IP_Address
    end
    --
    self.JobAllowed = function(ace)
        if IsPrincipalAceAllowed(("job.%s"):format(ace), ("identifier.%s"):format(self.License_ID)) then
            print("true")
        else
            print("false")
        end    
        if IsPrincipalAceAllowed(("identifier.%s"):format(self.License_ID), ("job.%s"):format(ace)) then
            print("true")
        else
            print("false")
        end    
        if IsPrincipalAceAllowed(("job.%s"):format(ace), ("%s"):format(self.License_ID)) then
            print("true")
        else
            print("false")
        end    
        if IsPrincipalAceAllowed(("%s"):format(self.License_ID), ("job.%s"):format(ace)) then
            print("true")
        else
            print("false")
        end    
        if IsPlayerAceAllowed(tostring(self.ID), ("job.%s"):format(ace)) then
            print("true")
        else
            print("false")
        end    
        if IsPlayerAceAllowed(("job.%s"):format(ace), tostring(self.ID)) then
            print("true")
        else
            print("false")
        end    
    end
    --
    c.debug_2('Generated User')
    return self
end
