# ingenium Data Directory

This directory contains game data loaded at resource startup.

## Files Required

- `tattoos.json` - Tattoo shop data (collections, zones, hashes)
- `weapons.json` - Weapon stats, components, compatibility
- `vehicles.json` - Vehicle metadata, classes, manufacturers
- `modkits.json` - Vehicle modification options per model
- `items.json` - Inventory item definitions

## File Sources

Copy these files from `ig.dump/data/` directory.

## Data Structure Examples

### tattoos.json
```json
{
  "12345": {
    "hash": 12345,
    "collection": "mpbeach_overlays",
    "localizedName": "Tribal Sun",
    "zone": "ZONE_HEAD",
    "gender": "male"
  }
}
```

### weapons.json
```json
{
  "453432689": {
    "hash": 453432689,
    "displayName": "Pistol",
    "weaponType": "Pistol",
    "damage": 26,
    "ammoType": "AMMO_PISTOL",
    "components": [],
    "tintCount": 7
  }
}
```

### vehicles.json
```json
{
  "3078201489": {
    "hash": 3078201489,
    "displayName": "Adder",
    "manufacturer": "Truffade",
    "class": "Super",
    "seats": 2,
    "type": "automobile"
  }
}
```

### modkits.json
```json
{
  "3078201489": {
    "0": {
      "name": "Spoilers",
      "items": {
        "0": "Stock",
        "1": "Carbon Spoiler"
      }
    }
  }
}
```

### items.json
```json
{
  "bread": {
    "name": "bread",
    "displayName": "Bread",
    "description": "A loaf of bread",
    "weight": 0.5,
    "type": "food",
    "stackable": true,
    "maxStack": 10,
    "icon": "bread.png",
    "usable": true,
    "sellPrice": 5,
    "buyPrice": 10
  }
}
```

## Updating Data

To update data after making changes to JSON files:

```
restart ingenium
```

The loader will automatically reload all data files.
