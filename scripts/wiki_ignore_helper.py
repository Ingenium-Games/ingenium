#!/usr/bin/env python3
"""
Helper tool to add @wiki:ignore or --WIKI-IGNORE flags to functions.

Usage:
  python3 scripts/wiki_ignore_helper.py --list-candidates
  python3 scripts/wiki_ignore_helper.py --add "ig.namespace.FunctionName"
  python3 scripts/wiki_ignore_helper.py --search "internal"
"""

import os
import re
import sys
from pathlib import Path

from pathlib import Path

# Determine repository root: prefer CI-provided GITHUB_WORKSPACE, else use
# the repository root relative to this script when running locally.
env_repo = os.environ.get('GITHUB_WORKSPACE')
if env_repo and Path(env_repo).exists():
    REPO_ROOT = Path(env_repo)
else:
    REPO_ROOT = Path(__file__).resolve().parents[1]

CODE_DIRS = {
    'client': str(REPO_ROOT / 'client'),
    'server': str(REPO_ROOT / 'server'),
    'shared': str(REPO_ROOT / 'shared'),
}

def find_function_file(full_name):
    """Find the file containing a specific function"""
    pattern = full_name.replace('.', r'\.') + r'\s*\('
    
    for code_type, code_dir in CODE_DIRS.items():
        if not os.path.exists(code_dir):
            continue
        
        for root, dirs, files in os.walk(code_dir):
            for file in files:
                if not file.endswith('.lua'):
                    continue
                
                filepath = os.path.join(root, file)
                try:
                    with open(filepath, 'r', encoding='utf-8') as f:
                        content = f.read()
                    
                    if re.search(r'function\s+' + pattern, content):
                        return filepath, content
                except:
                    pass
    
    return None, None

def add_ignore_flag(full_name, flag_style='@wiki:ignore'):
    """Add ignore flag to a function"""
    filepath, content = find_function_file(full_name)
    
    if not filepath:
        print(f'❌ Function {full_name} not found')
        return False
    
    # Find the function definition
    pattern = r'(function\s+' + re.escape(full_name) + r'\s*\([^)]*\))'
    
    if flag_style == '@wiki:ignore':
        replacement = r'---@wiki:ignore\n\1'
    else:  # --WIKI-IGNORE
        replacement = r'--WIKI-IGNORE\n\1'
    
    new_content = re.sub(pattern, replacement, content, count=1)
    
    if new_content == content:
        print(f'❌ Could not add flag to {full_name}')
        return False
    
    # Write back
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(new_content)
    
    print(f'✅ Added {flag_style} to {full_name} in {filepath}')
    return True

def list_candidates(pattern=None):
    """List functions that might be internal (candidates for ignore flag)"""
    candidates = []
    
    # Keywords that suggest internal functions
    internal_keywords = [
        'internal',
        'private',
        'helper',
        'debug',
        'test',
        '_',  # Functions starting with underscore
    ]
    
    for code_type, code_dir in CODE_DIRS.items():
        if not os.path.exists(code_dir):
            continue
        
        for root, dirs, files in os.walk(code_dir):
            for file in files:
                if not file.endswith('.lua'):
                    continue
                
                filepath = os.path.join(root, file)
                try:
                    with open(filepath, 'r', encoding='utf-8') as f:
                        content = f.read()
                    
                    # Find function definitions
                    func_pattern = r'function\s+(ig\.\w+\.\w+)\s*\('
                    for match in re.finditer(func_pattern, content):
                        full_name = match.group(1)
                        
                        # Check if it looks internal
                        is_internal = False
                        for keyword in internal_keywords:
                            if keyword in full_name.lower() or keyword in filepath.lower():
                                is_internal = True
                                break
                        
                        if is_internal:
                            if pattern is None or pattern.lower() in full_name.lower():
                                candidates.append(full_name)
                
                except:
                    pass
    
    return sorted(set(candidates))

def main():
    if len(sys.argv) < 2:
        print('Usage:')
        print('  python wiki_ignore_helper.py --list              List all functions')
        print('  python wiki_ignore_helper.py --candidates        List internal candidates')
        print('  python wiki_ignore_helper.py --add <func>        Add @wiki:ignore flag')
        print('  python wiki_ignore_helper.py --search <pattern>  Search for functions')
        sys.exit(1)
    
    if sys.argv[1] == '--candidates':
        print('🔍 Internal function candidates (for @wiki:ignore):')
        candidates = list_candidates()
        for func in candidates:
            print(f'  - {func}')
        print(f'\nTotal: {len(candidates)} candidates')
    
    elif sys.argv[1] == '--add' and len(sys.argv) > 2:
        func_name = sys.argv[2]
        add_ignore_flag(func_name)
    
    elif sys.argv[1] == '--search' and len(sys.argv) > 2:
        pattern = sys.argv[2]
        print(f'🔍 Functions matching "{pattern}":')
        candidates = list_candidates(pattern)
        for func in candidates:
            print(f'  - {func}')
    
    else:
        print('Invalid arguments')
        sys.exit(1)

if __name__ == '__main__':
    main()
