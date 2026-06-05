#!/bin/bash
# sync-elevenlabs.sh — Update ElevenLabs agent system prompts from repo files
#
# Usage: ./_scripts/sync-elevenlabs.sh <path-to-instructions.md>
# Example: ./_scripts/sync-elevenlabs.sh elevenlabs/solomon-1-pain-points/instructions.md
#
# Requires: ELEVENLABS_API_KEY environment variable
# Optional: ELEVENLABS_AGENT_ID overrides the agent_id in YAML frontmatter

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info()  { echo -e "${GREEN}[INFO]${NC}  $*"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; }

# --- Validate input ---

if [ $# -lt 1 ]; then
    echo "Usage: $0 <path-to-instructions.md>"
    echo "Example: $0 elevenlabs/solomon-1-pain-points/instructions.md"
    exit 1
fi

INSTRUCTION_FILE="$1"

if [ ! -f "$INSTRUCTION_FILE" ]; then
    log_error "File not found: $INSTRUCTION_FILE"
    exit 1
fi

if [ -z "${ELEVENLABS_API_KEY:-}" ]; then
    log_error "ELEVENLABS_API_KEY is not set"
    exit 1
fi

# --- Extract YAML frontmatter ---

# Extract agent_id from YAML frontmatter (between first two --- lines)
AGENT_ID="${ELEVENLABS_AGENT_ID:-}"
if [ -z "$AGENT_ID" ]; then
    AGENT_ID=$(sed -n '/^---$/,/^---$/p' "$INSTRUCTION_FILE" | grep 'elevenlabs_agent_id:' | sed 's/.*: *"\(.*\)"/\1/')
    if [ -z "$AGENT_ID" ]; then
        log_error "No elevenlabs_agent_id found in YAML frontmatter and ELEVENLABS_AGENT_ID not set"
        exit 1
    fi
fi

# Extract version from YAML frontmatter
VERSION=$(sed -n '/^---$/,/^---$/p' "$INSTRUCTION_FILE" | grep 'version:' | sed 's/.*: *"\(.*\)"/\1/')
log_info "File:    $INSTRUCTION_FILE"
log_info "Agent:   $AGENT_ID"
log_info "Version: ${VERSION:-unknown}"

# --- Read the full instruction content ---

# Strip YAML frontmatter for the body (everything after second ---)
BODY=$(awk 'BEGIN { c=0 } /^---$/ { c++; next } c >= 2 { print }' "$INSTRUCTION_FILE")

if [ -z "$BODY" ]; then
    log_error "No content found after YAML frontmatter"
    exit 1
fi

CHAR_COUNT=$(echo "$BODY" | wc -c | tr -d ' ')
log_info "Chars:   $CHAR_COUNT"

# --- Call ElevenLabs API ---

log_info "Updating agent via ElevenLabs API..."

# Build JSON payload (escape for JSON)
PAYLOAD=$(jq -n \
    --arg prompt "$BODY" \
    '{conversation_config: {agent: {prompt: {prompt: $prompt}}}}')

RESPONSE=$(curl -s -w "\n%{http_code}" \
    -X PATCH "https://api.elevenlabs.io/v1/convai/agents/$AGENT_ID" \
    -H "Content-Type: application/json" \
    -H "xi-api-key: $ELEVENLABS_API_KEY" \
    -d "$PAYLOAD" 2>&1)

HTTP_CODE=$(echo "$RESPONSE" | tail -1)
BODY_RESPONSE=$(echo "$RESPONSE" | sed '$d')

if [ "$HTTP_CODE" -eq 200 ]; then
    log_info "✅ Agent $AGENT_ID updated successfully (v${VERSION:-unknown})"
    echo "Response: $BODY_RESPONSE" | jq '.agent_id, .name' 2>/dev/null || true
else
    log_error "❌ API returned HTTP $HTTP_CODE"
    echo "$BODY_RESPONSE" | jq '.' 2>/dev/null || echo "$BODY_RESPONSE"
    exit 1
fi
