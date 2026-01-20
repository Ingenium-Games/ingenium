# Phone Apps: Calculator and Email

This document describes the Calculator and Email phone applications added to the Ingenium framework.

## Calculator App

### Overview
A basic calculator application built into the phone system that provides standard arithmetic operations.

### Features
- **Addition** (+)
- **Subtraction** (-)
- **Multiplication** (×)
- **Division** (÷)
- Clear (C) - Resets all values
- Clear Entry (CE) - Clears current input
- Backspace (←) - Removes last digit
- Decimal point support
- Error handling for division by zero

### Usage
1. Open your phone from inventory
2. Tap the Calculator app icon (🔢)
3. Use the number pad and operators to perform calculations
4. Press equals (=) to see the result

### Technical Details
- Component: `nui/src/components/phone/apps/CalculatorApp.vue`
- Precision: Results are rounded to 8 decimal places to avoid floating point errors
- Visual feedback: Displays previous value and operator above current input

---

## Email App

### Overview
A fully-functional email system allowing characters to send and receive emails within the game world.

### Features

#### Account Management
- **Registration**: Create a new email account with username and password
- **Login**: Access existing email account
- **Email Validation**:
  - Minimum 3 characters before @ symbol
  - Only alphanumeric characters and dots (.) allowed
  - Domain must contain at least one dot
  - Example valid emails: `john.doe@mail.com`, `player123@game.net`

#### Email Operations
- **Compose**: Send new emails with subject and message
- **Inbox**: View received emails
  - Unread count badge
  - Mark as read when opening
  - Shows sender, subject, preview, and timestamp
- **Sent**: View emails you've sent
  - Shows recipient, subject, preview, and timestamp
- **Message Length**: Up to 5000 characters per email
- **Subject Length**: Up to 200 characters

#### Future Features (Placeholders)
The following features are disabled but reserved for future implementation:
- Reply to emails
- Forward emails
- Email chains/threads

### Usage

#### Creating an Email Account
1. Open your phone from inventory
2. Tap the Email app icon (📧)
3. Click "Need an account? Register"
4. Enter desired email address (must follow validation rules)
5. Enter a password (minimum 4 characters)
6. Click "Create Account"

#### Logging In
1. Open the Email app
2. Enter your email address
3. Enter your password
4. Click "Login"

#### Sending an Email
1. Log into your email account
2. Click the "✍️ Compose" button
3. Enter recipient's email address
4. (Optional) Enter subject
5. Enter your message
6. Click "📤 Send"

#### Reading Emails
1. Click on the "📥 Inbox" or "📤 Sent" tab
2. Click on any email to view full details
3. Inbox emails are automatically marked as read when opened

### Database Schema

#### phone_email_accounts
Stores email account information:
- `ID`: Auto-increment primary key
- `Character_ID`: Owner's character ID
- `Email_Address`: Email address (unique)
- `Password_Hash`: Hashed password
- `Created_At`: Account creation timestamp

#### phone_emails
Stores email messages:
- `ID`: Auto-increment primary key
- `Sender`: Sender's email address
- `Recipient`: Recipient's email address
- `Subject`: Email subject (max 200 chars)
- `Message`: Email body (max 5000 chars)
- `Sent_At`: Send timestamp
- `Read_Status`: 0 = unread, 1 = read

### API Reference

#### Server Events

**Register Account**
```lua
TriggerServerEvent("Server:Email:Register", email, password)
```

**Login**
```lua
TriggerServerEvent("Server:Email:Login", email, password)
```

**Send Email**
```lua
TriggerServerEvent("Server:Email:Send", sender, recipient, subject, message)
```

**Mark as Read**
```lua
TriggerServerEvent("Server:Email:MarkRead", emailId)
```

**Logout**
```lua
TriggerServerEvent("Server:Email:Logout")
```

#### Client Events

**Registration Success**
```lua
RegisterNetEvent("Client:Email:RegisterSuccess", function(data)
    -- data.email, data.inbox, data.sent
end)
```

**Registration Error**
```lua
RegisterNetEvent("Client:Email:RegisterError", function(message)
    -- Error message
end)
```

**Login Success**
```lua
RegisterNetEvent("Client:Email:LoginSuccess", function(data)
    -- data.email, data.inbox, data.sent
end)
```

**Login Error**
```lua
RegisterNetEvent("Client:Email:LoginError", function(message)
    -- Error message
end)
```

**Inbox Updated**
```lua
RegisterNetEvent("Client:Email:InboxUpdated", function(inbox)
    -- Array of inbox emails
end)
```

**Sent Updated**
```lua
RegisterNetEvent("Client:Email:SentUpdated", function(sent)
    -- Array of sent emails
end)
```

### Security

#### Password Storage
- Passwords are hashed before storage (simple hash for game purposes)
- Not intended for production security - suitable for game environment only
- Each character can only register one email account

#### Validation
All inputs are validated on both client and server:
- Email format validation
- Password minimum length (4 characters)
- Message and subject length limits
- Recipient existence check before sending

#### Logging
All email operations are logged for audit purposes:
- Account creation
- Login attempts
- Email sends
- Access attempts

### File Locations

**Frontend**
- `nui/src/components/phone/apps/CalculatorApp.vue`
- `nui/src/components/phone/apps/EmailApp.vue`
- `nui/src/components/Phone.vue` (updated)

**Backend**
- `server/[SQL]/_phone_email.lua` - Database operations
- `server/[Events]/_phone_email.lua` - Event handlers
- `client/_phone.lua` - Client callbacks (updated)

**Database**
- `db.sql` - Schema definitions (updated)

**Configuration**
- `fxmanifest.lua` - Resource manifest (updated)

### Troubleshooting

**Email won't send**
- Verify recipient email exists in the system
- Check email format is valid
- Ensure you're logged into your account

**Can't register**
- Check email format meets validation rules
- Verify you don't already have an email account
- Password must be at least 4 characters

**Lost password**
- Password reset is not currently implemented
- Contact server administration for assistance

---

## Development Notes

### Adding New Phone Apps
To add additional phone apps:

1. Create Vue component in `nui/src/components/phone/apps/YourApp.vue`
2. Import in `nui/src/components/Phone.vue`
3. Add app icon to home screen in Phone.vue
4. Add conditional rendering for your app
5. (Optional) Add server-side event handlers
6. (Optional) Add database tables/functions
7. Build NUI: `cd nui && npm run build`

### Extending Email Features
To add reply/forward/chains features:

1. Update `EmailApp.vue` to enable buttons
2. Modify email data structure to support threads
3. Update database schema for thread relationships
4. Implement server-side thread logic
5. Update client callbacks

### Testing
- Test email registration with various invalid formats
- Test email sending between multiple accounts
- Test inbox/sent synchronization
- Test calculator with edge cases (division by zero, large numbers, decimals)
