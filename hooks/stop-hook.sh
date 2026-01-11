#!/bin/bash

# Lisa Stop Hook
# Prevents session exit when a Lisa campaign is active
# Feeds Claude's output back as input to continue the campaign loop
# Supports marketing, PR, and branding disciplines

set -euo pipefail

# Read hook input from stdin (advanced stop hook API)
HOOK_INPUT=$(cat)

# Check if Lisa campaign is active
LISA_STATE_FILE=".claude/lisa-campaign.local.md"

if [[ ! -f "$LISA_STATE_FILE" ]]; then
  # No active campaign - allow exit
  exit 0
fi

# Parse markdown frontmatter (YAML between ---) and extract values
FRONTMATTER=$(sed -n '/^---$/,/^---$/{ /^---$/d; p; }' "$LISA_STATE_FILE")
ITERATION=$(echo "$FRONTMATTER" | grep '^iteration:' | sed 's/iteration: *//')
MAX_ITERATIONS=$(echo "$FRONTMATTER" | grep '^max_iterations:' | sed 's/max_iterations: *//')
# Extract completion_promise and strip surrounding quotes if present
COMPLETION_PROMISE=$(echo "$FRONTMATTER" | grep '^completion_promise:' | sed 's/completion_promise: *//' | sed 's/^"\(.*\)"$/\1/')
# Extract campaign details
CAMPAIGN_NAME=$(echo "$FRONTMATTER" | grep '^campaign_name:' | sed 's/campaign_name: *//' | sed 's/^"\(.*\)"$/\1/')
CAMPAIGN_TYPE=$(echo "$FRONTMATTER" | grep '^campaign_type:' | sed 's/campaign_type: *//' | sed 's/^"\(.*\)"$/\1/')
# Extract progress tracking fields (with defaults for backward compatibility)
DELIVERABLES_TOTAL=$(echo "$FRONTMATTER" | grep '^deliverables_total:' | sed 's/deliverables_total: *//')
DELIVERABLES_COMPLETED=$(echo "$FRONTMATTER" | grep '^deliverables_completed:' | sed 's/deliverables_completed: *//')
QUALITY_CHECKS_PASSED=$(echo "$FRONTMATTER" | grep '^quality_checks_passed:' | sed 's/quality_checks_passed: *//')
QUALITY_CHECKS_FAILED=$(echo "$FRONTMATTER" | grep '^quality_checks_failed:' | sed 's/quality_checks_failed: *//')
CURRENT_DELIVERABLE=$(echo "$FRONTMATTER" | grep '^current_deliverable:' | sed 's/current_deliverable: *//' | sed 's/^"\(.*\)"$/\1/')
COMPLEXITY=$(echo "$FRONTMATTER" | grep '^complexity:' | sed 's/complexity: *//' | sed 's/^"\(.*\)"$/\1/')
STARTED_AT=$(echo "$FRONTMATTER" | grep '^started_at:' | sed 's/started_at: *//' | sed 's/^"\(.*\)"$/\1/')

# Set defaults if fields don't exist (backward compatibility)
[[ -z "$DELIVERABLES_TOTAL" ]] && DELIVERABLES_TOTAL=0
[[ -z "$DELIVERABLES_COMPLETED" ]] && DELIVERABLES_COMPLETED=0
[[ -z "$QUALITY_CHECKS_PASSED" ]] && QUALITY_CHECKS_PASSED=0
[[ -z "$QUALITY_CHECKS_FAILED" ]] && QUALITY_CHECKS_FAILED=0
[[ -z "$CURRENT_DELIVERABLE" ]] && CURRENT_DELIVERABLE="In progress"
[[ -z "$COMPLEXITY" ]] && COMPLEXITY="Unknown"

# Validate numeric fields before arithmetic operations
if [[ ! "$ITERATION" =~ ^[0-9]+$ ]]; then
  echo "⚠️  Lisa campaign: State file corrupted" >&2
  echo "   File: $LISA_STATE_FILE" >&2
  echo "   Problem: 'iteration' field is not a valid number (got: '$ITERATION')" >&2
  echo "" >&2
  echo "   This usually means the state file was manually edited or corrupted." >&2
  echo "   Lisa campaign is stopping. Run /lisa again to start fresh." >&2
  rm "$LISA_STATE_FILE"
  exit 0
fi

if [[ ! "$MAX_ITERATIONS" =~ ^[0-9]+$ ]]; then
  echo "⚠️  Lisa campaign: State file corrupted" >&2
  echo "   File: $LISA_STATE_FILE" >&2
  echo "   Problem: 'max_iterations' field is not a valid number (got: '$MAX_ITERATIONS')" >&2
  echo "" >&2
  echo "   This usually means the state file was manually edited or corrupted." >&2
  echo "   Lisa campaign is stopping. Run /lisa again to start fresh." >&2
  rm "$LISA_STATE_FILE"
  exit 0
fi

# Check if max iterations reached
if [[ $MAX_ITERATIONS -gt 0 ]] && [[ $ITERATION -ge $MAX_ITERATIONS ]]; then
  # Use discipline-appropriate messaging
  case "$CAMPAIGN_TYPE" in
    marketing)
      echo "🛑 Marketing campaign: Max iterations ($MAX_ITERATIONS) reached."
      echo "   Campaign: $CAMPAIGN_NAME"
      echo "   Check campaign-brief.json to see which deliverables are complete."
      ;;
    pr)
      echo "🛑 PR campaign: Max iterations ($MAX_ITERATIONS) reached."
      echo "   Campaign: $CAMPAIGN_NAME"
      echo "   Check campaign-brief.json to see which deliverables are complete."
      ;;
    branding)
      echo "🛑 Branding project: Max iterations ($MAX_ITERATIONS) reached."
      echo "   Project: $CAMPAIGN_NAME"
      echo "   Check campaign-brief.json to see which deliverables are complete."
      ;;
    *)
      echo "🛑 Lisa campaign: Max iterations ($MAX_ITERATIONS) reached."
      echo "   Campaign: $CAMPAIGN_NAME"
      ;;
  esac
  rm "$LISA_STATE_FILE"
  exit 0
fi

# Get transcript path from hook input
TRANSCRIPT_PATH=$(echo "$HOOK_INPUT" | jq -r '.transcript_path')

if [[ ! -f "$TRANSCRIPT_PATH" ]]; then
  echo "⚠️  Lisa campaign: Transcript file not found" >&2
  echo "   Expected: $TRANSCRIPT_PATH" >&2
  echo "   This is unusual and may indicate a Claude Code internal issue." >&2
  echo "   Lisa campaign is stopping." >&2
  rm "$LISA_STATE_FILE"
  exit 0
fi

# Read last assistant message from transcript (JSONL format - one JSON per line)
# First check if there are any assistant messages
if ! grep -q '"role":"assistant"' "$TRANSCRIPT_PATH"; then
  echo "⚠️  Lisa campaign: No assistant messages found in transcript" >&2
  echo "   Transcript: $TRANSCRIPT_PATH" >&2
  echo "   This is unusual and may indicate a transcript format issue" >&2
  echo "   Lisa campaign is stopping." >&2
  rm "$LISA_STATE_FILE"
  exit 0
fi

# Extract last assistant message with explicit error handling
LAST_LINE=$(grep '"role":"assistant"' "$TRANSCRIPT_PATH" | tail -1)
if [[ -z "$LAST_LINE" ]]; then
  echo "⚠️  Lisa campaign: Failed to extract last assistant message" >&2
  echo "   Lisa campaign is stopping." >&2
  rm "$LISA_STATE_FILE"
  exit 0
fi

# Parse JSON with error handling
LAST_OUTPUT=$(echo "$LAST_LINE" | jq -r '
  .message.content |
  map(select(.type == "text")) |
  map(.text) |
  join("\n")
' 2>&1)

# Check if jq succeeded
if [[ $? -ne 0 ]]; then
  echo "⚠️  Lisa campaign: Failed to parse assistant message JSON" >&2
  echo "   Error: $LAST_OUTPUT" >&2
  echo "   This may indicate a transcript format issue" >&2
  echo "   Lisa campaign is stopping." >&2
  rm "$LISA_STATE_FILE"
  exit 0
fi

if [[ -z "$LAST_OUTPUT" ]]; then
  echo "⚠️  Lisa campaign: Assistant message contained no text content" >&2
  echo "   Lisa campaign is stopping." >&2
  rm "$LISA_STATE_FILE"
  exit 0
fi

# Check for completion promise (only if set)
if [[ "$COMPLETION_PROMISE" != "null" ]] && [[ -n "$COMPLETION_PROMISE" ]]; then
  # Extract text from <promise> tags using Perl for multiline support
  # -0777 slurps entire input, s flag makes . match newlines
  # .*? is non-greedy (takes FIRST tag), whitespace normalized
  PROMISE_TEXT=$(echo "$LAST_OUTPUT" | perl -0777 -pe 's/.*?<promise>(.*?)<\/promise>.*/$1/s; s/^\s+|\s+$//g; s/\s+/ /g' 2>/dev/null || echo "")

  # Use = for literal string comparison (not pattern matching)
  # == in [[ ]] does glob pattern matching which breaks with *, ?, [ characters
  if [[ -n "$PROMISE_TEXT" ]] && [[ "$PROMISE_TEXT" = "$COMPLETION_PROMISE" ]]; then
    # Use discipline-appropriate celebration messaging
    case "$CAMPAIGN_TYPE" in
      marketing)
        echo "✅ Marketing campaign complete! Detected <promise>$COMPLETION_PROMISE</promise>"
        echo "   Campaign: $CAMPAIGN_NAME"
        echo "   All deliverables approved. Check deliverables/ folder for your content."
        ;;
      pr)
        echo "✅ PR campaign complete! Detected <promise>$COMPLETION_PROMISE</promise>"
        echo "   Campaign: $CAMPAIGN_NAME"
        echo "   All deliverables approved. Check deliverables/ folder for your content."
        ;;
      branding)
        echo "✅ Branding project complete! Detected <promise>$COMPLETION_PROMISE</promise>"
        echo "   Project: $CAMPAIGN_NAME"
        echo "   All deliverables approved. Check deliverables/ folder for your brand assets."
        ;;
      *)
        echo "✅ Lisa campaign complete! Detected <promise>$COMPLETION_PROMISE</promise>"
        echo "   Campaign: $CAMPAIGN_NAME"
        ;;
    esac
    rm "$LISA_STATE_FILE"
    exit 0
  fi
fi

# Calculate time elapsed since campaign start
if [[ -n "$STARTED_AT" ]]; then
  START_EPOCH=$(date -j -u -f "%Y-%m-%dT%H:%M:%SZ" "$STARTED_AT" +%s 2>/dev/null || echo 0)
  CURRENT_EPOCH=$(date -u +%s)
  if [[ $START_EPOCH -gt 0 ]]; then
    ELAPSED_SECONDS=$((CURRENT_EPOCH - START_EPOCH))
    ELAPSED_MINUTES=$((ELAPSED_SECONDS / 60))
    ELAPSED_HOURS=$((ELAPSED_MINUTES / 60))
    ELAPSED_MINS_REMAINDER=$((ELAPSED_MINUTES % 60))

    if [[ $ELAPSED_HOURS -gt 0 ]]; then
      TIME_ELAPSED="${ELAPSED_HOURS}h ${ELAPSED_MINS_REMAINDER}m"
    else
      TIME_ELAPSED="${ELAPSED_MINUTES}m"
    fi
  else
    TIME_ELAPSED="unknown"
  fi
else
  TIME_ELAPSED="unknown"
fi

# Create progress bar (30 characters wide)
if [[ $DELIVERABLES_TOTAL -gt 0 ]]; then
  PROGRESS_PERCENT=$((DELIVERABLES_COMPLETED * 100 / DELIVERABLES_TOTAL))
  PROGRESS_FILLED=$((PROGRESS_PERCENT * 30 / 100))
  PROGRESS_EMPTY=$((30 - PROGRESS_FILLED))

  PROGRESS_BAR=""
  for ((i=0; i<PROGRESS_FILLED; i++)); do
    PROGRESS_BAR+="━"
  done
  for ((i=0; i<PROGRESS_EMPTY; i++)); do
    PROGRESS_BAR+="─"
  done
  PROGRESS_DISPLAY="$PROGRESS_BAR $PROGRESS_PERCENT%"
else
  PROGRESS_DISPLAY="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 0%"
fi

# Early warning system - check if approaching max iterations
WARNING_MESSAGE=""
if [[ $MAX_ITERATIONS -gt 0 ]]; then
  # Calculate warning threshold (80% of max iterations)
  WARNING_THRESHOLD=$((MAX_ITERATIONS * 80 / 100))

  if [[ $ITERATION -ge $WARNING_THRESHOLD ]]; then
    ITERATIONS_REMAINING=$((MAX_ITERATIONS - ITERATION))
    DELIVERABLES_REMAINING=$((DELIVERABLES_TOTAL - DELIVERABLES_COMPLETED))

    # Calculate pace: iterations per deliverable
    if [[ $DELIVERABLES_COMPLETED -gt 0 ]]; then
      PACE=$((ITERATION / DELIVERABLES_COMPLETED))
    else
      # No deliverables completed yet, use conservative estimate
      PACE=$ITERATION
    fi

    # Estimate iterations needed to complete remaining deliverables
    if [[ $DELIVERABLES_REMAINING -gt 0 ]]; then
      ITERATIONS_NEEDED=$((PACE * DELIVERABLES_REMAINING))
    else
      ITERATIONS_NEEDED=0
    fi

    # Check if we'll run out of iterations
    if [[ $ITERATIONS_NEEDED -gt $ITERATIONS_REMAINING ]]; then
      # Will NOT complete - critical warning
      WARNING_MESSAGE=$(cat <<WARNING

⚠️  ITERATION LIMIT WARNING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Status: Running low on iterations ($ITERATIONS_REMAINING remaining)
Current pace: ~$PACE iterations per deliverable
Remaining work: $DELIVERABLES_REMAINING deliverables

⚠️  At current pace, you need ~$ITERATIONS_NEEDED more iterations
   but only have $ITERATIONS_REMAINING remaining.

RECOMMENDATIONS:
1. Reduce scope: Mark some deliverables as lower priority
2. Increase limit: Cancel and restart with higher --max-iterations
3. Simplify: Adjust acceptance criteria to be less complex

To cancel: Use /lisa:cancel-lisa command
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
WARNING
)
    else
      # Should complete, but warn anyway
      ESTIMATED_FINAL_ITERATION=$((ITERATION + ITERATIONS_NEEDED))
      WARNING_MESSAGE=$(cat <<WARNING

⚠️  Iteration Limit Notice
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
You've reached $ITERATION of $MAX_ITERATIONS iterations (${WARNING_THRESHOLD}% threshold)
Current pace: ~$PACE iterations per deliverable
Estimated completion: ~iteration $ESTIMATED_FINAL_ITERATION

You should complete within the limit, but watch progress closely.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
WARNING
)
    fi
  fi
fi

# Build progress summary
PROGRESS_SUMMARY=$(cat <<PROGRESS
📊 Campaign Progress
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Iteration: $ITERATION/$MAX_ITERATIONS
Time elapsed: $TIME_ELAPSED
Complexity: $COMPLEXITY

Deliverables: $DELIVERABLES_COMPLETED/$DELIVERABLES_TOTAL complete
$PROGRESS_DISPLAY

Current: $CURRENT_DELIVERABLE
Quality checks: $QUALITY_CHECKS_PASSED passed, $QUALITY_CHECKS_FAILED failed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$WARNING_MESSAGE
PROGRESS
)

# Not complete - continue loop with SAME PROMPT
NEXT_ITERATION=$((ITERATION + 1))

# Extract prompt (everything after the closing ---)
# Skip first --- line, skip until second --- line, then print everything after
# Use i>=2 instead of i==2 to handle --- in prompt content
PROMPT_TEXT=$(awk '/^---$/{i++; next} i>=2' "$LISA_STATE_FILE")

if [[ -z "$PROMPT_TEXT" ]]; then
  echo "⚠️  Lisa campaign: State file corrupted or incomplete" >&2
  echo "   File: $LISA_STATE_FILE" >&2
  echo "   Problem: No prompt text found" >&2
  echo "" >&2
  echo "   This usually means:" >&2
  echo "     • State file was manually edited" >&2
  echo "     • File was corrupted during writing" >&2
  echo "" >&2
  echo "   Lisa campaign is stopping. Run /lisa again to start fresh." >&2
  rm "$LISA_STATE_FILE"
  exit 0
fi

# Update iteration in frontmatter (portable across macOS and Linux)
# Create temp file, then atomically replace
TEMP_FILE="${LISA_STATE_FILE}.tmp.$$"
sed "s/^iteration: .*/iteration: $NEXT_ITERATION/" "$LISA_STATE_FILE" > "$TEMP_FILE"
mv "$TEMP_FILE" "$LISA_STATE_FILE"

# Build system message with discipline-appropriate terminology and progress
if [[ "$COMPLETION_PROMISE" != "null" ]] && [[ -n "$COMPLETION_PROMISE" ]]; then
  case "$CAMPAIGN_TYPE" in
    marketing)
      SYSTEM_MSG="📊 Marketing campaign - Iteration $NEXT_ITERATION | Campaign: $CAMPAIGN_NAME | To complete: output <promise>$COMPLETION_PROMISE</promise> (ONLY when all deliverables approved=true)

$PROGRESS_SUMMARY"
      ;;
    pr)
      SYSTEM_MSG="📰 PR campaign - Iteration $NEXT_ITERATION | Campaign: $CAMPAIGN_NAME | To complete: output <promise>$COMPLETION_PROMISE</promise> (ONLY when all deliverables approved=true)

$PROGRESS_SUMMARY"
      ;;
    branding)
      SYSTEM_MSG="🎨 Branding project - Iteration $NEXT_ITERATION | Project: $CAMPAIGN_NAME | To complete: output <promise>$COMPLETION_PROMISE</promise> (ONLY when all deliverables approved=true)

$PROGRESS_SUMMARY"
      ;;
    *)
      SYSTEM_MSG="🔄 Lisa iteration $NEXT_ITERATION | Campaign: $CAMPAIGN_NAME | To complete: output <promise>$COMPLETION_PROMISE</promise> (ONLY when all deliverables approved=true)

$PROGRESS_SUMMARY"
      ;;
  esac
else
  SYSTEM_MSG="🔄 Lisa iteration $NEXT_ITERATION | Campaign: $CAMPAIGN_NAME | No completion promise set - loop runs infinitely

$PROGRESS_SUMMARY"
fi

# Output JSON to block the stop and feed prompt back
# The "reason" field contains the prompt that will be sent back to Claude
jq -n \
  --arg prompt "$PROMPT_TEXT" \
  --arg msg "$SYSTEM_MSG" \
  '{
    "decision": "block",
    "reason": $prompt,
    "systemMessage": $msg
  }'

# Exit 0 for successful hook execution
exit 0
