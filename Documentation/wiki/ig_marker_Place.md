# ig.marker.Place

## Description

Places a visual marker at specified coordinates. Markers are commonly used to indicate interaction points, spawn locations, or important areas in the game world.

## Signature

```lua
function ig.marker.Place(ords, v)
```

## Parameters

- **`v`**: number "A number to select corresponding local array value.
- **`ords`**: table "{x,y,z}

## Example

```lua
-- Example 1: Simple marker placement
local coords = vector3(100.0, 200.0, 30.0)
ig.marker.Place(coords, 1)  -- Type 1 = cylinder marker

-- Example 2: Colored marker with custom size
CreateThread(function()
    while true do
        Wait(0)
        local markerCoords = vector3(150.0, 250.0, 30.0)
        DrawMarker(
            1, -- Type
            markerCoords.x, markerCoords.y, markerCoords.z,
            0.0, 0.0, 0.0, -- Direction
            0.0, 0.0, 0.0, -- Rotation
            1.0, 1.0, 1.0, -- Scale
            255, 0, 0, 100, -- RGBA
            false, false, 2, false, nil, nil, false
        )
    end
end)

-- Example 3: Marker with interaction check
local shopCoords = vector3(25.0, -1347.0, 29.5)
CreateThread(function()
    while true do
        Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = #(playerCoords - shopCoords)
        
        if distance < 10.0 then
            ig.marker.Place(shopCoords, 2)  -- Show marker when near
            
            if distance < 1.5 then
                -- Show help text
                BeginTextCommandDisplayHelp("STRING")
                AddTextComponentSubstringPlayerName("Press ~INPUT_CONTEXT~ to interact")
                EndTextCommandDisplayHelp(0, false, true, -1)
            end
        end
    end
end)
```

## Source

Defined in: `client/_markers.lua`
