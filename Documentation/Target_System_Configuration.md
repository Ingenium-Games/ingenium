# Target System Configuration

## Overview

The Ingenium targeting system now supports customizable target icons, allowing you to configure the appearance and size of the targeting reticle. This guide covers the configuration options available for the target system.

## Configuration Options

All target system configuration is located in `_config/config.lua` under the `conf.target` table:

```lua
conf.target = {}
conf.target.iconType = "svg"      -- "svg", "emoji", "png", or "gif"
conf.target.iconValue = ""        -- emoji character or URL to image file
conf.target.iconSize = 18         -- icon size in pixels (18 = half of original 36px)
```

### Icon Types

#### 1. SVG (Default)

The default eye icon using scalable vector graphics:

```lua
conf.target.iconType = "svg"
conf.target.iconValue = ""        -- Leave empty for default
conf.target.iconSize = 18         -- Size in pixels
```

**Advantages:**
- Scalable without quality loss
- Supports color changes (inactive vs active)
- Small file size
- Built-in default

#### 2. Emoji

Use any Unicode emoji as your targeting icon:

```lua
conf.target.iconType = "emoji"
conf.target.iconValue = "👁️"      -- Any emoji character
conf.target.iconSize = 18         -- Size in pixels
```

**Examples:**
- `"👁️"` - Eye emoji (default if left empty)
- `"🎯"` - Target/bullseye
- `"🔍"` - Magnifying glass
- `"⊕"` - Crosshair
- `"•"` - Dot

**Advantages:**
- Easy to configure
- Wide variety of options
- No external files needed

#### 3. PNG

Use a transparent PNG image:

```lua
conf.target.iconType = "png"
conf.target.iconValue = "https://example.com/target-icon.png"
conf.target.iconSize = 18
```

**Requirements:**
- Must be a valid URL or local file path
- Transparent background recommended
- Square aspect ratio works best

**Advantages:**
- Full control over design
- Can use custom artwork
- Professional appearance

#### 4. GIF

Use an animated GIF for dynamic targeting icons:

```lua
conf.target.iconType = "gif"
conf.target.iconValue = "https://example.com/blinking-eye.gif"
conf.target.iconSize = 18
```

**Examples:**
- Blinking eye animation
- Rotating crosshair
- Pulsing dot
- Looking around eye

**Requirements:**
- Must be a valid URL or local file path
- Keep file size small for performance
- Square aspect ratio recommended
- Transparent background recommended

**Advantages:**
- Eye-catching and dynamic
- Can indicate different states through animation
- Adds visual interest

## Icon Size Recommendations

The default icon size has been reduced to **18 pixels** (half of the original 36px size) for less screen clutter:

- **16-20px**: Recommended for most use cases (subtle presence)
- **24-32px**: Larger, more visible
- **12-16px**: Minimal, unobtrusive
- **36px+**: Not recommended (blocks view)

## Visual Feedback

The icon provides visual feedback:
- **Black/Dimmed**: No valid target
- **Light Grey/Bright**: Valid target detected

For PNG/GIF icons:
- **50% opacity**: No valid target
- **100% opacity**: Valid target detected
- **Brightness filter**: Applied to PNG/GIF when inactive

## Examples

### Example 1: Emoji Crosshair (Small)

```lua
conf.target.iconType = "emoji"
conf.target.iconValue = "⊕"
conf.target.iconSize = 16
```

### Example 2: Blinking Eye GIF

```lua
conf.target.iconType = "gif"
conf.target.iconValue = "https://your-cdn.com/assets/blinking-eye.gif"
conf.target.iconSize = 18
```

### Example 3: Custom PNG Icon

```lua
conf.target.iconType = "png"
conf.target.iconValue = "https://your-cdn.com/assets/target-reticle.png"
conf.target.iconSize = 20
```

### Example 4: Default SVG (Smaller)

```lua
conf.target.iconType = "svg"
conf.target.iconValue = ""
conf.target.iconSize = 14  -- Very subtle
```

## Best Practices

1. **Test Visibility**: Ensure your icon is visible in various lighting conditions
2. **Keep It Small**: Icons larger than 24px can obstruct the view
3. **Optimize GIFs**: Keep file size under 100KB for best performance
4. **Use Transparency**: Transparent backgrounds work best for all icon types
5. **Center Alignment**: Square icons (1:1 aspect ratio) center properly
6. **Consider Color**: Icons should contrast with both light and dark environments

## Target Menu Behavior

When a valid target is detected:
1. Icon changes from dimmed to bright/colored
2. Options list appears to the right of the icon
3. Users can left-click options to interact
4. Right-click or ESC to dismiss the target menu

## Vehicle Bone Targets

The default configuration includes vehicle bone targets for:
- **Front Driver Door**: Toggle open/close
- **Front Passenger Door**: Toggle open/close
- **Rear Driver Door**: Toggle open/close
- **Rear Passenger Door**: Toggle open/close
- **Hood/Bonnet**: Toggle open/close
- **Trunk/Boot**: Toggle open/close

These targets only appear when:
- Vehicle is unlocked
- Player is within bone detection threshold
- Player is looking at the specific bone/component

## Technical Details

### Implementation

The target icon configuration is:
1. Defined in `_config/config.lua`
2. Sent to NUI on resource start via `client/[Target]/_main.lua`
3. Rendered by `nui/src/components/target/TargetMenu.vue`
4. Dynamically switches between SVG, emoji, PNG, and GIF

### Performance

- SVG: No performance impact (rendered directly)
- Emoji: Minimal performance impact (native Unicode rendering)
- PNG: Small impact (single image load)
- GIF: Moderate impact (animated frames, keep file size small)

## Troubleshooting

### Icon Not Displaying

1. Check browser console for errors (F12)
2. Verify URL is accessible (for PNG/GIF)
3. Ensure NUI was rebuilt (`npm run build`)
4. Restart resource to reload config

### Icon Too Large/Small

Adjust `conf.target.iconSize` value in `_config/config.lua` and restart resource.

### GIF Not Animating

1. Verify GIF is properly formatted
2. Check file size (large GIFs may lag)
3. Ensure URL is valid and accessible

### Icon Position Wrong

The icon is centered at screen center (50%, 50%). This is hardcoded and should not be changed as it aligns with the raycast origin.

## Related Files

- `_config/config.lua` - Configuration
- `client/[Target]/_main.lua` - Client-side targeting logic
- `client/[Target]/_defaults.lua` - Default vehicle bone targets
- `nui/src/components/target/TargetMenu.vue` - Target UI component
