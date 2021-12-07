-- ====================================================================================--
c.tebex = {}
--[[
NOTES
    -
]] --
-- ====================================================================================--
--[[
{id} - fivem:var id
{sid} - LIVE SERVER ID IF IN SERVER
{hexid} - This returns the Hex ID (e.g. steam:110000abf6b0001) for the player.
{transaction} - The transaction ID of the payment.
{server} - Will output the name of the server.
{price} - The amount paid.
{currency} - The currency of the payment.
{time} - The time of purchase, e.g. 15:30.
{date} - The date of purchase, e.g. 13/01/2012.
{email} - The email address of the customer.
{ip} - The IP address of the customer.
{packageId} - The ID of the package.
{packagePrice} - The price of the package.
{packageExpiry} - The expiry length of the package (represented in the package's expiry period).
{packageName} - The name of the package.
{purchaserName} - The name of the player who purchased a gift package. 
{purchaserUuid} - The UUID of the player who purchased a gift package.
{purchaseQuantity} - The quantity of the package that was purchased.
]]-- 

RegisterCommand('AddPriority', function(source, args, rawCommand)
    local id = args[1]
    c.sql.user.SetPriority(id, true)
end, true)

RegisterCommand('RemovePriority', function(source, args, rawCommand)
    local id = args[1]
    c.sql.user.SetPriority(id, false)
end, true)

RegisterCommand('AddCharacterSlot', function(source, args, rawCommand)
    local id = args[1]
    c.sql.user.AddCharacterSlot(id, false)
end, true)

RegisterCommand('TestingCommand', function(source, args, rawCommand)
    local id = args[1]
    print("TestingCommand from Tebex",args[1],args[2])
    print(table.unpack(args))
end, true)
