# Appearance Customization System

## Overview
The Appearance Customization System provides a comprehensive Vue 3 user interface for character appearance editing in GTA V/FiveM. It integrates with the backend Lua client/server implementation and Pinia store to deliver real-time character customization.

## Architecture

### Components Structure
```
nui/src/components/appearance/
├── AppearanceCustomization.vue    # Main container component
├── ModelSelector.vue              # Ped model selection
├── HeritageEditor.vue             # Parent blending (freemode only)
├── FaceFeaturesEditor.vue         # 20 facial feature sliders
├── HairEditor.vue                 # Hair styles, colors, and eye color
├── OverlayEditor.vue              # Overlays (makeup, facial hair, etig.)
├── ClothingEditor.vue             # Clothing components
├── AccessoriesEditor.vue          # Props/accessories
├── TattooEditor.vue               # Tattoo management
└── CameraControls.vue             # Camera view controls
```

### Store Integration
The system uses the Pinia store at `nui/src/stores/appearance.js` which provides:
- State management for current appearance data
- Actions for all appearance modifications
- Integration with Lua client callbacks
- Loading states and error handling

## Features

### 1. Model Selection
- **Grid Layout**: Visual grid of available ped models
- **Search & Filter**: Search by name, filter by gender or freemode
- **Freemode Highlighting**: Special visual indicator for freemode models
- **Dynamic Data**: Populated from `data/peds.json`

### 2. Heritage Editor (Freemode Only)
- **Parent Selection**: Choose mother/father faces and skin tones
- **Blend Sliders**: Mix ratios for face shape and skin tone
- **Real-time Preview**: Instant updates as sliders are adjusted
- **Conditional Display**: Only shown for freemode characters

### 3. Face Features
- **20 Sliders**: All facial features from GTA V's character creator
- **Debounced Updates**: 300ms debounce to prevent excessive API calls
- **Value Display**: Current value shown next to each slider
- **Scrollable List**: Organized vertical layout with custom scrollbar

### 4. Hair & Eyes
- **Hair Style Grid**: 73 available styles in grid layout
- **Color Pickers**: Primary and highlight color selection
- **Eye Color Grid**: Visual color picker with 32 eye colors
- **Active Indicators**: Clear visual feedback for selections

### 5. Overlays (Appearance)
- **13 Categories**: Blemishes, facial hair, eyebrows, aging, makeup, etig.
- **Style Selection**: Dropdown for available styles per overlay
- **Opacity Slider**: Fine-tune visibility of each overlay
- **Color Picker**: For overlays that support coloring
- **Compact Cards**: Each overlay in its own card with all controls

### 6. Clothing
- **12 Component Slots**: Face, mask, hair, torso, legs, bag, shoes, etig.
- **Drawable/Texture Controls**: +/- buttons and number inputs
- **Range Validation**: Prevents invalid values (0-255)
- **Organized Layout**: Each component in a dedicated section

### 7. Accessories
- **5 Prop Slots**: Hat, glasses, earrings, watch, bracelet
- **Remove Option**: -1 drawable value removes the prop
- **Texture Variants**: Full texture support for each prop
- **Help Text**: Hints for usage (e.g., "-1 to remove")

### 8. Tattoos
- **Zone-based Organization**: Torso, head, left arm, right arm, left leg, right leg
- **Zone Selector**: Quick switching between body zones
- **Applied Tattoos View**: Shows all currently applied tattoos with remove option
- **Apply/Remove**: Simple one-click application and removal
- **Clear All**: Bulk removal with confirmation
- **Gender-aware**: Uses correct hash for male/female models

### 9. Camera Controls
- **4 View Modes**: Face, Body, Legs, Full body
- **Rotation**: Left/right rotation buttons
- **Turn Around**: Automatic 360° rotation
- **Active Indicator**: Visual feedback for current view

## Configuration

The system supports dynamic configuration through the `config` object passed when opening:

```lua
-- Example Lua configuration
local config = {
    allowModelChange = true,      -- Show model selection tab
    allowHeritage = true,          -- Show heritage editor
    allowFaceFeatures = true,      -- Show face features
    allowHair = true,              -- Show hair & eyes
    allowOverlays = true,          -- Show appearance/overlays
    allowClothing = true,          -- Show clothing
    allowAccessories = true,       -- Show accessories
    allowTattoos = true,           -- Show tattoos
    isCharacterCreation = false    -- Special handling for new characters
}
```

## Usage

### Opening the Customization UI
From Lua client code:
```lua
-- Open appearance customization
exports['ingenium']:OpenAppearanceCustomization({
    appearance = currentAppearanceData,
    constants = appearanceConstants,
    peds = pedsData,
    tattoos = tattoosData,
    config = configOptions
})
```

### From NUI (Development/Testing)
```javascript
// Simulate opening from dev tools
window.postMessage({
    message: 'appearance:open',
    data: {
        appearance: { /* appearance data */ },
        constants: { /* constants data */ },
        peds: { /* peds data */ },
        tattoos: { /* tattoos data */ },
        config: { /* config options */ }
    }
})
```

## Performance Optimizations

1. **Debounced Sliders**: Face feature updates are debounced to 300ms
2. **Virtual Scrolling Ready**: Large lists (peds, tattoos) can be extended with virtual scrolling
3. **Lazy Store Loading**: Appearance store is lazy-loaded when first needed
4. **Conditional Rendering**: Tabs and features only render when active/available
5. **Optimized Filters**: Computed properties for efficient filtering and sorting

## Accessibility

- **Keyboard Navigation**: All controls are keyboard accessible
- **ARIA Labels**: Proper labels for screen readers
- **Color Contrast**: WCAG AA compliant contrast ratios
- **Focus States**: Clear visual indicators for keyboard focus
- **Tooltips**: Helpful tooltips on hover for controls

## Styling

The system uses:
- **Tailwind CSS**: For utility classes
- **Custom CSS**: Scoped component styles
- **CSS Variables**: From ingenium theme
- **Consistent Design**: Matches existing NUI components
- **Responsive Layout**: Adapts to different screen sizes

### Color Scheme
- Primary: `#4287f5` (Blue)
- Success: `#4caf50` (Green)
- Danger: `#dc3545` (Red)
- Background: `rgba(26, 26, 26, 0.98)` - `rgba(42, 42, 42, 0.98)`

## Data Files

### Required Data Files
1. **data/peds.json**: All ped models with metadata
2. **data/tattoos.json**: Tattoos organized by body zone
3. **data/appearance-constants.json**: Eye colors, face features, overlays, etig.

### Data Structure Examples

**Ped Entry:**
```json
{
  "hash": 1885233650,
  "name": "mp_m_freemode_01",
  "displayName": "Freemode Male",
  "gender": "male",
  "type": "freemode"
}
```

**Tattoo Entry:**
```json
{
  "name": "TAT_AR_000",
  "label": "Turbulence",
  "hashMale": "MP_Airraces_Tattoo_000_M",
  "hashFemale": "MP_Airraces_Tattoo_000_F",
  "zone": "ZONE_TORSO",
  "collection": "mpairraces_overlays"
}
```

## Testing

### Manual Testing Checklist
- [ ] Model selection works for all ped types
- [ ] Heritage editor appears only for freemode
- [ ] Face features update with proper debouncing
- [ ] Hair and eye color changes apply correctly
- [ ] Overlays render with proper gender filtering
- [ ] Clothing updates work for all component slots
- [ ] Accessories can be added and removed
- [ ] Tattoos can be applied, removed, and cleared
- [ ] Camera controls change views smoothly
- [ ] Save/Cancel buttons work correctly
- [ ] Tab navigation is smooth
- [ ] Loading states display properly
- [ ] Configuration options hide/show tabs correctly
- [ ] Keyboard navigation works throughout
- [ ] Responsive layout works on different screen sizes

### Browser Testing
Tested on:
- Chrome/Edge (Chromium-based)
- Firefox
- Safari (if applicable)

## Build

```bash
# Install dependencies
cd nui
npm install

# Development build with watch
npm run watch

# Production build
npm run build
```

## Troubleshooting

### Common Issues

**Issue**: Appearance not updating
- Check that Lua callbacks are properly registered
- Verify data is being sent from client
- Check browser console for errors

**Issue**: Tabs not showing
- Verify config allows the tab
- For heritage: check if model is freemode
- Check that data is properly loaded

**Issue**: Tattoos not applying
- Verify correct gender hash is being used
- Check that collection name is correct
- Ensure ped model supports tattoos

**Issue**: Build fails
- Clear node_modules and reinstall: `rm -rf node_modules && npm install`
- Check Node.js version (requires Node 16+)
- Verify all dependencies are installed

## Future Enhancements

Potential improvements:
- [ ] Virtual scrolling for large lists (1000+ items)
- [ ] Image previews for peds, hair styles, clothing
- [ ] Preset save/load system
- [ ] Randomize feature
- [ ] Copy appearance from another player
- [ ] Undo/redo functionality
- [ ] Advanced search with multiple filters
- [ ] Favorite peds/styles
- [ ] Recently used items

## Contributing

When contributing to the appearance system:
1. Follow existing component structure and naming
2. Maintain consistent styling with other components
3. Add proper TypeScript/JSDoc types if applicable
4. Test all appearance modifications
5. Ensure accessibility standards are met
6. Update this README if adding new features

## References

- Pinia Store: `nui/src/stores/appearance.js`
- NUI Utils: `nui/src/utils/nui.js`
- Lua Client: `client/_appearance.lua`
- Lua Callbacks: `client/[Callbacks]/_appearance.lua`
- Data Files: `data/peds.json`, `data/tattoos.json`, `data/appearance-constants.json`
