-- ====================================================================================--

c.skill = {} -- functions
c._skills = {} -- Server sent to client

-- ====================================================================================--

AddEventHandler("Client:Character:SetSkills", function(skills)
    c._skills = skills
end)

--- Sets the table of active modifiers.
---@param t table "Typically passed from the server as an internal table."
function c.skill.SetSkills()
    if LocalPlayer.state.Skills ~= nil then
        c._skills = LocalPlayer.state.Skills
        c.func.Debug_2("[F] c.skill.SetSkills() LocalState Used")
        -- print(c._skills)
        -- print(c.table.Dump(c._skills))
    else
        c._skills = TriggerServerCallback({eventName = "GetSkills"})
        c.func.Debug_2("[F] c.skill.SetSkills() Event Used")
    end
end

-- ====================================================================================--

--
function c.skill.GetSkills()
    return self.Skills
end
--
function c.skill.GetSkill(skill)
    for k, v in pairs(self.Skills) do
        if k == skill then
            return v
        end
    end
end
--
function c.skill.CompareSkill(sk, level)
    local skill = c.skill.GetSkill(sk)
    if skill < level then
        return false
    else
        return true
    end
end
