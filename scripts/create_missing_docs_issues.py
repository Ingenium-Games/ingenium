#!/usr/bin/env python3
"""
Create GitHub issues for functions with missing documentation.
Usage: python3 scripts/create_missing_docs_issues.py [--auto-create]
"""

import json
import subprocess
from pathlib import Path

MISSING_REPORT_PATH = '/workspaces/ingenium/MISSING_DOCUMENTATION_REPORT.txt'
REPO = 'Ingenium-Games/ingenium'

def parse_missing_report():
    """Parse the missing documentation report"""
    functions = {}
    current_namespace = None
    
    with open(MISSING_REPORT_PATH, 'r') as f:
        lines = f.readlines()
    
    for line in lines:
        line = line.strip()
        
        if line and not line.startswith('-') and line.endswith(':'):
            # Namespace header
            current_namespace = line.rstrip(':')
            if current_namespace not in functions:
                functions[current_namespace] = []
        elif line.startswith('- '):
            # Function entry
            func_entry = line[2:].strip()
            if current_namespace:
                functions[current_namespace].append(func_entry)
    
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

def main():
    """Main execution"""
    print('📋 Parsing missing documentation report...')
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
    print('To create GitHub issues, run:')
    print('  python3 scripts/create_missing_docs_issues.py --auto-create')
    print('=' * 60)

if __name__ == '__main__':
    main()
