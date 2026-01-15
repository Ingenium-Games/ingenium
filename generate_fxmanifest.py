#!/usr/bin/env python3
"""
FXManifest Generator for FiveM Resources
Scans Lua files, detects dependencies via function calls, and generates optimized load order.
"""

import os
import re
import sys
from pathlib import Path
from typing import Dict, Set, List, Tuple
from collections import defaultdict, deque

# Exclusion patterns (like .gitignore)
EXCLUDE_PATTERNS = {
    'node_modules',
    '.git',
    '.gitignore',
    'package-lock.json',
    'package.json',
    '__pycache__',
    '.pytest_cache',
    'Documentation',
    '[Example',  # [Example Doors], [Example Items]
    '[Stubs]',
    'logs',
    'data',  # JSON data files
    'nui',   # UI files handled separately
    '*.md',
}

class LuaFileAnalyzer:
    """Analyzes Lua files for function calls and exports."""
    
    def __init__(self, root_path: str):
        self.root = Path(root_path)
        self.files: Dict[str, dict] = {}
        self.dependencies: Dict[str, Set[str]] = defaultdict(set)
        self.exports: Dict[str, Set[str]] = defaultdict(set)
        
    def should_exclude(self, path: Path) -> bool:
        """Check if path matches exclusion patterns."""
        path_str = str(path)
        for pattern in EXCLUDE_PATTERNS:
            if pattern in path_str or path.name.endswith(pattern):
                return True
        return False
    
    def find_lua_files(self, directory: str, context: str) -> List[Path]:
        """Find all Lua files in a directory."""
        files = []
        for root, dirs, filenames in os.walk(directory):
            # Remove excluded directories
            dirs[:] = [d for d in dirs if not self.should_exclude(Path(root) / d)]
            
            for filename in filenames:
                if filename.endswith('.lua'):
                    filepath = Path(root) / filename
                    if not self.should_exclude(filepath):
                        files.append(filepath)
        
        return sorted(files)
    
    def extract_exports(self, content: str) -> Set[str]:
        """Extract function names that are exported/defined."""
        exports = set()
        
        # Pattern: function ig.something.FunctionName or ig.something.property = function
        patterns = [
            r'function\s+ig\.(\w+)\.(\w+)',  # function ig.module.FunctionName
            r'ig\.(\w+)\.(\w+)\s*=\s*function',  # ig.module.property = function
            r'exports\("(\w+)"',  # exports("FunctionName")
        ]
        
        for pattern in patterns:
            matches = re.findall(pattern, content)
            for match in matches:
                if isinstance(match, tuple):
                    exports.add(f"{match[0]}.{match[1]}")
                else:
                    exports.add(match)
        
        return exports
    
    def extract_dependencies(self, content: str, filepath: Path) -> Set[str]:
        """Extract function calls that indicate dependencies."""
        dependencies = set()
        
        # Pattern: ig.something.FunctionCall( or TriggerEvent, etc
        patterns = [
            r'ig\.(\w+)\.(\w+)\s*\(',  # ig.module.function(
            r'ig\.(\w+)\s*\(',  # ig.module(
            r'TriggerEvent\s*\(\s*["\']([^"\']+)',  # TriggerEvent("event")
            r'TriggerServerEvent\s*\(\s*["\']([^"\']+)',  # TriggerServerEvent("event")
            r'require\s*\(\s*["\']([^"\']+)',  # require("module")
        ]
        
        for pattern in patterns:
            matches = re.findall(pattern, content)
            for match in matches:
                if isinstance(match, tuple):
                    # For ig.module.function patterns
                    module = match[0]
                    if len(match) > 1:
                        func = match[1]
                        dependencies.add(f"ig.{module}")
                    else:
                        dependencies.add(f"ig.{module}")
                else:
                    # For simple string matches
                    if not match.startswith('glm') and match not in ['shared', 'global']:
                        dependencies.add(match)
        
        return dependencies
    
    def analyze_files(self):
        """Analyze all Lua files in the resource."""
        contexts = {
            'shared': self.root / 'shared',
            'client': self.root / 'client',
            'server': self.root / 'server',
        }
        
        for context, directory in contexts.items():
            if not directory.exists():
                continue
            
            lua_files = self.find_lua_files(str(directory), context)
            
            for filepath in lua_files:
                try:
                    with open(filepath, 'r', encoding='utf-8') as f:
                        content = f.read()
                    
                    rel_path = filepath.relative_to(self.root)
                    key = str(rel_path).replace('\\', '/')
                    
                    self.files[key] = {
                        'context': context,
                        'path': filepath,
                        'exports': self.extract_exports(content),
                        'dependencies': self.extract_dependencies(content, filepath),
                    }
                except Exception as e:
                    print(f"Error analyzing {filepath}: {e}", file=sys.stderr)
    
    def determine_load_order(self) -> List[str]:
        """Determine optimal load order based on dependencies."""
        # Start with critical files
        critical_files = [
            'shared/_ig.lua',
            'shared/_log.lua',
            '_config/config.lua',
            'server/_var.lua',
            'client/_var.lua',
        ]
        
        order = []
        processed = set()
        
        # Add critical files first
        for critical in critical_files:
            if critical in self.files and critical not in processed:
                order.append(critical)
                processed.add(critical)
        
        # Add remaining files by context and name
        def sort_key(item):
            key = item[0]
            context_order = {'shared': 0, 'config': 1, 'client': 2, 'server': 3}
            context = item[1]['context']
            
            # Prioritize _var.lua and critical files
            if '_var.lua' in key:
                priority = -2
            elif key.startswith('_config'):
                priority = -1
            else:
                priority = 0
            
            return (context_order.get(context, 99), priority, key)
        
        remaining = sorted(
            [(k, v) for k, v in self.files.items() if k not in processed],
            key=sort_key
        )
        
        for key, _ in remaining:
            if key not in processed:
                order.append(key)
                processed.add(key)
        
        return order
    
    def generate_manifest(self) -> str:
        """Generate fxmanifest.lua content."""
        order = self.determine_load_order()
        
        shared_scripts = [f for f in order if self.files[f]['context'] == 'shared']
        client_scripts = [f for f in order if self.files[f]['context'] == 'client']
        server_scripts = [f for f in order if self.files[f]['context'] == 'server']
        
        # Handle config files
        config_files = [
            '_config/config.lua',
            '_config/defaults.lua',
        ]
        
        manifest = '''------------------------------------------------------------------------------
fx_version "cerulean"
game "gta5"
lua54 "yes"
author "Twiitchter"
description "Ingenium"
version "1.0.0"
------------------------------------------------------------------------------
provide "polyzone"
provide "pma-voice"
provide "ig.target"

ui_page "nui/dist/index.html"
------------------------------------------------------------------------------
shared_scripts {
'''
        
        # Add config files first
        for config in config_files:
            manifest += f'    "{config}",\n'
        
        # Add other config files
        for script in shared_scripts:
            if script.startswith('_config'):
                manifest += f'    "{script}",\n'
        
        # Add rest of shared scripts
        for script in shared_scripts:
            if not script.startswith('_config'):
                manifest += f'    "{script}",\n'
        
        manifest += '''}
------------------------------------------------------------------------------
client_scripts {
'''
        
        for script in client_scripts:
            manifest += f'    "{script}",\n'
        
        manifest += '''    "nui/lua/*.lua"
}
------------------------------------------------------------------------------
server_scripts {
'''
        
        for script in server_scripts:
            manifest += f'    "{script}",\n'
        
        manifest += '''}
------------------------------------------------------------------------------
dependencies {
    "/onesync",
    "freecam",
    "screenshot-basic",
}
------------------------------------------------------------------------------
files {
    "data/*.json",
    "nui/img/*.png",
    "nui/inventory/dist/assets/*.css",
    "nui/inventory/dist/assets/*.js",
    "nui/dist/*.html",
    "nui/dist/assets/*.css",
    "nui/dist/assets/*.js"
}
------------------------------------------------------------------------------
'''
        
        return manifest


def main():
    """Main entry point."""
    resource_path = os.path.dirname(os.path.abspath(__file__))
    
    print(f"Scanning resource: {resource_path}")
    analyzer = LuaFileAnalyzer(resource_path)
    
    print("Analyzing Lua files...")
    analyzer.analyze_files()
    print(f"Found {len(analyzer.files)} Lua files")
    
    print("Determining load order...")
    order = analyzer.determine_load_order()
    
    print("\nLoad Order:")
    for i, script in enumerate(order, 1):
        context = analyzer.files[script]['context']
        print(f"  {i:2d}. [{context:6s}] {script}")
    
    print("\nGenerating fxmanifest.lua...")
    manifest = analyzer.generate_manifest()
    
    manifest_path = os.path.join(resource_path, 'fxmanifest.lua')
    with open(manifest_path, 'w', encoding='utf-8') as f:
        f.write(manifest)
    
    print(f"✓ fxmanifest.lua generated successfully")
    print(f"  Output: {manifest_path}")


if __name__ == '__main__':
    main()
