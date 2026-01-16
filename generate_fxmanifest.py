#!/usr/bin/env python3
"""
FXManifest Generator for FiveM Resources
Scans Lua files, detects dependencies via function calls, and generates optimized load order.
"""

import os
import re
import sys
import argparse
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
        self.bracket_dirs: Dict[str, List[str]] = defaultdict(list)  # Track [Bracket] directories
        self.locale_files: List[str] = []  # Track locale files separately
        
    def should_exclude(self, path: Path) -> bool:
        """Check if path matches exclusion patterns."""
        path_str = str(path)
        # Don't exclude [Bracket] directories - we want them!
        if path.name.startswith('[') and path.name.endswith(']'):
            return False
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
        
        # First, process _config folder (special handling - not context-specific)
        config_dir = self.root / '_config'
        if config_dir.exists():
            for filepath in sorted(config_dir.glob('*.lua')):
                try:
                    with open(filepath, 'r', encoding='utf-8') as f:
                        content = f.read()
                    
                    rel_path = filepath.relative_to(self.root)
                    key = str(rel_path).replace('\\', '/')
                    
                    self.files[key] = {
                        'context': 'config',  # Special context for config files
                        'path': filepath,
                        'exports': self.extract_exports(content),
                        'dependencies': self.extract_dependencies(content, filepath),
                    }
                except Exception as e:
                    print(f"Error analyzing {filepath}: {e}", file=sys.stderr)
        
        # Process locale folder (special handling - shared context)
        locale_dir = self.root / 'locale'
        if locale_dir.exists():
            for filepath in sorted(locale_dir.glob('*.lua')):
                try:
                    with open(filepath, 'r', encoding='utf-8') as f:
                        content = f.read()
                    
                    rel_path = filepath.relative_to(self.root)
                    key = str(rel_path).replace('\\', '/')
                    
                    self.files[key] = {
                        'context': 'locale',  # Special context for locale files
                        'path': filepath,
                        'exports': self.extract_exports(content),
                        'dependencies': self.extract_dependencies(content, filepath),
                    }
                    self.locale_files.append(key)
                except Exception as e:
                    print(f"Error analyzing {filepath}: {e}", file=sys.stderr)
        
        for context, directory in contexts.items():
            if not directory.exists():
                continue
            
            # First, detect all [Bracket] directories
            for item in sorted(directory.iterdir()):
                if item.is_dir() and item.name.startswith('[') and item.name.endswith(']'):
                    if not self.should_exclude(item):
                        rel_path = item.relative_to(self.root)
                        glob_pattern = f"{str(rel_path).replace(chr(92), '/')}"
                        if glob_pattern not in self.bracket_dirs[context]:
                            self.bracket_dirs[context].append(glob_pattern)
            
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
    
    def generate_manifest(self, version: str = "1.0.0") -> str:
        """Generate fxmanifest.lua content."""
        order = self.determine_load_order()
        
        shared_scripts = [f for f in order if self.files[f]['context'] == 'shared']
        client_scripts = [f for f in order if self.files[f]['context'] == 'client']
        server_scripts = [f for f in order if self.files[f]['context'] == 'server']
        
        # Dynamically find all config files in _config folder
        config_files = []
        config_priority = ['_config/config.lua', '_config/defaults.lua']  # Load these first
        
        # Add priority config files
        for config in config_priority:
            if config in self.files:
                config_files.append(config)
        
        # Add all other config files (sorted alphabetically)
        other_configs = sorted([f for f in self.files.keys() if f.startswith('_config/') and f not in config_priority])
        config_files.extend(other_configs)
        
        manifest = f'''------------------------------------------------------------------------------
fx_version "cerulean"
game "gta5"
lua54 "yes"
author "Twiitchter"
description "Ingenium"
version "{version}"
------------------------------------------------------------------------------
provide "polyzone"
provide "pma-voice"

ui_page "nui/dist/index.html"
------------------------------------------------------------------------------
shared_scripts {{
'''
        
        # Add config files first
        for config in config_files:
            manifest += f'    "{config}",\n'
        
        # Add foundation shared files that should load early
        foundation_files = [
            'shared/_ig.lua',
            'shared/_log.lua',
            'shared/_locale.lua',
            'shared/_protect.lua',
        ]
        for foundation in foundation_files:
            if foundation in self.files:
                manifest += f'    "{foundation}",\n'
        
        # Add locale files after shared/_locale.lua
        for locale_file in sorted(self.locale_files):
            manifest += f'    "{locale_file}",\n'
        
        # Add other config files
        for script in shared_scripts:
            if script.startswith('_config'):
                manifest += f'    "{script}",\n'
        
        # Add rest of shared scripts (excluding foundation files)
        for script in shared_scripts:
            if not script.startswith('_config') and script not in foundation_files:
                manifest += f'    "{script}",\n'
        
        # Add bracket directories for shared as catch-all
        for bracket_dir in sorted(self.bracket_dirs['shared']):
            manifest += f'    "{bracket_dir}/*.lua",\n'
        
        manifest += '''}
------------------------------------------------------------------------------
client_scripts {
'''
        
        for script in client_scripts:
            manifest += f'    "{script}",\n'
        
        # Add bracket directories for client as catch-all
        for bracket_dir in sorted(self.bracket_dirs['client']):
            manifest += f'    "{bracket_dir}/*.lua",\n'
        
        manifest += '''    "nui/lua/*.lua"
}
------------------------------------------------------------------------------
server_scripts {
'''
        
        # Enforce specific load order groups
        # Group 1: Foundation files (must load first)
        server_foundation_files = [
            'server/_var.lua',
            'server/_data.lua',
            'server/_callback.lua',
            'server/_functions.lua',
        ]
        
        # Group 2: Files that load after foundation
        server_early_files = [
            'server/[Garage]/_var.lua',
            'server/[API]/_api.lua',
            'server/[Appearance]/_pricing.lua',
            'server/[Callbacks]/_animations_forced.lua',
            'server/[Callbacks]/_appearance.lua',
            'server/[Callbacks]/_banking.lua',
            'server/[Callbacks]/_inventory.lua',
            'server/[Callbacks]/_players.lua',
            'server/[Callbacks]/_vehicles.lua',
            'server/[Classes]/_blank_object.lua',
            'server/[Classes]/_existing_object.lua',
            'server/[Classes]/_job.lua',
            'server/[Classes]/_npc.lua',
            'server/[Classes]/_offline_player.lua',
            'server/[Classes]/_owned_vehicle.lua',
            'server/[Classes]/_player.lua',
            'server/[Classes]/_vehicle.lua',
        ]
        
        # Group 3: Data module files
        server_data_files = [
            'server/[Data - No Save Needed]/_appearance.lua',
            'server/[Data - No Save Needed]/_modkit.lua',
            'server/[Data - No Save Needed]/_names.lua',
            'server/[Data - No Save Needed]/_npc.lua',
            'server/[Data - No Save Needed]/_objects.lua',
            'server/[Data - No Save Needed]/_peds.lua',
            'server/[Data - No Save Needed]/_tattoo.lua',
            'server/[Data - No Save Needed]/_vehicle.lua',
            'server/[Data - No Save Needed]/_weapons.lua',
        ]
        
        # Group 4: Core dependency files (before Data - Save to File)
        server_core_files = [
            'server/[Commands]/_locate_vehicles.lua',
            'server/[Deferals]/_deferals.lua',
            'server/[Dev]/_commands.lua',
            'server/[Doors]/_doors.lua',
            'server/[Events]/_character.lua',
            'server/[Events]/_character_lifecycle.lua',
            'server/[Events]/_feedback.lua',
            'server/[Events]/_vehicle.lua',
            'server/[Garage]/_callbacks.lua',
            'server/[Objects]/_jobs.lua',
            'server/[Objects]/_npcs.lua',
            'server/[Objects]/_objects.lua',
            'server/[Objects]/_players.lua',
            'server/[Objects]/_vehicles.lua',
            'server/[Onesync]/_events.lua',
            'server/[Onesync]/_sbch.lua',
            'server/[SQL]/_bank.lua',
            'server/[SQL]/_banking.lua',
            'server/[SQL]/_character.lua',
            'server/[SQL]/_gen.lua',
            'server/[SQL]/_handler.lua',
            'server/[SQL]/_jobs.lua',
            'server/[SQL]/_saves.lua',
            'server/[SQL]/_users.lua',
            'server/[SQL]/_vehicles.lua',
            'server/[Security]/_statebag_protection.lua',
            'server/[Security]/_transaction_security.lua',
            'server/[Third Party]/_adaptivecards.lua',
            'server/[Third Party]/_discord.lua',
            'server/[Third Party]/_queue_commands.lua',
            'server/[Third Party]/_queue_config_new.lua',
            'server/[Third Party]/_queue_system.lua',
            'server/[Tools]/_logging.lua',
            'server/[Tools]/_memory.lua',
            'server/[Validation]/_validator.lua',
            'server/[Voice]/_voip.lua',
            'server/_bank.lua',
            'server/_chat.lua',
            'server/_commands.lua',
            'server/_cron.lua',
            'server/_events.lua',
            'server/_instance.lua',
            'server/_payroll.lua',
            'server/_persistance.lua',
            'server/_save_routine.lua',
            'server/_screenshot.lua',
            'server/_tebex.lua',
            'server/_time.lua',
            'server/_vehicle_persistence.lua',
        ]
        
        # Group 5: Data - Save to File (must load after dependencies)
        server_save_files = [
            'server/[Data - Save to File]/_drops.lua',
            'server/[Data - Save to File]/_gsr.lua',
            'server/[Data - Save to File]/_items.lua',
            'server/[Data - Save to File]/_jobs.lua',
            'server/[Data - Save to File]/_notes.lua',
            'server/[Data - Save to File]/_pickups.lua',
        ]
        
        # Load all groups in order
        for foundation in server_foundation_files:
            manifest += f'    "{foundation}",\n'
        
        for early in server_early_files:
            if early in self.files:
                manifest += f'    "{early}",\n'
        
        for data in server_data_files:
            if data in self.files:
                manifest += f'    "{data}",\n'
        
        for core in server_core_files:
            if core in self.files:
                manifest += f'    "{core}",\n'
        
        for save in server_save_files:
            if save in self.files:
                manifest += f'    "{save}",\n'
        
        # Finally add server.lua
        manifest += f'    "server/server.lua",\n'        
        # Add any remaining scripts not explicitly listed (catch-all for new files)
        all_ordered_files = set(server_foundation_files + server_early_files + server_data_files + server_core_files + server_save_files + ['server/server.lua'])
        for script in server_scripts:
            if script not in all_ordered_files:
                manifest += f'    "{script}",\n'        
        # Add bracket directories for server as catch-all
        for bracket_dir in sorted(self.bracket_dirs['server']):
            manifest += f'    "{bracket_dir}/*.lua",\n'
        
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
    parser = argparse.ArgumentParser(description='Generate fxmanifest.lua for Ingenium resource')
    parser.add_argument('--version', '-v', type=str, default='1.0.0', 
                        help='Version number for the manifest (e.g., 1.0.4)')
    args = parser.parse_args()
    
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
    
    print(f"\nGenerating fxmanifest.lua (version {args.version})...")
    manifest = analyzer.generate_manifest(version=args.version)
    
    manifest_path = os.path.join(resource_path, 'fxmanifest.lua')
    with open(manifest_path, 'w', encoding='utf-8') as f:
        f.write(manifest)
    
    print(f"✓ fxmanifest.lua generated successfully")
    print(f"  Output: {manifest_path}")
    print(f"  Version: {args.version}")


if __name__ == '__main__':
    main()
