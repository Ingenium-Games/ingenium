-- ====================================================================================--

if not c.sql then c.sql = {} end
c.sql.obj = {}

-- ====================================================================================--

--[[

CREATE TABLE `objects` (
	`ID` INT(11) NOT NULL,
    `UUID` VARCHAR(36) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci'
	`Model` VARCHAR(50) NULL DEFAULT NULL COMMENT 'Hash ID' COLLATE 'utf8mb4_unicode_ci',
	`Coords` VARCHAR(355) NOT NULL DEFAULT '{"x":0.00,"y":0.00,"z":0.00,"h":0.00}' COLLATE 'utf8mb4_unicode_ci',
	`Inventory` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`Created` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`Updated` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	UNIQUE INDEX `UUID` (`UUID`) USING BTREE,
	INDEX `Created` (`Created`) USING BTREE,
	INDEX `Updated` (`Updated`) USING BTREE,
	INDEX `Character_ID` (`Character_ID`) USING BTREE,
	INDEX `Model` (`Model`) USING BTREE
)
COLLATE='utf8mb4_unicode_ci'
ENGINE=InnoDB
ROW_FORMAT=DYNAMIC
;

]]--

--- Takes Job information from the Database and imports it into the Server Upon the Initialise() function.
---@param cb function "Callback function if any, called after the SQL statement."
function c.sql.obj.GetObjects(cb)
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchAll("SELECT * FROM `objects`", {
    }, function(data)
        for i=1, #data, 1 do
            local j = data[i]
            c.objects[i] = j
        end
        IsBusy = false
    end)
    --
    while IsBusy do
        Citizen.Wait(0)
    end
    --
    if cb then
        cb()
    end
end
--

function c.sql.obj.Add(data, cb)
    local IsBusy = true
    local Data = data
    MySQL.Async.execute("INSERT INTO `objects` (`UUID`, `Model`, `Coords`, `Meta`, `States`, `Inventory`, `Created`, `Updated`) VALUES (@UUID, @Model, @Coords, @Meta, @States, @Inventory, @Created, @Updated);",{
        ["@UUID"] = Data.UUID,
        ["@Model"] = Data.Model,
        ["@Coords"] = Data.Coords,
        ["@Meta"] = Data.Meta,
        ["@States"] = Data.States,
        ["@Inventory"] = Data.Inventory,
        ["@Created"] = c.func.Timestamp(),
        ["@Updated"] = c.func.Timestamp(),
    }, function(r)
        IsBusy = false
    end)
    --
    while IsBusy do
        Citizen.Wait(0)
    end
    --
    if cb then
        cb()
    end
end
--