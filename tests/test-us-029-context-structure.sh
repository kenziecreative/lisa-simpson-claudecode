#!/bin/bash
# Test US-029: Context directory and file structure
# Verifies all acceptance criteria are met

set -e  # Exit on first error

echo "Testing US-029: Context directory and file structure"
echo "======================================================"
echo ""

PLUGIN_ROOT="$HOME/.claude/plugins/marketplaces/local/plugins/lisa"
CONTEXT_DIR="$PLUGIN_ROOT/context"
SCHEMAS_DIR="$PLUGIN_ROOT/schemas"
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

assert_valid_json() {
    if jq empty "$1" 2>/dev/null; then
        echo "✅ VALID JSON: $1"
        ((PASS++))
    else
        echo "❌ INVALID JSON: $1"
        ((FAIL++))
        return 1
    fi
}

assert_json_has_field() {
    if jq -e "$2" "$1" >/dev/null 2>&1; then
        echo "✅ HAS FIELD: $1 has field $2"
        ((PASS++))
    else
        echo "❌ MISSING FIELD: $1 missing field $2"
        ((FAIL++))
        return 1
    fi
}

echo "1. Testing context/ directory exists"
assert_exists "$CONTEXT_DIR"
echo ""

echo "2. Testing templates/ subdirectory exists"
assert_exists "$TEMPLATES_DIR"
echo ""

echo "3. Testing schemas/ directory exists"
assert_exists "$SCHEMAS_DIR"
echo ""

echo "4. Testing context-files.schema.json exists and is valid"
assert_exists "$SCHEMAS_DIR/context-files.schema.json"
assert_valid_json "$SCHEMAS_DIR/context-files.schema.json"
echo ""

echo "5. Testing company-profile.json template"
assert_exists "$TEMPLATES_DIR/company-profile.json"
assert_valid_json "$TEMPLATES_DIR/company-profile.json"
assert_json_has_field "$TEMPLATES_DIR/company-profile.json" ".companyName"
assert_json_has_field "$TEMPLATES_DIR/company-profile.json" ".industry"
assert_json_has_field "$TEMPLATES_DIR/company-profile.json" ".foundedYear"
assert_json_has_field "$TEMPLATES_DIR/company-profile.json" ".teamSize"
assert_json_has_field "$TEMPLATES_DIR/company-profile.json" ".mission"
assert_json_has_field "$TEMPLATES_DIR/company-profile.json" ".valuePropositions"
assert_json_has_field "$TEMPLATES_DIR/company-profile.json" ".targetAudience"
assert_json_has_field "$TEMPLATES_DIR/company-profile.json" ".keyProducts"
assert_json_has_field "$TEMPLATES_DIR/company-profile.json" ".metrics"
assert_json_has_field "$TEMPLATES_DIR/company-profile.json" ".boilerplate"
echo ""

echo "6. Testing brand-voice.json template"
assert_exists "$TEMPLATES_DIR/brand-voice.json"
assert_valid_json "$TEMPLATES_DIR/brand-voice.json"
assert_json_has_field "$TEMPLATES_DIR/brand-voice.json" ".voiceAttributes"
assert_json_has_field "$TEMPLATES_DIR/brand-voice.json" ".toneGuidelines"
assert_json_has_field "$TEMPLATES_DIR/brand-voice.json" ".prohibitedPatterns"
assert_json_has_field "$TEMPLATES_DIR/brand-voice.json" ".signatureMoves"
assert_json_has_field "$TEMPLATES_DIR/brand-voice.json" ".guardrails"
assert_json_has_field "$TEMPLATES_DIR/brand-voice.json" ".examples"
echo ""

echo "7. Testing style-preferences.json template"
assert_exists "$TEMPLATES_DIR/style-preferences.json"
assert_valid_json "$TEMPLATES_DIR/style-preferences.json"
assert_json_has_field "$TEMPLATES_DIR/style-preferences.json" ".styleGuide"
assert_json_has_field "$TEMPLATES_DIR/style-preferences.json" ".spellingChoices"
assert_json_has_field "$TEMPLATES_DIR/style-preferences.json" ".formattingRules"
assert_json_has_field "$TEMPLATES_DIR/style-preferences.json" ".legalDisclaimers"
assert_json_has_field "$TEMPLATES_DIR/style-preferences.json" ".accessibilityStandards"
echo ""

echo "8. Testing readabilityThresholds in style-preferences.json"
assert_json_has_field "$TEMPLATES_DIR/style-preferences.json" ".readabilityThresholds"
assert_json_has_field "$TEMPLATES_DIR/style-preferences.json" ".readabilityThresholds.globalDefault"
assert_json_has_field "$TEMPLATES_DIR/style-preferences.json" ".readabilityThresholds.byDeliverableType"
# Check specific thresholds from testing
assert_json_has_field "$TEMPLATES_DIR/style-preferences.json" '.readabilityThresholds.byDeliverableType."visual-identity-brief"'
assert_json_has_field "$TEMPLATES_DIR/style-preferences.json" '.readabilityThresholds.byDeliverableType."thought-leadership"'
assert_json_has_field "$TEMPLATES_DIR/style-preferences.json" '.readabilityThresholds.byDeliverableType."crisis-response"'
# Verify specific values match testing data
VISUAL_THRESHOLD=$(jq -r '.readabilityThresholds.byDeliverableType."visual-identity-brief"' "$TEMPLATES_DIR/style-preferences.json")
if [ "$VISUAL_THRESHOLD" = "50" ]; then
    echo "✅ CORRECT: visual-identity-brief threshold is 50 (from testing)"
    ((PASS++))
else
    echo "❌ WRONG: visual-identity-brief threshold is $VISUAL_THRESHOLD, expected 50"
    ((FAIL++))
fi
THOUGHT_THRESHOLD=$(jq -r '.readabilityThresholds.byDeliverableType."thought-leadership"' "$TEMPLATES_DIR/style-preferences.json")
if [ "$THOUGHT_THRESHOLD" = "55" ]; then
    echo "✅ CORRECT: thought-leadership threshold is 55 (from testing)"
    ((PASS++))
else
    echo "❌ WRONG: thought-leadership threshold is $THOUGHT_THRESHOLD, expected 55"
    ((FAIL++))
fi
CRISIS_THRESHOLD=$(jq -r '.readabilityThresholds.byDeliverableType."crisis-response"' "$TEMPLATES_DIR/style-preferences.json")
if [ "$CRISIS_THRESHOLD" = "70" ]; then
    echo "✅ CORRECT: crisis-response threshold is 70 (from testing)"
    ((PASS++))
else
    echo "❌ WRONG: crisis-response threshold is $CRISIS_THRESHOLD, expected 70"
    ((FAIL++))
fi
echo ""

echo "9. Testing lisa-memory-core.json template"
assert_exists "$TEMPLATES_DIR/lisa-memory-core.json"
assert_valid_json "$TEMPLATES_DIR/lisa-memory-core.json"
assert_json_has_field "$TEMPLATES_DIR/lisa-memory-core.json" ".version"
assert_json_has_field "$TEMPLATES_DIR/lisa-memory-core.json" ".lastUpdated"
assert_json_has_field "$TEMPLATES_DIR/lisa-memory-core.json" ".entries"
echo ""

echo "10. Testing lisa-memory-contextual.json template"
assert_exists "$TEMPLATES_DIR/lisa-memory-contextual.json"
assert_valid_json "$TEMPLATES_DIR/lisa-memory-contextual.json"
assert_json_has_field "$TEMPLATES_DIR/lisa-memory-contextual.json" ".version"
assert_json_has_field "$TEMPLATES_DIR/lisa-memory-contextual.json" ".lastUpdated"
assert_json_has_field "$TEMPLATES_DIR/lisa-memory-contextual.json" ".entries"
# Check contextual memory has required fields
FIRST_ENTRY=$(jq '.entries[0]' "$TEMPLATES_DIR/lisa-memory-contextual.json")
if echo "$FIRST_ENTRY" | jq -e '.id' >/dev/null 2>&1 && \
   echo "$FIRST_ENTRY" | jq -e '.name' >/dev/null 2>&1 && \
   echo "$FIRST_ENTRY" | jq -e '.category' >/dev/null 2>&1 && \
   echo "$FIRST_ENTRY" | jq -e '.whenToUse' >/dev/null 2>&1 && \
   echo "$FIRST_ENTRY" | jq -e '.content' >/dev/null 2>&1; then
    echo "✅ CORRECT: contextual memory entries have required fields (id, name, category, whenToUse, content)"
    ((PASS++))
else
    echo "❌ MISSING: contextual memory entries missing required fields"
    ((FAIL++))
fi
echo ""

echo "11. Testing .gitignore contains context/ entries"
assert_exists "$PLUGIN_ROOT/.gitignore"
assert_file_contains "$PLUGIN_ROOT/.gitignore" "context/\*.json"
assert_file_contains "$PLUGIN_ROOT/.gitignore" "!context/templates/"
echo ""

echo "12. Testing context/README.md exists"
assert_exists "$CONTEXT_DIR/README.md"
assert_file_contains "$CONTEXT_DIR/README.md" "Quick Start"
assert_file_contains "$CONTEXT_DIR/README.md" "readabilityThresholds"
assert_file_contains "$CONTEXT_DIR/README.md" "Fallback chain"
echo ""

echo "13. Testing schema documentation"
assert_file_contains "$SCHEMAS_DIR/context-files.schema.json" "companyProfile"
assert_file_contains "$SCHEMAS_DIR/context-files.schema.json" "brandVoice"
assert_file_contains "$SCHEMAS_DIR/context-files.schema.json" "stylePreferences"
assert_file_contains "$SCHEMAS_DIR/context-files.schema.json" "lisaMemoryCore"
assert_file_contains "$SCHEMAS_DIR/context-files.schema.json" "lisaMemoryContextual"
assert_file_contains "$SCHEMAS_DIR/context-files.schema.json" "readabilityThresholds"
echo ""

echo "======================================================"
echo "Test Results Summary"
echo "======================================================"
echo "✅ Passed: $PASS"
echo "❌ Failed: $FAIL"
echo ""

if [ $FAIL -eq 0 ]; then
    echo "🎉 ALL TESTS PASSED - US-029 is complete!"
    exit 0
else
    echo "💔 SOME TESTS FAILED - US-029 needs fixes"
    exit 1
fi
