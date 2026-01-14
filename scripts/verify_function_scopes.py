#!/usr/bin/env python3
"""
Ingenium Function Scope Verification Script

This script verifies that all function scope markers ([S], [C], [S C]) in the
Documentation/wiki/README.md are accurate based on actual code locations.

It handles special cases:
- Functions only in `client/` are `[C]`
- Functions only in `server/` are `[S]`
- Functions in `shared/` are `[S C]`

Usage:
  verify_function_scopes.py          # Verify only (fails on mismatch)
  verify_function_scopes.py --fix    # Auto-fix README scope markers
  verify_function_scopes.py --verbose # Show detailed logging
"""

import os
import re
import sys
import argparse
from pathlib import Path
from typing import Dict, Set, Tuple, List, Optional

class FunctionScopeVerifier:
    def __init__(self, repo_root: str, verbose: bool = False, debug: bool = False):
        self.repo_root = Path(repo_root)
        self.client_dir = self.repo_root / "client"
        self.server_dir = self.repo_root / "server"
        self.shared_dir = self.repo_root / "shared"
        self.readme_path = self.repo_root / "Documentation" / "wiki" / "README.md"
        self.verbose = verbose
        # `debug` enables per-function/per-file diagnostic prints (more verbose than --verbose)
        self.debug = debug
        
        # Store function details
        self.function_info = {}  # {func_key: {'locations': [], 'file': path}}
        self.mismatches = []
        
    # NOTE: Duplicity checks intentionally removed. Scope is determined
    # exclusively by file location: client => [C], server => [S], shared => [S C].
    
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
                        
                        # Store detailed location info
                        key = f"{namespace}.{func_name}"
                        if key not in self.function_info:
                            self.function_info[key] = {
                                'locations': [],
                                'has_duplicity': False,
                                'file': None
                            }
                        
                        self.function_info[key]['locations'].append(scope)
                        self.function_info[key]['file'] = str(lua_file.relative_to(self.repo_root))
                        
                        # No duplicity checks here — keep location only
                        if self.debug:
                            print(f"  ℹ️  {key} found in {scope}/ ({lua_file.relative_to(self.repo_root)})")
                        
            except Exception as e:
                print(f"Error reading {lua_file}: {e}", file=sys.stderr)
                
        return functions
    
    def determine_scope(self, func_key: str) -> str:
        """Determine the correct scope based on where the function is defined and duplicity checks."""
        if func_key not in self.function_info:
            return "[UNKNOWN]"
        
        info = self.function_info[func_key]
        locations = info['locations']
        
        # Count locations
        has_client = 'client' in locations
        has_server = 'server' in locations
        has_shared = 'shared' in locations

        # Determine scope based purely on file locations
        if has_shared or (has_client and has_server):
            if self.debug:
                print(f"  ℹ️  {func_key}: [S C] - shared or in both client/server")
            return "[S C]"
        if has_client:
            if self.debug:
                print(f"  ℹ️  {func_key}: [C] - found only in client/")
            return "[C]"
        if has_server:
            if self.debug:
                print(f"  ℹ️  {func_key}: [S] - found only in server/")
            return "[S]"
        else:
            return "[UNKNOWN]"
    
    def fix_readme(self, mismatches: List[Dict]) -> bool:
        """Fix README by updating scope markers to match actual code.
        
        Returns: True if changes were made
        """
        if not mismatches:
            print("No mismatches to fix")
            return False
        
        print(f"\n🔧 Fixing {len(mismatches)} scope markers in README...")
        
        with open(self.readme_path, 'r', encoding='utf-8', errors='replace') as f:
            readme_content = f.read()
        
        original_content = readme_content
        changes_made = 0
        
        for m in mismatches:
            namespace, func_name = m['func'].split('.')
            old_marker = m['readme']
            new_marker = m['actual']
            
            # Pattern to find and replace: - [ig.namespace.Function](file.md) [OLD_MARKER]
            # We need to be precise to avoid replacing the wrong occurrence
            pattern = rf'(\- \[ig\.{re.escape(namespace)}\.{re.escape(func_name)}\]\([^)]+\))\s+{re.escape(old_marker)}'
            replacement = rf'\1 {new_marker}'
            
            new_content = re.sub(pattern, replacement, readme_content)
            
            if new_content != readme_content:
                print(f"  ✅ Fixed {m['func']}: {old_marker} → {new_marker}")
                readme_content = new_content
                changes_made += 1
            else:
                print(f"  ⚠️  Could not fix {m['func']} (pattern not found)")
        
        if changes_made > 0:
            with open(self.readme_path, 'w', encoding='utf-8') as f:
                f.write(readme_content)
            print(f"\n✅ Updated {changes_made} scope markers in README")
            return True
        
        return False

    def verify(self) -> Tuple[bool, List[Dict]]:
        """Verify all functions in README against actual code.
        
        Returns: (success, mismatches)
        """
        print("🔍 Scanning codebase...")
        
        # Scan all directories
        client_funcs = self.scan_directory(self.client_dir, 'client')
        server_funcs = self.scan_directory(self.server_dir, 'server')
        shared_funcs = self.scan_directory(self.shared_dir, 'shared')
        
        print(f"Found {len(self.function_info)} total function definitions")
        
        # Read README
        if not self.readme_path.exists():
            print(f"ERROR: README not found at {self.readme_path}")
            return False, []
        
        with open(self.readme_path, 'r', encoding='utf-8', errors='replace') as f:
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
            
            if key not in self.function_info:
                not_found += 1
                if self.debug:
                    print(f"  ⚠️  {key} not found in codebase")
                continue
            
            actual_marker = self.determine_scope(key)
            
            if readme_marker != actual_marker:
                info = self.function_info[key]
                mismatches.append({
                    'func': key,
                    'readme': readme_marker,
                    'actual': actual_marker,
                    'locations': info['locations'],
                    'file': info['file'],
                    'has_duplicity': info['has_duplicity']
                })
                if self.debug:
                    print(f"  ❌ {key}: README={readme_marker} ACTUAL={actual_marker}")
            else:
                correct += 1
                if self.debug:
                    print(f"  ✅ {key}: {readme_marker}")
        
        # Report results
        print(f"\n📊 VERIFICATION RESULTS")
        print(f"✅ Correct: {correct}")
        print(f"❌ Mismatches: {len(mismatches)}")
        print(f"❓ Not Found: {not_found}")
        
        if mismatches:
            print(f"\n⚠️  MISMATCHES FOUND:\n")
            for m in sorted(mismatches, key=lambda x: (x['readme'], x['actual'], x['func'])):
                print(f"  {m['func']:40} README: {m['readme']:6} ACTUAL: {m['actual']:6}")
                print(f"    File: {m['file']}")
                print(f"    Locations: {', '.join(m['locations'])}")
                if m['has_duplicity']:
                    print(f"    Has IsDuplicityVersion check: Yes")
                print()
        
        return len(mismatches) == 0, mismatches

def main():
    parser = argparse.ArgumentParser(
        description='Verify and fix function scope markers in README',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s              # Verify only (fails on mismatch)
  %(prog)s --fix        # Auto-fix README scope markers
  %(prog)s --verbose    # Show detailed logging
  %(prog)s --fix --verbose  # Fix with detailed logging
        """
    )
    parser.add_argument('--fix', action='store_true', 
                       help='Automatically fix README scope markers')
    parser.add_argument('--verbose', '-v', action='store_true',
                       help='Show detailed logging')
    parser.add_argument('--debug', '-d', action='store_true',
                       help='Show per-function debug logging (more verbose than --verbose)')
    
    args = parser.parse_args()
    
    # Determine repository root: prefer CI-provided GITHUB_WORKSPACE, else use
    # the repository root relative to this script when running locally.
    env_repo = os.environ.get('GITHUB_WORKSPACE')
    # Prefer the CI-provided GITHUB_WORKSPACE only if that path actually exists
    # on this machine. Some local environments (or older defaults) set a
    # placeholder like '/workspaces/ingenium' which is invalid locally and
    # causes the script to look in the wrong place.
    if env_repo and Path(env_repo).exists():
        repo_root = env_repo
    else:
        # When running locally (e.g., in VS Code or terminal), resolve the repo
        # root to the parent of this `scripts/` folder.
        repo_root = str(Path(__file__).resolve().parents[1])

    verifier = FunctionScopeVerifier(repo_root, verbose=args.verbose, debug=args.debug)
    success, mismatches = verifier.verify()
    
    if args.fix and mismatches:
        # Fix the mismatches
        fixed = verifier.fix_readme(mismatches)
        if fixed:
            print("\n🎉 README has been updated. Re-running verification...")
            # Re-verify to confirm
            verifier = FunctionScopeVerifier(repo_root, verbose=False)
            success, remaining_mismatches = verifier.verify()
            if not success:
                print("\n⚠️  Some mismatches remain after fix. Please review manually.")
                sys.exit(1)
            print("\n✅ All scope markers are now correct!")
            sys.exit(0)
        else:
            print("\n❌ Failed to fix README")
            sys.exit(1)
    
    # If running in CI (GITHUB_WORKSPACE), write mismatches to a JSON file
    # but do not fail the process so downstream workflow steps can act on the results.
    env_repo = os.environ.get('GITHUB_WORKSPACE')
    try:
        import json
        if env_repo and Path(env_repo).exists():
            out_path = Path(repo_root) / 'scripts' / 'function_scope_mismatches.json'
            with open(out_path, 'w', encoding='utf-8') as f:
                json.dump({'mismatches': mismatches}, f, indent=2, ensure_ascii=False)
            print(f"Wrote mismatch report to {out_path}")
            # Always exit 0 in CI so workflow can continue to create issues/PRs
            sys.exit(0)
    except Exception:
        # If writing the report fails, fall through to normal exit behavior
        pass

    sys.exit(0 if success else 1)

if __name__ == '__main__':
    main()
