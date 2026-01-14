#!/usr/bin/env python3
"""
Ingenium README Auto-Update Script

This script automatically:
1. Detects new .md files in Documentation/wiki/
2. Extracts function names and scope markers
3. Updates README.md with new functions in the correct namespace
4. Verifies scope markers match actual code locations

Exit codes:
  0 = No changes needed
  1 = Changes made and saved
"""

import os
import re
import sys
from pathlib import Path
from typing import Dict, List, Tuple
from collections import defaultdict

class ReadmeUpdater:
    def __init__(self, repo_root: str):
        self.repo_root = Path(repo_root)
        self.wiki_dir = self.repo_root / "Documentation" / "wiki"
        self.readme_path = self.wiki_dir / "README.md"
        self.client_dir = self.repo_root / "client"
        self.server_dir = self.repo_root / "server"
        self.shared_dir = self.repo_root / "shared"
        
        # Store function details including duplicity check info
        self.function_info = {}  # {func_key: {'locations': [], 'has_duplicity': bool}}
        
    def check_function_has_duplicity(self, content: str, func_name: str) -> bool:
        """Check if a function body contains IsDuplicityVersion() check.
        
        This indicates the function is designed to work on both client and server
        even though it's only defined in one location.
        """
        # Find the function definition
        pattern = rf'function\s+ig\.[a-z]+\.{re.escape(func_name)}\s*\([^)]*\)'
        match = re.search(pattern, content)
        
        if not match:
            return False
        
        # Get the function body (up to next function or end of file)
        start_pos = match.end()
        
        # Find next function or end
        next_func_pattern = r'\nfunction\s+'
        next_match = re.search(next_func_pattern, content[start_pos:])
        
        if next_match:
            func_body = content[start_pos:start_pos + next_match.start()]
        else:
            func_body = content[start_pos:]
        
        # Check for IsDuplicityVersion in the function body
        return 'IsDuplicityVersion()' in func_body
    
    def scan_function_definitions(self) -> Dict[str, List[str]]:
        """Scan all .lua files to find function definitions by scope."""
        functions_by_scope = defaultdict(list)
        
        for directory, scope in [(self.client_dir, 'client'), 
                                  (self.server_dir, 'server'), 
                                  (self.shared_dir, 'shared')]:
            if not directory.exists():
                continue
                
            for lua_file in directory.rglob("*.lua"):
                if ".git" in lua_file.parts or "node_modules" in lua_file.parts:
                    continue
                    
                try:
                    with open(lua_file, 'r', encoding='utf-8', errors='ignore') as f:
                        content = f.read()
                        # Find: function ig.namespace.FunctionName(...)
                        pattern = r'function\s+ig\.([a-z]+)\.([A-Za-z_]\w*)\s*\('
                        for match in re.finditer(pattern, content):
                            namespace = match.group(1)
                            func_name = match.group(2)
                            key = f"{namespace}.{func_name}"
                            if key not in functions_by_scope[scope]:
                                functions_by_scope[scope].append(key)
                            
                            # Store detailed info
                            if key not in self.function_info:
                                self.function_info[key] = {
                                    'locations': [],
                                    'has_duplicity': False
                                }
                            self.function_info[key]['locations'].append(scope)
                            
                            # Check for IsDuplicityVersion pattern
                            if self.check_function_has_duplicity(content, func_name):
                                self.function_info[key]['has_duplicity'] = True
                except:
                    pass
        
        return dict(functions_by_scope)
    
    def determine_scope_marker(self, func_key: str, functions_by_scope: Dict) -> str:
        """Determine the correct scope marker for a function."""
        # Check if we have detailed info
        if func_key in self.function_info:
            info = self.function_info[func_key]
            if info['has_duplicity']:
                return "[S C]"
            locations = info['locations']
        else:
            # Fallback to old logic
            namespace = func_key.split('.')[0]
            
            in_client = func_key in functions_by_scope.get('client', [])
            in_server = func_key in functions_by_scope.get('server', [])
            in_shared = func_key in functions_by_scope.get('shared', [])
            
            locations = []
            if in_client:
                locations.append('client')
            if in_server:
                locations.append('server')
            if in_shared:
                locations.append('shared')
        
        # Determine scope based on actual file locations
        has_client = 'client' in locations
        has_server = 'server' in locations
        has_shared = 'shared' in locations
        
        if (has_client and has_server) or has_shared:
            return "[S C]"
        elif has_client:
            return "[C]"
        elif has_server:
            return "[S]"
        else:
            return "[UNKNOWN]"
    
    def extract_functions_from_wiki_files(self) -> Dict[str, List[Tuple[str, str]]]:
        """Extract functions from .md files in wiki directory.
        
        Returns: {namespace: [(func_name, filename), ...]}
        """
        functions = defaultdict(list)
        
        if not self.wiki_dir.exists():
            return dict(functions)
        
        # Pattern: ig_namespace_FunctionName.md
        for md_file in self.wiki_dir.glob("ig_*.md"):
            stem = md_file.stem  # e.g., "ig_export_GetIngenium"
            parts = stem.split('_', 1)  # Split on first underscore
            
            if len(parts) == 2:
                category = parts[0]  # "ig"
                rest = parts[1]      # "export_GetIngenium"
                
                # Handle exports separately
                if rest.startswith("export_"):
                    # These are documented exports, not functions
                    continue
                elif rest.startswith("event_"):
                    # These are events, not functions
                    continue
                else:
                    # Regular function: namespace_FunctionName
                    namespace_func = rest.split('_', 1)
                    if len(namespace_func) == 2:
                        namespace = namespace_func[0]
                        func_name = namespace_func[1]
                        functions[namespace].append((func_name, md_file.name))
        
        return dict(functions)
    
    def update_readme(self) -> bool:
        """Update README with any new functions.
        
        Returns: True if changes were made, False otherwise
        """
        if not self.readme_path.exists():
            print(f"README not found at {self.readme_path}")
            return False
        
        # Get existing functions
        functions_by_scope = self.scan_function_definitions()
        
        # Extract functions from markdown files
        wiki_functions = self.extract_functions_from_wiki_files()
        
        if not wiki_functions:
            print("No new functions detected in wiki markdown files")
            return False
        
        # Read README
        with open(self.readme_path, 'r') as f:
            readme_lines = f.readlines()
        
        # Find existing functions per namespace
        readme_funcs = defaultdict(list)
        for i, line in enumerate(readme_lines):
            match = re.match(r'\s*- \[ig\.([a-z]+)\.([A-Za-z_]\w*)\]', line)
            if match:
                namespace = match.group(1)
                func_name = match.group(2)
                readme_funcs[namespace].append((func_name, i, line.rstrip()))
        
        changes_made = False
        new_entries = defaultdict(list)
        
        # Check for new functions not in README
        for namespace, wiki_funcs in wiki_functions.items():
            for func_name, filename in wiki_funcs:
                # Check if already in README
                existing = [f[0] for f in readme_funcs.get(namespace, [])]
                if func_name not in existing:
                    func_key = f"{namespace}.{func_name}"
                    scope = self.determine_scope_marker(func_key, functions_by_scope)
                    md_filename = f"ig_{namespace}_{func_name}.md"
                    entry = f"  - [ig.{namespace}.{func_name}]({md_filename}) {scope}"
                    new_entries[namespace].append(entry)
                    changes_made = True
        
        if not changes_made:
            print("No new functions to add to README")
            return False
        
        # Insert new functions into README
        for namespace, new_funcs in sorted(new_entries.items()):
            # Find the section for this namespace
            section_pattern = f"^### {namespace}$"
            section_found = False
            insert_pos = None
            
            for i, line in enumerate(readme_lines):
                if re.match(section_pattern, line):
                    section_found = True
                    # Find the next line that's not a function entry
                    j = i + 2  # Skip "### namespace" and description
                    while j < len(readme_lines) and readme_lines[j].strip().startswith('-'):
                        j += 1
                    insert_pos = j
                    break
            
            if section_found and insert_pos is not None:
                # Insert new functions, maintaining alphabetical order
                for entry in sorted(new_funcs):
                    readme_lines.insert(insert_pos, entry + '\n')
                    insert_pos += 1
                
                print(f"Added {len(new_funcs)} functions to {namespace} section")
        
        # Write updated README
        if changes_made:
            with open(self.readme_path, 'w') as f:
                f.writelines(readme_lines)
            print(f"✅ README updated successfully")
            return True
        
        return False

def main():
    repo_root = os.environ.get('GITHUB_WORKSPACE', '/workspaces/ingenium')
    updater = ReadmeUpdater(repo_root)
    
    print("🔍 Scanning for new functions...")
    changed = updater.update_readme()
    
    if changed:
        sys.exit(1)  # Exit with 1 to signal changes were made
    else:
        sys.exit(0)  # Exit with 0 if no changes

if __name__ == '__main__':
    main()
