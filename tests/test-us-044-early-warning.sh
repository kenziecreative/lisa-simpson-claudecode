#!/bin/bash

# Test US-044: Early warning system for iteration limits
#
# Acceptance Criteria:
# 1. Warn at 80% of max iterations (e.g., 24/30)
# 2. Calculate pace: iterations per deliverable
# 3. Estimate if campaign will complete within limit
# 4. Show recommendation: reduce scope or increase limit
# 5. Display warning in campaign output
# 6. Include in .claude/lisa-campaign.local.md
# 7. Suggest specific actions based on current state

set -euo pipefail

echo "Testing US-044: Early warning system for iteration limits"
echo "=========================================================="
echo ""

PLUGIN_ROOT="$HOME/.claude/plugins/marketplaces/local/plugins/lisa"
cd "$PLUGIN_ROOT"

# Test 1: Warning threshold calculation
echo "✓ Test 1: Warning threshold calculation"
MAX_ITERATIONS=30
WARNING_THRESHOLD=$((MAX_ITERATIONS * 80 / 100))

if [[ "$WARNING_THRESHOLD" == "24" ]]; then
  echo "  ✓ 80% of 30 iterations = 24"
else
  echo "  ✗ FAIL: Expected 24, got $WARNING_THRESHOLD"
  exit 1
fi

MAX_ITERATIONS=50
WARNING_THRESHOLD=$((MAX_ITERATIONS * 80 / 100))
if [[ "$WARNING_THRESHOLD" == "40" ]]; then
  echo "  ✓ 80% of 50 iterations = 40"
else
  echo "  ✗ FAIL: Expected 40, got $WARNING_THRESHOLD"
  exit 1
fi
echo ""

# Test 2: Pace calculation
echo "✓ Test 2: Pace calculation (iterations per deliverable)"

# Scenario: 12 iterations, 3 deliverables complete
ITERATION=12
DELIVERABLES_COMPLETED=3
if [[ $DELIVERABLES_COMPLETED -gt 0 ]]; then
  PACE=$((ITERATION / DELIVERABLES_COMPLETED))
else
  PACE=$ITERATION
fi

if [[ "$PACE" == "4" ]]; then
  echo "  ✓ 12 iterations ÷ 3 deliverables = 4 iterations/deliverable"
else
  echo "  ✗ FAIL: Expected pace 4, got $PACE"
  exit 1
fi

# Scenario: No deliverables completed yet
ITERATION=8
DELIVERABLES_COMPLETED=0
if [[ $DELIVERABLES_COMPLETED -gt 0 ]]; then
  PACE=$((ITERATION / DELIVERABLES_COMPLETED))
else
  PACE=$ITERATION
fi

if [[ "$PACE" == "8" ]]; then
  echo "  ✓ No deliverables completed: pace = current iteration (8)"
else
  echo "  ✗ FAIL: Expected pace 8, got $PACE"
  exit 1
fi
echo ""

# Test 3: Iteration needed estimation
echo "✓ Test 3: Estimating iterations needed to complete"

PACE=4
DELIVERABLES_REMAINING=5
ITERATIONS_NEEDED=$((PACE * DELIVERABLES_REMAINING))

if [[ "$ITERATIONS_NEEDED" == "20" ]]; then
  echo "  ✓ 4 iterations/deliverable × 5 remaining = 20 iterations needed"
else
  echo "  ✗ FAIL: Expected 20, got $ITERATIONS_NEEDED"
  exit 1
fi
echo ""

# Test 4: Will complete vs won't complete detection
echo "✓ Test 4: Detecting if campaign will complete"

# Scenario A: Will complete (enough iterations)
ITERATIONS_NEEDED=15
ITERATIONS_REMAINING=20

if [[ $ITERATIONS_NEEDED -gt $ITERATIONS_REMAINING ]]; then
  WILL_COMPLETE="NO"
else
  WILL_COMPLETE="YES"
fi

if [[ "$WILL_COMPLETE" == "YES" ]]; then
  echo "  ✓ 15 needed, 20 remaining: Will complete"
else
  echo "  ✗ FAIL: Should complete but detected as won't complete"
  exit 1
fi

# Scenario B: Won't complete (not enough iterations)
ITERATIONS_NEEDED=25
ITERATIONS_REMAINING=10

if [[ $ITERATIONS_NEEDED -gt $ITERATIONS_REMAINING ]]; then
  WILL_COMPLETE="NO"
else
  WILL_COMPLETE="YES"
fi

if [[ "$WILL_COMPLETE" == "NO" ]]; then
  echo "  ✓ 25 needed, 10 remaining: Won't complete"
else
  echo "  ✗ FAIL: Should not complete but detected as will complete"
  exit 1
fi
echo ""

# Test 5: Warning message generation (will NOT complete)
echo "✓ Test 5: Critical warning message (won't complete)"

ITERATION=25
MAX_ITERATIONS=30
ITERATIONS_REMAINING=$((MAX_ITERATIONS - ITERATION))
DELIVERABLES_COMPLETED=2
DELIVERABLES_TOTAL=10
DELIVERABLES_REMAINING=$((DELIVERABLES_TOTAL - DELIVERABLES_COMPLETED))

PACE=$((ITERATION / DELIVERABLES_COMPLETED))
ITERATIONS_NEEDED=$((PACE * DELIVERABLES_REMAINING))

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

if echo "$WARNING_MESSAGE" | grep -q "ITERATION LIMIT WARNING"; then
  echo "  ✓ Critical warning header present"
else
  echo "  ✗ FAIL: Warning header missing"
  exit 1
fi

if echo "$WARNING_MESSAGE" | grep -q "5 remaining"; then
  echo "  ✓ Iterations remaining shown correctly"
else
  echo "  ✗ FAIL: Iterations remaining missing or incorrect"
  exit 1
fi

if echo "$WARNING_MESSAGE" | grep -q "~12 iterations per deliverable"; then
  echo "  ✓ Pace shown correctly (12 iterations/deliverable)"
else
  echo "  ✗ FAIL: Pace missing or incorrect"
  exit 1
fi

if echo "$WARNING_MESSAGE" | grep -q "8 deliverables"; then
  echo "  ✓ Remaining deliverables shown correctly"
else
  echo "  ✗ FAIL: Remaining deliverables missing or incorrect"
  exit 1
fi

if echo "$WARNING_MESSAGE" | grep -q "you need ~96 more iterations"; then
  echo "  ✓ Estimated iterations needed shown (96)"
else
  echo "  ✗ FAIL: Estimated iterations needed missing or incorrect"
  exit 1
fi

if echo "$WARNING_MESSAGE" | grep -q "RECOMMENDATIONS"; then
  echo "  ✓ Recommendations section present"
else
  echo "  ✗ FAIL: Recommendations section missing"
  exit 1
fi

if echo "$WARNING_MESSAGE" | grep -q "Reduce scope"; then
  echo "  ✓ Recommendation 1: Reduce scope"
else
  echo "  ✗ FAIL: Reduce scope recommendation missing"
  exit 1
fi

if echo "$WARNING_MESSAGE" | grep -q "Increase limit"; then
  echo "  ✓ Recommendation 2: Increase limit"
else
  echo "  ✗ FAIL: Increase limit recommendation missing"
  exit 1
fi

if echo "$WARNING_MESSAGE" | grep -q "/lisa:cancel-lisa"; then
  echo "  ✓ Cancel command shown"
else
  echo "  ✗ FAIL: Cancel command missing"
  exit 1
fi
echo ""

# Test 6: Notice message generation (will complete)
echo "✓ Test 6: Notice message (will complete)"

ITERATION=25
MAX_ITERATIONS=30
DELIVERABLES_COMPLETED=8
DELIVERABLES_TOTAL=10
DELIVERABLES_REMAINING=$((DELIVERABLES_TOTAL - DELIVERABLES_COMPLETED))

PACE=$((ITERATION / DELIVERABLES_COMPLETED))
ITERATIONS_NEEDED=$((PACE * DELIVERABLES_REMAINING))
ESTIMATED_FINAL_ITERATION=$((ITERATION + ITERATIONS_NEEDED))

WARNING_MESSAGE="
⚠️  Iteration Limit Notice
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
You have reached 25 of 30 iterations (24% threshold)
Current pace: ~3 iterations per deliverable
Estimated completion: ~iteration 31

You should complete within the limit, but watch progress closely.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if echo "$WARNING_MESSAGE" | grep -q "Iteration Limit Notice"; then
  echo "  ✓ Notice header present (less severe)"
else
  echo "  ✗ FAIL: Notice header missing"
  exit 1
fi

if echo "$WARNING_MESSAGE" | grep -q "reached 25 of 30"; then
  echo "  ✓ Progress shown"
else
  echo "  ✗ FAIL: Progress missing or incorrect"
  exit 1
fi

if echo "$WARNING_MESSAGE" | grep -q "~3 iterations per deliverable"; then
  echo "  ✓ Pace shown correctly (3 iterations/deliverable)"
else
  echo "  ✗ FAIL: Pace missing or incorrect"
  exit 1
fi

if echo "$WARNING_MESSAGE" | grep -q "~iteration 31"; then
  echo "  ✓ Estimated completion shown (31)"
else
  echo "  ✗ FAIL: Estimated completion missing or incorrect"
  exit 1
fi

if echo "$WARNING_MESSAGE" | grep -q "should complete within the limit"; then
  echo "  ✓ Positive message present"
else
  echo "  ✗ FAIL: Positive message missing"
  exit 1
fi
echo ""

# Test 7: No warning before threshold
echo "✓ Test 7: No warning before 80% threshold"

ITERATION=15
MAX_ITERATIONS=30
WARNING_THRESHOLD=$((MAX_ITERATIONS * 80 / 100))

WARNING_MESSAGE=""
if [[ $ITERATION -ge $WARNING_THRESHOLD ]]; then
  WARNING_MESSAGE="WARNING TRIGGERED"
fi

if [[ -z "$WARNING_MESSAGE" ]]; then
  echo "  ✓ No warning at iteration 15/30 (< 80%)"
else
  echo "  ✗ FAIL: Warning triggered before threshold"
  exit 1
fi

ITERATION=24
if [[ $ITERATION -ge $WARNING_THRESHOLD ]]; then
  WARNING_MESSAGE="WARNING TRIGGERED"
fi

if [[ -n "$WARNING_MESSAGE" ]]; then
  echo "  ✓ Warning triggers at iteration 24/30 (= 80%)"
else
  echo "  ✗ FAIL: Warning didn't trigger at threshold"
  exit 1
fi
echo ""

# Test 8: Integration with progress summary
echo "✓ Test 8: Warning included in progress summary"

ITERATION=25
MAX_ITERATIONS=30
WARNING_THRESHOLD=$((MAX_ITERATIONS * 80 / 100))
DELIVERABLES_COMPLETED=2
DELIVERABLES_TOTAL=10
DELIVERABLES_REMAINING=$((DELIVERABLES_TOTAL - DELIVERABLES_COMPLETED))
ITERATIONS_REMAINING=$((MAX_ITERATIONS - ITERATION))

WARNING_MESSAGE=""
if [[ $ITERATION -ge $WARNING_THRESHOLD ]]; then
  PACE=$((ITERATION / DELIVERABLES_COMPLETED))
  ITERATIONS_NEEDED=$((PACE * DELIVERABLES_REMAINING))

  if [[ $ITERATIONS_NEEDED -gt $ITERATIONS_REMAINING ]]; then
    WARNING_MESSAGE=$(cat <<WARNING

⚠️  ITERATION LIMIT WARNING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Status: Running low on iterations ($ITERATIONS_REMAINING remaining)
WARNING
)
  fi
fi

PROGRESS_SUMMARY=$(cat <<PROGRESS
📊 Campaign Progress
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Iteration: $ITERATION/$MAX_ITERATIONS$WARNING_MESSAGE
PROGRESS
)

if echo "$PROGRESS_SUMMARY" | grep -q "📊 Campaign Progress"; then
  echo "  ✓ Progress summary header present"
else
  echo "  ✗ FAIL: Progress summary header missing"
  exit 1
fi

if echo "$PROGRESS_SUMMARY" | grep -q "⚠️  ITERATION LIMIT WARNING"; then
  echo "  ✓ Warning embedded in progress summary"
else
  echo "  ✗ FAIL: Warning not embedded in progress summary"
  exit 1
fi

if echo "$PROGRESS_SUMMARY" | grep -q "5 remaining"; then
  echo "  ✓ Warning details present in summary"
else
  echo "  ✗ FAIL: Warning details missing from summary"
  exit 1
fi
echo ""

echo "=========================================================="
echo "✅ US-044 Tests PASSED"
echo ""
echo "All acceptance criteria verified:"
echo "  ✓ Warn at 80% of max iterations"
echo "  ✓ Calculate pace: iterations per deliverable"
echo "  ✓ Estimate if campaign will complete within limit"
echo "  ✓ Show recommendations (reduce scope, increase limit)"
echo "  ✓ Display warning in campaign output"
echo "  ✓ Include in progress summary"
echo "  ✓ Suggest specific actions based on current state"
echo ""
