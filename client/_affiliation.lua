-- ====================================================================================--

c.affiliation = {}

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
function c.affiliation.GetGroups()
    local newgroups = c.table.merge(groups, defaultgroups)
    return newgroups
end

--- [Internal] Add the created group to a table.
---@param name string "Name of group : "NAME""
---@param grouphash string "Hash number of the group, typically starts with: "0x""
---@param relations table "Table of relations to iterate over : {['Companion'] = {}, ['Respect'] = {}, ['Like'] = {}, ['Nutral'] = {}, ['Dislike'] = {}, ['Hate'] = {}}"
function c.affiliation.AddGroupToTable(name, grouphash, relations)
    if not groups[name] then
        groups[name] = {["hash"] = grouphash, ["relations"] = relations} 
    end
end

--- Returns the cappitalized name as entered and hash of the new group.
---@param str string "Can be lower case, will convert to UPPERCASE"
---@param relations table "Table of relations to iterate over : {['Companion'] = {}, ['Respect'] = {}, ['Like'] = {}, ['Nutral'] = {}, ['Dislike'] = {}, ['Hate'] = {}}"
function c.affiliation.CreateGroup(str, relations)
    local name = c.check.String(string.upper(str))
    local _, grouphash = AddRelationshipGroup(name)
    c.affiliation.AddGroupToTable(name, grouphash, relations)
    return name, grouphash
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