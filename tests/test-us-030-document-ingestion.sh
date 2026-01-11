#!/bin/bash
# Test US-030: Document ingestion for company setup
# Verifies setup-company skill exists and has correct structure

set -e  # Exit on first error

echo "Testing US-030: Document ingestion for company setup"
echo "===================================================="
echo ""

PLUGIN_ROOT="$HOME/.claude/plugins/marketplaces/local/plugins/lisa"
SKILL_FILE="$PLUGIN_ROOT/skills/setup-company.md"
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

echo "1. Testing skills/setup-company.md exists"
assert_exists "$SKILL_FILE"
echo ""

echo "2. Testing skill has frontmatter"
assert_file_contains "$SKILL_FILE" "name: setup-company"
assert_file_contains "$SKILL_FILE" "description:"
echo ""

echo "3. Testing skill prompts for document upload/paste"
assert_file_contains_case_insensitive "$SKILL_FILE" "upload"
assert_file_contains_case_insensitive "$SKILL_FILE" "paste"
assert_file_contains_case_insensitive "$SKILL_FILE" "brand guide"
assert_file_contains_case_insensitive "$SKILL_FILE" "style guide"
echo ""

echo "4. Testing skill extracts to company-profile.json"
assert_file_contains "$SKILL_FILE" "company-profile.json"
assert_file_contains "$SKILL_FILE" "companyName"
assert_file_contains "$SKILL_FILE" "mission"
assert_file_contains "$SKILL_FILE" "valuePropositions"
assert_file_contains "$SKILL_FILE" "metrics"
assert_file_contains "$SKILL_FILE" "boilerplate"
echo ""

echo "5. Testing skill extracts to brand-voice.json"
assert_file_contains "$SKILL_FILE" "brand-voice.json"
assert_file_contains "$SKILL_FILE" "voiceAttributes"
assert_file_contains "$SKILL_FILE" "prohibitedPatterns"
assert_file_contains "$SKILL_FILE" "toneGuidelines"
echo ""

echo "6. Testing skill extracts to style-preferences.json"
assert_file_contains "$SKILL_FILE" "style-preferences.json"
assert_file_contains "$SKILL_FILE" "styleGuide"
assert_file_contains "$SKILL_FILE" "formattingRules"
assert_file_contains "$SKILL_FILE" "readabilityThresholds"
echo ""

echo "7. Testing skill identifies gaps"
assert_file_contains_case_insensitive "$SKILL_FILE" "gap"
assert_file_contains_case_insensitive "$SKILL_FILE" "missing"
assert_file_contains_case_insensitive "$SKILL_FILE" "follow-up"
echo ""

echo "8. Testing skill asks follow-up questions"
assert_file_contains_case_insensitive "$SKILL_FILE" "question"
assert_file_contains_case_insensitive "$SKILL_FILE" "ask"
echo ""

echo "9. Testing skill shows preview before saving"
assert_file_contains_case_insensitive "$SKILL_FILE" "preview"
assert_file_contains_case_insensitive "$SKILL_FILE" "before saving"
echo ""

echo "10. Testing skill validates required fields"
assert_file_contains_case_insensitive "$SKILL_FILE" "validate"
assert_file_contains_case_insensitive "$SKILL_FILE" "required"
echo ""

echo "11. Testing skill supports multiple document formats"
assert_file_contains_case_insensitive "$SKILL_FILE" "Google Docs"
assert_file_contains_case_insensitive "$SKILL_FILE" "Notion"
assert_file_contains_case_insensitive "$SKILL_FILE" "PDF"
assert_file_contains_case_insensitive "$SKILL_FILE" "Markdown"
echo ""

echo "12. Testing skill creates verification test"
assert_file_contains_case_insensitive "$SKILL_FILE" "verification"
assert_file_contains_case_insensitive "$SKILL_FILE" "test"
assert_file_contains_case_insensitive "$SKILL_FILE" "sample deliverable"
echo ""

echo "13. Testing skill has clear instructions"
assert_file_contains "$SKILL_FILE" "Step 1"
assert_file_contains "$SKILL_FILE" "Step 2"
assert_file_contains "$SKILL_FILE" "Step 3"
echo ""

echo "14. Testing skill references context templates"
assert_file_contains "$SKILL_FILE" "context/templates"
assert_file_contains "$SKILL_FILE" "context/"
echo ""

echo "15. Testing context templates exist (dependency check)"
assert_exists "$TEMPLATES_DIR/company-profile.json"
assert_exists "$TEMPLATES_DIR/brand-voice.json"
assert_exists "$TEMPLATES_DIR/style-preferences.json"
echo ""

echo "===================================================="
echo "Test Results Summary"
echo "===================================================="
echo "✅ Passed: $PASS"
echo "❌ Failed: $FAIL"
echo ""

if [ $FAIL -eq 0 ]; then
    echo "🎉 ALL TESTS PASSED - US-030 is complete!"
    echo ""
    echo "To test the skill manually:"
    echo "1. Run: claude code"
    echo "2. Use: /setup-company skill"
    echo "3. Provide sample brand document"
    echo "4. Verify it extracts data and creates context files"
    exit 0
else
    echo "💔 SOME TESTS FAILED - US-030 needs fixes"
    exit 1
fi
