#!/usr/bin/env python3
"""
Generate complete README.md with ALL discovered functions.
Features:
- Scans all functions across client/, server/, shared/
- Respects @wiki:ignore flag for excluding functions
- Includes functions even without .md documentation
- Reports missing documentation at completion
"""

import os
import re
from pathlib import Path
from collections import defaultdict

# Configuration
WIKI_IGNORE_FLAGS = [
    '@wiki:ignore',
    '--WIKI-IGNORE',
    '--NO-WIKI',
]
from pathlib import Path

# Determine repository root: prefer CI-provided GITHUB_WORKSPACE, else use
# the repository root relative to this script when running locally.
env_repo = os.environ.get('GITHUB_WORKSPACE')
if env_repo and Path(env_repo).exists():
    REPO_ROOT = Path(env_repo)
else:
    REPO_ROOT = Path(__file__).resolve().parents[1]

WIKI_DIR = REPO_ROOT / 'Documentation' / 'wiki'
CODE_DIRS = {
    'client': REPO_ROOT / 'client',
    'server': REPO_ROOT / 'server',
    'shared': REPO_ROOT / 'shared',
}
README_PATH = WIKI_DIR / 'README.md'

def read_file(path):
    """Read file contents"""
    try:
        with open(path, 'r', encoding='utf-8') as f:
            return f.read()
    except FileNotFoundError:
        return ''

def has_ignore_flag(content, line_num, context_lines=5):
    """Check if function has @wiki:ignore flag nearby"""
    lines = content.split('\n')
    
    # Check in context around function definition
    start = max(0, line_num - context_lines)
    end = min(len(lines), line_num + context_lines)
    
    context = '\n'.join(lines[start:end])
    
    for flag in WIKI_IGNORE_FLAGS:
        if flag.lower() in context.lower():
            return True
    return False

def scan_functions():
    """Scan all code directories for function definitions"""
    function_locations = defaultdict(lambda: defaultdict(list))  # full_name -> {code_type -> [file1, file2]}
    functions = defaultdict(list)  # namespace -> [functions]
    ignored = []
    
    for code_type, code_dir in CODE_DIRS.items():
        if not os.path.exists(code_dir):
            continue
            
        for root, dirs, files in os.walk(code_dir):
            for file in files:
                if not file.endswith('.lua'):
                    continue
                    
                filepath = os.path.join(root, file)
                content = read_file(filepath)
                
                # Find all function definitions: function ig.namespace.FunctionName
                pattern = r'function\s+(ig\.\w+\.\w+)\s*\('
                
                for match in re.finditer(pattern, content):
                    full_name = match.group(1)
                    line_num = content[:match.start()].count('\n')
                    
                    # Check for ignore flag
                    if has_ignore_flag(content, line_num):
                        if full_name not in ignored:
                            ignored.append(full_name)
                        continue
                    
                    # Track location
                    function_locations[full_name][code_type].append(filepath)
    
    # Build functions dict with proper scope
    for full_name, locations in function_locations.items():
        parts = full_name.split('.')
        if len(parts) == 3:  # ig.namespace.FunctionName
            namespace = parts[1]
            func_name = parts[2]
            
            # Get all code types where this function exists
            location_types = list(locations.keys())
            
            # Determine scope
            scope = determine_scope(full_name, location_types)
            
            functions[namespace].append({
                'name': func_name,
                'full_name': full_name,
                'scope': scope,
                'locations': locations,
                'code_types': location_types,
            })
    
    return functions, ignored

def determine_scope(full_name, all_locations):
    """Determine function scope [C], [S], or [S C] based on all locations where it exists"""
    has_client = 'client' in all_locations
    has_server = 'server' in all_locations
    
    if has_client and has_server:
        return '[S C]'
    elif has_client:
        return '[C]'
    elif has_server:
        return '[S]'
    else:
        return '[S C]'  # Default if both not found

def get_existing_md_files():
    """Get list of existing markdown files"""
    existing = set()
    if os.path.exists(WIKI_DIR):
        for file in os.listdir(WIKI_DIR):
            if file.endswith('.md') and file != 'README.md':
                existing.add(file)
    return existing

def detect_orphaned_wiki_pages(functions):
    """
    Detect wiki pages that no longer have corresponding functions in the codebase.
    
    Args:
        functions (dict): Dictionary mapping namespace (str) to list of function dicts.
                         Each function dict contains 'name', 'full_name', 'scope', etc.
    
    Returns:
        list: List of orphaned wiki filenames (str) to delete.
    """
    # Build set of all valid function wiki filenames
    valid_filenames = set()
    
    for namespace, funcs in functions.items():
        for func in funcs:
            filename = get_md_filename(namespace, func['name'])
            valid_filenames.add(filename)
    
    # Get all existing wiki MD files
    existing_files = get_existing_md_files()
    
    # Special files that should not be deleted (non-function documentation)
    special_files = {
        'README.md',
        'README_ORIGINAL.md',
        'DOCUMENTATION_UPDATE_SUMMARY.md',
        'EVENTS_REFERENCE.md',
        'EXPORTS_GUIDE.md',
        'PUBLIC_API.md',
    }
    
    # Find orphaned files: existing files that are not in valid filenames and not special files
    orphaned = []
    for file in existing_files:
        # Check if it follows the ig_namespace_FunctionName.md pattern and is not valid
        if (file not in valid_filenames and file not in special_files and 
            file.startswith('ig_') and file.endswith('.md')):
            orphaned.append(file)
    
    return orphaned

def remove_orphaned_wiki_pages(orphaned_files):
    """
    Remove orphaned wiki pages and return list of deleted files.
    
    Args:
        orphaned_files (list): List of wiki filenames (str) to delete.
    
    Returns:
        list: List of successfully deleted filenames (str).
    """
    deleted = []
    failed = []
    
    for file in orphaned_files:
        filepath = WIKI_DIR / file
        try:
            os.remove(filepath)
            deleted.append(file)
            print(f'  🗑️  Deleted orphaned wiki page: {file}')
        except PermissionError as e:
            print(f'  ⚠️  Permission denied when deleting {file}: {e}')
            failed.append(file)
        except OSError as e:
            print(f'  ⚠️  Failed to delete {file}: {e}')
            failed.append(file)
    
    if failed:
        print(f'\n⚠️  Warning: {len(failed)} file(s) could not be deleted')
        for file in failed:
            print(f'     - {file}')
    
    return deleted

def get_md_filename(namespace, func_name):
    """Get expected markdown filename"""
    return f'ig_{namespace}_{func_name}.md'

def check_md_exists(namespace, func_name):
    """Check if markdown file exists for function"""
    filename = get_md_filename(namespace, func_name)
    return os.path.exists(os.path.join(WIKI_DIR, filename))

def generate_readme(functions, ignored):
    """Generate complete README.md content"""
    
    # Get existing MD files for cross-reference
    existing_mds = get_existing_md_files()
    
    lines = [
        '# Ingenium Framework - Complete Function & Event Reference',
        '',
        '**745+ functions** | **100+ events** | **62+ public exports** | **11+ public events**',
        '',
        '---',
        '',
        '## ✅ Best Practice: Declaring the Framework Object',
        '',
        'When using Ingenium from an external resource, declare the framework as a global variable at the start of your script:',
        '',
        '```lua',
        '-- Declare at the top of your resource.',
        'ig = exports["ingenium"]:GetIngenium()',
        '',
        '-- Then use it throughout your resource:',
        'ig.func.Notify("Hello!", "green", 3000)',
        'ig.inventory.GetInventory()',
        'ig.appearance.SetAppearance(appearanceData)',
        '```',
        '',
        '---',
        '',
        '## Complete Namespace Reference',
        '',
    ]
    
    missing_docs = []
    documented_count = 0
    total_count = 0
    
    # Sort namespaces alphabetically
    for namespace in sorted(functions.keys()):
        funcs = functions[namespace]
        total_count += len(funcs)
        
        lines.append(f'### {namespace}')
        lines.append('')
        
        # Add description placeholder
        lines.append(f'{namespace} namespace functions.')
        lines.append('')
        
        # Sort functions alphabetically within namespace
        for func in sorted(funcs, key=lambda x: x['name']):
            full_name = func['full_name']
            scope = func['scope']
            
            # Check if MD file exists
            md_filename = get_md_filename(namespace, func['name'])
            has_md = os.path.exists(os.path.join(WIKI_DIR, md_filename))
            
            if has_md:
                # Link to existing MD file
                lines.append(f'- [ig.{namespace}.{func["name"]}]({md_filename}) {scope}')
                documented_count += 1
            else:
                # No MD file - add placeholder and mark as missing
                lines.append(f'- [ig.{namespace}.{func["name"]}]({md_filename}) {scope} ⚠️ Missing Documentation')
                missing_docs.append({
                    'namespace': namespace,
                    'name': func['name'],
                    'full_name': full_name,
                    'scope': scope,
                    'locations': func.get('locations', {}),
                })
        
        lines.append('')
    
    # Add summary section
    lines.extend([
        '---',
        '',
        '## Documentation Status',
        '',
        f'**Total Functions:** {total_count}',
        f'**Documented:** {documented_count} ({100*documented_count//total_count if total_count else 0}%)',
        f'**Missing Documentation:** {len(missing_docs)} ⚠️',
        '',
    ])
    
    if ignored:
        lines.extend([
            '## Ignored Functions (Internal Only)',
            '',
            f'The following {len(ignored)} functions are marked with @wiki:ignore and are not exposed in the public API:',
            '',
        ])
        for func in sorted(ignored):
            lines.append(f'- `{func}` (internal)')
        lines.append('')
    
    return '\n'.join(lines), missing_docs, len(ignored)

def create_missing_docs_report(missing_docs, ignored_count):
    """Create report of missing documentation"""
    report_lines = [
        '📋 MISSING DOCUMENTATION REPORT',
        '================================',
        '',
    ]
    
    if missing_docs:
        report_lines.append(f'Functions Without Wiki Files: {len(missing_docs)}')
        report_lines.append('')
        
        # Group by namespace
        by_namespace = defaultdict(list)
        for doc in missing_docs:
            by_namespace[doc['namespace']].append(doc)
        
        for namespace in sorted(by_namespace.keys()):
            report_lines.append(f'  {namespace}:')
            for doc in sorted(by_namespace[namespace], key=lambda x: x['name']):
                report_lines.append(f'    - {doc["full_name"]} {doc["scope"]}')
            report_lines.append('')
    
    if ignored_count:
        report_lines.append(f'Functions Ignored (marked @wiki:ignore): {ignored_count}')
        report_lines.append('')
    
    report_lines.extend([
        'ACTIONS TAKEN:',
        '✅ Functions added to README.md (with placeholders if missing docs)',
        '⚠️  Missing documentation marked with ⚠️ symbol',
        '',
        'NEXT STEPS:',
        '1. Create .md files for marked functions',
        '2. Update README.md entry once documentation is complete',
        '3. Run verify script to confirm all links',
        '',
    ])
    
    return '\n'.join(report_lines)

def main():
    """Main execution"""
    print('🔍 Scanning codebase for all functions...')
    functions, ignored = scan_functions()
    
    total_found = sum(len(funcs) for funcs in functions.values())
    print(f'✅ Found {total_found} functions across {len(functions)} namespaces')
    print(f'⏭️  Ignoring {len(ignored)} functions marked with @wiki:ignore')
    
    # Detect and remove orphaned wiki pages
    print('\n🧹 Checking for orphaned wiki pages...')
    orphaned = detect_orphaned_wiki_pages(functions)
    deleted_count = 0
    
    if orphaned:
        print(f'⚠️  Found {len(orphaned)} orphaned wiki pages (functions no longer exist in codebase):')
        deleted = remove_orphaned_wiki_pages(orphaned)
        deleted_count = len(deleted)
        print(f'✅ Deleted {deleted_count} orphaned wiki pages')
    else:
        print('✅ No orphaned wiki pages found')
    
    print('\n📝 Generating README.md...')
    readme_content, missing_docs, ignored_count = generate_readme(functions, ignored)
    
    # Write README
    with open(README_PATH, 'w', encoding='utf-8') as f:
        f.write(readme_content)
    print(f'✅ README.md generated ({len(readme_content)} bytes)')
    
    # Generate report
    report = create_missing_docs_report(missing_docs, ignored_count)
    print('\n' + report)
    
    # Save report
    report_path = REPO_ROOT / 'MISSING_DOCUMENTATION_REPORT.txt'
    with open(report_path, 'w', encoding='utf-8') as f:
        f.write(report)
    print(f'\n📄 Report saved to {report_path}')
    
    # Summary
    print('=' * 60)
    print(f'📊 GENERATION SUMMARY')
    print('=' * 60)
    print(f'Total Functions Found:        {total_found}')
    print(f'Functions Documented:         {total_found - len(missing_docs)}')
    print(f'Functions Missing Docs:       {len(missing_docs)} ⚠️')
    print(f'Functions Ignored (Internal): {ignored_count}')
    if deleted_count > 0:
        print(f'Orphaned Pages Removed:       {deleted_count} 🗑️')
    print(f'Namespaces:                   {len(functions)}')
    print('=' * 60)
    
    # Report status
    if missing_docs:
        print(f'\n⚠️  {len(missing_docs)} functions need documentation!')
        print('📋 See MISSING_DOCUMENTATION_REPORT.txt for details')
        return 1
    else:
        print('\n✅ All functions documented!')
        return 0

if __name__ == '__main__':
    exit(main())
