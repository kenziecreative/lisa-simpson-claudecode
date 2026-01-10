#!/bin/bash

# Brand Compliance Check Script
# Validates content against brand guidelines for Lisa campaigns

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Parse arguments
FILE_PATH=""

if [[ $# -eq 0 ]]; then
  echo "❌ Error: No file path provided" >&2
  echo "" >&2
  echo "Usage: brand-check.sh <file-path>" >&2
  echo "" >&2
  echo "Example:" >&2
  echo "  brand-check.sh deliverables/landing-page.md" >&2
  exit 1
fi

FILE_PATH="$1"

# Validate file exists
if [[ ! -f "$FILE_PATH" ]]; then
  echo "❌ Error: File not found: $FILE_PATH" >&2
  exit 1
fi

# Find brand-config.json (check multiple locations)
BRAND_CONFIG=""
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -f "${SCRIPT_DIR}/brand-config.json" ]]; then
  BRAND_CONFIG="${SCRIPT_DIR}/brand-config.json"
elif [[ -f "brand-config.json" ]]; then
  BRAND_CONFIG="brand-config.json"
elif [[ -f ".claude/plugins/lisa/scripts/brand-config.json" ]]; then
  BRAND_CONFIG=".claude/plugins/lisa/scripts/brand-config.json"
else
  echo "⚠️  Warning: brand-config.json not found - using defaults" >&2
  BRAND_CONFIG=""
fi

# Check if jq is available for JSON parsing
if ! command -v jq &> /dev/null; then
  echo "❌ Error: jq is not installed" >&2
  echo "   Install with: brew install jq (macOS) or apt-get install jq (Linux)" >&2
  exit 1
fi

# Read brand config if available
if [[ -n "$BRAND_CONFIG" ]]; then
  APPROVED_TERMS=$(jq -r '.approvedTerms[]? // empty' "$BRAND_CONFIG" 2>/dev/null || echo "")
  PROHIBITED_TERMS=$(jq -r '.prohibitedTerms[]? // empty' "$BRAND_CONFIG" 2>/dev/null || echo "")
  REQUIRED_TERMS=$(jq -r '.requiredTerms[]? // empty' "$BRAND_CONFIG" 2>/dev/null || echo "")
else
  # Default empty arrays if no config
  APPROVED_TERMS=""
  PROHIBITED_TERMS=""
  REQUIRED_TERMS=""
fi

# Read file content (strip HTML/markdown for plain text comparison)
CONTENT=$(cat "$FILE_PATH")

# Track violations
VIOLATIONS=0
VIOLATION_DETAILS=""

# Check for prohibited terms
if [[ -n "$PROHIBITED_TERMS" ]]; then
  while IFS= read -r term; do
    if [[ -n "$term" ]]; then
      # Case-insensitive search with line numbers
      MATCHES=$(grep -n -i "$term" "$FILE_PATH" || true)
      if [[ -n "$MATCHES" ]]; then
        ((VIOLATIONS++))
        VIOLATION_DETAILS+="❌ Prohibited term '$term' found:\n$MATCHES\n\n"
      fi
    fi
  done <<< "$PROHIBITED_TERMS"
fi

# Check for required terms (at least one occurrence)
if [[ -n "$REQUIRED_TERMS" ]]; then
  while IFS= read -r term; do
    if [[ -n "$term" ]]; then
      # Case-insensitive search
      if ! grep -q -i "$term" "$FILE_PATH"; then
        ((VIOLATIONS++))
        VIOLATION_DETAILS+="⚠️  Required term '$term' not found in content\n\n"
      fi
    fi
  done <<< "$REQUIRED_TERMS"
fi

# Output results
if [[ $VIOLATIONS -eq 0 ]]; then
  echo -e "${GREEN}✅ Brand compliance check passed${NC}"
  echo ""
  echo "File: $FILE_PATH"
  if [[ -n "$BRAND_CONFIG" ]]; then
    echo "Config: $BRAND_CONFIG"
  fi
  echo "No brand guideline violations found."
  exit 0
else
  echo -e "${RED}❌ Brand compliance check failed${NC}" >&2
  echo "" >&2
  echo "File: $FILE_PATH" >&2
  if [[ -n "$BRAND_CONFIG" ]]; then
    echo "Config: $BRAND_CONFIG" >&2
  fi
  echo "" >&2
  echo "Violations found: $VIOLATIONS" >&2
  echo "" >&2
  echo -e "$VIOLATION_DETAILS" >&2
  echo "──────────────────────────────────────────────────────" >&2
  echo "Review brand guidelines and update content to resolve" >&2
  echo "violations before marking deliverable as approved." >&2
  exit 1
fi
