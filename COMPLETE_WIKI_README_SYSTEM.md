# Complete Wiki README Generation System

## Overview

The Ingenium Framework now has a **complete system for automatically generating a comprehensive README.md** with ALL functions discovered in the codebase, with intelligent support for:

- ✅ **Complete Function Discovery** - Scans all 741 functions across 62 namespaces
- ✅ **Wiki Ignore Flags** - Mark internal functions to exclude from public API
- ✅ **Missing Documentation Tracking** - Identifies and reports 62 functions without wiki files
- ✅ **Automatic Scope Detection** - Correctly identifies [C], [S], [S C] scopes
- ✅ **Documentation Status** - Shows which functions have wiki documentation

---

## Components

### 1. generate_readme_complete.py
**Purpose:** Generate complete README.md with all discovered functions

**Features:**
- Scans client/, server/, shared/ directories
- Discovers 741 functions across 62 namespaces
- Detects and respects @wiki:ignore flags
- Marks functions with missing documentation
- Reports statistics and missing docs

**Usage:**
```bash
python3 scripts/generate_readme_complete.py
```

**Output:**
```
🔍 Scanning codebase for all functions...
✅ Found 741 functions across 62 namespaces
⏭️  Ignoring 0 functions marked with @wiki:ignore

📝 Generating README.md...
✅ README.md generated (45881 bytes)

📊 GENERATION SUMMARY
============================================================
Total Functions Found:        741
Functions Documented:         679
Functions Missing Docs:       62 ⚠️
Functions Ignored (Internal): 0
Namespaces:                   62
============================================================
```

### 2. create_missing_docs_issues.py
**Purpose:** Analyze missing documentation and prepare GitHub issues

**Features:**
- Parses missing documentation report
- Shows which functions need documentation
- Generates GitHub issue templates
- Prepares auto-creation (with --auto-create flag)

**Usage:**
```bash
python3 scripts/create_missing_docs_issues.py              # Show templates
python3 scripts/create_missing_docs_issues.py --auto-create # Create issues
```

### 3. wiki_ignore_helper.py
**Purpose:** Manage @wiki:ignore flags on internal functions

**Features:**
- Find and list internal functions
- Add @wiki:ignore flag to functions
- Search for functions by pattern
- List candidates for ignore flag

**Usage:**
```bash
python3 scripts/wiki_ignore_helper.py --candidates          # List internal candidates
python3 scripts/wiki_ignore_helper.py --add "ig.ns.Func"   # Add flag
python3 scripts/wiki_ignore_helper.py --search "debug"      # Search
```

---

## Wiki Ignore Flag System

### What is @wiki:ignore?

A special flag that marks a function as internal-only, excluding it from public API documentation.

### Supported Formats

The system recognizes multiple flag formats:

```lua
---@wiki:ignore
function ig.namespace.InternalFunction()
end
```

or

```lua
--WIKI-IGNORE
function ig.namespace.InternalFunction()
end
```

or

```lua
--NO-WIKI
function ig.namespace.InternalFunction()
end
```

### Placement

Flags can be placed:
- **Before function:** In comment line(s) before definition
- **Inside function:** In first few lines after function declaration
- **Flexible:** Detection looks within 5 lines of definition

### Why Use It?

1. **API Clarity** - Separates public functions from internal helpers
2. **Documentation** - Prevents internal functions from appearing in README
3. **Maintenance** - Clear intent about which functions are public
4. **Scalability** - Grows with codebase without manual maintenance

---

## Complete Workflow

### For All Functions

```
1. Run discovery script
   └─ Scans entire codebase
   └─ Finds 741 functions
   └─ Checks for @wiki:ignore flags

2. Generate README.md
   └─ Creates comprehensive function listing
   └─ Groups by namespace (62 total)
   └─ Shows documentation status
   └─ Marks missing docs

3. Report missing documentation
   └─ Identifies 62 functions without .md files
   └─ Groups by namespace
   └─ Prioritizes by need
```

### For Internal Functions

```
1. Identify internal function
   └─ Review code and purpose
   └─ Determine if should be public

2. Add @wiki:ignore flag
   └─ Use helper script: wiki_ignore_helper.py
   └─ Adds flag near function definition
   
3. Regenerate README
   └─ Run generate_readme_complete.py
   └─ Function excluded from README
   └─ Added to "ignored" section
```

### For New Functions

```
1. Create function code
   └─ File: client/, server/, or shared/
   
2. Create wiki documentation (optional)
   └─ File: Documentation/wiki/ig_namespace_FunctionName.md
   
3. Run discovery & generation
   └─ Function automatically discovered
   └─ Added to README (with/without doc status)
   └─ Links to .md file if it exists

4. Status checking
   └─ Not documented? Marked with ⚠️
   └─ Missing report shows it
   └─ GitHub issue can be created
```

---

## Results Summary

### Current State (After Full Scan)

```
📊 COMPLETE FUNCTION INVENTORY
═══════════════════════════════

Total Functions:       741
Documented (with .md): 679 (91.6%)
Missing Docs:          62 (8.4%)
Ignored (Internal):    0 (0%)

Namespaces:            62
- Smallest:            1 function
- Largest:             50+ functions

Scope Distribution:
├─ [C] only:           ~300 functions
├─ [S] only:           ~200 functions
└─ [S C]:              ~240 functions
```

### Missing Documentation (62 Functions)

By Namespace:
```
debug          - 11 functions (logging & debugging)
ui             - 11 functions (UI components)
queue          - 7 functions (player queue)
object         - 7 functions (object management)
weapon         - 6 functions (weapon system)
discord        - 5 functions (Discord integration)
vehicle        - 4 functions (vehicle operations)
data           - 4 functions (player data)
util           - 3 functions (utilities)
player         - 2 functions (player info)
payroll        - 1 function (payroll)
death          - 1 function (death events)
```

---

## Usage Examples

### Example 1: Generate Full README

```bash
$ python3 scripts/generate_readme_complete.py

🔍 Scanning codebase for all functions...
✅ Found 741 functions across 62 namespaces

📝 Generating README.md...
✅ README.md generated

📊 GENERATION SUMMARY
Total Functions Found: 741
Functions Documented: 679
Functions Missing Docs: 62 ⚠️
Namespaces: 62
```

### Example 2: Find Internal Function Candidates

```bash
$ python3 scripts/wiki_ignore_helper.py --candidates

🔍 Internal function candidates (for @wiki:ignore):
  - ig.debug.Debug
  - ig.debug.ErrorHandler
  - ig.debug.FormatMessage
  ... (showing matches for "internal", "private", "debug" keywords)

Total: 15 candidates
```

### Example 3: Add Ignore Flag to Function

```bash
$ python3 scripts/wiki_ignore_helper.py --add "ig.debug.ErrorHandler"

✅ Added @wiki:ignore to ig.debug.ErrorHandler in /workspaces/ingenium/server/_debug.lua
```

### Example 4: Check Missing Documentation

```bash
$ cat MISSING_DOCUMENTATION_REPORT.txt

📋 MISSING DOCUMENTATION REPORT
Functions Without Wiki Files: 62

debug:
  - ig.debug.Debug [S C]
  - ig.debug.Error [S C]
  ... (11 total in debug namespace)

ui:
  - ig.ui.HideContext [C]
  - ig.ui.HideHUD [C]
  ... (11 total in ui namespace)
```

---

## Flag Format Recommendations

### Recommended: @wiki:ignore
```lua
---@wiki:ignore
function ig.namespace.InternalFunction()
end
```

**Why:**
- Follows standard Lua doc convention
- IDE-friendly (auto-completion aware)
- Clear namespace (@wiki)
- Professional appearance

### Alternative: --WIKI-IGNORE
```lua
--WIKI-IGNORE
function ig.namespace.InternalFunction()
end
```

**Why:**
- Simple, plain comment
- Easy to search (all caps)
- Clear intent
- Minimal syntax

### Not Recommended
- `@private` - Could conflict with other uses
- `--NO-WIKI` - Less explicit
- `--HIDE` - Ambiguous purpose

---

## Configuration Options

In `generate_readme_complete.py`:

```python
# Recognized ignore flags
WIKI_IGNORE_FLAGS = [
    '@wiki:ignore',    # Primary
    '--WIKI-IGNORE',   # Alternative
    '--NO-WIKI',       # Alternative
]

# Search context (lines before/after function)
IGNORE_DETECTION_CONTEXT = 5

# Wiki directory
WIKI_DIR = '/workspaces/ingenium/Documentation/wiki'

# Code directories
CODE_DIRS = {
    'client': '/workspaces/ingenium/client',
    'server': '/workspaces/ingenium/server',
    'shared': '/workspaces/ingenium/shared',
}
```

---

## Integration with GitHub Actions

Add to your GitHub Actions workflow:

```yaml
- name: Generate complete README
  run: python3 scripts/generate_readme_complete.py

- name: Check for missing documentation
  run: |
    python3 scripts/create_missing_docs_issues.py
    if [ -s MISSING_DOCUMENTATION_REPORT.txt ]; then
      echo "⚠️ Found missing documentation"
      head -20 MISSING_DOCUMENTATION_REPORT.txt
    fi
```

---

## Maintenance & Best Practices

### When Adding New Functions

1. ✅ Define function in code
2. ✅ Create wiki .md file (if public)
3. ✅ OR add @wiki:ignore flag (if internal)
4. ✅ Run generate script to verify

### When Marking Function as Internal

1. ✅ Use `wiki_ignore_helper.py --add`
2. ✅ Or manually add @wiki:ignore flag
3. ✅ Run generate script to verify removal from README

### Regular Maintenance

```bash
# Weekly/after changes:
python3 scripts/generate_readme_complete.py

# Monitor missing documentation:
tail -20 MISSING_DOCUMENTATION_REPORT.txt

# Find unmarked internal functions:
python3 scripts/wiki_ignore_helper.py --candidates
```

---

## Troubleshooting

### Function not discovered
- Check function syntax: `function ig.namespace.FunctionName()`
- Verify file location (client/, server/, or shared/)
- Check for typos in full name

### Ignore flag not working
- Check syntax: `@wiki:ignore`, `--WIKI-IGNORE`, or `--NO-WIKI`
- Ensure flag is within 5 lines of function
- Re-run generation script

### Wrong scope detected
- Check if function exists in multiple locations
- Verify IsDuplicityVersion handling
- Run verify script to validate

### Missing .md files
- Check Documentation/wiki/ directory
- Verify filename format: `ig_namespace_FunctionName.md`
- Regenerate README after creating .md files

---

## Summary

This complete system provides:

✅ **Automatic Discovery** - Find all 741 functions automatically  
✅ **Flexible Configuration** - @wiki:ignore for internal functions  
✅ **Complete Documentation** - Track what needs wiki files  
✅ **Easy Maintenance** - Run one script to update README  
✅ **Scalable** - Grows with your codebase  

**Status: PRODUCTION READY**
