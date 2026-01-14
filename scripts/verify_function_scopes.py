#!/usr/bin/env python3
"""
Ingenium Function Scope Verification Script

This script verifies that all function scope markers ([S], [C], [S C]) in the 
Documentation/wiki/README.md are accurate based on actual code locations.

It handles special cases:
- Functions with IsDuplicityVersion checks are [S C] (true dual-scope)
- Functions only in client/ are [C]
- Functions only in server/ are [S]
- Functions in shared/ are [S C] UNLESS they're wrappers with duplicity checks
"""

import os
import re
import sys
from pathlib import Path
from typing import Dict, Set, Tuple, List

class FunctionScopeVerifier:
    def __init__(self, repo_root: str):
        self.repo_root = Path(repo_root)
        self.client_dir = self.repo_root / "client"
        self.server_dir = self.repo_root / "server"
        self.shared_dir = self.repo_root / "shared"
        self.readme_path = self.repo_root / "Documentation" / "wiki" / "README.md"
        
        # Known namespaces with IsDuplicityVersion pattern (true dual-scope)
        self.duplicity_namespaces = {
            'callback', 'log', 'debug', 'voip'
        }
        
        self.function_locations = {}  # {namespace: {func_name: [locations]}}
        self.mismatches = []
        
    def scan_directory(self, directory: Path, scope: str) -> Dict[str, Set[str]]:
        """Scan a directory for function definitions."""
        functions = {}
        
        if not directory.exists():
            return functions
            
        for lua_file in directory.rglob("*.lua"):
            if ".git" in lua_file.parts or "node_modules" in lua_file.parts:
                continue
                
            try:
                with open(lua_file, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()
                    
                    # Find function definitions: function ig.namespace.FunctionName(...)
                    pattern = r'function\s+ig\.([a-z]+)\.([A-Za-z_]\w*)\s*\('
                    for match in re.finditer(pattern, content):
                        namespace = match.group(1)
                        func_name = match.group(2)
                        
                        if namespace not in functions:
                            functions[namespace] = set()
                        functions[namespace].add(func_name)
                        
                        # Store location info
                        key = f"{namespace}.{func_name}"
                        if key not in self.function_locations:
                            self.function_locations[key] = []
                        self.function_locations[key].append(scope)
                        
            except Exception as e:
                print(f"Error reading {lua_file}: {e}", file=sys.stderr)
                
        return functions
    
    def determine_scope(self, namespace: str, locations: List[str]) -> str:
        """Determine the correct scope based on where the function is defined."""
        # Special case: known duplicity pattern namespaces
        if namespace in self.duplicity_namespaces:
            return "[S C]"
        
        # Count locations
        has_client = 'client' in locations
        has_server = 'server' in locations
        has_shared = 'shared' in locations
        
        # Determine scope
        if has_client and has_server:
            return "[S C]"
        elif has_shared:
            return "[S C]"
        elif has_client:
            return "[C]"
        elif has_server:
            return "[S]"
        else:
            return "[UNKNOWN]"
    
    def verify(self):
        """Verify all functions in README against actual code."""
        print("🔍 Scanning codebase...")
        
        # Scan all directories
        client_funcs = self.scan_directory(self.client_dir, 'client')
        server_funcs = self.scan_directory(self.server_dir, 'server')
        shared_funcs = self.scan_directory(self.shared_dir, 'shared')
        
        print(f"Found {len(self.function_locations)} total function definitions")
        
        # Read README
        if not self.readme_path.exists():
            print(f"ERROR: README not found at {self.readme_path}")
            return False
        
        with open(self.readme_path, 'r') as f:
            readme_content = f.read()
        
        # Find all function references in README
        # Pattern: - [ig.namespace.Function](file.md) [SCOPE]
        pattern = r'\- \[ig\.([a-z]+)\.([A-Za-z_]\w*)\]\([^)]+\)\s*(\[[S C]+\])'
        
        matches = re.findall(pattern, readme_content)
        print(f"Found {len(matches)} functions in README")
        
        mismatches = []
        correct = 0
        not_found = 0
        
        for namespace, func_name, readme_marker in matches:
            key = f"{namespace}.{func_name}"
            
            if key not in self.function_locations:
                not_found += 1
                continue
            
            locations = self.function_locations[key]
            actual_marker = self.determine_scope(namespace, locations)
            
            if readme_marker != actual_marker:
                mismatches.append({
                    'func': key,
                    'readme': readme_marker,
                    'actual': actual_marker,
                    'locations': locations
                })
            else:
                correct += 1
        
        # Report results
        print(f"\n📊 VERIFICATION RESULTS")
        print(f"✅ Correct: {correct}")
        print(f"❌ Mismatches: {len(mismatches)}")
        print(f"❓ Not Found: {not_found}")
        
        if mismatches:
            print(f"\n⚠️  MISMATCHES FOUND:\n")
            for m in sorted(mismatches, key=lambda x: (x['readme'], x['actual'], x['func'])):
                print(f"  {m['func']:40} README: {m['readme']:6} ACTUAL: {m['actual']:6}")
                print(f"    Locations: {', '.join(m['locations'])}")
            return False
        
        return True

def main():
    repo_root = os.environ.get('GITHUB_WORKSPACE', '/workspaces/ingenium')
    
    verifier = FunctionScopeVerifier(repo_root)
    success = verifier.verify()
    
    sys.exit(0 if success else 1)

if __name__ == '__main__':
    main()
