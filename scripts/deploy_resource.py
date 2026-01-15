#!/usr/bin/env python3
"""
FiveM Resource Deployment Script
Reads fxmanifest.lua and copies only the required files to Desktop
"""

import os
import re
import sys
import shutil
from pathlib import Path
from typing import List, Set

class ManifestParser:
    """Parses fxmanifest.lua to extract file references."""
    
    def __init__(self, manifest_path: str):
        self.manifest_path = Path(manifest_path)
        self.resource_root = self.manifest_path.parent
        self.files_to_copy: Set[str] = set()
        
    def parse_manifest(self) -> Set[str]:
        """Parse fxmanifest.lua and extract all file paths."""
        if not self.manifest_path.exists():
            raise FileNotFoundError(f"Manifest not found: {self.manifest_path}")
        
        with open(self.manifest_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Extract all quoted file paths
        # Matches: "path/to/file.lua" or "path/*.lua"
        pattern = r'["\']([^"\']+)["\']'
        
        matches = re.findall(pattern, content)
        
        for match in matches:
            # Skip non-file patterns
            if match.startswith('/') or match.startswith('--'):
                continue
            
            # Add literal file paths
            if not '*' in match:
                self.files_to_copy.add(match)
            else:
                # Handle glob patterns
                self._expand_glob(match)
        
        return self.files_to_copy
    
    def _expand_glob(self, glob_pattern: str):
        """Expand glob patterns to actual files."""
        # Convert glob pattern to regex
        pattern_dir = glob_pattern.split('*')[0].rstrip('/')
        
        base_path = self.resource_root / pattern_dir
        if not base_path.exists():
            return
        
        # Get all files matching pattern
        if glob_pattern.endswith('/*'):
            # Match all files in directory
            for item in base_path.iterdir():
                if item.is_file():
                    rel_path = str(item.relative_to(self.resource_root)).replace('\\', '/')
                    self.files_to_copy.add(rel_path)
        elif '/**/' in glob_pattern:
            # Recursive glob
            ext = glob_pattern.split('**/')[-1]
            for item in base_path.rglob(f'*{ext}'):
                if item.is_file():
                    rel_path = str(item.relative_to(self.resource_root)).replace('\\', '/')
                    self.files_to_copy.add(rel_path)
    
    def copy_files(self, destination: Path, overwrite: bool = True) -> int:
        """Copy all required files to destination."""
        files_copied = 0
        files_skipped = 0
        
        # Create resource directory
        destination.mkdir(parents=True, exist_ok=True)
        
        for file_path in sorted(self.files_to_copy):
            src = self.resource_root / file_path
            
            # Skip if source doesn't exist
            if not src.exists():
                print(f"  ⚠ SKIP (not found): {file_path}")
                files_skipped += 1
                continue
            
            dst = destination / file_path
            
            # Create destination directory
            dst.parent.mkdir(parents=True, exist_ok=True)
            
            # Check if destination exists
            if dst.exists() and not overwrite:
                print(f"  ⊘ SKIP (exists): {file_path}")
                files_skipped += 1
                continue
            
            try:
                shutil.copy2(src, dst)
                print(f"  ✓ COPY: {file_path}")
                files_copied += 1
            except Exception as e:
                print(f"  ✗ ERROR: {file_path} - {str(e)}")
                files_skipped += 1
        
        return files_copied


def main():
    """Main entry point."""
    
    # Get resource path (where this script is running from)
    if len(sys.argv) > 1:
        resource_path = sys.argv[1]
    else:
        # Try to find resource root by looking for fxmanifest.lua
        resource_path = os.path.dirname(os.path.abspath(__file__))
        # Go up to resource root if in scripts folder
        if resource_path.endswith('scripts'):
            resource_path = os.path.dirname(resource_path)
    
    resource_path = Path(resource_path)
    manifest_path = resource_path / 'fxmanifest.lua'
    
    if not manifest_path.exists():
        print(f"Error: fxmanifest.lua not found at {manifest_path}")
        sys.exit(1)
    
    # Get resource name
    resource_name = resource_path.name
    
    # Destination on Desktop
    desktop = Path.home() / 'Desktop' / resource_name
    
    print(f"📦 FiveM Resource Deployment")
    print(f"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print(f"Resource: {resource_name}")
    print(f"Source: {resource_path}")
    print(f"Destination: {desktop}")
    print(f"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    
    # Check for overwrite mode
    overwrite = True
    if len(sys.argv) > 2 and sys.argv[2].lower() == '--no-overwrite':
        overwrite = False
        print("Mode: Skip existing files")
    else:
        print("Mode: Overwrite existing files")
    
    print(f"\nParsing manifest...")
    parser = ManifestParser(str(manifest_path))
    
    try:
        files = parser.parse_manifest()
        print(f"Found {len(files)} files to copy")
    except Exception as e:
        print(f"Error parsing manifest: {e}")
        sys.exit(1)
    
    print(f"\nCopying files...")
    copied = parser.copy_files(desktop, overwrite=overwrite)
    
    print(f"\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print(f"✓ Deployment complete!")
    print(f"  Files copied: {copied}")
    print(f"  Location: {desktop}")
    print(f"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")


if __name__ == '__main__':
    main()
