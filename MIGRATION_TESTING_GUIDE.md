# Callback Migration Testing Guide

This document outlines the testing procedures for the security callback migration completed in this PR.

## Overview

All security-critical client-to-server events have been migrated from the traditional `RegisterNetEvent`/`TriggerServerEvent` pattern to the secure callback system (`RegisterServerCallback`/`TriggerServerCallback`).

## Security Benefits

The callback system provides:
- **Ticket-based validation** with 30-second expiration
- **Source validation** to prevent cross-client attacks
- **Rate limiting** (max 10 requests/second per player)
- **One-time use tickets** to prevent replay attacks
- **Automatic cleanup** of expired tickets and stale data

## Testing Checklist

### Character Management
- [ ] **Character Selection**
  - [ ] Connect to server
  - [ ] Character list loads correctly
  - [ ] Can select existing character
  - [ ] Character spawns at correct location
  
- [ ] **Character Creation**
  - [ ] Can open character creation UI
  - [ ] Can customize appearance
  - [ ] Can create new character with first/last name
  - [ ] Character spawns correctly after creation
  - [ ] Starting items (phone) are added
  
- [ ] **Character Deletion**
  - [ ] Can delete a character
  - [ ] Character is removed from list
  - [ ] Cannot delete character while playing
  
- [ ] **Appearance System**
  - [ ] Can open appearance customization
  - [ ] Can modify appearance features
  - [ ] Changes are saved correctly
  - [ ] Appearance loads correctly on respawn
  - [ ] Invalid appearance data is rejected
  
- [ ] **Death System**
  - [ ] Character death is reported correctly
  - [ ] Death state is saved to database
  - [ ] Death notifications appear

- [ ] **Job System**
  - [ ] Job can be assigned
  - [ ] Duty status can be toggled (if enabled)
  - [ ] ACL permissions are updated correctly

### Inventory & Items

- [ ] **Drop System**
  - [ ] Can drop items from inventory
  - [ ] Items appear on ground
  - [ ] Can access drops (open inventory)
  - [ ] Restricted drops deny unauthorized access
  - [ ] Empty drops are removed
  - [ ] Drop inventory updates correctly
  
- [ ] **Pickup System**
  - [ ] Can collect pickups
  - [ ] Items are added to inventory
  - [ ] Pickups are removed after collection

### World Interaction

- [ ] **Door System**
  - [ ] Can interact with doors
  - [ ] Door state syncs to all clients
  - [ ] Unauthorized access is prevented (if ACL enabled)
  
- [ ] **GSR System**
  - [ ] Firing weapon creates GSR
  - [ ] Police can test for GSR
  - [ ] GSR results are accurate
  - [ ] Non-police cannot test for GSR

- [ ] **Note System**
  - [ ] Can read notes
  - [ ] Read status is tracked correctly

### Other Systems

- [ ] **Feedback System**
  - [ ] Can submit feedback
  - [ ] Rate limiting prevents spam
  - [ ] Feedback is logged to Discord

- [ ] **Connection**
  - [ ] Player connection flow works
  - [ ] Character selection screen appears
  - [ ] Player data is initialized correctly

## Rate Limiting Tests

Test that rate limiting is working:

1. **Normal Usage** - Should work fine
   - Perform character actions at normal speed
   - All actions should succeed

2. **Rapid Requests** - Should be rate limited
   - Attempt to spam character actions rapidly (>10/second)
   - After 10 requests, further requests should fail with rate limit error
   - After 1 second window, requests should work again

3. **Multiple Players** - Should be independent
   - Rate limit for one player should not affect others
   - Each player gets their own 10 requests/second

## Security Tests

### Ticket Expiration
1. Intercept a callback request
2. Wait 30+ seconds
3. Try to replay the request
4. Should be rejected with "expired ticket" message

### Source Validation
1. Attempt to send a callback response with wrong source ID
2. Should be rejected with "source mismatch" message

### Replay Attack Prevention
1. Capture a valid callback request/response
2. Try to replay the same ticket
3. Should be rejected (tickets are one-time use)

## Error Handling Tests

Verify proper error handling:

- [ ] Player not found errors return appropriate message
- [ ] Invalid item errors are caught
- [ ] Database errors don't crash server
- [ ] Client receives error messages when operations fail

## Backwards Compatibility

Test that server-side code still works:

- [ ] Commands that trigger character events still work
- [ ] Server-side character operations function correctly
- [ ] Legacy `TriggerEvent("Server:Character:List", src, Primary_ID)` still works

## Performance Tests

- [ ] Normal gameplay performance is not degraded
- [ ] Server tick time remains acceptable
- [ ] No memory leaks from ticket cleanup
- [ ] Cleanup thread runs every 60 seconds without issues

## Known Limitations

- CodeQL security scanner does not support Lua files
- Manual security review required for Lua-specific vulnerabilities
- NUI callbacks between JS/HTML and Lua are not migrated (as noted in issue)

## Rollback Plan

If critical issues are found:

1. Revert PR commits
2. Previous event-based system will be restored
3. All functionality should work as before

## Success Criteria

Migration is successful if:

1. ✅ All character management flows work correctly
2. ✅ All inventory operations function properly
3. ✅ No critical security vulnerabilities introduced
4. ✅ Rate limiting works as expected
5. ✅ Server performance is not degraded
6. ✅ Error handling is robust
7. ✅ Backwards compatibility maintained

## Notes

- All server-to-client notifications remain as events (correct pattern)
- Native FiveM events remain unchanged
- Internal client events remain unchanged
- Vehicle enter/exit events remain as events (state notifications, not security-critical)
