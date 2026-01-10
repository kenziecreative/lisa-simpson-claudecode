#!/usr/bin/env python3

"""
SEO Validation Script
Checks basic SEO elements for web content in Lisa marketing campaigns
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
        # Assume plain text, wrap in HTML
        html_content = f"<div>{content}</div>"
        soup = BeautifulSoup(html_content, 'html.parser')
        is_markdown = False

    return soup, content, is_markdown


def calculate_keyword_density(text, keyword):
    """Calculate keyword density as percentage"""
    # Normalize text
    text_lower = text.lower()
    keyword_lower = keyword.lower()

    # Count keyword occurrences
    keyword_count = text_lower.count(keyword_lower)

    # Count total words
    words = re.findall(r'\b\w+\b', text_lower)
    total_words = len(words)

    if total_words == 0:
        return 0.0

    # Calculate density as percentage
    density = (keyword_count / total_words) * 100

    return density


def check_seo(file_path, keyword):
    """
    Check SEO elements of content

    Args:
        file_path: Path to content file
        keyword: Target keyword for SEO optimization

    Returns:
        tuple: (passed: bool, issues: list)
    """
    soup, raw_content, is_markdown = parse_content(file_path)

    issues = []

    # Get all text for keyword density calculation
    text_content = soup.get_text()

    # 1. Check keyword density (2-4% is ideal)
    density = calculate_keyword_density(text_content, keyword)
    if density < 1.0:
        issues.append(f"⚠️  Keyword density too low: {density:.2f}% (target: 2-4%)")
    elif density > 5.0:
        issues.append(f"⚠️  Keyword density too high: {density:.2f}% (target: 2-4%). May appear as keyword stuffing.")
    # else: Good range (1-5%), we're lenient

    # 2. Check for H1 header
    h1_tags = soup.find_all('h1')
    if len(h1_tags) == 0:
        issues.append("❌ No H1 header found (required for SEO)")
    elif len(h1_tags) > 1:
        issues.append(f"⚠️  Multiple H1 headers found ({len(h1_tags)}). Best practice: use only one H1.")

    # 3. Check for H2 headers
    h2_tags = soup.find_all('h2')
    if len(h2_tags) == 0:
        issues.append("⚠️  No H2 headers found (recommended for content structure)")

    # 4. Check for meta description (look in raw content for markdown metadata)
    meta_description = None
    # Check HTML meta tag
    meta_tag = soup.find('meta', attrs={'name': 'description'})
    if meta_tag:
        meta_description = meta_tag.get('content', '')
    else:
        # Check for meta description in markdown frontmatter or content
        meta_match = re.search(r'(?:meta[_ ]?description|description):\s*["\']?([^"\'\n]+)["\']?', raw_content, re.IGNORECASE)
        if meta_match:
            meta_description = meta_match.group(1).strip()

    if not meta_description:
        issues.append("❌ No meta description found (required for search snippets)")
    elif len(meta_description) > 160:
        issues.append(f"⚠️  Meta description too long: {len(meta_description)} chars (recommended: < 160)")

    # 5. Check for title tag (HTML only)
    if not is_markdown:
        title_tag = soup.find('title')
        if not title_tag or not title_tag.get_text().strip():
            issues.append("⚠️  No title tag found (recommended for HTML pages)")

    # 6. Check if keyword appears in H1
    if h1_tags:
        h1_text = ' '.join([h1.get_text() for h1 in h1_tags]).lower()
        if keyword.lower() not in h1_text:
            issues.append(f"⚠️  Target keyword '{keyword}' not found in H1 header (recommended)")

    # Determine pass/fail (fail only on critical issues)
    critical_issues = [i for i in issues if i.startswith('❌')]
    passed = len(critical_issues) == 0

    return passed, issues, density


def main():
    parser = argparse.ArgumentParser(
        description='Check SEO elements of web content',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  seo-check.py deliverables/landing-page.md "AI analytics"
  seo-check.py deliverables/blog-post.md "machine learning"

SEO Checklist:
  ✓ Keyword density: 2-4% (not too low, not keyword stuffing)
  ✓ H1 header: Exactly one, contains target keyword
  ✓ H2 headers: At least one for content structure
  ✓ Meta description: Present, < 160 characters
  ✓ Title tag: Present (HTML files)
        """
    )

    parser.add_argument('file', help='Path to content file to check')
    parser.add_argument('keyword', help='Target keyword for SEO optimization')

    args = parser.parse_args()

    # Check SEO
    passed, issues, density = check_seo(args.file, args.keyword)

    # Output results
    if passed:
        print("✅ SEO check passed")
        print("")
        print(f"File: {args.file}")
        print(f"Target keyword: {args.keyword}")
        print(f"Keyword density: {density:.2f}%")
        print("")
        if issues:
            print("Recommendations (non-critical):")
            for issue in issues:
                print(f"  {issue}")
            print("")
        print("Critical SEO requirements met.")
        sys.exit(0)
    else:
        print("❌ SEO check failed", file=sys.stderr)
        print("", file=sys.stderr)
        print(f"File: {args.file}", file=sys.stderr)
        print(f"Target keyword: {args.keyword}", file=sys.stderr)
        print(f"Keyword density: {density:.2f}%", file=sys.stderr)
        print("", file=sys.stderr)
        print("Issues found:", file=sys.stderr)
        for issue in issues:
            print(f"  {issue}", file=sys.stderr)
        print("", file=sys.stderr)
        print("──────────────────────────────────────────────────────", file=sys.stderr)
        print("Fix critical issues (❌) before marking deliverable as approved.", file=sys.stderr)
        sys.exit(1)


if __name__ == '__main__':
    main()
