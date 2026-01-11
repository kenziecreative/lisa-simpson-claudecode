#!/bin/bash
# Test US-033: Company setup documentation and examples
# Verifies setup documentation is complete and accessible

set -e  # Exit on first error

echo "Testing US-033: Company setup documentation and examples"
echo "========================================================="
echo ""

PLUGIN_ROOT="$HOME/.claude/plugins/marketplaces/local/plugins/lisa"
README="$PLUGIN_ROOT/README.md"

# Track test results
PASS=0
FAIL=0

# Helper function for test assertions
assert_file_contains() {
    if grep -q "$2" "$1" 2>/dev/null; then
        echo "✅ CONTAINS: README has '$2'"
        ((PASS++))
    else
        echo "❌ MISSING: README does not contain '$2'"
        ((FAIL++))
        return 1
    fi
}

assert_file_contains_case_insensitive() {
    if grep -iq "$2" "$1" 2>/dev/null; then
        echo "✅ CONTAINS: README has '$2' (case-insensitive)"
        ((PASS++))
    else
        echo "❌ MISSING: README does not contain '$2' (case-insensitive)"
        ((FAIL++))
        return 1
    fi
}

echo "1. Testing README has 'Setting Up Lisa for Your Company' section"
assert_file_contains "$README" "## Setting Up Lisa for Your Company"
echo ""

echo "2. Testing step-by-step instructions for /setup-company skill"
assert_file_contains "$README" "/setup-company"
assert_file_contains_case_insensitive "$README" "run the setup skill"
assert_file_contains_case_insensitive "$README" "step"
echo ""

echo "3. Testing examples of what to provide"
assert_file_contains_case_insensitive "$README" "brand guide"
assert_file_contains_case_insensitive "$README" "style guide"
assert_file_contains_case_insensitive "$README" "company info"
echo ""

echo "4. Testing sample company-profile.json with annotations"
assert_file_contains "$README" "company-profile.json"
assert_file_contains "$README" "companyName"
assert_file_contains "$README" "Acme Analytics"
assert_file_contains_case_insensitive "$README" "Core company facts"
echo ""

echo "5. Testing sample brand-voice.json with examples"
assert_file_contains "$README" "brand-voice.json"
assert_file_contains "$README" "voiceAttributes"
assert_file_contains_case_insensitive "$README" "How your company communicates"
assert_file_contains_case_insensitive "$README" "Clear & Direct"
echo ""

echo "6. Testing plain language explanations"
assert_file_contains_case_insensitive "$README" "What Each File Does"
assert_file_contains_case_insensitive "$README" "Plain Language"
echo ""

echo "7. Testing troubleshooting section"
assert_file_contains_case_insensitive "$README" "Troubleshooting"
assert_file_contains_case_insensitive "$README" "content still feels generic"
assert_file_contains_case_insensitive "$README" "Check if context"
echo ""

echo "8. Testing update instructions"
assert_file_contains_case_insensitive "$README" "update context"
assert_file_contains_case_insensitive "$README" "company evolves"
echo ""

echo "9. Testing verification instructions"
assert_file_contains_case_insensitive "$README" "verification"
assert_file_contains_case_insensitive "$README" "test campaign"
assert_file_contains_case_insensitive "$README" "verify"
echo ""

echo "10. Testing all 5 context files are documented"
assert_file_contains "$README" "company-profile.json"
assert_file_contains "$README" "brand-voice.json"
assert_file_contains "$README" "style-preferences.json"
assert_file_contains "$README" "lisa-memory-core.json"
assert_file_contains "$README" "lisa-memory-contextual.json"
echo ""

echo "11. Testing readability thresholds fallback chain explained"
assert_file_contains_case_insensitive "$README" "fallback chain"
assert_file_contains_case_insensitive "$README" "acceptance criteria"
assert_file_contains_case_insensitive "$README" "style-preferences"
assert_file_contains_case_insensitive "$README" "built-in defaults"
echo ""

echo "12. Testing table of contents includes setup section"
assert_file_contains "$README" "Table of Contents"
assert_file_contains "$README" "[Setting Up Lisa for Your Company]"
echo ""

echo "13. Testing privacy note about context files"
assert_file_contains_case_insensitive "$README" "privacy"
assert_file_contains_case_insensitive "$README" "not committed to git"
echo ""

echo "14. Testing examples from different industries"
# Check that examples are detailed and realistic
if grep -q "Acme Analytics" "$README" && \
   grep -q "SaaS - Business Intelligence" "$README" && \
   grep -q "2,500+ companies" "$README"; then
    echo "✅ Realistic industry example with details"
    ((PASS++))
else
    echo "❌ Missing realistic industry example"
    ((FAIL++))
fi
echo ""

echo "========================================================="
echo "Test Results Summary"
echo "========================================================="
echo "✅ Passed: $PASS"
echo "❌ Failed: $FAIL"
echo ""

if [ $FAIL -eq 0 ]; then
    echo "🎉 ALL TESTS PASSED - US-033 is complete!"
    echo ""
    echo "Setup documentation verified:"
    echo "  ✅ 'Setting Up Lisa for Your Company' section added"
    echo "  ✅ Step-by-step instructions for /setup-company skill"
    echo "  ✅ Examples of documents to provide"
    echo "  ✅ Sample company-profile.json with annotations"
    echo "  ✅ Sample brand-voice.json with examples"
    echo "  ✅ Plain language explanations"
    echo "  ✅ Troubleshooting section"
    echo "  ✅ Update instructions"
    echo "  ✅ Verification instructions"
    echo "  ✅ All 5 context files documented"
    echo "  ✅ Readability fallback chain explained"
    echo "  ✅ Table of contents updated"
    echo "  ✅ Privacy note included"
    echo "  ✅ Realistic industry examples"
    echo ""
    echo "Documentation is accessible and confidence-building for non-technical users."
    exit 0
else
    echo "💔 SOME TESTS FAILED - US-033 needs fixes"
    exit 1
fi
