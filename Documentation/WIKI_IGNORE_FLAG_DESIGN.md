# Wiki Ignore Flag System - Design Document

## Proposed Flag Format

### Option 1: `@wiki:ignore` (Recommended)
```lua
---@wiki:ignore
function ig.namespace.InternalFunction(param)
  -- Implementation
end
```
**Pros:** Follows standard Lua documentation format, IDE-friendly, clear namespace  
**Cons:** Longer syntax  

### Option 2: `--WIKI-IGNORE` (User Suggested)
```lua
--WIKI-IGNORE
function ig.namespace.InternalFunction(param)
  -- Implementation
end
```
**Pros:** Concise, plain comment, easy to search  
**Cons:** Could be confused with regular comments  

### Option 3: `--[[ @private ]]` (Standard Convention)
```lua
--[[ @private
  This function is internal only
]]
function ig.namespace.InternalFunction(param)
  -- Implementation
end
```
**Pros:** Standard Lua convention, includes optional description  
**Cons:** More verbose  

### Option 4: `@internal` (Minimalist)
```lua
---@internal
function ig.namespace.InternalFunction(param)
  -- Implementation
end
```
**Pros:** Clean, concise, IDE-friendly  
**Cons:** Less explicit about wiki vs other internal uses  

---

## Recommendation: `@wiki:ignore` or `--WIKI-IGNORE`

### Chosen: `@wiki:ignore` (with fallback to `--WIKI-IGNORE`)
- **Placement:** Immediately before or after `function` keyword
- **Format:** Single line comment (Lua doc style)
- **Detection:** Look within 3 lines before/after function definition
- **Syntax Examples:**
  ```lua
  ---@wiki:ignore
  function ig.namespace.InternalFunction(param)
  ```
  
  or
  
  ```lua
  function ig.namespace.InternalFunction(param)
    ---@wiki:ignore
  end
  ```

### Alternative: `--WIKI-IGNORE` (if preferred)
- **Placement:** Same flexible placement
- **Format:** Plain comment, all caps for visibility
- **Detection:** Simple string search in context

---

## Detection Algorithm

1. When scanning function definition: `function ig.namespace.FunctionName(...)`
2. Look in 5-line context (2 lines before, function line, 2 lines after)
3. Check for `@wiki:ignore` or `--WIKI-IGNORE` (case-insensitive)
4. If found: Mark as "ignored" and skip from README
5. If not found: Include in README

---

## Implementation Benefits

1. **Non-Intrusive:** Flag is optional comment, doesn't affect functionality
2. **IDE-Friendly:** Works with standard Lua doc tools
3. **Flexible:** Can be placed before or after function
4. **Searchable:** Easy to grep/search across codebase
5. **Versioning:** Easy to track which functions are hidden
6. **Team Communication:** Clear intent in code

---

## Special Cases

### Functions in Shared Files
- If function has `@wiki:ignore`: Skip from README regardless
- If in shared/ with `IsDuplicityVersion`: Include as [S C]

### Classes/Objects
- Can apply flag to class definition
- All methods of flagged class get same treatment

### Exports
- Exported functions should NOT have `@wiki:ignore`
- If they do, note as warning in report

---

## Missing Documentation Report

At completion, generate:
```
📋 MISSING DOCUMENTATION REPORT
===============================

Functions Without Wiki Files:
  - ig.namespace.Function1
  - ig.namespace.Function2
  ...

Total: XX functions missing .md files

ACTIONS TAKEN:
✅ Added to README (placeholder)
⚠️  Flag as "Documentation Pending"
📋 Create GitHub issues (optional)
```

---

## Configuration

Optional config section in script:
```python
WIKI_IGNORE_FLAGS = [
    '@wiki:ignore',      # Primary
    '--WIKI-IGNORE',     # Alternative
    '--NO-WIKI',         # Alternative
]

# Reporting
CREATE_ISSUES = False    # Auto-create GitHub issues
ISSUE_LABEL = 'documentation'
ISSUE_MILESTONE = 'v1.0'

# Namespace organization in README
NAMESPACE_ORDER = [
    'callback',
    'affiliation',
    'ammo',
    # ... etc
]
```

---

**Next Step:** Implement script with chosen flag system
