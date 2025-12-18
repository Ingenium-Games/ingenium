-- ====================================================================================--
ig.skill = {} -- functions
ig._skills = {} -- Server sent to client
-- ====================================================================================--

--- Sets the table of active modifiers.
---@param t table "Typically passed from the server as an internal table."
function ig.skill.SetSkills()
    if LocalPlayer.state.Skills ~= nil then
        ig._skills = LocalPlayer.state.Skills
        ig.funig.Debug_2("[F] ig.skill.SetSkills() LocalState Used")
        -- print(ig._skills)
        -- print(ig.table.Dump(ig._skills))
    else
        ig._skills = TriggerServerCallback({eventName = "GetSkills"})
        ig.funig.Debug_2("[F] ig.skill.SetSkills() Event Used")
    end
end

-- ====================================================================================--

--
function ig.skill.GetSkills()
    return self.Skills
end
--
function ig.skill.GetSkill(skill)
    for k, v in pairs(self.Skills) do
        if k == skill then
            return v
        end
    end
end
--
function ig.skill.CompareSkill(sk, level)
    local skill = ig.skill.GetSkill(sk)
    if skill < level then
        return false
    else
        return true
    end
end
