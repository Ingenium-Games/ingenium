# .mcp — Manifest for Ingenium + Ingenium.sql

Purpose
This directory contains the MCP manifest and helpers used by Copilot Chat and automated agents to resolve stable references across the Ingenium framework and its SQL handler.

What it does
- Provides a single, versioned mapping of repositories and documentation permalinks.
- Is regenerated automatically when markdown/docs/wiki files change (see workflow).
- Ensures agents always reference exact blob permalinks (commit SHAs), avoiding branch drift.

Where it lives
This manifest lives in the Ingenium-Games/ingenium repository at `.mcp/manifest.yaml`. It references both:
- Ingenium-Games/ingenium (this repo)
- Ingenium-Games/ingenium.sql (SQL handler repo)

How regeneration works
- `scripts/generate_shared_manifest.sh` scans the configured repositories for markdown/docs and writes `.mcp/manifest.yaml` with stable blob permalinks.
- A GitHub Actions workflow `.github/workflows/update-shared-manifest.yml`
  - runs on pushes that change docs (*.md, docs/**, wiki/**)
  - can be triggered manually or scheduled
  - commits the regenerated manifest back to this repo if it changed

Security
- Do NOT store secrets in this manifest.
- The generator uses a token (GITHUB_TOKEN or PAT) to fetch file permalinks. Configure tokens in the repository Secrets.

Usage for agents
- Provide `.mcp/manifest.yaml` as the authoritative mapping at session start (paste contents or give raw permalink).
- Use `.mcp/prompt_template.txt` as the system prompt so agents prefer manifest permalinks and commit SHAs.

If you want me to:
- Generate an initial snapshot (populate `references.docs`) run the generator against actual repo refs — I can do that if you provide a PAT or allow the workflow to run once (it will populate the manifest automatically).
- Move the manifest to a centralized repo, tell me the target repo and access method (PAT vs GITHUB_TOKEN) and I'll adapt the workflow.
