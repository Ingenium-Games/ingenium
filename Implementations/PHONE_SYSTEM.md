# Phone System Implementation Guide

## Overview

The Ingenium Phone System is a fully integrated NUI-based phone with Vue 3, featuring a Settings app and Contacts app. The phone uses IMEI-based tracking, database persistence, and follows Ingenium's class-based entity architecture.

## Architecture

### Database Layer

**Table: `phones`**
- Stores phone data keyed by IMEI (UUID)
- Fields: IMEI, Phone_Number, Character_ID, Contacts (JSON), Settings (JSON), Created, Last_Used
- See `db.sql` for full schema

### Server Modules

1. **SQL Module** (`server/[SQL]/_phone.lua`)
   - Database CRUD operations
   - Functions: `Get()`, `GetByNumber()`, `Create()`, `UpdateContacts()`, `UpdateSettings()`, etc.

2. **Phone Management** (`server/[Data - No Save Needed]/_phone.lua`)
   - Phone lifecycle management
   - IMEI generation on first use
   - Integration with inventory system
   - Functions: `GetOrCreate()`, `AddContact()`, `UpdateSettings()`, etc.

3. **Event Handlers** (`server/[Events]/_phone.lua`)
   - Server-side event handlers for client requests
   - Validates all incoming data
   - Events: `Server:Phone:UpdateSettings`, `Server:Phone:AddContact`, etc.

### Client Module

**Client Handler** (`client/_phone.lua`)
- Animation and prop management
- NUI communication
- Events: `Client:Phone:Use`, callbacks for settings/contacts updates

### NUI (Vue 3)

1. **Phone Store** (`nui/src/stores/phone.js`)
   - Pinia store for phone state
   - Manages phone visibility, lock state, current app, contacts, settings

2. **Phone Component** (`nui/src/components/Phone.vue`)
   - Main phone UI with animations
   - Lock screen, home screen, status bar, navigation

3. **Settings App** (`nui/src/components/phone/apps/SettingsApp.vue`)
   - Plane Mode toggle
   - Emergency Alerts toggle (disabled when plane mode is on)
   - Displays provider, phone number, IMEI

4. **Contacts App** (`nui/src/components/phone/apps/ContactsApp.vue`)
   - Contact list view
   - Add/Edit/Delete contacts
   - Contact details view
   - Placeholders for Call/Message buttons (future feature)

## Usage

### From Inventory

Players can use the Phone item from their inventory. On first use, the phone generates a unique IMEI and creates a database record.

```lua
-- Server automatically handles via event:
AddEventHandler("Inventory:Consume:Phone", function(source, position, quantity)
    ig.phone.Use(source, position)
end)
```

### Phone Data Structure

**Settings:**
```json
{
  "planeMode": false,
  "emergencyAlerts": true,
  "provider": "Warstock"
}
```

**Contact:**
```json
{
  "id": "uuid",
  "name": "John Doe",
  "number": "123456",
  "type": "personal|work",
  "email": "john@example.com"
}
```

## API Reference

### Server Functions

```lua
-- Get or create phone data for a player's phone item
local phoneData = ig.phone.GetOrCreate(xPlayer, inventoryPosition)

-- Update phone settings
ig.phone.UpdateSettings(imei, settingsTable)

-- Manage contacts
ig.phone.AddContact(imei, contactTable)
ig.phone.UpdateContact(imei, contactId, updatedContactTable)
ig.phone.RemoveContact(imei, contactId)

-- Check phone state
local isPlaneMode = ig.phone.IsPlaneMode(imei)
local hasAlerts = ig.phone.EmergencyAlertsEnabled(imei)
```

### Server Events

```lua
-- Trigger phone usage
TriggerClientEvent("Client:Phone:Use", source, phoneData)

-- Update contacts from server
TriggerClientEvent("Client:Phone:ContactsUpdated", source, contacts)

-- Update settings from server
TriggerClientEvent("Client:Phone:SettingsUpdated", source, settings)
```

### Client Events

```lua
-- Register for phone usage
RegisterNetEvent("Client:Phone:Use", function(phoneData)
    -- Opens phone UI
end)
```

### NUI Callbacks

```javascript
// From NUI to Client
RegisterNUICallback('NUI:Client:PhoneClose', ...)
RegisterNUICallback('NUI:Client:PhoneUpdateSettings', ...)
RegisterNUICallback('NUI:Client:PhoneAddContact', ...)
RegisterNUICallback('NUI:Client:PhoneUpdateContact', ...)
RegisterNUICallback('NUI:Client:PhoneDeleteContact', ...)
```

## Data Flow

### Opening the Phone

1. Player uses Phone item from inventory
2. Server (`ig.phone.Use()`) gets or creates phone data
3. Server sends `Client:Phone:Use` event with phone data
4. Client (`ig.phone.Open()`) plays animation and attaches prop
5. Client sends `Client:NUI:PhoneOpen` message to NUI
6. Vue store (`phoneStore.open()`) receives data and displays UI

### Updating Settings

1. User toggles setting in Settings app
2. Vue component sends `NUI:Client:PhoneUpdateSettings` callback
3. Client forwards to `Server:Phone:UpdateSettings` event
4. Server validates and saves to database via `ig.phone.UpdateSettings()`
5. Server optionally sends `Client:Phone:SettingsUpdated` back to client
6. Client updates NUI if needed

### Managing Contacts

Same pattern as settings:
1. User action in Contacts app
2. NUI callback to client
3. Client event to server
4. Server validates and persists
5. Server sends updated contact list back
6. Client updates NUI

## Security

- All client data is validated on server
- IMEI validation (UUID format check)
- String length limits enforced
- Contact data sanitized via `ig.check.*` functions
- Server is source of truth for all phone data

## Future Enhancements

### Calling System
- Hook into plane mode check: `ig.phone.IsPlaneMode(imei)`
- Check for blocked numbers in contacts
- Conference call support (multiple participants)

### Messaging System
- SMS between players
- Message history persistence
- Read/unread status

### Emergency Alerts
- When player is downed, check `ig.phone.EmergencyAlertsEnabled(imei)`
- If enabled and not in plane mode, alert EMS automatically

### Life Invader (Social Media)
- Posts, likes, comments
- Friend system
- News feed

## Troubleshooting

### Phone doesn't open
- Check console for errors
- Verify Phone item exists in `ig.items`
- Check `Hotkey = true` in Phone item definition
- Verify inventory callback event is registered

### Settings don't persist
- Check database connection
- Verify `ig.sql.phone` module loaded
- Check server console for SQL errors
- Verify dirty flag system is working

### Contacts disappear
- Verify JSON encoding/decoding
- Check database column size (longtext should be sufficient)
- Verify contact ID generation

### Animation issues
- Check animation dictionary loaded: `cellphone@`
- Verify prop model exists: `prop_phone_ing`
- Check bone index: 28422 (right hand)

## Files Modified/Created

### Database
- `db.sql` - Added `phones` table

### Server
- `server/[SQL]/_phone.lua` - Phone SQL operations
- `server/[Data - No Save Needed]/_phone.lua` - Phone management
- `server/[Events]/_phone.lua` - Event handlers

### Client
- `client/_phone.lua` - Client-side phone handler

### NUI
- `nui/src/stores/phone.js` - Phone state store
- `nui/src/components/Phone.vue` - Main phone component
- `nui/src/components/phone/apps/SettingsApp.vue` - Settings app
- `nui/src/components/phone/apps/ContactsApp.vue` - Contacts app
- `nui/src/utils/nui.js` - Added phone message handlers
- `nui/src/App.vue` - Added Phone component

### Config
- `fxmanifest.lua` - Added new server/client files

## Testing Checklist

- [ ] Phone item can be used from inventory
- [ ] IMEI is generated on first use
- [ ] Phone opens with animation
- [ ] Prop attaches to player hand
- [ ] Lock screen appears
- [ ] Lock screen can be unlocked
- [ ] Home screen shows app icons
- [ ] Settings app opens
- [ ] Plane mode can be toggled
- [ ] Emergency alerts can be toggled
- [ ] Emergency alerts disabled when plane mode on
- [ ] Provider, number, IMEI displayed correctly
- [ ] Contacts app opens
- [ ] Can add new contact
- [ ] Can edit existing contact
- [ ] Can delete contact
- [ ] Contact list displays correctly
- [ ] Contact details view works
- [ ] Settings persist across phone close/open
- [ ] Contacts persist across phone close/open
- [ ] Settings persist across server restart
- [ ] Contacts persist across server restart
- [ ] Phone closes properly
- [ ] Animation stops on close
- [ ] Prop is removed on close
- [ ] ESC key closes phone
- [ ] Multiple players can use phones simultaneously

## Known Limitations

1. **No Calling Yet** - Call buttons are placeholders
2. **No Messaging Yet** - Message buttons are placeholders
3. **No History** - No call or message history tracking yet
4. **Single Phone** - Each player can only have one active phone at a time
5. **No SIM Swap** - Phone number is tied to character, not phone item

## Performance Considerations

- Phone data loaded on-demand (not preloaded for all players)
- Contacts stored as JSON (efficient for small contact lists)
- Settings stored as JSON (minimal data)
- IMEI used as primary key (fast lookups)
- Database queries use prepared statements
- Client-side animations are GPU accelerated

## Maintenance

### Adding New Settings
1. Add field to Settings component
2. Update default settings in SQL module
3. Update validation in event handler
4. Update Settings app UI

### Adding New Apps
1. Create new Vue component in `nui/src/components/phone/apps/`
2. Add app icon to home screen in `Phone.vue`
3. Add case in `v-else-if` chain for app routing
4. Create server handlers if app needs persistence
5. Update phone store if app needs state management

## Credits

Implemented following Ingenium's architectural patterns:
- Class-based entity system
- Dirty flag persistence
- StateBag synchronization
- Vue 3 Single-App NUI architecture
- Pinia state management
- TailwindCSS styling
