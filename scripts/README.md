# FiveM Resource Scripts

Utility scripts for managing the Ingenium FiveM resource.

## Scripts

### 1. `generate_fxmanifest.py`
Automatically generates an optimized, non-globbed `fxmanifest.lua` by scanning all Lua files and determining the correct load order.

**Usage:**
```bash
python generate_fxmanifest.py
```

**What it does:**
- Scans all Lua files in `shared/`, `client/`, and `server/` directories
- Extracts function definitions and dependencies
- Determines optimal load order based on dependencies
- Generates a clean `fxmanifest.lua` with explicit file listings
- Excludes: node_modules, .git, Documentation, [Example], [Stubs], logs

**Output:**
- Generates `../fxmanifest.lua` in the resource root

---

### 2. `deploy_resource.py`
Copies only the files listed in `fxmanifest.lua` to your Desktop in a folder named after the resource.

**Usage:**
```bash
# Copy with overwrite (default)
python deploy_resource.py

# Copy without overwriting existing files
python deploy_resource.py --no-overwrite

# Specify resource path explicitly
python deploy_resource.py /path/to/resource
```

**What it does:**
- Reads `fxmanifest.lua` from the resource root
- Parses all file references (handles both explicit files and glob patterns)
- Copies only those files to `Desktop/<resource_name>/`
- Expands glob patterns (`*`, `**`) to actual files
- Creates necessary directory structure
- Skips files that don't exist in source
- Optionally preserves existing files (no overwrite)

**Output:**
- Copies files to `~/Desktop/ingenium/` (or your resource name)
- Shows progress with ✓, ⚠, and ✗ indicators

**Example:**
```bash
python deploy_resource.py
# Output:
# 📦 FiveM Resource Deployment
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Resource: ingenium
# Source: /path/to/ingenium
# Destination: /home/user/Desktop/ingenium
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Mode: Overwrite existing files
#
# Parsing manifest...
# Found 156 files to copy
#
# Copying files...
#   ✓ COPY: shared/_ig.lua
#   ✓ COPY: shared/_log.lua
#   ✓ COPY: client/_var.lua
#   ... (continues)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# ✓ Deployment complete!
#   Files copied: 156
#   Location: /home/user/Desktop/ingenium
```

---

## Requirements

- Python 3.6+
- No external dependencies (uses only stdlib)

## Notes

- Both scripts work from the `scripts/` directory
- They automatically detect the resource root directory
- File paths in `fxmanifest.lua` must use forward slashes `/`
- Glob patterns are expanded based on actual files that exist

