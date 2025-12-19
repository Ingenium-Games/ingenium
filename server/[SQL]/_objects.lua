-- ====================================================================================--
if not ig.sql then ig.sql = {} end
ig.sql.obj = {}
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
function ig.sql.obj.GetObjects(cb)
    local result = ig.sql.Query("SELECT * FROM `objects`", {})
    for i=1, #result, 1 do
        local j = result[i]
        ig.objects[i] = j
    end
    if cb then
        cb()
    end
end
--

function ig.sql.obj.Add(data, cb)
    local Data = data
    ig.sql.Insert(
        "INSERT INTO `objects` (`UUID`, `Model`, `Coords`, `Meta`, `States`, `Inventory`, `Created`, `Updated`) VALUES (?, ?, ?, ?, ?, ?, ?, ?);",
        {Data.UUID, Data.Model, Data.Coords, Data.Meta, Data.States, Data.Inventory, ig.func.Timestamp(), ig.func.Timestamp()},
        function(insertId)
            if cb then
                cb(insertId)
            end
        end)
end
--