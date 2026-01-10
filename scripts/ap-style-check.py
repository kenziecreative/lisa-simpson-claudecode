#!/usr/bin/env python3

"""
AP Style Check Script
Validates content against AP Stylebook guidelines for Lisa PR campaigns
"""

import sys
import re
import argparse


def check_ap_style(file_path):
    """
    Check content for AP Style compliance

    Args:
        file_path: Path to content file

    Returns:
        tuple: (passed: bool, violations: list, suggestions: list)
    """
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
    except FileNotFoundError:
        print(f"❌ Error: File not found: {file_path}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"❌ Error reading file: {e}", file=sys.stderr)
        sys.exit(1)

    violations = []
    suggestions = []

    # 1. Check for Oxford comma (AP Style doesn't use it)
    # Pattern: word, word, and word
    oxford_pattern = r'\b\w+,\s+\w+,\s+and\s+\w+\b'
    oxford_matches = list(re.finditer(oxford_pattern, content, re.IGNORECASE))
    if oxford_matches:
        for match in oxford_matches[:3]:  # Limit to first 3 examples
            violations.append(f"⚠️  Oxford comma found: '{match.group()}' (AP Style: remove comma before 'and')")

    # 2. Check for common spelling errors
    if re.search(r'\balot\b', content, re.IGNORECASE):
        violations.append("❌ Spelling error: 'alot' should be 'a lot'")

    # 3. Check percent usage (AP Style: use % with numerals)
    percent_word_pattern = r'\b\d+\s+percent\b'
    if re.search(percent_word_pattern, content):
        violations.append("⚠️  Use '%' symbol with numerals (e.g., '50%' not '50 percent')")

    # 4. Check for 'over' vs 'more than' with quantities
    # AP Style prefers 'more than' for quantities, 'over' for spatial relationships
    over_quantity_pattern = r'\bover\s+\d+'
    over_matches = list(re.finditer(over_quantity_pattern, content, re.IGNORECASE))
    if over_matches:
        for match in over_matches[:2]:  # Limit examples
            suggestions.append(f"💡 Consider: '{match.group()}' → use 'more than' for quantities (AP Style preference)")

    # 5. Check date format (AP Style: Month Day, Year)
    # Look for incorrect formats like "January 15th, 2026" or "2026-01-15"
    date_ordinal_pattern = r'\b(January|February|March|April|May|June|July|August|September|October|November|December)\s+\d+(st|nd|rd|th)'
    if re.search(date_ordinal_pattern, content):
        violations.append("⚠️  Date format: Don't use ordinal suffixes (e.g., 'Jan. 15' not 'Jan. 15th')")

    iso_date_pattern = r'\b\d{4}-\d{2}-\d{2}\b'
    if re.search(iso_date_pattern, content):
        suggestions.append("💡 ISO date format found (YYYY-MM-DD). AP Style: use 'Month Day, Year' format")

    # 6. Check time format (AP Style: use a.m./p.m. with space)
    # Look for incorrect formats
    time_wrong_format = r'\b\d{1,2}:\d{2}\s*(AM|PM|am|pm)\b'
    if re.search(time_wrong_format, content):
        violations.append("⚠️  Time format: AP Style uses 'a.m.' and 'p.m.' (lowercase with periods)")

    # 7. Check for double spaces after periods (modern AP Style uses single space)
    if re.search(r'\.\s{2,}', content):
        suggestions.append("💡 Double spaces after periods found. Modern AP Style uses single space.")

    # 8. Check state abbreviations (should be abbreviated in datelines/body text)
    state_full_pattern = r'\b(Alabama|Alaska|Arizona|Arkansas|California|Colorado|Connecticut|Delaware|Florida|Georgia|Idaho|Illinois|Indiana|Iowa|Kansas|Kentucky|Louisiana|Maine|Maryland|Massachusetts|Michigan|Minnesota|Mississippi|Missouri|Montana|Nebraska|Nevada|New Hampshire|New Jersey|New Mexico|New York|North Carolina|North Dakota|Ohio|Oklahoma|Oregon|Pennsylvania|Rhode Island|South Carolina|South Dakota|Tennessee|Texas|Utah|Vermont|Virginia|Washington|West Virginia|Wisconsin|Wyoming)\b'
    state_matches = list(re.finditer(state_full_pattern, content))
    if len(state_matches) > 3:  # If states mentioned frequently, suggest abbreviations
        suggestions.append("💡 Multiple state names found. AP Style: abbreviate states when used with city names")

    # 9. Check for numbers (AP Style: spell out one through nine, use numerals for 10+)
    small_number_pattern = r'\b(?:10|11|12|13|14|15|16|17|18|19|[2-9]\d+)\b(?!\d)'
    # This is informational only, as there are many exceptions in AP Style

    # 10. Check title capitalization (should be lowercase after names)
    title_after_name = r'\b([A-Z][a-z]+\s+[A-Z][a-z]+),\s+([A-Z][a-z]+\s+[A-Z][a-z]+)'
    # Example: "John Smith, Chief Executive Officer" - only flag if multiple capitals after comma
    if re.search(title_after_name, content):
        suggestions.append("💡 Titles: AP Style capitalizes titles before names, lowercase after (e.g., 'CEO Jane Smith' or 'Jane Smith, chief executive officer')")

    # Determine pass/fail (fail on critical errors, warnings are non-blocking)
    critical_violations = [v for v in violations if v.startswith('❌')]
    passed = len(critical_violations) == 0

    return passed, violations, suggestions


def main():
    parser = argparse.ArgumentParser(
        description='Check content for AP Style compliance',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  ap-style-check.py deliverables/press-release.md
  ap-style-check.py deliverables/media-pitch.txt

Common AP Style Rules:
  • No Oxford comma (A, B and C - not A, B, and C)
  • Percent: Use % symbol (50% not 50 percent)
  • Dates: Month Day, Year (Jan. 15, 2026 - not Jan. 15th)
  • Time: 10 a.m., 3:30 p.m. (lowercase with periods)
  • Numbers: Spell out one-nine, numerals for 10+
  • States: Abbreviate with city names (Calif., N.Y.)
  • Titles: Capitalize before names, lowercase after
  • More than (not over) for quantities

This tool checks common AP Style patterns. Always reference
the AP Stylebook for comprehensive guidelines.
        """
    )

    parser.add_argument('file', help='Path to content file to check')

    args = parser.parse_args()

    # Check AP Style
    passed, violations, suggestions = check_ap_style(args.file)

    # Output results
    if passed:
        print("✅ AP Style check passed")
        print("")
        print(f"File: {args.file}")
        print("")
        if violations:
            print("Warnings (non-critical):")
            for violation in violations:
                print(f"  {violation}")
            print("")
        if suggestions:
            print("Style suggestions:")
            for suggestion in suggestions:
                print(f"  {suggestion}")
            print("")
        print("No critical AP Style violations found.")
        sys.exit(0)
    else:
        print("❌ AP Style check failed", file=sys.stderr)
        print("", file=sys.stderr)
        print(f"File: {args.file}", file=sys.stderr)
        print("", file=sys.stderr)
        if violations:
            print("Violations:", file=sys.stderr)
            for violation in violations:
                print(f"  {violation}", file=sys.stderr)
            print("", file=sys.stderr)
        if suggestions:
            print("Suggestions:", file=sys.stderr)
            for suggestion in suggestions:
                print(f"  {suggestion}", file=sys.stderr)
            print("", file=sys.stderr)
        print("──────────────────────────────────────────────────────", file=sys.stderr)
        print("Fix critical violations (❌) before approval.", file=sys.stderr)
        print("Address warnings (⚠️) for better AP Style compliance.", file=sys.stderr)
        sys.exit(1)


if __name__ == '__main__':
    main()
