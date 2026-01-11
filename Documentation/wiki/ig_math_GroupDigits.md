# ig.math.GroupDigits

## Description

Formats a number with thousands separators (commas). Converts numeric values into human-readable format by inserting commas every three digits.

## Signature

```lua
function ig.math.GroupDigits(val)
```

## Parameters

- **`val`**: any

## Example

```lua
-- Format numbers with commas
local formatted = ig.math.GroupDigits("1000000")
print(formatted)  -- Output: "1,000,000"

local price = ig.math.GroupDigits("99999")
print(price)  -- Output: "99,999"
```

## Source

Defined in: `shared/[Tools]/_math.lua`
