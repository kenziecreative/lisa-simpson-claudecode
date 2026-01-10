#!/bin/bash

# Lisa Campaign Setup Script
# Initializes campaign state file for multi-discipline creative orchestration

set -euo pipefail

# Parse arguments
CAMPAIGN_BRIEF_PATH=""
MAX_ITERATIONS=30
COMPLETION_PROMISE="COMPLETE"

# Parse options and positional arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      cat << 'HELP_EOF'
Lisa Campaign Setup - Multi-Discipline Creative Orchestration

USAGE:
  setup-lisa-campaign.sh <campaign-brief.json> [OPTIONS]

ARGUMENTS:
  campaign-brief.json    Path to campaign brief JSON file (required)

OPTIONS:
  --max-iterations <n>           Maximum iterations before auto-stop (default: 30)
  --completion-promise '<text>'  Promise phrase (default: 'COMPLETE')
  -h, --help                     Show this help message

DESCRIPTION:
  Initializes a Lisa campaign loop for marketing, PR, or branding deliverables.
  Reads campaign brief JSON and creates state file for the Stop hook.

EXAMPLES:
  setup-lisa-campaign.sh campaign-brief.json
  setup-lisa-campaign.sh campaign-brief.json --max-iterations 50
  setup-lisa-campaign.sh campaign-brief.json --completion-promise 'ALL DONE'
HELP_EOF
      exit 0
      ;;
    --max-iterations)
      if [[ -z "${2:-}" ]]; then
        echo "❌ Error: --max-iterations requires a number argument" >&2
        exit 1
      fi
      if ! [[ "$2" =~ ^[0-9]+$ ]]; then
        echo "❌ Error: --max-iterations must be a positive integer, got: $2" >&2
        exit 1
      fi
      MAX_ITERATIONS="$2"
      shift 2
      ;;
    --completion-promise)
      if [[ -z "${2:-}" ]]; then
        echo "❌ Error: --completion-promise requires a text argument" >&2
        exit 1
      fi
      COMPLETION_PROMISE="$2"
      shift 2
      ;;
    *)
      # First positional argument is campaign brief path
      if [[ -z "$CAMPAIGN_BRIEF_PATH" ]]; then
        CAMPAIGN_BRIEF_PATH="$1"
        shift
      else
        echo "❌ Error: Unexpected argument: $1" >&2
        echo "   Usage: setup-lisa-campaign.sh <campaign-brief.json> [OPTIONS]" >&2
        exit 1
      fi
      ;;
  esac
done

# Validate campaign brief path is provided
if [[ -z "$CAMPAIGN_BRIEF_PATH" ]]; then
  echo "❌ Error: No campaign brief path provided" >&2
  echo "" >&2
  echo "   Usage: setup-lisa-campaign.sh <campaign-brief.json> [OPTIONS]" >&2
  echo "" >&2
  echo "   Examples:" >&2
  echo "     setup-lisa-campaign.sh campaign-brief.json" >&2
  echo "     setup-lisa-campaign.sh my-campaign.json --max-iterations 50" >&2
  echo "" >&2
  echo "   For all options: setup-lisa-campaign.sh --help" >&2
  exit 1
fi

# Validate campaign brief file exists
if [[ ! -f "$CAMPAIGN_BRIEF_PATH" ]]; then
  echo "❌ Error: Campaign brief file not found" >&2
  echo "   Path: $CAMPAIGN_BRIEF_PATH" >&2
  echo "" >&2
  echo "   Make sure the file exists and the path is correct." >&2
  exit 1
fi

# Check if jq is available
if ! command -v jq &> /dev/null; then
  echo "❌ Error: jq is not installed" >&2
  echo "   Lisa requires jq for JSON parsing." >&2
  echo "" >&2
  echo "   Install with:" >&2
  echo "     macOS: brew install jq" >&2
  echo "     Linux: apt-get install jq or yum install jq" >&2
  exit 1
fi

# Validate campaign brief is valid JSON
if ! jq empty "$CAMPAIGN_BRIEF_PATH" 2>/dev/null; then
  echo "❌ Error: Campaign brief is not valid JSON" >&2
  echo "   File: $CAMPAIGN_BRIEF_PATH" >&2
  echo "" >&2
  echo "   Check the file for syntax errors." >&2
  exit 1
fi

# Extract campaign details from brief
CAMPAIGN_NAME=$(jq -r '.campaign // "Untitled Campaign"' "$CAMPAIGN_BRIEF_PATH")
CAMPAIGN_TYPE=$(jq -r '.campaignType // "unknown"' "$CAMPAIGN_BRIEF_PATH")
CAMPAIGN_DESCRIPTION=$(jq -r '.description // ""' "$CAMPAIGN_BRIEF_PATH")

# Validate campaignType is one of the supported types
if [[ "$CAMPAIGN_TYPE" != "marketing" ]] && [[ "$CAMPAIGN_TYPE" != "pr" ]] && [[ "$CAMPAIGN_TYPE" != "branding" ]]; then
  echo "❌ Error: Invalid campaignType in brief" >&2
  echo "   Found: $CAMPAIGN_TYPE" >&2
  echo "   Expected: 'marketing', 'pr', or 'branding'" >&2
  echo "" >&2
  echo "   Check the campaignType field in your campaign brief." >&2
  exit 1
fi

# Count deliverables
DELIVERABLE_COUNT=$(jq '.deliverables | length' "$CAMPAIGN_BRIEF_PATH")

if [[ "$DELIVERABLE_COUNT" -eq 0 ]]; then
  echo "❌ Error: No deliverables found in campaign brief" >&2
  echo "   File: $CAMPAIGN_BRIEF_PATH" >&2
  echo "" >&2
  echo "   Add at least one deliverable to your campaign brief." >&2
  exit 1
fi

# Create .claude directory if it doesn't exist
mkdir -p .claude

# Check if there's already an active campaign
LISA_STATE_FILE=".claude/lisa-campaign.local.md"
if [[ -f "$LISA_STATE_FILE" ]]; then
  echo "⚠️  Warning: An active Lisa campaign already exists" >&2
  echo "   State file: $LISA_STATE_FILE" >&2
  echo "" >&2
  echo "   Use /cancel-lisa to stop the current campaign first." >&2
  exit 1
fi

# Initialize learnings.txt if it doesn't exist
LEARNINGS_FILE="learnings.txt"
if [[ ! -f "$LEARNINGS_FILE" ]]; then
  cat > "$LEARNINGS_FILE" <<'LEARNINGS_EOF'
# Lisa Campaign Learnings

This file captures institutional memory across campaigns and disciplines.
Lisa appends learnings after each deliverable. This is append-only - never delete or modify existing entries.

## Format
[YYYY-MM-DD HH:MM] - [Discipline] - [Deliverable ID] - [Campaign Name]
What was created, files changed, learnings for future iterations

────────────────────────────────────────────────────────────────────

LEARNINGS_EOF
fi

# Build discipline-appropriate prompt based on campaignType
AGENT_PROMPT_PATH="${CLAUDE_PLUGIN_ROOT}/prompts/${CAMPAIGN_TYPE}-agent.md"

# For now, create a basic prompt inline (will be replaced by agent prompt files in US-009)
# This is a temporary simplified version to get the setup script working
PROMPT_BODY=$(cat <<PROMPT_EOF
You are Lisa, an AI ${CAMPAIGN_TYPE} coordinator for Claude Code.

Your task is to work through the campaign brief at: $CAMPAIGN_BRIEF_PATH

## Your Process

1. **Read the campaign brief**
   - Use the Read tool to read: $CAMPAIGN_BRIEF_PATH
   - Understand the campaign: "$CAMPAIGN_NAME"
   - Note the discipline: $CAMPAIGN_TYPE

2. **Pick the next deliverable**
   - Find the highest priority deliverable where approved=false
   - Check dependencies are complete before starting

3. **Create the deliverable**
   - Follow the description and acceptance criteria
   - Save to deliverables/ folder with clear filename
   - Use discipline-appropriate language and format

4. **Check quality**
   - Run appropriate quality checks for $CAMPAIGN_TYPE discipline
   - Ensure all acceptance criteria are met

5. **Update the brief**
   - Mark approved=true in the campaign brief JSON
   - Use Edit tool to update the file

6. **Log learnings**
   - Append insights to learnings.txt
   - Include date, discipline, deliverable ID, what you learned

7. **Check completion**
   - If ALL deliverables have approved=true, output: <promise>$COMPLETION_PROMISE</promise>
   - Otherwise, continue to next deliverable

## Important Guidelines

- Work on ONE deliverable at a time
- NEVER mark approved=true unless ALL acceptance criteria are verified
- Use ${CAMPAIGN_TYPE}-appropriate language and terminology
- Quality checks must pass before approval
- Learnings are append-only (never overwrite)

## Campaign Details

Campaign: $CAMPAIGN_NAME
Type: $CAMPAIGN_TYPE
Deliverables: $DELIVERABLE_COUNT
Brief: $CAMPAIGN_BRIEF_PATH

Begin by reading the campaign brief and selecting the first deliverable to create.
PROMPT_EOF
)

# Quote completion promise for YAML if needed
if [[ -n "$COMPLETION_PROMISE" ]] && [[ "$COMPLETION_PROMISE" != "null" ]]; then
  COMPLETION_PROMISE_YAML="\"$COMPLETION_PROMISE\""
else
  COMPLETION_PROMISE_YAML="null"
fi

# Create state file with YAML frontmatter
cat > "$LISA_STATE_FILE" <<EOF
---
active: true
iteration: 1
max_iterations: $MAX_ITERATIONS
completion_promise: $COMPLETION_PROMISE_YAML
campaign_name: "$CAMPAIGN_NAME"
campaign_type: "$CAMPAIGN_TYPE"
started_at: "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
---

$PROMPT_BODY
EOF

# Output setup message with discipline-appropriate emojis
case "$CAMPAIGN_TYPE" in
  marketing)
    EMOJI="📊"
    DISCIPLINE_NAME="Marketing campaign"
    ;;
  pr)
    EMOJI="📰"
    DISCIPLINE_NAME="PR campaign"
    ;;
  branding)
    EMOJI="🎨"
    DISCIPLINE_NAME="Branding project"
    ;;
  *)
    EMOJI="🔄"
    DISCIPLINE_NAME="Campaign"
    ;;
esac

cat <<EOF
$EMOJI Lisa campaign activated!

$DISCIPLINE_NAME: $CAMPAIGN_NAME
Type: $CAMPAIGN_TYPE
Deliverables: $DELIVERABLE_COUNT
Max iterations: $(if [[ $MAX_ITERATIONS -gt 0 ]]; then echo $MAX_ITERATIONS; else echo "unlimited"; fi)
Completion promise: $COMPLETION_PROMISE

The Stop hook is now active. Lisa will work through each deliverable,
checking quality and updating the campaign brief as she progresses.

Campaign brief: $CAMPAIGN_BRIEF_PATH
Learnings log: $LEARNINGS_FILE
Output folder: deliverables/

$EMOJI
EOF

# Output the prompt body to start the loop
echo ""
echo "$PROMPT_BODY"
