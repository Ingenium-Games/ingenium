# Public Event: Client:Banking:OpenMenu

**Triggered to**: Open banking menu on client  
**Security**: ✅ Public (can trigger from any resource)  
**Side**: [C]

## Description

Trigger the banking menu display on the client with account information.

## Parameters

- `data` (table) - Banking menu data
  - `data.characterId` (number) - Character ID
  - `data.iban` (string) - IBAN account number
  - `data.balance` (number) - Current balance

## Usage

```lua
-- Server: Send to client
TriggerClientEvent("Client:Banking:OpenMenu", playerId, {
    characterId = charId,
    iban = playerIban,
    balance = playerBalance
})

-- Client: Receives and displays menu automatically
```

## Examples

```lua
-- Server-side: Open banking for a player
TriggerClientEvent("Client:Banking:OpenMenu", playerId, {
    characterId = charId,
    iban = "DE89370400440532013000",
    balance = 5000.50
})

-- Or use the public export (if available)
exports["ingenium"]:OpenBanking()
```

## Related Functions

- [OpenBanking](ig_export_OpenBanking.md) - Client-side banking trigger
- [TriggerServerCallback](ig_export_TriggerServerCallback.md) - Banking operations
- [Notify](ig_export_Notify.md) - Notifications

## See Also

- [Client:Menu:Select](ig_event_ClientMenuSelect.md) - Menu selection
- [Client:Input:Submit](ig_event_ClientInputSubmit.md) - Input submission
