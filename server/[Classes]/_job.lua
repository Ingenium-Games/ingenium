-- ====================================================================================--

--[[
NOTES.
    - Create job as object to check for ownership, permit account or safe access or to 
    - enable job functions or equilivant meu selections.
]]--


-- ====================================================================================--

c.class.Job = {}
c.class.Job._index = c.class.Job

function c.class.Job:Create(tab)
    local self = {}
    --
    self.Name = tab.Name
    self.Label = tab.Label
    self.Boss = tab.Boss
    self.Grades = tab.Grades
    self.Members = tab.Members
    self.Description = tab.Description
    self.Accounts = tab.Accounts
    --
    self.GetName = function()
        return self.Name
    end
    --
    self.GetGrades = function()
        return self.Grades
    end
    --
    self.GetDescription = function()
        return self.Description
    end
    --
    self.SetDescription = function(s)
        local str = tostring(s)
        if #str <= 1500 then
            self.Description = str
        else
            c.debug_1("Unable to set description as length is too long. Must be less than 255 characters.")
        end
    end
    --
    self.GetAccounts = function(b)
        local bool = c.check.Boolean(b)
        if bool then
            local Accounts = {}
            for k,v in pairs(self.Accounts) do
                Accounts[k] = v
            end
            return Accounts
        else
            return self.Accounts
        end
    end
    --
    self.GetAccount = function(acc)
        for k, v in pairs(self.Accounts) do
            if k == acc then
                return v
            end
        end
    end
    --
    self.SetAccount = function(acc, v)
        local num = c.check.Number(v)
        if self.Accounts[acc] then
            self.Accounts[acc] = c.math.Decimals(num,0)
        else
            c.debug_1("Account entered does not exist")
        end
    end
    --
    self.GetSafe = function()
        local acc = self.GetAccount("Safe")
        if acc then
            return acc
        end
    end
    --
    self.SetSafe = function(v)
        local num = c.check.Number(v)
        if num >= 0 then
            local acc = c.math.Decimals(num, 0)
            self.SetAccount("Safe", acc)
        end
    end
    --
    self.AddSafe = function(v)
        local num = c.check.Number(v)
        if num > 0 then
            local acc = self.GetAccount("Safe")
            if acc then
                local bkp = acc
                acc = acc + c.math.Decimals(num, 0)
                if acc < 0 then
                    self.SetAccount("Safe", bkp)
                    c.debug_1("Job "..self.Name.." has AddSafe() Cancelled due to Negative balance remaining.")
                    CancelEvent()
                else
                    self.SetAccount("Safe", acc)
                end
            end
        end
    end
    --
    self.RemoveSafe = function(v)
        local num = c.check.Number(v)
        if num > 0 then
            local acc = self.GetAccount("Safe")
            if acc then
                local bkp = acc
                acc = acc - c.math.Decimals(num, 0)
                if acc < 0 then
                    self.SetAccount("Safe", bkp)
                    c.debug_1("Job "..self.Name.." has RemoveSafe() Cancelled due to Negative balance remaining.")
                    CancelEvent()
                else
                    self.SetAccount("Safe", acc)
                end
            end
        end
    end
    --
    self.GetBank = function()
        local acc = self.GetAccount("Bank")
        if acc then
            return acc
        end
    end
    --
    self.SetBank = function(v)
        local num = c.check.Number(v)
        local acc = c.math.Decimals(num, 0)
        self.SetAccount("Bank", acc)
    end
    --
    self.AddBank = function(v)
        local num = c.check.Number(v)
        if num > 0 then
            local acc = self.GetAccount("Bank")
            if acc then
                acc = acc + c.math.Decimals(num, 0)
                if acc < 0 then
                    self.SetAccount("Bank", acc)
                else
                    self.SetAccount("Bank", acc)
                end
            end
        end
    end
    --
    self.RemoveBank = function(v)
        local num = c.check.Number(v)
        if num > 0 then
            local acc = self.GetAccount("Bank")
            if acc then
                acc = acc - c.math.Decimals(num, 0)
                if acc < 0 then
                    self.SetAccount("Bank", acc)
                else
                    self.SetAccount("Bank", acc)
                end
            end
        end
    end
    --
    self.FindMember = function(member)
        for _,v in pairs(self.Members) do
            if v == member then
                return true
            end
        end
        return false
    end
    --
    self.AddMember = function(member)
        local check = self.FindMember(member)
        if not check then
            table.insert(self.Members, member)
        end
    end
    --
    self.RemoveMember = function(member)
        local check = self.FindMember(member)
        if check then
            table.remove(self.Members, member)
        end
    end
    --
    self.SetBoss = function(member)
        self.AddMember(member)
        self.Boss = member
    end
    --

    --
    c.debug_2("Generated Job: "..self.Name)
    return self
end

function c.class.Job.New(tab)
    local self = {}
	setmetatable(self, c.class.Job:Create(tab))
	return self
end