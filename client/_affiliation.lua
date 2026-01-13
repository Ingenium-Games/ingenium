-- ====================================================================================--
-- In experimental state.
ig.affiliation = {}
-- ====================================================================================--

local defaultgroups = {
    ["PLAYER"]                  = {["hash"] = 0x6F0783F5, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["CIVMALE"]                 = {["hash"] = 0x02B8FA80, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["CIVFEMALE"]               = {["hash"] = 0x47033600, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["COP"]                     = {["hash"] = 0xA49E591C, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["SECURITY_GUARD"]          = {["hash"] = 0xF50B51B7, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["PRIVATE_SECURITY"]        = {["hash"] = 0xA882EB57, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["FIREMAN"]                 = {["hash"] = 0xFC2CA767, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["GANG_1"]                  = {["hash"] = 0x4325F88A, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["GANG_2"]                  = {["hash"] = 0x11DE95FC, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["GANG_9"]                  = {["hash"] = 0x8DC30DC3, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["GANG_10"]                 = {["hash"] = 0x0DBF2731, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["AMBIENT_GANG_LOST"]       = {["hash"] = 0x90C7DA60, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["AMBIENT_GANG_MEXICAN"]    = {["hash"] = 0x11A9A7E3, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["AMBIENT_GANG_FAMILY"]     = {["hash"] = 0x45897C40, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["AMBIENT_GANG_BALLAS"]     = {["hash"] = 0xC26D562A, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["AMBIENT_GANG_MARABUNTE"]  = {["hash"] = 0x7972FFBD, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["AMBIENT_GANG_CULT"]       = {["hash"] = 0x783E3868, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["AMBIENT_GANG_SALVA"]      = {["hash"] = 0x936E7EFB, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["AMBIENT_GANG_WEICHENG"]   = {["hash"] = 0x6A3B9F86, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["AMBIENT_GANG_HILLBILLY"]  = {["hash"] = 0xB3598E9C, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["DEALER"]                  = {["hash"] = 0x8296713E, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["HATES_PLAYER"]            = {["hash"] = 0x84DCFAAD, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["HEN"]                     = {["hash"] = 0xC01035F9, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["WILD_ANIMAL"]             = {["hash"] = 0x7BEA6617, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["SHARK"]                   = {["hash"] = 0x229503C8, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {0x6F0783F5,},}},
    ["COUGAR"]                  = {["hash"] = 0xCE133D78, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {0x6F0783F5,},}},
    ["NO_RELATIONSHIP"]         = {["hash"] = 0xFADE4843, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["SPECIAL"]                 = {["hash"] = 0xD9D08749, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["MISSION2"]                = {["hash"] = 0x80401068, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["MISSION3"]                = {["hash"] = 0x49292237, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["MISSION4"]                = {["hash"] = 0x5B4DC680, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["MISSION5"]                = {["hash"] = 0x270A5DFA, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["MISSION6"]                = {["hash"] = 0x392C823E, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["MISSION7"]                = {["hash"] = 0x024F9485, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["MISSION8"]                = {["hash"] = 0x14CAB97B, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["ARMY"]                    = {["hash"] = 0xE3D976F3, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {0x6F0783F5,},}},
    ["GUARD_DOG"]               = {["hash"] = 0x522B964A, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["AGGRESSIVE_INVESTIGATE"]  = {["hash"] = 0xEB47D4E0, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["MEDIC"]                   = {["hash"] = 0xB0423AA0, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["PRISONER"]                = {["hash"] = 0x7EA26372, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["DOMESTIC_ANIMAL"]         = {["hash"] = 0x72F30F6E, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
    ["DEER"]                    = {["hash"] = 0x31E50E10, ["relations"] = {["Companion"] = {}, ["Respect"] = {}, ["Like"] = {}, ["Nutral"] = {}, ["Dislike"] = {}, ["Hate"] = {},}},
}

local groups = {}

--- Returns Groups after merging the default and Newly created groups.
--- func desc
---@param . any
function ig.affiliation.GetGroups()
    local newgroups = ig.table.merge(groups, defaultgroups)
    return newgroups
end

--- [Internal] Add the created group to a table.
---@param name string "Name of group : "NAME""
---@param grouphash string "Hash number of the group, typically starts with: "0x""
---@param relations table "Table of relations to iterate over : {['Companion'] = {}, ['Respect'] = {}, ['Like'] = {}, ['Nutral'] = {}, ['Dislike'] = {}, ['Hate'] = {}}"
function ig.affiliation.AddGroupToTable(name, grouphash, relations)
    if not groups[name] then
        groups[name] = {["hash"] = grouphash, ["relations"] = relations} 
    end
end

--- Returns the cappitalized name as entered and hash of the new group.
---@param str string "Can be lower case, will convert to UPPERCASE"
---@param relations table "Table of relations to iterate over : {['Companion'] = {}, ['Respect'] = {}, ['Like'] = {}, ['Nutral'] = {}, ['Dislike'] = {}, ['Hate'] = {}}"
function ig.affiliation.CreateGroup(str, relations)
    local name = ig.check.String(string.upper(str))
    local _, grouphash = AddRelationshipGroup(name)
    ig.affiliation.AddGroupToTable(name, grouphash, relations)
    return name, grouphash
end

--- Set relationship between two groups (bidirectional)
---@param group1 string "First group name"
---@param group2 string "Second group name"
---@param relationship number "Relationship type: 0=Companion, 1=Respect, 2=Like, 3=Neutral, 4=Dislike, 5=Hate"
function ig.affiliation.SetGroupRelationship(group1, group2, relationship)
    local groups = ig.affiliation.GetGroups()
    
    if not groups[group1] then
        ig.log.Error("Affiliation", "Group '" .. group1 .. "' not found")
        return false
    end
    
    if not groups[group2] then
        ig.log.Error("Affiliation", "Group '" .. group2 .. "' not found")
        return false
    end
    
    local hash1 = groups[group1].hash
    local hash2 = groups[group2].hash
    
    -- Set bidirectional relationship
    SetRelationshipBetweenGroups(relationship, hash1, hash2)
    SetRelationshipBetweenGroups(relationship, hash2, hash1)
    
    ig.log.Debug("Affiliation", "Set " .. group1 .. " <-> " .. group2 .. " to relationship level " .. relationship)
    return true
end

--- Set relationship between two groups (single direction)
---@param sourceGroup string "Source group name"
---@param targetGroup string "Target group name"
---@param relationship number "Relationship type: 0=Companion, 1=Respect, 2=Like, 3=Neutral, 4=Dislike, 5=Hate"
function ig.affiliation.SetGroupRelationshipDirectional(sourceGroup, targetGroup, relationship)
    local groups = ig.affiliation.GetGroups()
    
    if not groups[sourceGroup] then
        ig.log.Error("Affiliation", "Source group '" .. sourceGroup .. "' not found")
        return false
    end
    
    if not groups[targetGroup] then
        ig.log.Error("Affiliation", "Target group '" .. targetGroup .. "' not found")
        return false
    end
    
    local sourceHash = groups[sourceGroup].hash
    local targetHash = groups[targetGroup].hash
    
    -- Set one-way relationship
    SetRelationshipBetweenGroups(relationship, sourceHash, targetHash)
    
    ig.log.Debug("Affiliation", "Set " .. sourceGroup .. " -> " .. targetGroup .. " to relationship level " .. relationship)
    return true
end

--- Clear relationship between two groups
---@param group1 string "First group name"
---@param group2 string "Second group name"
function ig.affiliation.ClearGroupRelationship(group1, group2)
    local groups = ig.affiliation.GetGroups()
    
    if not groups[group1] then
        ig.log.Error("Affiliation", "Group '" .. group1 .. "' not found")
        return false
    end
    
    if not groups[group2] then
        ig.log.Error("Affiliation", "Group '" .. group2 .. "' not found")
        return false
    end
    
    local hash1 = groups[group1].hash
    local hash2 = groups[group2].hash
    
    -- Clear both directions
    ClearRelationshipBetweenGroups(0, hash1, hash2)
    ClearRelationshipBetweenGroups(0, hash2, hash1)
    
    ig.log.Debug("Affiliation", "Cleared relationship between " .. group1 .. " and " .. group2)
    return true
end

--- Assign a ped to a relationship group
---@param ped number "Ped entity ID"
---@param groupName string "Group name"
function ig.affiliation.SetPedGroup(ped, groupName)
    if not DoesEntityExist(ped) then
        ig.log.Error("Affiliation", "Ped entity does not exist")
        return false
    end
    
    local groups = ig.affiliation.GetGroups()
    
    if not groups[groupName] then
        ig.log.Error("Affiliation", "Group '" .. groupName .. "' not found")
        return false
    end
    
    local groupHash = groups[groupName].hash
    
    SetPedRelationshipGroupHash(ped, groupHash)
    
    ig.log.Trace("Affiliation", "Assigned ped " .. ped .. " to group " .. groupName)
    return true
end

--- Set a ped's default relationship group (affects how NPCs react)
---@param ped number "Ped entity ID"
---@param groupName string "Group name to set as default"
function ig.affiliation.SetPedDefaultGroup(ped, groupName)
    if not DoesEntityExist(ped) then
        ig.log.Error("Affiliation", "Ped entity does not exist")
        return false
    end
    
    local groups = ig.affiliation.GetGroups()
    
    if not groups[groupName] then
        ig.log.Error("Affiliation", "Group '" .. groupName .. "' not found")
        return false
    end
    
    local groupHash = groups[groupName].hash
    
    SetPedRelationshipGroupDefaultHash(ped, groupHash)
    
    ig.log.Trace("Affiliation", "Set ped " .. ped .. " default group to " .. groupName)
    return true
end

--- Batch configure relationships for a group with multiple other groups
---@param sourceGroup string "Source group name"
---@param relationships table "Table of {groupName = relationshipLevel, ...}"
---@param bidirectional boolean "If true, sets bidirectional relationships (default: false)"
function ig.affiliation.ConfigureGroupRelationships(sourceGroup, relationships, bidirectional)
    if not relationships or type(relationships) ~= "table" then
        ig.log.Error("Affiliation", "Relationships must be a table")
        return false
    end
    
    local groups = ig.affiliation.GetGroups()
    local configCount = 0
    
    if not groups[sourceGroup] then
        ig.log.Error("Affiliation", "Source group '" .. sourceGroup .. "' not found")
        return false
    end
    
    for targetGroup, relationshipLevel in pairs(relationships) do
        local success = false
        if bidirectional then
            success = ig.affiliation.SetGroupRelationship(sourceGroup, targetGroup, relationshipLevel)
        else
            success = ig.affiliation.SetGroupRelationshipDirectional(sourceGroup, targetGroup, relationshipLevel)
        end
        
        if success then
            configCount = configCount + 1
        end
    end
    
    ig.log.Info("Affiliation", "Configured " .. configCount .. " relationships for group " .. sourceGroup)
    return configCount
end

--- Get relationship level between two groups
---@param group1 string "First group name"
---@param group2 string "Second group name"
---@return number "Relationship level or -1 if groups not found"
function ig.affiliation.GetGroupRelationship(group1, group2)
    local groups = ig.affiliation.GetGroups()
    
    if not groups[group1] or not groups[group2] then
        ig.log.Warn("Affiliation", "One or both groups not found")
        return -1
    end
    
    local hash1 = groups[group1].hash
    local hash2 = groups[group2].hash
    
    local relationshipLevel = GetRelationshipBetweenGroups(hash1, hash2)
    
    return relationshipLevel
end

--- Get relationship level between two peds
---@param ped1 number "First ped entity ID"
---@param ped2 number "Second ped entity ID"
---@return number "Relationship level or -1 if peds not found"
function ig.affiliation.GetPedRelationship(ped1, ped2)
    if not DoesEntityExist(ped1) or not DoesEntityExist(ped2) then
        ig.log.Warn("Affiliation", "One or both peds do not exist")
        return -1
    end
    
    local relationshipLevel = GetRelationshipBetweenPeds(ped1, ped2)
    
    return relationshipLevel
end

--- Check if a group exists
---@param groupName string "Group name to check"
---@return boolean "True if group exists"
function ig.affiliation.GroupExists(groupName)
    local groups = ig.affiliation.GetGroups()
    return groups[groupName] ~= nil
end

--- Get group hash by name
---@param groupName string "Group name"
---@return number "Group hash or nil if not found"
function ig.affiliation.GetGroupHash(groupName)
    local groups = ig.affiliation.GetGroups()
    if groups[groupName] then
        return groups[groupName].hash
    end
    return nil
end

--[[

-- To create loop to set relationship or look to permenant solution.
-- Potentially use multiple threads??

0 = Companion  
1 = Respect  
2 = Like  
3 = Neutral  
4 = Dislike  
5 = Hate  
255 = Pedestrians  

local _, groupHash = AddRelationshipGroup(name)
local retval = DoesRelationshipGroupExist(groupHash)
local num = GetRelationshipBetweenGroups(group1, group2)
local num = GetRelationshipBetweenPeds(ped1, ped2)

-- CALL TWICE, VICE VERSA ELSE --

ClearRelationshipBetweenGroups(relationship, group1, group2)
SetPedRelationshipGroupDefaultHash(ped, hash)
SetRelationshipBetweenGroups(relationship, group1, group2)
SetPedRelationshipGroupHash(ped, hash)

]]--