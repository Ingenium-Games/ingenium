# Internationalization (i18n) and Debugging Guide

## Table of Contents
- [Internationalization (i18n)](#internationalization-i18n)
- [Enhanced Debugging System](#enhanced-debugging-system)
- [Error Handling](#error-handling)
- [Server-Side Logging](#server-side-logging)

---

## Internationalization (i18n)

### Overview
Ingenium now supports multiple languages through a locale system. Users can change their preferred language by setting `conf.locale` in the configuration file.

### Supported Languages
- `en` - English (default)
- `fr` - French (Français)
- `es` - Spanish (Español)
- `de` - German (Deutsch)
- `pt` - Portuguese (Português)

### Configuration
Set the locale in `_config/config.lua`:
```lua
conf.locale = "en"  -- Change to "fr", "es", "de", or "pt"
```

### Using Translations in Code
Use the `_()` function to translate text:
```lua
local text = _("switch")  -- Returns translated text for current locale
```

Use the `_L()` function for uppercase first character:
```lua
local text = _L("switch")  -- Returns translated text with first character uppercase
```

### Fallback System
If a translation is missing:
1. The system will attempt to use the English translation
2. If no English translation exists, it will return the key itself

This ensures the system never shows error messages for missing translations.

### Adding New Locales
To add a new locale:

1. Create a new file in the `locale/` directory (e.g., `locale/it.lua` for Italian)
2. Follow this format:
```lua
Locales["it"] = {
    ["switch"] = "Usa per cambiare personaggio(i).",
    ["setjob"] = "Permesso(i) moderatore richiesto(i).",
    -- Add more translations...
}
```
3. The file will be automatically loaded by the manifest

### Adding New Translation Keys
To add new translation keys to all locales:

1. Add the key to `locale/en.lua` first (this is the fallback)
2. Add the same key to all other locale files with appropriate translations
3. Use the key in your code with `_("your_key")`


### Performance Considerations
- Debug messages are only processed if their level is enabled
- File logging is batched to minimize I/O overhead
- Use appropriate log levels to avoid console spam
- Disable DEBUG and TRACE levels in production

### Locale Best Practices
- Always provide English translations first (fallback)
- Keep translations concise
- Use placeholders for dynamic content: `_("message", playerName)`
- Test with multiple locales before release


## Troubleshooting

### Locale not working
1. Check that `conf.locale` is set correctly in `_config/config.lua`
2. Verify the locale file exists in `locale/` directory
3. Check console for any errors during resource start
4. Ensure the locale file has the correct format

### Debug messages not showing
1. Check debug flags in `_config/config.lua`
2. Verify the message level matches enabled flags
3. Ensure `shared/[Tools]/_debug.lua` is loaded (check manifest)

### Log files not created
1. Verify the resource has write permissions
2. Check that you're on the server side (client can't write files)
3. Look for error messages in console
4. Ensure `server/[Tools]/_logging.lua` is loaded

---

## Support

For issues, questions, or contributions related to i18n and debugging:
- Check the [main README](../README.md)
- Review [CONTRIBUTING.md](../CONTRIBUTING.md)
- Open an issue on GitHub

---

*Last updated: 2026-01-08*
