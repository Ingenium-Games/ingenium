# ig.screenshot.Take

## Description

Takes a screenshot of the player's current view and sends it to the server for processing. Screenshots are uploaded using the screenshot-basic resource and can be sent to Discord, image hosts, or Discourse based on configuration.

## Signature

```lua
function ig.screenshot.Take(reason, additionalData, callback)
```

## Parameters

- **`reason`**: string (optional) - The reason for taking the screenshot (e.g., "player_report", "manual_command")
- **`additionalData`**: table (optional) - Additional metadata to include with the screenshot
- **`callback`**: function (optional) - Callback function to execute after screenshot is taken. Receives (success, imageUrl) as parameters

## Returns

- **boolean** - True if screenshot was initiated successfully, false otherwise

## Example

```lua
-- Take a screenshot manually
ig.screenshot.Take('manual_command', nil, function(success, imageUrl)
    if success then
        print('Screenshot captured: ' .. imageUrl)
    else
        print('Failed to capture screenshot')
    end
end)

-- Take screenshot on player report
ig.screenshot.Take('player_report', {
    reportedPlayer = 'PlayerName',
    reportReason = 'Exploiting'
})

-- Using the export
exports['ingenium']:TakeScreenshot('admin_request', {}, function(success, data)
    print('Screenshot result:', success)
end)
```

## Important Notes

> ⚠️ **Dependency**: Requires the `screenshot-basic` resource to be started.

> ℹ️ **Configuration**: Screenshots must be enabled via `conf.screenshot.enabled`.

> 📝 **Metadata**: Automatically collects metadata based on `conf.screenshot.includeMetadata` settings.

> ⏳ **Throttling**: Only one screenshot can be taken at a time. Subsequent calls while a screenshot is in progress will return false.

## Related Functions

- [ig.screenshot.ValidateWebhook](ig_screenshot_ValidateWebhook.md)
- [ig.screenshot.SendToDiscord](ig_screenshot_SendToDiscord.md)
- [ig.screenshot.SendToImageHost](ig_screenshot_SendToImageHost.md)
- [ig.screenshot.SendToDiscourse](ig_screenshot_SendToDiscourse.md)

## Source

Defined in: `client/_screenshot.lua`
