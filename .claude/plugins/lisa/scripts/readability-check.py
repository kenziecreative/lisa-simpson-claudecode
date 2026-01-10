#!/usr/bin/env python3

"""
Readability Check Script
Validates content readability using Flesch-Kincaid metrics for Lisa campaigns
"""

import sys
import re
import argparse

try:
    import textstat
except ImportError:
    print("❌ Error: textstat library not installed", file=sys.stderr)
    print("   Install with: pip install textstat", file=sys.stderr)
    print("   Or: pip install -r scripts/requirements.txt", file=sys.stderr)
    sys.exit(1)


def strip_markdown(text):
    """Remove markdown formatting to get plain text for readability analysis"""
    # Remove code blocks
    text = re.sub(r'```[\s\S]*?```', '', text)
    text = re.sub(r'`[^`]+`', '', text)

    # Remove HTML tags
    text = re.sub(r'<[^>]+>', '', text)

    # Remove markdown links but keep link text
    text = re.sub(r'\[([^\]]+)\]\([^\)]+\)', r'\1', text)

    # Remove markdown images
    text = re.sub(r'!\[([^\]]*)\]\([^\)]+\)', r'\1', text)

    # Remove markdown headers
    text = re.sub(r'^#{1,6}\s+', '', text, flags=re.MULTILINE)

    # Remove bold/italic markers
    text = re.sub(r'\*\*([^\*]+)\*\*', r'\1', text)
    text = re.sub(r'\*([^\*]+)\*', r'\1', text)
    text = re.sub(r'__([^_]+)__', r'\1', text)
    text = re.sub(r'_([^_]+)_', r'\1', text)

    # Remove horizontal rules
    text = re.sub(r'^[\-\*_]{3,}$', '', text, flags=re.MULTILINE)

    # Remove bullet points
    text = re.sub(r'^\s*[\-\*\+]\s+', '', text, flags=re.MULTILINE)

    # Remove numbered lists
    text = re.sub(r'^\s*\d+\.\s+', '', text, flags=re.MULTILINE)

    # Clean up extra whitespace
    text = re.sub(r'\n\s*\n', '\n\n', text)

    return text.strip()


def check_readability(file_path, threshold=60):
    """
    Check readability of content using Flesch-Kincaid metrics

    Args:
        file_path: Path to content file
        threshold: Minimum Flesch Reading Ease score (default: 60)

    Returns:
        tuple: (passed: bool, reading_ease: float, grade_level: float)
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

    # Strip markdown/HTML formatting
    plain_text = strip_markdown(content)

    if not plain_text.strip():
        print("❌ Error: No text content found after removing formatting", file=sys.stderr)
        print("   File may be empty or contain only markup/code.", file=sys.stderr)
        sys.exit(1)

    # Calculate readability metrics
    reading_ease = textstat.flesch_reading_ease(plain_text)
    grade_level = textstat.flesch_kincaid_grade(plain_text)

    # Determine pass/fail
    passed = reading_ease >= threshold

    return passed, reading_ease, grade_level


def interpret_score(score):
    """Provide human-readable interpretation of Flesch Reading Ease score"""
    if score >= 90:
        return "Very easy to read (5th grade level)"
    elif score >= 80:
        return "Easy to read (6th grade level)"
    elif score >= 70:
        return "Fairly easy to read (7th grade level)"
    elif score >= 60:
        return "Plain English (8th-9th grade level)"
    elif score >= 50:
        return "Fairly difficult to read (10th-12th grade level)"
    elif score >= 30:
        return "Difficult to read (college level)"
    else:
        return "Very difficult to read (college graduate level)"


def main():
    parser = argparse.ArgumentParser(
        description='Check readability of content using Flesch-Kincaid metrics',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  readability-check.py deliverables/landing-page.md
  readability-check.py deliverables/email.md --threshold 65
  readability-check.py deliverables/blog-post.md -t 60

Flesch Reading Ease interpretation:
  90-100: Very easy (5th grade)
  80-89:  Easy (6th grade)
  70-79:  Fairly easy (7th grade)
  60-69:  Plain English (8th-9th grade) ← Default threshold
  50-59:  Fairly difficult (10th-12th grade)
  30-49:  Difficult (college)
  0-29:   Very difficult (college graduate)

Higher scores = easier to read
        """
    )

    parser.add_argument('file', help='Path to content file to check')
    parser.add_argument(
        '-t', '--threshold',
        type=float,
        default=60,
        help='Minimum Flesch Reading Ease score (default: 60)'
    )

    args = parser.parse_args()

    # Check readability
    passed, reading_ease, grade_level = check_readability(args.file, args.threshold)

    # Output results
    if passed:
        print("✅ Readability check passed")
        print("")
        print(f"File: {args.file}")
        print(f"Flesch Reading Ease: {reading_ease:.1f} (threshold: {args.threshold})")
        print(f"Flesch-Kincaid Grade Level: {grade_level:.1f}")
        print(f"Interpretation: {interpret_score(reading_ease)}")
        print("")
        print("Content meets readability standards.")
        sys.exit(0)
    else:
        print("❌ Readability check failed", file=sys.stderr)
        print("", file=sys.stderr)
        print(f"File: {args.file}", file=sys.stderr)
        print(f"Flesch Reading Ease: {reading_ease:.1f} (threshold: {args.threshold})", file=sys.stderr)
        print(f"Flesch-Kincaid Grade Level: {grade_level:.1f}", file=sys.stderr)
        print(f"Interpretation: {interpret_score(reading_ease)}", file=sys.stderr)
        print("", file=sys.stderr)
        print("──────────────────────────────────────────────────────", file=sys.stderr)
        print("To improve readability:", file=sys.stderr)
        print("  • Use shorter sentences (aim for 15-20 words average)", file=sys.stderr)
        print("  • Use simpler words when possible", file=sys.stderr)
        print("  • Break up long paragraphs", file=sys.stderr)
        print("  • Use active voice instead of passive", file=sys.stderr)
        print("  • Avoid jargon and complex terminology", file=sys.stderr)
        sys.exit(1)


if __name__ == '__main__':
    main()
