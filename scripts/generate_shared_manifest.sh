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
  sha="$(curl -sS -H "Authorization: token ${GITHUB_TOKEN}" \
    "${GITHUB_API}/repos/${repo}/git/refs/heads/${ref}" \
    | jq -r '.object.sha' 2>/dev/null || true)"
  if [ -n "${sha}" ] && [ "${sha}" != "null" ]; then
    echo "${sha}"
    return
  fi
  # Try tags ref
  sha="$(curl -sS -H "Authorization: token ${GITHUB_TOKEN}" \
    "${GITHUB_API}/repos/${repo}/git/refs/tags/${ref}" \
    | jq -r '.object.sha' 2>/dev/null || true)"
  if [ -n "${sha}" ] && [ "${sha}" != "null" ]; then
    echo "${sha}"
    return
  fi
  # Assume ref is already a sha
  echo "${ref}"
}

# Build docs JSON array
docs_json="[]"

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
  tree_json="$(curl -sS -H "Authorization: token ${GITHUB_TOKEN}" \
    "${GITHUB_API}/repos/${repo_name}/git/trees/${commit_sha}?recursive=1")"

  # For each markdown file, create an entry
  mapfile -t md_paths < <(echo "${tree_json}" \
    | jq -r '.tree[] | select(.type=="blob") | .path' \
    | grep -E '\\.(md|markdown)$' || true)

  for mdpath in "${md_paths[@]}"; do
    permalink="https://github.com/${repo_name}/blob/${commit_sha}/${mdpath}"
    entry="$(jq -n \
      --arg id "$(basename "${repo_name}")/${mdpath}" \
      --arg repo "${repo_name}" \
      --arg path "${mdpath}" \
      --arg ref "commit:${commit_sha}" \
      --arg permalink "${permalink}" \
      '{id:$id,repo:$repo,path:$path,ref:$ref,permalink:$permalink}')"
    docs_json="$(echo "${docs_json}" | jq ". + [${entry}]")"
  done
done

# Merge docs_json into manifest (YAML)
if [ ! -f "${MANIFEST_PATH}" ]; then
  echo "Error: manifest not found at ${MANIFEST_PATH}"
  exit 1
fi

# Use python3 to merge and write manifest (preserves other fields)
python3 - <<PY
import sys, yaml, json
manpath = "${MANIFEST_PATH}"
m = yaml.safe_load(open(manpath))
docs = json.loads('''${docs_json}''')
m.setdefault('references', {})
m['references']['docs'] = docs
open(manpath, 'w').write(yaml.safe_dump(m, sort_keys=False))
print("Wrote", manpath)
PY

echo "Manifest regenerated at ${MANIFEST_PATH}"
