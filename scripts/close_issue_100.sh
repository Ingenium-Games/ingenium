#!/bin/bash
# Helper script to close issue #100 with appropriate documentation
# Usage: ./scripts/close_issue_100.sh

set -e

REPO="Ingenium-Games/ingenium"
ISSUE_NUMBER=100
WORKFLOW_RUN="20992396608"
COMMIT_SHA="eea18041"

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "Error: gh CLI is not installed"
    echo "Install it from: https://cli.github.com/"
    exit 1
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo "Error: Not authenticated with gh CLI"
    echo "Run: gh auth login"
    exit 1
fi

# Prepare comment
COMMENT="## Resolution

This issue has been resolved. The functions listed in this issue were marked with \`@wiki:ignore\` annotations in the codebase and should not have been reported as missing documentation.

### Changes Made

The verification scripts have been updated to respect \`@wiki:ignore\` annotations:

- **Updated**: \`scripts/verify_function_scopes.py\` to skip functions with \`@wiki:ignore\` markers (commit c88d9391)
- **Updated**: \`scripts/create_missing_docs_issues.py\` to prefer verifier JSON output

### Verification

**Workflow run**: [${WORKFLOW_RUN}](https://github.com/${REPO}/actions/runs/${WORKFLOW_RUN}) (SHA: ${COMMIT_SHA}) shows \`{\"mismatches\": []}\`

The latest verification confirms that all \`@wiki:ignore\` markers are being respected and no false positives are being generated.

### Example

From \`server/_data.lua\`:

\`\`\`lua
--- Add a player
---@wiki:ignore
---@param src number
function ig.data.AddPlayer(src)
\`\`\`

Functions marked with \`@wiki:ignore\` are now correctly skipped by the verifier and will not appear in future issue reports.

See \`ISSUE_100_RESOLUTION.md\` for complete documentation."

echo "Closing issue #${ISSUE_NUMBER} in ${REPO}..."
echo ""
echo "Comment to be added:"
echo "===================="
echo "$COMMENT"
echo "===================="
echo ""

# Close the issue with comment
gh issue close ${ISSUE_NUMBER} --repo ${REPO} --comment "$COMMENT"

echo ""
echo "✅ Issue #${ISSUE_NUMBER} has been closed successfully!"
echo "View at: https://github.com/${REPO}/issues/${ISSUE_NUMBER}"
