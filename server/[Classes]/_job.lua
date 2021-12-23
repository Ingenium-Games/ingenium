-- ====================================================================================--
c.class.Job = {}
c.class.Job.__index = c.class.Job
-- ====================================================================================--
--- func desc
---@param tab any
function c.class.Job:Create(tab)
    self.Name = tab.Name
    self.Label = tab.Label
    self.Boss = tab.Boss
    self.Grades = tab.Grades
    self.Members = tab.Members
    self.Description = tab.Description
    self.Accounts = tab.Accounts
    return self
end
--- func desc
function c.class.Job:GetName()
    return self.Name
end
--- func desc
function c.class.Job:GetGrades()
    return self.Grades
end
--- func desc
function c.class.Job:GetDescription()
    return self.Description
end
--- func desc
---@param s any
function c.class.Job:SetDescription(s)
    local str = tostring(s)
    if #str <= 1500 then
        self.Description = str
    else
        c.debug_1("Unable to set description as length is too long. Must be less than 255 characters.")
    end
end
--- func desc
---@param b any
function c.class.Job:GetAccounts(b)
    local bool = c.check.Boolean(b)
    if bool then
        local Accounts = {}
        for k, v in pairs(self.Accounts) do
            Accounts[k] = v
        end
        return Accounts
    else
        return self.Accounts
    end
end
--- func desc
---@param acc any
function c.class.Job:GetAccount(acc)
    for k, v in pairs(self.Accounts) do
        if k == acc then
            return v
        end
    end
end
--- func desc
---@param acc any
---@param v any
function c.class.Job:SetAccount(acc, v)
    local num = c.check.Number(v)
    if self.Accounts[acc] then
        self.Accounts[acc] = c.math.Decimals(num, 0)
    else
        c.debug_1("Account entered does not exist")
    end
end
--- func desc
function c.class.Job:GetSafe()
    local acc = self:GetAccount("Safe")
    if acc then
        return acc
    end
end
--- func desc
---@param v any
function c.class.Job:SetSafe(v)
    local num = c.check.Number(v)
    if num >= 0 then
        local acc = c.math.Decimals(num, 0)
        self:SetAccount("Safe", acc)
    end
end
--- func desc
---@param v any
function c.class.Job:AddSafe(v)
    local num = c.check.Number(v)
    if num > 0 then
        local acc = self:GetAccount("Safe")
        if acc then
            local bkp = acc
            acc = acc + c.math.Decimals(num, 0)
            if acc < 0 then
                self:SetAccount("Safe", bkp)
                c.debug_1("Job " .. self.Name .. " has AddSafe() Cancelled due to Negative balance remaining.")
                CancelEvent()
            else
                self:SetAccount("Safe", acc)
            end
        end
    end
end
--- func desc
---@param v any
function c.class.Job:RemoveSafe(v)
    local num = c.check.Number(v)
    if num > 0 then
        local acc = self:GetAccount("Safe")
        if acc then
            local bkp = acc
            acc = acc - c.math.Decimals(num, 0)
            if acc < 0 then
                self:SetAccount("Safe", bkp)
                c.debug_1("Job " .. self.Name .. " has RemoveSafe() Cancelled due to Negative balance remaining.")
                CancelEvent()
            else
                self:SetAccount("Safe", acc)
            end
        end
    end
end
--- func desc
function c.class.Job:GetBank()
    local acc = self:GetAccount("Bank")
    if acc then
        return acc
    end
end
--- func desc
---@param v any
function c.class.Job:SetBank(v)
    local num = c.check.Number(v)
    local acc = c.math.Decimals(num, 0)
    self:SetAccount("Bank", acc)
end
--- func desc
---@param v any
function c.class.Job:AddBank(v)
    local num = c.check.Number(v)
    if num > 0 then
        local acc = self:GetAccount("Bank")
        if acc then
            acc = acc + c.math.Decimals(num, 0)
            if acc < 0 then
                self:SetAccount("Bank", acc)
            else
                self:SetAccount("Bank", acc)
            end
        end
    end
end
--- func desc
---@param v any
function c.class.Job:RemoveBank(v)
    local num = c.check.Number(v)
    if num > 0 then
        local acc = self:GetAccount("Bank")
        if acc then
            acc = acc - c.math.Decimals(num, 0)
            if acc < 0 then
                self:SetAccount("Bank", acc)
            else
                self:SetAccount("Bank", acc)
            end
        end
    end
end
--- func desc
---@param member any
function c.class.Job:FindMember(member)
    for _, v in pairs(self.Members) do
        if v == member then
            return true
        end
    end
    return false
end
--- func desc
---@param member any
function c.class.Job:AddMember(member)
    local check = self:FindMember(member)
    if not check then
        table.insert(self.Members, member)
    end
end
--- func desc
---@param member any
function c.class.Job:RemoveMember(member)
    local check = self:FindMember(member)
    if check then
        table.remove(self.Members, member)
    end
end
--- func desc
---@param member any
function c.class.Job:SetBoss(member)
    self.AddMember(member)
    self.Boss = member
end
-- ====================================================================================--
--- func desc
---@param tab any
function c.class.Job.New(tab)
    local self = {}
    setmetatable(self, c.class.Job:Create(tab))
    return self
end
