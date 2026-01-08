# ig.sql.user.SetBan

## Description

Sets or removes a ban status for a player identified by their license ID. Always include a detailed reason and ensure proper permission checks before use.

## Signature

```lua
function ig.sql.user.SetBan(license_id, bool, reason, cb)
```

## Example

```lua
-- Example 1: Ban a player with reason
local license = ig.func.identifier(source)
local reason = {
    ["Reason"] = "Cheating detected",
    ["Timestamp"] = os.time(),
    ["BannedBy"] = "Admin Name"
}
ig.sql.user.SetBan(license, true, reason, function()
    DropPlayer(source, "You have been banned: " .. reason["Reason"])
    print("Player banned successfully")
end)

-- Example 2: Unban a player
ig.sql.user.SetBan(license_id, false, nil, function()
    print("Player unbanned")
end)

-- Example 3: Temporary ban with expiry (custom implementation)
local tempReason = {
    ["Reason"] = "Temp ban for 24h",
    ["Timestamp"] = os.time(),
    ["Expiry"] = os.time() + (24 * 60 * 60),
    ["BannedBy"] = GetPlayerName(adminSource)
}
ig.sql.user.SetBan(license, true, tempReason, function()
    print("Temp ban applied")
end)
```

## Important Notes

> ⚠️ **Security**: This function interacts with the database. Always validate and sanitize inputs to prevent SQL injection.

> ⚠️ **Security**: This function accesses player identifiers or can ban/kick players. Ensure proper permission checks.

## Related Functions

- [ig.sql.user.Add](ig_sql_user_Add.md)
- [ig.sql.user.AddCharacterSlot](ig_sql_user_AddCharacterSlot.md)
- [ig.sql.user.Find](ig_sql_user_Find.md)
- [ig.sql.user.Get](ig_sql_user_Get.md)
- [ig.sql.user.GetAce](ig_sql_user_GetAce.md)

## Source

Defined in: `server/[SQL]/_users.lua`
