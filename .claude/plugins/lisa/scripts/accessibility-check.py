#!/usr/bin/env python3

"""
Accessibility Check Script
Validates content against WCAG 2.1 AA accessibility standards for Lisa campaigns
"""

import sys
import re
import argparse
from pathlib import Path

try:
    from bs4 import BeautifulSoup
except ImportError:
    print("❌ Error: beautifulsoup4 library not installed", file=sys.stderr)
    print("   Install with: pip install beautifulsoup4", file=sys.stderr)
    print("   Or: pip install -r scripts/requirements.txt", file=sys.stderr)
    sys.exit(1)

try:
    import markdown
except ImportError:
    print("❌ Error: markdown library not installed", file=sys.stderr)
    print("   Install with: pip install markdown", file=sys.stderr)
    print("   Or: pip install -r scripts/requirements.txt", file=sys.stderr)
    sys.exit(1)


def parse_content(file_path):
    """Parse content file (markdown or HTML) and return BeautifulSoup object"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
    except FileNotFoundError:
        print(f"❌ Error: File not found: {file_path}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"❌ Error reading file: {e}", file=sys.stderr)
        sys.exit(1)

    file_ext = Path(file_path).suffix.lower()

    if file_ext in ['.md', '.markdown']:
        # Convert markdown to HTML
        html_content = markdown.markdown(content)
        soup = BeautifulSoup(html_content, 'html.parser')
        is_markdown = True
    elif file_ext in ['.html', '.htm']:
        soup = BeautifulSoup(content, 'html.parser')
        is_markdown = False
    else:
        # Assume plain text
        html_content = f"<div>{content}</div>"
        soup = BeautifulSoup(html_content, 'html.parser')
        is_markdown = False

    return soup, content, is_markdown


def check_heading_hierarchy(soup):
    """Check that headings follow proper hierarchy (H1 → H2 → H3, no skipping)"""
    issues = []

    # Get all heading tags
    headings = soup.find_all(re.compile('^h[1-6]$'))

    if not headings:
        # No headings is okay for some content
        return issues

    prev_level = 0
    for heading in headings:
        current_level = int(heading.name[1])  # Extract number from h1, h2, etc.

        # Check if we skipped a level
        if current_level > prev_level + 1:
            issues.append(f"⚠️  Heading hierarchy skip: {heading.name.upper()} follows H{prev_level} (should not skip levels)")

        prev_level = current_level

    return issues


def check_alt_text(soup):
    """Check that all images have alt text"""
    issues = []

    images = soup.find_all('img')

    for img in images:
        alt = img.get('alt', '')
        src = img.get('src', 'unknown')

        if not alt:
            issues.append(f"❌ Image missing alt text: {src}")
        elif len(alt.strip()) == 0:
            issues.append(f"❌ Image has empty alt text: {src}")

    return issues


def check_semantic_html(soup):
    """Check for semantic HTML usage"""
    issues = []

    # Check for proper use of semantic tags vs divs for navigation, articles, etc.
    # This is a simplified check - full semantic analysis would be more complex

    # Check for links with meaningful text
    links = soup.find_all('a')
    for link in links:
        link_text = link.get_text().strip().lower()
        if link_text in ['click here', 'here', 'read more', 'more']:
            issues.append(f"⚠️  Link text not descriptive: '{link.get_text().strip()}' (use descriptive link text)")

    # Check for proper button/link usage
    buttons_as_links = soup.find_all('a', href='#')
    if buttons_as_links:
        issues.append(f"⚠️  Found {len(buttons_as_links)} links with href='#' (consider using <button> for interactive elements)")

    return issues


def check_color_contrast_warnings(content):
    """
    Provide guidance on color contrast (can't fully check without rendering)
    This is a simplified check that looks for color specifications
    """
    issues = []

    # Check if colors are specified in content
    color_pattern = r'(color|background|bg):\s*#?[0-9a-fA-F]{3,6}'
    if re.search(color_pattern, content):
        issues.append("ℹ️  Colors specified in content - please verify contrast ratios meet WCAG 2.1 AA standards:")
        issues.append("    • Normal text: 4.5:1 contrast ratio")
        issues.append("    • Large text (18pt+ or 14pt+ bold): 3:1 contrast ratio")
        issues.append("    • Use a tool like WebAIM Contrast Checker to verify")

    return issues


def check_accessibility(file_path):
    """
    Check accessibility of content

    Args:
        file_path: Path to content file

    Returns:
        tuple: (passed: bool, issues: list)
    """
    soup, raw_content, is_markdown = parse_content(file_path)

    issues = []

    # 1. Check heading hierarchy
    hierarchy_issues = check_heading_hierarchy(soup)
    issues.extend(hierarchy_issues)

    # 2. Check alt text for images
    alt_text_issues = check_alt_text(soup)
    issues.extend(alt_text_issues)

    # 3. Check semantic HTML
    semantic_issues = check_semantic_html(soup)
    issues.extend(semantic_issues)

    # 4. Color contrast warnings (informational)
    color_issues = check_color_contrast_warnings(raw_content)
    issues.extend(color_issues)

    # Determine pass/fail (fail only on critical issues)
    critical_issues = [i for i in issues if i.startswith('❌')]
    passed = len(critical_issues) == 0

    return passed, issues


def main():
    parser = argparse.ArgumentParser(
        description='Check accessibility of content against WCAG 2.1 AA standards',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  accessibility-check.py deliverables/landing-page.md
  accessibility-check.py deliverables/brand-guidelines.html

WCAG 2.1 AA Checklist:
  ✓ Heading hierarchy: No skipped levels (H1 → H2 → H3)
  ✓ Alt text: All images have descriptive alt text
  ✓ Semantic HTML: Use semantic tags appropriately
  ✓ Link text: Descriptive (not "click here")
  ✓ Color contrast: 4.5:1 for normal text, 3:1 for large text

Note: Full color contrast validation requires visual rendering.
This tool provides guidance on color usage.
        """
    )

    parser.add_argument('file', help='Path to content file to check')

    args = parser.parse_args()

    # Check accessibility
    passed, issues = check_accessibility(args.file)

    # Output results
    if passed:
        print("✅ Accessibility check passed")
        print("")
        print(f"File: {args.file}")
        print("")
        if issues:
            print("Recommendations and notes:")
            for issue in issues:
                print(f"  {issue}")
            print("")
        print("Critical accessibility requirements met (WCAG 2.1 AA).")
        sys.exit(0)
    else:
        print("❌ Accessibility check failed", file=sys.stderr)
        print("", file=sys.stderr)
        print(f"File: {args.file}", file=sys.stderr)
        print("", file=sys.stderr)
        print("Issues found:", file=sys.stderr)
        for issue in issues:
            print(f"  {issue}", file=sys.stderr)
        print("", file=sys.stderr)
        print("──────────────────────────────────────────────────────", file=sys.stderr)
        print("Fix critical issues (❌) to meet WCAG 2.1 AA standards.", file=sys.stderr)
        print("Address warnings (⚠️) for better accessibility.", file=sys.stderr)
        sys.exit(1)


if __name__ == '__main__':
    main()
