#!/usr/bin/env bash
# Regenerate .mcp/manifest.yaml.docs by scanning configured repositories for markdown files
# and writing stable blob permalinks (commit SHA). Intended to run in CI (GitHub Actions).
#
# Requirements: GITHUB_TOKEN, jq, python3 (yq optional)
#
# Usage:
#   GITHUB_TOKEN=... ./scripts/generate_shared_manifest.sh
set -euo pipefail

MANIFEST_PATH="${MANIFEST_PATH:-.mcp/manifest.yaml}"
REPOS_ENV="${REPOS:-Ingenium-Games/ingenium:main;Ingenium-Games/ingenium.sql:main}"
GITHUB_API="https://api.github.com"

if [ -z "${GITHUB_TOKEN:-}" ]; then
  echo "Error: GITHUB_TOKEN must be set (use repo token or PAT)"
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "Error: jq is required"
  exit 1
fi

echo "Regenerating ${MANIFEST_PATH} for repos: ${REPOS_ENV}"

# Helper to get commit sha for a ref that may be a branch or a commit sha
get_commit_sha() {
  local repo="$1" ref="$2"
  # Try heads ref
  response="$(curl -sS -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    "${GITHUB_API}/repos/${repo}/git/refs/heads/${ref}" 2>&1)"
  
  # Check if response is valid JSON
  if echo "${response}" | jq empty 2>/dev/null; then
    sha="$(echo "${response}" | jq -r '.object.sha' 2>/dev/null || true)"
    if [ -n "${sha}" ] && [ "${sha}" != "null" ]; then
      echo "${sha}"
      return
    fi
  fi
  
  # Try tags ref
  response="$(curl -sS -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    "${GITHUB_API}/repos/${repo}/git/refs/tags/${ref}" 2>&1)"
  
  # Check if response is valid JSON
  if echo "${response}" | jq empty 2>/dev/null; then
    sha="$(echo "${response}" | jq -r '.object.sha' 2>/dev/null || true)"
    if [ -n "${sha}" ] && [ "${sha}" != "null" ]; then
      echo "${sha}"
      return
    fi
  fi
  
  # Assume ref is already a sha
  echo "${ref}"
}

# Create temporary file for docs JSON and set up cleanup trap
docs_json_tmpfile=$(mktemp)
if [ ! -f "${docs_json_tmpfile}" ]; then
  echo "Error: Failed to create temporary file"
  exit 1
fi
trap 'rm -f "${docs_json_tmpfile}"' EXIT

# Initialize temporary file with empty JSON array
printf '[]' > "${docs_json_tmpfile}"

IFS=';' read -r -a repos_arr <<< "${REPOS_ENV}"
for repo_entry in "${repos_arr[@]}"; do
  repo_entry_trim="$(echo -n "${repo_entry}" | tr -d '[:space:]')"
  repo_name="${repo_entry_trim%%:*}"
  repo_ref="${repo_entry_trim#*:}"
  echo "Processing ${repo_name} @ ${repo_ref}"

  # Get commit sha for ref
  commit_sha="$(get_commit_sha "${repo_name}" "${repo_ref}")"
  echo "Resolved ${repo_ref} -> ${commit_sha}"

  # Get tree (recursive)
  tree_json="$(curl -sS -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    "${GITHUB_API}/repos/${repo_name}/git/trees/${commit_sha}?recursive=1")"

  # Validate tree_json is valid JSON
  if ! echo "${tree_json}" | jq empty 2>/dev/null; then
    echo "Error: Failed to fetch or parse tree for ${repo_name} @ ${commit_sha}"
    echo "Response: ${tree_json}"
    continue
  fi

  # For each markdown file, create an entry
  # Use a more robust method than mapfile with process substitution
  md_paths_raw="$(echo "${tree_json}" \
    | jq -r '.tree[]? | select(.type=="blob") | .path' 2>/dev/null \
    | grep -E '\.(md|markdown)$' || true)"
  
  # Read into array line by line
  md_paths=()
  while IFS= read -r line; do
    if [ -n "${line}" ]; then
      md_paths+=("${line}")
    fi
  done <<< "${md_paths_raw}"

  for mdpath in "${md_paths[@]}"; do
    # Skip empty paths
    if [ -z "${mdpath}" ]; then
      continue
    fi
    permalink="https://github.com/${repo_name}/blob/${commit_sha}/${mdpath}"
    entry="$(jq -n \
      --arg id "$(basename "${repo_name}")/${mdpath}" \
      --arg repo "${repo_name}" \
      --arg path "${mdpath}" \
      --arg ref "commit:${commit_sha}" \
      --arg permalink "${permalink}" \
      '{id:$id,repo:$repo,path:$path,ref:$ref,permalink:$permalink}')"
    docs_json="$(cat "${docs_json_tmpfile}" | jq ". + [${entry}]")"
    printf '%s' "${docs_json}" > "${docs_json_tmpfile}"
  done
done

# Merge docs_json into manifest (YAML)
if [ ! -f "${MANIFEST_PATH}" ]; then
  echo "Error: manifest not found at ${MANIFEST_PATH}"
  exit 1
fi

# Validate docs_json before processing
if ! jq empty < "${docs_json_tmpfile}" 2>/dev/null; then
  echo "Error: docs_json is not valid JSON"
  exit 1
fi

if [ ! -s "${docs_json_tmpfile}" ] || [ "$(cat "${docs_json_tmpfile}")" = "[]" ]; then
  echo "Warning: No markdown files found in configured repositories"
fi

# Use python3 to merge and write manifest (preserves other fields)
python3 - "${MANIFEST_PATH}" "${docs_json_tmpfile}" <<'PY'
import sys
import yaml
import json

# Validate argument count
if len(sys.argv) != 3:
    print("Error: Expected 2 arguments (manifest path and docs JSON file)", file=sys.stderr)
    sys.exit(1)

manpath = sys.argv[1]
docs_json_file = sys.argv[2]

# Validate docs_json_file is not empty
if not docs_json_file or docs_json_file.strip() == "":
    print("Error: docs_json_file argument is empty", file=sys.stderr)
    sys.exit(1)

try:
    # Read docs JSON from file
    with open(docs_json_file, 'r') as jf:
        docs_json_str = jf.read()
    
    # Parse JSON
    try:
        docs = json.loads(docs_json_str)
    except json.JSONDecodeError as e:
        print(f"Error: Failed to parse docs JSON: {e}", file=sys.stderr)
        sys.exit(1)
    
    # Read YAML manifest
    try:
        with open(manpath, 'r') as f:
            m = yaml.safe_load(f)
    except FileNotFoundError:
        print(f"Error: Manifest file not found at {manpath}", file=sys.stderr)
        sys.exit(1)
    except yaml.YAMLError as e:
        print(f"Error: Failed to parse YAML manifest: {e}", file=sys.stderr)
        sys.exit(1)
    
    # Update manifest
    m.setdefault('references', {})
    m['references']['docs'] = docs
    
    # Write updated manifest
    try:
        with open(manpath, 'w') as f:
            f.write(yaml.safe_dump(m, sort_keys=False))
    except IOError as e:
        print(f"Error: Failed to write manifest: {e}", file=sys.stderr)
        sys.exit(1)
    
    print("Wrote", manpath)

except Exception as e:
    print(f"Error: Unexpected error occurred: {e}", file=sys.stderr)
    sys.exit(1)
PY

echo "Manifest regenerated at ${MANIFEST_PATH}"
