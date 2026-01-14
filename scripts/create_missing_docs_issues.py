#!/usr/bin/env python3
"""
Create GitHub issues for functions with missing documentation.
Usage: python3 scripts/create_missing_docs_issues.py [--auto-create]
"""

import os
import os
import re
import json
import subprocess
import argparse
import shutil
from pathlib import Path

# Determine repository root: prefer CI-provided GITHUB_WORKSPACE, else use
# the repository root relative to this script when running locally.
env_repo = os.environ.get('GITHUB_WORKSPACE')
if env_repo and Path(env_repo).exists():
    REPO_ROOT = Path(env_repo)
else:
    REPO_ROOT = Path(__file__).resolve().parents[1]

MISSING_REPORT_PATH = REPO_ROOT / 'MISSING_DOCUMENTATION_REPORT.txt'
REPO = 'Ingenium-Games/ingenium'

def parse_missing_report():
    """Parse the missing documentation report"""
    functions = {}
    current_namespace = None
    
    if not MISSING_REPORT_PATH.exists():
        print(f"ERROR: Missing report not found at {MISSING_REPORT_PATH}")
        return {}

    with open(MISSING_REPORT_PATH, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    
    for line in lines:
        line = line.strip()
        
        if line and not line.startswith('-') and line.endswith(':'):
            # Candidate namespace header (normalize to lowercase)
            candidate = line.rstrip(':').strip()
            ns = candidate.lower()
            # Only accept valid namespace identifiers (lowercase, alnum and underscores)
            if re.match(r'^[a-z][a-z0-9_]+$', ns):
                current_namespace = ns
                if current_namespace not in functions:
                    functions[current_namespace] = []
            else:
                # Ignore generic headings like ACTIONS TAKEN, NEXT STEPS, etc.
                current_namespace = None
        elif line.startswith('- '):
            # Function entry
            func_entry = line[2:].strip()
            if current_namespace:
                functions[current_namespace].append(func_entry)
    
    return functions


def parse_mismatch_json(json_path: Path):
    """Parse verifier mismatch JSON into the same namespace->functions map.

    Expects JSON of the form: {"mismatches": [{"func": "namespace.func", ...}, ...]}
    """
    if not json_path.exists():
        return {}

    try:
        with open(json_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
    except Exception as e:
        print(f"ERROR: Failed to read mismatch JSON at {json_path}: {e}")
        return {}

    functions = {}
    for m in data.get('mismatches', []):
        func = m.get('func')
        if not func or '.' not in func:
            continue
        ns, name = func.split('.', 1)
        if ns not in functions:
            functions[ns] = []
        functions[ns].append(name)

    return functions

def generate_issue_body(namespace, missing_funcs):
    """Generate GitHub issue body"""
    issue_body = f"""## Missing Documentation: {namespace} Namespace

The following {len(missing_funcs)} functions in the `ig.{namespace}` namespace are missing wiki documentation:

"""
    
    for func in sorted(missing_funcs):
        issue_body += f"- `{func}`\n"
    
    issue_body += f"""
### Actions Required

1. Create markdown files for each function:
   - Example: `Documentation/wiki/ig_{namespace}_FunctionName.md`
   - Use the provided function template

2. Update README.md references once docs are complete

3. Run verification script to confirm all links

### Documentation Template

Use this template for new function documentation:

```markdown
# ig.{namespace}.FunctionName

**Scope:** [C/S/S C]

## Description

Brief description of what this function does.

## Syntax

```lua
ig.{namespace}.FunctionName(param1, param2)
```

## Parameters

- **param1** - Description of parameter 1
- **param2** - Description of parameter 2

## Returns

Description of return value

## Example

```lua
local result = ig.{namespace}.FunctionName(...)
```
```

### Related

- [Complete Function Reference](README.md)
"""
    
    return issue_body

def create_github_issue(namespace, funcs):
    """Create GitHub issue using gh CLI"""
    title = f"📝 Documentation: {namespace} namespace ({len(funcs)} functions)"
    body = generate_issue_body(namespace, funcs)
    
    # Create issue using gh CLI
    cmd = [
        'gh', 'issue', 'create',
        '--repo', REPO,
        '--title', title,
        '--body', body,
        '--label', 'documentation',
        '--label', 'wiki',
    ]
    
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        print(f"✅ Created issue for {namespace}: {result.stdout.strip()}")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to create issue for {namespace}: {e.stderr}")
        return False


def create_aggregate_issue(all_missing: dict):
    """Create a single aggregated GitHub issue covering all namespaces/functions."""
    total_funcs = sum(len(funcs) for funcs in all_missing.values())
    total_ns = len(all_missing)
    title = f"📝 Documentation: Missing wiki docs — {total_ns} namespaces, {total_funcs} functions"

    # Build body
    body = f"## Missing Documentation (aggregated)\n\n"
    body += f"The verifier detected {total_funcs} functions across {total_ns} namespaces missing wiki documentation.\n\n"
    for ns in sorted(all_missing.keys()):
        funcs = all_missing[ns]
        body += f"### ig.{ns} — {len(funcs)} functions\n"
        for f in sorted(funcs):
            body += f"- `{f}`\n"
        body += "\n"

    body += "### Actions\n\n- Create wiki pages for each listed function.\n- Reference these pages in Documentation/wiki/README.md.\n\n"

    # Write to temp file and call gh
    import tempfile
    with tempfile.NamedTemporaryFile('w', encoding='utf-8', delete=False) as tf:
        tf.write(body)
        tmp_path = tf.name

    cmd = [
        'gh', 'issue', 'create',
        '--repo', REPO,
        '--title', title,
        '--body-file', tmp_path,
        '--label', 'documentation',
        '--label', 'wiki',
    ]

    try:
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        # gh prints the URL to stdout
        url = result.stdout.strip()
        print(f"✅ Created aggregated issue: {url}")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to create aggregated issue: {e.stderr}")
        return False

def main():
    """Main execution"""
    parser = argparse.ArgumentParser(description='Create GitHub issues for missing docs')
    parser.add_argument('--auto-create', action='store_true', help='Automatically create GitHub issues using gh CLI')
    parser.add_argument('--repo', default=None, help='Repository to create issues in (owner/repo)')
    parser.add_argument('--yes', action='store_true', help='Skip confirmation prompts when creating issues')
    args = parser.parse_args()

    # Allow overriding target repo
    global REPO
    if args.repo:
        REPO = args.repo

    print('📋 Parsing missing documentation report and verifier mismatches...')

    # Prefer verifier JSON if present (produced by scripts/verify_function_scopes.py in CI)
    mismatch_json_path = REPO_ROOT / 'scripts' / 'function_scope_mismatches.json'
    missing = {}
    if mismatch_json_path.exists():
        missing = parse_mismatch_json(mismatch_json_path)
        if missing:
            print(f'ℹ️  Loaded {sum(len(v) for v in missing.values())} mismatches from {mismatch_json_path}')
    if not missing:
        # Fall back to legacy MISSING_DOCUMENTATION_REPORT.txt parsing
        missing = parse_missing_report()
    
    print(f'✅ Found {len(missing)} namespaces with missing documentation\n')
    
    # Print summary
    total_missing = sum(len(funcs) for funcs in missing.values())
    print('=' * 60)
    print('MISSING DOCUMENTATION SUMMARY')
    print('=' * 60)
    for namespace in sorted(missing.keys()):
        funcs = missing[namespace]
        print(f'{namespace:20} - {len(funcs):3} functions')
    print('=' * 60)
    print(f'{"TOTAL":20} - {total_missing:3} functions')
    print('=' * 60)
    
    print('\n📝 ISSUE TEMPLATES\n')
    
    # Show issue templates (don't create yet without --auto-create)
    for namespace in sorted(missing.keys()):
        funcs = missing[namespace]
        print(f'\n--- NAMESPACE: {namespace} ---')
        print(f'Title: 📝 Documentation: {namespace} namespace ({len(funcs)} functions)')
        print(f'Labels: documentation, wiki')
        print(f'Functions: {", ".join(f[0:len(f)//2] + "..." for f in funcs[:3])}')
        if len(funcs) > 3:
            print(f'  ... and {len(funcs) - 3} more')
    
    print('\n' + '=' * 60)

    # If --auto-create, proceed to create issues using gh CLI
    if args.auto_create:
        gh_path = shutil.which('gh')
        if not gh_path:
            print('ERROR: gh CLI not found in PATH. Install GitHub CLI to enable --auto-create.')
            return

        if not missing:
            print('No missing documentation namespaces found; nothing to create.')
            return

        if not args.yes:
            resp = input(f"Create {len(missing)} GitHub issues in {REPO}? [y/N]: ")
            if resp.strip().lower() != 'y':
                print('Aborting issue creation.')
                return

        # Create a single aggregated issue for this run
        ok = create_aggregate_issue(missing)
        if ok:
            print('\n' + '=' * 60)
            print('Created: 1 aggregated issue, Failed: 0')
            print('=' * 60)
        else:
            print('\n' + '=' * 60)
            print('Created: 0 issues, Failed: 1')
            print('=' * 60)
    else:
        print('To create GitHub issues, run:')
        print('  python3 scripts/create_missing_docs_issues.py --auto-create')
        print('Use --yes to skip confirmation: --auto-create --yes')
        print('=' * 60)

if __name__ == '__main__':
    main()
