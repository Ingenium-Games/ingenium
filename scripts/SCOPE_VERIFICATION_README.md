# Scope Verification System Documentation

## Overview

The scope verification system ensures that function scope markers ([S], [C], [S C]) in the Documentation/wiki/README.md accurately reflect the actual implementation locations in the codebase.

## Key Features

### 1. Precise Scope Detection

The system uses a precise method to determine function scopes:

- **[C]** (Client-only): Functions defined only in `client/` directory
- **[S]** (Server-only): Functions defined only in `server/` directory
- **[S C]** (Dual-scope): Functions in either:
  - Both `client/` and `server/` directories
  - The `shared/` directory
  - Functions with `IsDuplicityVersion()` check (even if only in one directory)

### 2. IsDuplicityVersion() Detection

The script analyzes function bodies to detect `IsDuplicityVersion()` checks. Functions with this check are marked as dual-scope ([S C]) because they're designed to run on both client and server, even though they may only be defined in one location.

**Example:**
```lua
function ig.callback.RegisterServer(eventName, handler)
    if not IsDuplicityVersion() then
        error('ig.callback.RegisterServer can only be used on the server side')
        return nil
    end
    return RegisterServerCallback({...})
end
```

This function is in `client/_callback.lua` but has an `IsDuplicityVersion()` check, so it's correctly marked as [S C].

### 3. Auto-Fix Capability

The script can automatically fix mismatches in the README:

```bash
# Verify only (fails on mismatch)
python3 scripts/verify_function_scopes.py

# Auto-fix README scope markers  
python3 scripts/verify_function_scopes.py --fix

# Show detailed logging
python3 scripts/verify_function_scopes.py --verbose

# Fix with detailed logging
python3 scripts/verify_function_scopes.py --fix --verbose
```

## CI Integration

### Workflow: wiki-sync.yml

#### 1. verify-function-scopes (Always runs)
- Runs on every push and pull request
- Verifies all scope markers match actual code
- Uses `--verbose` flag for detailed output
- Fails if mismatches are found

#### 2. auto-fix-scopes (Runs on main branch failures)
- Triggered when verification fails on `main` branch
- Automatically fixes scope markers
- Creates a PR with the fixes
- Includes detailed explanation of changes

#### 3. comment-pr (Runs on pull requests)
- Posts verification results as a PR comment
- Includes fix instructions if mismatches found
- Uses collapsible details for full report

## Script Files

### verify_function_scopes.py

Main verification script with the following capabilities:

- **Scan codebase**: Analyzes all `.lua` files in `client/`, `server/`, and `shared/`
- **Detect IsDuplicityVersion**: Parses function bodies to find duplicity checks
- **Verify README**: Compares README markers with actual implementation
- **Fix mismatches**: Updates README with correct scope markers
- **Detailed logging**: Provides comprehensive debugging information

**Exit codes:**
- `0`: Success (all markers correct)
- `1`: Failure (mismatches found)

### update_readme_exports.py

Companion script that:

- Detects new function documentation files
- Adds them to README with correct scope markers
- Uses the same IsDuplicityVersion detection logic
- Maintains consistency with verification script

## Examples

### Example 1: Client-Only Function

```lua
// In client/_callback.lua
function ig.callback.UnregisterClient(eventData)
    if eventData then
        UnregisterClientCallback(eventData)
    end
end
```

**Scope**: [C] - Only in client/, no IsDuplicityVersion check

### Example 2: Dual-Scope Function with IsDuplicityVersion

```lua
// In client/_callback.lua
function ig.callback.RegisterServer(eventName, handler)
    if not IsDuplicityVersion() then
        error('Can only be used on server side')
        return nil
    end
    return RegisterServerCallback({...})
end
```

**Scope**: [S C] - Has IsDuplicityVersion check, can run on both sides

### Example 3: Server-Only Function

```lua
// In server/_player.lua
function ig.player.AddPlayer(source, data)
    players[source] = data
end
```

**Scope**: [S] - Only in server/ directory

### Example 4: Shared Function

```lua
// In shared/_utils.lua
function ig.utils.FormatNumber(num)
    return tostring(num)
end
```

**Scope**: [S C] - In shared/ directory, available on both sides

## Troubleshooting

### Mismatch After Code Change

If you add/modify a function and get a scope mismatch:

1. Run the verification script locally:
   ```bash
   python3 scripts/verify_function_scopes.py --verbose
   ```

2. Review the mismatch details:
   - Check the file location
   - Check if IsDuplicityVersion is detected correctly
   - Verify the expected scope

3. Fix automatically:
   ```bash
   python3 scripts/verify_function_scopes.py --fix
   ```

4. Commit the fixed README

### False Positive Detection

If the script incorrectly detects IsDuplicityVersion:

- Check the function body for the exact string `IsDuplicityVersion()`
- Ensure it's within the function body (not in comments)
- Review the regex pattern in `check_function_has_duplicity()`

### README Not Updating

If `--fix` doesn't update the README:

1. Check the pattern in the README matches:
   ```
   - [ig.namespace.Function](file.md) [SCOPE]
   ```

2. Verify the function exists in the codebase

3. Run with `--verbose` to see detailed processing

## Best Practices

1. **Run locally before committing**: Always verify scope markers before pushing
2. **Use --verbose for debugging**: Helps understand why a particular scope was assigned
3. **Review auto-fix changes**: Always review what `--fix` changed before committing
4. **Keep IsDuplicityVersion consistent**: Use this pattern consistently for dual-scope functions
5. **Update tests**: If you modify scope detection logic, verify with existing functions

## Maintenance

### Adding New Namespaces

No special configuration needed. The script automatically:
- Detects functions in any namespace
- Applies the same scope detection rules
- No hardcoded namespace lists (removed the old `duplicity_namespaces` set)

### Modifying Detection Logic

If you need to modify how scopes are determined:

1. Update `determine_scope()` in `verify_function_scopes.py`
2. Update `determine_scope_marker()` in `update_readme_exports.py`
3. Test with `--verbose` on existing functions
4. Verify CI passes

### Performance Considerations

The script is optimized for:
- Fast file scanning with pathlib
- Efficient regex matching
- Minimal file reads (caches function info)
- Typical runtime: 2-5 seconds for ~700 functions

## Version History

### v2.0 (Current)
- ✅ Per-function IsDuplicityVersion detection
- ✅ Removed hardcoded namespace lists
- ✅ Added --fix flag for auto-correction
- ✅ Added --verbose flag for debugging
- ✅ Improved CI integration with auto-fix job
- ✅ Enhanced PR comments with fix instructions

### v1.0 (Previous)
- ❌ Used namespace-wide duplicity rules
- ❌ No auto-fix capability
- ❌ Limited debugging information
- ❌ False positives for callback functions
