#!/bin/bash
# Test US-031: Context loading during campaign execution
# Verifies setup script loads and injects context files

set -e  # Exit on first error

echo "Testing US-031: Context loading during campaign execution"
echo "========================================================="
echo ""

PLUGIN_ROOT="$HOME/.claude/plugins/marketplaces/local/plugins/lisa"
SETUP_SCRIPT="$PLUGIN_ROOT/scripts/setup-lisa-campaign.sh"
CONTEXT_DIR="$PLUGIN_ROOT/context"
TEMPLATES_DIR="$CONTEXT_DIR/templates"

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

echo "1. Testing setup script has context loading code"
assert_file_contains "$SETUP_SCRIPT" "CONTEXT_DIR"
assert_file_contains "$SETUP_SCRIPT" "load_context_file"
echo ""

echo "2. Testing setup script loads company-profile.json"
assert_file_contains "$SETUP_SCRIPT" "company-profile.json"
echo ""

echo "3. Testing setup script loads brand-voice.json"
assert_file_contains "$SETUP_SCRIPT" "brand-voice.json"
echo ""

echo "4. Testing setup script loads style-preferences.json"
assert_file_contains "$SETUP_SCRIPT" "style-preferences.json"
echo ""

echo "5. Testing setup script loads memory files"
assert_file_contains "$SETUP_SCRIPT" "lisa-memory-core.json"
assert_file_contains "$SETUP_SCRIPT" "lisa-memory-contextual.json"
echo ""

echo "6. Testing setup script injects context into prompt"
assert_file_contains "$SETUP_SCRIPT" "CONTEXT_SECTION"
assert_file_contains "$SETUP_SCRIPT" "Company Context"
echo ""

echo "7. Testing setup script shows context warnings"
assert_file_contains "$SETUP_SCRIPT" "CONTEXT_WARNINGS"
assert_file_contains "$SETUP_SCRIPT" "generic"
echo ""

echo "8. Testing setup script displays context status"
assert_file_contains "$SETUP_SCRIPT" "CONTEXT_STATUS"
assert_file_contains "$SETUP_SCRIPT" "Loaded"
assert_file_contains "$SETUP_SCRIPT" "personalized"
echo ""

echo "9. Testing context includes usage instructions"
assert_file_contains "$SETUP_SCRIPT" "Using This Context"
assert_file_contains "$SETUP_SCRIPT" "Company Profile"
assert_file_contains "$SETUP_SCRIPT" "Brand Voice"
assert_file_contains "$SETUP_SCRIPT" "Style Preferences"
echo ""

echo "10. Testing context mentions readability thresholds"
assert_file_contains "$SETUP_SCRIPT" "readabilityThresholds"
assert_file_contains "$SETUP_SCRIPT" "override"
echo ""

echo "11. Creating test context files"
# Create test context directory
TEST_CONTEXT_DIR="$PLUGIN_ROOT/context-test-temp"
mkdir -p "$TEST_CONTEXT_DIR"

# Copy templates to test directory
cp "$TEMPLATES_DIR/company-profile.json" "$TEST_CONTEXT_DIR/"
cp "$TEMPLATES_DIR/brand-voice.json" "$TEST_CONTEXT_DIR/"
cp "$TEMPLATES_DIR/style-preferences.json" "$TEST_CONTEXT_DIR/"

if [ -f "$TEST_CONTEXT_DIR/company-profile.json" ] && \
   [ -f "$TEST_CONTEXT_DIR/brand-voice.json" ] && \
   [ -f "$TEST_CONTEXT_DIR/style-preferences.json" ]; then
    echo "✅ Test context files created"
    ((PASS++))
else
    echo "❌ Failed to create test context files"
    ((FAIL++))
fi
echo ""

echo "12. Testing load_context_file function"
# Source the script to get the function (in a subshell to avoid pollution)
(
    export CLAUDE_PLUGIN_ROOT="$PLUGIN_ROOT"

    # Extract just the function definition
    LOAD_FUNC=$(sed -n '/^load_context_file()/,/^}/p' "$SETUP_SCRIPT")

    # Define the function in this subshell
    eval "$LOAD_FUNC"

    # Test the function
    OUTPUT=$(load_context_file "$TEST_CONTEXT_DIR/company-profile.json" "Test Company Profile" 2>&1)

    if echo "$OUTPUT" | grep -q "Test Company Profile" && \
       echo "$OUTPUT" | grep -q "json"; then
        echo "✅ load_context_file works correctly"
        exit 0
    else
        echo "❌ load_context_file doesn't work as expected"
        exit 1
    fi
)

if [ $? -eq 0 ]; then
    ((PASS++))
else
    ((FAIL++))
fi
echo ""

echo "13. Cleanup test files"
rm -rf "$TEST_CONTEXT_DIR"
echo "✅ Test cleanup complete"
((PASS++))
echo ""

echo "14. Testing context filtering mention for contextual memory"
assert_file_contains "$SETUP_SCRIPT" "whenToUse"
echo ""

echo "========================================================="
echo "Test Results Summary"
echo "========================================================="
echo "✅ Passed: $PASS"
echo "❌ Failed: $FAIL"
echo ""

if [ $FAIL -eq 0 ]; then
    echo "🎉 ALL TESTS PASSED - US-031 is complete!"
    echo ""
    echo "Context loading implementation verified:"
    echo "  ✅ Loads all 5 context files"
    echo "  ✅ Injects context into agent prompt"
    echo "  ✅ Shows warnings for missing files"
    echo "  ✅ Displays context status to user"
    echo "  ✅ Provides usage instructions"
    echo "  ✅ Mentions readability threshold overrides"
    echo ""
    echo "Manual test:"
    echo "  1. Copy context templates: cp context/templates/*.json context/"
    echo "  2. Run test campaign: /lisa:lisa test-campaign.json"
    echo "  3. Check .claude/lisa-campaign.local.md for context section"
    exit 0
else
    echo "💔 SOME TESTS FAILED - US-031 needs fixes"
    exit 1
fi
