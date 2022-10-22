-- ====================================================================================--

c.skill = {} -- functions
c._skills = {} -- Server sent to client

-- ====================================================================================--

AddEventHandler("Client:Character:SetSkills", function(skills)
    c._skills = skills
end)

exports("GetSkills", function()
    return c._skills
end)

-- ====================================================================================--

--
c.skill.GetSkills = function()
    return self.Skills
end
--
c.skill.GetSkill = function(skill)
    for k, v in pairs(self.Skills) do
        if k == skill then
            return v
        end
    end
end
--
c.skill.CompareSkill = function(sk, level)
    local skill = c.skill.GetSkill(sk)
    if skill < level then
        return false
    else
        return true
    end
end
