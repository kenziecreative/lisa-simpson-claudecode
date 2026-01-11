#!/bin/bash
# Test US-032: Learning from feedback during campaigns
# Verifies feedback capture and memory update functionality

set -e  # Exit on first error

echo "Testing US-032: Learning from feedback during campaigns"
echo "========================================================"
echo ""

PLUGIN_ROOT="$HOME/.claude/plugins/marketplaces/local/plugins/lisa"
SETUP_SCRIPT="$PLUGIN_ROOT/scripts/setup-lisa-campaign.sh"
SHOW_MEMORY_CMD="$PLUGIN_ROOT/commands/show-memory.md"
CONTEXTUAL_MEMORY_TEMPLATE="$PLUGIN_ROOT/context/templates/lisa-memory-contextual.json"

# Track test results
PASS=0
FAIL=0

# Helper function for test assertions
assert_exists() {
    if [ -e "$1" ]; then
        echo "✅ EXISTS: $1"
        ((PASS++))
    else
        echo "❌ MISSING: $1"
        ((FAIL++))
        return 1
    fi
}

assert_file_contains() {
    if grep -q "$2" "$1" 2>/dev/null; then
        echo "✅ CONTAINS: $1 has '$2'"
        ((PASS++))
    else
        echo "❌ MISSING: $1 does not contain '$2'"
        ((FAIL++))
        return 1
    fi
}

assert_file_contains_case_insensitive() {
    if grep -iq "$2" "$1" 2>/dev/null; then
        echo "✅ CONTAINS: $1 has '$2' (case-insensitive)"
        ((PASS++))
    else
        echo "❌ MISSING: $1 does not contain '$2' (case-insensitive)"
        ((FAIL++))
        return 1
    fi
}

echo "1. Testing setup script includes feedback learning instructions"
assert_file_contains "$SETUP_SCRIPT" "Learning From Feedback"
assert_file_contains_case_insensitive "$SETUP_SCRIPT" "wouldn't say it like that"
assert_file_contains_case_insensitive "$SETUP_SCRIPT" "worked really well"
echo ""

echo "2. Testing setup script instructs updating lisa-memory-contextual.json"
assert_file_contains "$SETUP_SCRIPT" "lisa-memory-contextual.json"
assert_file_contains "$SETUP_SCRIPT" "Add a new entry"
echo ""

echo "3. Testing memory entry structure is documented"
assert_file_contains "$SETUP_SCRIPT" "\"id\""
assert_file_contains "$SETUP_SCRIPT" "\"name\""
assert_file_contains "$SETUP_SCRIPT" "\"category\""
assert_file_contains "$SETUP_SCRIPT" "\"whenToUse\""
assert_file_contains "$SETUP_SCRIPT" "\"tags\""
assert_file_contains "$SETUP_SCRIPT" "\"content\""
assert_file_contains "$SETUP_SCRIPT" "\"learnedFrom\""
assert_file_contains "$SETUP_SCRIPT" "\"learnedDate\""
echo ""

echo "4. Testing categories are specified"
assert_file_contains "$SETUP_SCRIPT" "voice"
assert_file_contains "$SETUP_SCRIPT" "formatting"
assert_file_contains "$SETUP_SCRIPT" "content-type-specific"
assert_file_contains "$SETUP_SCRIPT" "quality-threshold"
echo ""

echo "5. Testing example memory entry provided"
assert_file_contains "$SETUP_SCRIPT" "Example memory entry"
assert_file_contains "$SETUP_SCRIPT" "revolutionize"
echo ""

echo "6. Testing confirmation message instructed"
assert_file_contains "$SETUP_SCRIPT" "Learned:"
assert_file_contains "$SETUP_SCRIPT" "I'll apply this"
echo ""

echo "7. Testing show-memory command exists"
assert_exists "$SHOW_MEMORY_CMD"
echo ""

echo "8. Testing show-memory has frontmatter"
assert_file_contains "$SHOW_MEMORY_CMD" "name: show-memory"
assert_file_contains "$SHOW_MEMORY_CMD" "description:"
echo ""

echo "9. Testing show-memory reads both memory files"
assert_file_contains "$SHOW_MEMORY_CMD" "lisa-memory-core.json"
assert_file_contains "$SHOW_MEMORY_CMD" "lisa-memory-contextual.json"
echo ""

echo "10. Testing show-memory displays formatted output"
assert_file_contains "$SHOW_MEMORY_CMD" "Core Memory"
assert_file_contains "$SHOW_MEMORY_CMD" "Contextual Memory"
assert_file_contains "$SHOW_MEMORY_CMD" "When to use"
echo ""

echo "11. Testing contextual memory template exists with correct structure"
assert_exists "$CONTEXTUAL_MEMORY_TEMPLATE"
if jq -e '.version' "$CONTEXTUAL_MEMORY_TEMPLATE" >/dev/null 2>&1 && \
   jq -e '.lastUpdated' "$CONTEXTUAL_MEMORY_TEMPLATE" >/dev/null 2>&1 && \
   jq -e '.entries' "$CONTEXTUAL_MEMORY_TEMPLATE" >/dev/null 2>&1; then
    echo "✅ Contextual memory template has required fields (version, lastUpdated, entries)"
    ((PASS++))
else
    echo "❌ Contextual memory template missing required fields"
    ((FAIL++))
fi
echo ""

echo "12. Testing contextual memory template entry structure"
FIRST_ENTRY=$(jq '.entries[0]' "$CONTEXTUAL_MEMORY_TEMPLATE" 2>/dev/null)
if echo "$FIRST_ENTRY" | jq -e '.id' >/dev/null 2>&1 && \
   echo "$FIRST_ENTRY" | jq -e '.name' >/dev/null 2>&1 && \
   echo "$FIRST_ENTRY" | jq -e '.category' >/dev/null 2>&1 && \
   echo "$FIRST_ENTRY" | jq -e '.whenToUse' >/dev/null 2>&1 && \
   echo "$FIRST_ENTRY" | jq -e '.tags' >/dev/null 2>&1 && \
   echo "$FIRST_ENTRY" | jq -e '.content' >/dev/null 2>&1 && \
   echo "$FIRST_ENTRY" | jq -e '.learnedFrom' >/dev/null 2>&1 && \
   echo "$FIRST_ENTRY" | jq -e '.learnedDate' >/dev/null 2>&1; then
    echo "✅ Contextual memory entry has all required fields"
    ((PASS++))
else
    echo "❌ Contextual memory entry missing required fields"
    ((FAIL++))
fi
echo ""

echo "13. Testing setup script instructs automatic application of patterns"
assert_file_contains "$SETUP_SCRIPT" "Apply learned patterns automatically"
echo ""

echo "14. Testing whenToUse field is emphasized for contextual application"
assert_file_contains "$SETUP_SCRIPT" "whenToUse: Specific conditions"
echo ""

echo "========================================================"
echo "Test Results Summary"
echo "========================================================"
echo "✅ Passed: $PASS"
echo "❌ Failed: $FAIL"
echo ""

if [ $FAIL -eq 0 ]; then
    echo "🎉 ALL TESTS PASSED - US-032 is complete!"
    echo ""
    echo "Feedback learning implementation verified:"
    echo "  ✅ Feedback triggers documented in agent prompt"
    echo "  ✅ Memory update instructions included"
    echo "  ✅ All required fields specified (id, name, category, whenToUse, etc.)"
    echo "  ✅ Four categories defined (voice, formatting, content-type-specific, quality-threshold)"
    echo "  ✅ Example memory entry provided"
    echo "  ✅ Confirmation message instructed"
    echo "  ✅ show-memory command created"
    echo "  ✅ Contextual memory template has correct structure"
    echo "  ✅ Automatic pattern application instructed"
    echo ""
    echo "Manual test workflow:"
    echo "  1. Run a campaign: /lisa:lisa test-campaign.json"
    echo "  2. When Lisa creates content, provide feedback: 'I wouldn't say it like that'"
    echo "  3. Verify Lisa updates context/lisa-memory-contextual.json"
    echo "  4. Check next deliverable applies the learned pattern"
    echo "  5. View memory: /lisa:show-memory"
    exit 0
else
    echo "💔 SOME TESTS FAILED - US-032 needs fixes"
    exit 1
fi
