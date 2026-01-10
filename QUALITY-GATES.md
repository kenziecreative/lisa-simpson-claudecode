# Quality Gates Documentation

**Automated quality checks for Lisa deliverables**

Lisa ensures every deliverable meets discipline-appropriate quality standards before marking it as approved. This document explains how each quality gate works, which disciplines use which checks, and how to configure or customize them.

---

## Table of Contents

- [Overview](#overview)
- [Quality Gates Matrix](#quality-gates-matrix)
- [Quality Check Scripts](#quality-check-scripts)
  - [Brand Compliance Check](#brand-compliance-check)
  - [Readability Check](#readability-check)
  - [SEO Check](#seo-check)
  - [Accessibility Check](#accessibility-check)
  - [AP Style Check](#ap-style-check)
- [Configuration](#configuration)
  - [Brand Guidelines](#brand-guidelines)
  - [Readability Thresholds](#readability-thresholds)
  - [SEO Configuration](#seo-configuration)
- [Integration with Lisa](#integration-with-lisa)
- [Exit Code Conventions](#exit-code-conventions)
- [Examples: Passing vs. Failing Content](#examples-passing-vs-failing-content)
- [Adding Custom Quality Checks](#adding-custom-quality-checks)
- [Troubleshooting](#troubleshooting)

---

## Overview

Quality gates are automated checks that run against deliverables before Lisa marks them as approved. Each discipline uses a specific combination of quality gates appropriate to its needs:

- **Marketing**: Brand compliance, readability, SEO, accessibility
- **PR**: Brand compliance, readability, AP Style
- **Branding**: Brand compliance, accessibility

All quality checks are Python scripts located in `.claude/plugins/lisa/scripts/quality/`. They read deliverable content, perform automated analysis, and return exit codes indicating pass (0) or fail (1).

---

## Quality Gates Matrix

| Quality Gate | Marketing | PR | Branding | Purpose |
|--------------|-----------|-----|----------|---------|
| **Brand Compliance** | ✅ | ✅ | ✅ | Ensures brand terminology, voice, and guidelines are followed |
| **Readability** | ✅ | ✅ | ❌ | Checks Flesch Reading Ease score for target audience clarity |
| **SEO** | ✅ | ❌ | ❌ | Validates keyword usage, meta descriptions, heading structure |
| **Accessibility** | ✅ | ❌ | ✅ | Checks alt text, heading hierarchy, color contrast mentions |
| **AP Style** | ❌ | ✅ | ❌ | Validates Associated Press style for media communications |

**Why different gates for different disciplines?**

- **Marketing** needs all checks except AP Style (uses conversational brand voice, not journalistic style)
- **PR** needs brand compliance, readability, and AP Style (journalistic standards), but not SEO (media decides publication)
- **Branding** focuses on strategic clarity (brand compliance) and accessibility, not readability scores (varies by deliverable type)

---

## Quality Check Scripts

### Brand Compliance Check

**Script**: `scripts/quality/check-brand-compliance.py`

**Purpose**: Ensures deliverables follow brand guidelines including approved terminology, voice characteristics, and messaging principles.

**How it works**:
1. Reads `scripts/quality/brand-config.json` containing brand rules
2. Scans deliverable content for:
   - **Required terms**: Brand-specific language that should appear
   - **Prohibited terms**: Words/phrases to avoid (competitors, outdated terms, jargon)
   - **Voice violations**: Detects tone mismatches (e.g., overly casual in formal contexts)
   - **Messaging consistency**: Checks alignment with positioning statements

**Usage**:
```bash
python3 scripts/quality/check-brand-compliance.py deliverables/MKT-001-landing-page.md
```

**Sample Output (Pass)**:
```
✅ Brand compliance check passed
- Found 3 required brand terms
- No prohibited terms detected
- Voice tone appropriate for audience
```

**Sample Output (Fail)**:
```
❌ Brand compliance check failed

Issues found:
- Prohibited term used: "cheap" (line 23) - Use "affordable" or "cost-effective"
- Missing required term: Product name should appear in first paragraph
- Voice violation: Overly casual tone detected in heading (line 5)
```

**Configuration**: See [Brand Guidelines Configuration](#brand-guidelines)

---

### Readability Check

**Script**: `scripts/quality/check-readability.py`

**Purpose**: Ensures content is readable for target audience using Flesch Reading Ease scoring.

**How it works**:
1. Calculates Flesch Reading Ease score (0-100 scale)
2. Compares to discipline-specific thresholds:
   - **Marketing**: Score ≥ 60 (standard, conversational)
   - **PR**: Score ≥ 60 (accessible to general business audience)
3. Analyzes sentence length, word complexity, paragraph structure

**Flesch Reading Ease Scale**:
- **90-100**: Very easy (5th grade level)
- **80-89**: Easy (6th grade)
- **70-79**: Fairly easy (7th grade)
- **60-69**: Standard (8th-9th grade) ← **Target for marketing/PR**
- **50-59**: Fairly difficult (10th-12th grade)
- **30-49**: Difficult (college level)
- **0-29**: Very difficult (graduate level)

**Usage**:
```bash
python3 scripts/quality/check-readability.py deliverables/MKT-002-email-sequence.md
```

**Sample Output (Pass)**:
```
✅ Readability check passed

Flesch Reading Ease: 67.3
Target: ≥ 60
Grade level: 8th-9th grade (appropriate for general business audience)

Metrics:
- Average sentence length: 15 words (good)
- Average syllables per word: 1.6 (conversational)
- Longest sentence: 24 words (acceptable)
```

**Sample Output (Fail)**:
```
❌ Readability check failed

Flesch Reading Ease: 48.2
Target: ≥ 60
Grade level: College level (too complex for target audience)

Issues:
- Average sentence length: 28 words (too long, aim for <20)
- 15 sentences exceed 30 words
- Passive voice detected in 8 sentences (use active voice)

Suggestions:
1. Break long sentences into shorter ones
2. Replace complex words: "utilize" → "use", "leverage" → "use"
3. Convert passive constructions to active voice
```

**Configuration**: See [Readability Thresholds Configuration](#readability-thresholds)

---

### SEO Check

**Script**: `scripts/quality/check-seo.py`

**Purpose**: Validates SEO best practices for web content including keyword usage, meta descriptions, and heading structure.

**How it works**:
1. Checks if `targetKeyword` is specified in campaign brief
2. Validates keyword presence in:
   - Title/H1 heading
   - First paragraph
   - At least one H2 heading
   - Throughout content (1-2% density)
3. Checks meta description (if present): 150-160 characters
4. Validates heading hierarchy (H1 → H2 → H3, no skipping levels)
5. Checks for alt text placeholders in images

**Usage**:
```bash
python3 scripts/quality/check-seo.py deliverables/MKT-003-blog-post.md --keyword "enterprise automation"
```

**Sample Output (Pass)**:
```
✅ SEO check passed

Target keyword: "enterprise automation"
- Found in title: ✓
- Found in first paragraph: ✓
- Found in H2 heading: ✓
- Keyword density: 1.4% (optimal: 1-2%)
- Meta description: 156 characters ✓
- Heading hierarchy: Valid (H1 → H2 → H3)
- Images with alt text: 3/3 ✓
```

**Sample Output (Fail)**:
```
❌ SEO check failed

Target keyword: "enterprise automation"

Issues:
- Keyword NOT found in title
- Keyword appears only once (insufficient, aim for 1-2% density)
- Meta description missing or too long (178 characters, max 160)
- Heading hierarchy broken: H1 → H3 (skipped H2)
- 2 images missing alt text

Recommendations:
1. Include "enterprise automation" in title/H1
2. Use keyword naturally in 2-3 more locations
3. Shorten meta description to 150-160 characters
4. Add H2 headings before H3 subheadings
5. Add descriptive alt text to all images
```

**Configuration**: See [SEO Configuration](#seo-configuration)

---

### Accessibility Check

**Script**: `scripts/quality/check-accessibility.py`

**Purpose**: Ensures content follows accessibility best practices for users with disabilities.

**How it works**:
1. **Heading hierarchy**: Validates no levels are skipped (H1 → H2 → H3)
2. **Alt text**: Checks all images have descriptive alt text
3. **Link text**: Ensures links have descriptive text (not "click here")
4. **Color references**: Flags color-only instructions (e.g., "click the red button")
5. **Acronyms**: Checks first usage of acronyms includes full form
6. **Table structure**: Validates tables have headers

**Usage**:
```bash
python3 scripts/quality/check-accessibility.py deliverables/BRD-001-brand-positioning.md
```

**Sample Output (Pass)**:
```
✅ Accessibility check passed

Checks performed:
- Heading hierarchy: Valid (H1 → H2 → H2 → H3)
- Images with alt text: 2/2 ✓
- Link text descriptive: 8/8 links ✓
- No color-only instructions detected
- Acronyms defined: 3/3 ✓
```

**Sample Output (Fail)**:
```
❌ Accessibility check failed

Issues:
- Heading hierarchy: H1 → H3 (skipped H2 on line 45)
- Image missing alt text: logo.png (line 12)
- Non-descriptive link: "click here" (line 67) - describe destination
- Color-only instruction: "See the red box for details" (line 89)
  Suggestion: "See the 'Key Features' box for details"
- Undefined acronym: "CTR" first used on line 34 without definition

Recommendations:
1. Add H2 heading before H3 on line 45
2. Add alt text: ![Company logo](logo.png) → ![Company logo: TechFlow enterprise automation platform](logo.png)
3. Replace "click here" with "Read our accessibility guidelines"
4. Define CTR on first usage: "click-through rate (CTR)"
```

**Configuration**: No configuration required (follows WCAG 2.1 standards)

---

### AP Style Check

**Script**: `scripts/quality/check-ap-style.py`

**Purpose**: Validates Associated Press style for PR materials including press releases, media pitches, and statements.

**How it works**:
1. **Date format**: Checks dates follow AP style (Jan. 15, 2026, not 1/15/26)
2. **Time format**: Validates time format (9 a.m. ET, not 9:00am)
3. **Number usage**: Numbers 0-9 spelled out, 10+ as numerals (with exceptions)
4. **State abbreviations**: Uses AP state abbreviations (Calif., not CA)
5. **Punctuation**: Oxford comma, single space after periods, quote mark placement
6. **Titles**: Capitalization rules for job titles, composition titles
7. **Company references**: First reference full name, subsequent can be shortened

**Usage**:
```bash
python3 scripts/quality/check-ap-style.py deliverables/PR-001-press-release.md
```

**Sample Output (Pass)**:
```
✅ AP Style check passed

Validated:
- Dates: 3 dates in correct AP format
- Times: 2 times correctly formatted (9 a.m. ET, 2:30 p.m. PT)
- Numbers: Correct usage (nine, 10, 250,000)
- Titles: Proper capitalization for job titles
- Company names: First reference full, subsequent shortened appropriately
```

**Sample Output (Fail)**:
```
❌ AP Style check failed

Issues:
- Date format: "1/15/2026" (line 12) → Use "Jan. 15, 2026"
- Time format: "9:00am" (line 23) → Use "9 a.m." (lowercase, space before a.m.)
- Number: "10" spelled out (line 34) → Use numeral "10" (spell 0-9, numerals 10+)
- State: "California" (line 45) → Use "Calif." on first reference
- Title: "Chief Executive Officer" (line 8) → lowercase: "chief executive officer" (only capitalize before name)
- Quote placement: "innovation". (line 56) → Period goes inside quotes: "innovation."

Corrections needed: 6
Refer to: AP Stylebook sections on dates, numbers, titles
```

**Configuration**: No configuration required (follows AP Stylebook standards)

---

## Configuration

### Brand Guidelines

**File**: `scripts/quality/brand-config.json`

This file defines brand-specific terminology, voice rules, and messaging guidelines that the brand compliance check enforces.

**Structure**:
```json
{
  "brand_name": "TechFlow",
  "required_terms": {
    "product_name": ["TechFlow", "TechFlow Platform"],
    "tagline": ["Enterprise automation for everyone"],
    "key_terms": ["workflow automation", "enterprise-grade", "accessible"]
  },
  "prohibited_terms": [
    {
      "term": "cheap",
      "reason": "Diminishes premium positioning",
      "alternatives": ["affordable", "cost-effective", "competitive pricing"]
    },
    {
      "term": "simple",
      "reason": "Implies limited capability",
      "alternatives": ["accessible", "intuitive", "user-friendly"]
    },
    {
      "term": "easy",
      "reason": "Overused, lacks specificity",
      "alternatives": ["streamlined", "efficient", "straightforward"]
    }
  ],
  "voice_characteristics": {
    "professional_approachable_ratio": 0.65,
    "confident_humble_ratio": 0.70,
    "technical_plain_ratio": 0.60,
    "serious_playful_ratio": 0.80
  },
  "messaging_pillars": [
    "Enterprise Power",
    "Accessible to All",
    "IT Confidence"
  ],
  "competitor_terms_to_avoid": ["SAP", "Oracle", "Zapier", "ServiceNow"]
}
```

**How to customize**:

1. **Update brand name**:
   ```json
   "brand_name": "YourCompany"
   ```

2. **Add required terms** that should appear in deliverables:
   ```json
   "required_terms": {
     "product_name": ["YourProduct", "YourProduct Suite"],
     "key_terms": ["your", "unique", "value", "props"]
   }
   ```

3. **Add prohibited terms** with alternatives:
   ```json
   "prohibited_terms": [
     {
       "term": "word_to_avoid",
       "reason": "Why we don't use this",
       "alternatives": ["better", "words", "to", "use"]
     }
   ]
   ```

4. **Adjust voice ratios** (0.0 to 1.0 scale):
   - Higher = more of first characteristic
   - Lower = more of second characteristic
   - Example: `0.65` means 65% professional, 35% approachable

5. **Update messaging pillars** from your brand positioning:
   ```json
   "messaging_pillars": [
     "Your First Pillar",
     "Your Second Pillar",
     "Your Third Pillar"
   ]
   ```

**Testing your configuration**:
```bash
# Validate JSON syntax
python3 -m json.tool scripts/quality/brand-config.json

# Test against a deliverable
python3 scripts/quality/check-brand-compliance.py deliverables/test-content.md
```

---

### Readability Thresholds

**File**: `scripts/quality/check-readability.py` (edit threshold variables)

By default, Lisa requires a Flesch Reading Ease score of **≥ 60** for marketing and PR content. You can adjust this threshold based on your audience.

**Editing thresholds**:

1. Open `scripts/quality/check-readability.py`
2. Find the threshold configuration section:
   ```python
   # Readability thresholds by discipline
   THRESHOLDS = {
       'marketing': 60,  # Standard/conversational (8th-9th grade)
       'pr': 60,         # Accessible to business audience
   }
   ```

3. Adjust values based on your audience:
   ```python
   # For technical audiences (developer docs, whitepapers)
   THRESHOLDS = {
       'marketing': 50,  # Fairly difficult (10th-12th grade)
       'pr': 60,
   }

   # For consumer audiences (broader public)
   THRESHOLDS = {
       'marketing': 70,  # Fairly easy (7th grade)
       'pr': 65,
   }
   ```

**Flesch score guidelines by audience**:

| Audience Type | Recommended Score | Grade Level | Example Content |
|---------------|-------------------|-------------|-----------------|
| General public | 70-80 | 7th-8th grade | Consumer marketing, news articles |
| Business professionals | 60-70 | 8th-9th grade | B2B marketing, press releases |
| Technical users | 50-60 | 10th-12th grade | Product documentation, technical blogs |
| Academic/Expert | 30-50 | College+ | Whitepapers, research papers |

**Testing custom thresholds**:
```bash
# Check readability with verbose output
python3 scripts/quality/check-readability.py deliverables/test-content.md --verbose
```

---

### SEO Configuration

**File**: `scripts/quality/check-seo.py` (edit configuration variables)

SEO checks validate keyword usage and content structure. Default settings work for most cases, but you can customize density targets and meta description length.

**Editing SEO settings**:

1. Open `scripts/quality/check-seo.py`
2. Find configuration section:
   ```python
   # SEO configuration
   KEYWORD_DENSITY_MIN = 0.01  # 1%
   KEYWORD_DENSITY_MAX = 0.02  # 2%
   META_DESCRIPTION_MIN = 150
   META_DESCRIPTION_MAX = 160
   ```

3. Adjust based on your SEO strategy:
   ```python
   # More aggressive keyword targeting
   KEYWORD_DENSITY_MIN = 0.015  # 1.5%
   KEYWORD_DENSITY_MAX = 0.025  # 2.5%

   # Longer meta descriptions (some search engines show up to 165)
   META_DESCRIPTION_MAX = 165
   ```

**Important notes**:
- **Keyword density** above 3% may trigger spam filters
- **Meta descriptions** longer than 160 characters may be truncated in search results
- Always prioritize **natural language** over keyword stuffing

**Testing SEO configuration**:
```bash
# Check SEO with specific keyword
python3 scripts/quality/check-seo.py deliverables/blog-post.md --keyword "your target keyword"
```

---

## Integration with Lisa

Quality gates are automatically integrated into Lisa's orchestration loop. Here's how they work in practice:

### 1. Deliverable Creation

Lisa creates a deliverable based on the campaign brief description and saves it to `deliverables/` folder.

### 2. Quality Check Selection

Based on the deliverable's campaign type, Lisa determines which quality checks to run:

```python
# Pseudo-code showing Lisa's logic
if campaign_type == "marketing":
    quality_checks = [
        "check-brand-compliance.py",
        "check-readability.py",
        "check-seo.py",
        "check-accessibility.py"
    ]
elif campaign_type == "pr":
    quality_checks = [
        "check-brand-compliance.py",
        "check-readability.py",
        "check-ap-style.py"
    ]
elif campaign_type == "branding":
    quality_checks = [
        "check-brand-compliance.py",
        "check-accessibility.py"
    ]
```

### 3. Running Quality Checks

Lisa runs each applicable check:

```bash
cd .claude/plugins/lisa
python3 scripts/quality/check-brand-compliance.py ../../deliverables/MKT-001-landing-page.md
python3 scripts/quality/check-readability.py ../../deliverables/MKT-001-landing-page.md
python3 scripts/quality/check-seo.py ../../deliverables/MKT-001-landing-page.md --keyword "enterprise automation"
python3 scripts/quality/check-accessibility.py ../../deliverables/MKT-001-landing-page.md
```

### 4. Handling Results

- **All checks pass (exit code 0)**: Lisa marks `approved: true` in campaign brief and proceeds to next deliverable
- **Any check fails (exit code 1)**: Lisa reads failure details, revises the deliverable, and re-runs checks

### 5. Retry Logic

Lisa attempts up to **3 revisions** per deliverable to pass quality checks:

1. **First attempt**: Create deliverable based on description
2. **If fails**: Revise based on quality check feedback
3. **If fails again**: More targeted revision addressing specific issues
4. **If fails third time**: Mark as approved with quality warning in learnings.txt

### 6. Learnings Logging

After approval, Lisa logs quality insights to `learnings.txt`:

```
[2026-01-10 14:30] - Marketing - MKT-001 - Q1 Product Launch
Created: Landing page copy (deliverables/MKT-001-product-landing-page.md)
Key insights: Benefit-driven headlines performed better than feature lists.
Placing CTAs both above and below the fold increased conversions.
Quality: Passed all checks on first attempt. Flesch score: 67 (target audience fit).
Marketing-specific notes: SEO keyword density at 1.6% performed well without feeling forced.
```

---

## Exit Code Conventions

All quality check scripts follow standard Unix exit code conventions:

| Exit Code | Meaning | Lisa's Action |
|-----------|---------|---------------|
| **0** | ✅ Check passed | Proceed to next check or mark approved |
| **1** | ❌ Check failed | Read failure output, revise deliverable, retry |
| **2** | ⚠️ Configuration error | Alert user about misconfiguration (e.g., missing brand-config.json) |

**Example exit code handling**:

```bash
# Running a quality check manually
python3 scripts/quality/check-readability.py deliverables/test.md
echo $?  # Prints exit code: 0 (pass) or 1 (fail)

# Using in scripts
if python3 scripts/quality/check-readability.py deliverables/test.md; then
    echo "✅ Readability check passed"
else
    echo "❌ Readability check failed"
fi
```

**Exit code in Python scripts**:

```python
import sys

# Pass
sys.exit(0)

# Fail
sys.exit(1)

# Configuration error
sys.exit(2)
```

---

## Examples: Passing vs. Failing Content

### Marketing Example: Landing Page Hero Copy

#### ❌ Failing Content

```markdown
# Maximize Your Potential with Our Revolutionary Solution

Are you tired of dealing with outdated, clunky software that doesn't meet your needs?
Our cheap, simple platform is easy to use and will help you streamline your workflow
and increase productivity by leveraging cutting-edge technology that utilizes AI to
facilitate enhanced optimization of your business processes, enabling you to achieve
unprecedented levels of efficiency and effectiveness.

Click here to learn more!
```

**Why it fails**:
- **Brand compliance**: Uses prohibited terms ("cheap", "simple", "easy")
- **Readability**: Flesch score ~35 (very difficult) - second sentence is 52 words
- **SEO**: Target keyword missing, no H2 headings, "click here" non-descriptive link
- **Accessibility**: "Click here" link text not descriptive

#### ✅ Passing Content

```markdown
# Enterprise Automation That Works for Everyone

Business teams waste hours on repetitive tasks. IT teams can't keep up with automation requests.
TechFlow bridges this gap with enterprise-grade workflow automation that's accessible to all users.

## Built for Complexity, Designed for Humans

Handle any workflow, any scale, any compliance requirement—without extensive IT resources or technical training.

- **Enterprise Power**: Process automation for complex business needs
- **User-Friendly**: No-code interface business users actually want to use
- **IT Confidence**: Security, governance, and control teams demand

[Start your free trial](https://techflow.com/trial) or [watch a 2-minute demo](https://techflow.com/demo).
```

**Why it passes**:
- **Brand compliance**: Uses approved terms, avoids prohibited words, confident yet accessible tone
- **Readability**: Flesch score 68 (standard, conversational) - short sentences, clear language
- **SEO**: Keyword in H1, natural usage throughout, proper heading hierarchy, descriptive links
- **Accessibility**: Descriptive link text, clear heading structure, alt text for images (if present)

---

### PR Example: Press Release Opening

#### ❌ Failing Content

```markdown
# Company Announces New Product

SAN FRANCISCO, 1/15/26 - We're excited to announce our new product is available.
The CEO said "This is a game changer." The product has lots of features and will help
businesses. For more information click here.
```

**Why it fails**:
- **Brand compliance**: Vague language, no brand messaging pillars
- **Readability**: Flesch score ~75 but lacks substance
- **AP Style**: Multiple violations:
  - Date format: "1/15/26" → "Jan. 15, 2026"
  - Contractions: "We're" → "Company Name is"
  - Numbers: "lots of" imprecise
  - Vague attribution: "The CEO" → "CEO Name, Title"
  - "click here" instead of URL or specific instruction

#### ✅ Passing Content

```markdown
# TechFlow Launches AI-Powered Enterprise Automation Platform

**SAN FRANCISCO, Jan. 15, 2026** — TechFlow today announced the general availability
of its AI-powered enterprise automation platform, the first solution to combine
enterprise-grade workflow capabilities with natural language processing and predictive analytics.

Three Fortune 500 companies have already adopted the platform, reducing automation
deployment time from months to weeks while empowering business users to create
workflows without extensive IT support.

"Enterprises are stuck between legacy systems that require armies of IT specialists
and consumer tools that lack the power for complex business needs," said Sarah Chen,
CEO of TechFlow. "We built TechFlow to bridge that gap—delivering enterprise capability
with consumer-grade accessibility."

For more information, visit www.techflow.com or contact [email protected].
```

**Why it passes**:
- **Brand compliance**: Uses messaging pillars, avoids prohibited terms, appropriate tone
- **Readability**: Flesch score 62 (accessible to business audience)
- **AP Style**: Correct date format, proper attribution, precise numbers, formatted city/state

---

### Branding Example: Brand Positioning Statement

#### ❌ Failing Content

```markdown
# Brand Positioning

Our company is the best in the industry. We make great products that customers love.
See the blue box for our competitive advantages. Visit our website to learn more.
```

**Why it fails**:
- **Brand compliance**: Generic language, no specific positioning framework, "best" is unsupported claim
- **Accessibility**:
  - Color-only reference: "blue box"
  - Non-descriptive link: "Visit our website"
  - No heading hierarchy (jumps from H1 to content)

#### ✅ Passing Content

```markdown
# TechFlow Brand Positioning Statement

## Target Audience

Enterprise technology decision-makers (CIOs, CTOs, VP Engineering) at mid-to-large
companies (500+ employees) seeking to modernize operations while maintaining security
and compliance standards.

**Demographics**: Technology leaders, 35-55 years old, managing teams of 10-500+
**Psychographics**: Value both innovation and reliability, frustrated by tradeoffs
between powerful-but-complex and simple-but-limited tools

## Positioning Statement

For enterprise technology leaders who need to scale automation without scaling IT resources,
TechFlow is the enterprise workflow automation platform that simplifies complex business
processes with powerful yet accessible automation.

Unlike legacy enterprise software (SAP, Oracle) that requires extensive IT resources,
or simple consumer tools (Zapier) that lack enterprise capabilities, TechFlow bridges
the gap with enterprise-grade power and consumer-grade ease of use.

## Competitive Positioning

[Competitive Positioning Map - visualizing TechFlow's unique position]

**TechFlow's unique space**: High capability + High accessibility

- **Legacy enterprise (SAP, Oracle)**: High capability, Low accessibility
- **Consumer tools (Zapier)**: Low capability, High accessibility
- **IT-centric platforms (ServiceNow)**: Medium capability, Low accessibility
- **TechFlow**: High capability, High accessibility

## Reason to Believe

- 10,000+ users across 50+ enterprise customers
- Average deployment time: 2 weeks (vs. 6 months for legacy systems)
- 94% user satisfaction score
- SOC 2 Type II, ISO 27001 certified
- 500+ pre-built integrations with enterprise systems
```

**Why it passes**:
- **Brand compliance**: Follows positioning framework, uses approved terms, clear differentiation
- **Accessibility**:
  - Clear heading hierarchy (H1 → H2)
  - Descriptive headings and labels
  - Competitive map referenced with context ("visualizing TechFlow's unique position")
  - No color-only instructions

---

## Adding Custom Quality Checks

You can extend Lisa's quality system by adding custom checks for your specific needs.

### Step 1: Create a Quality Check Script

Create a new Python script in `scripts/quality/`:

```bash
touch scripts/quality/check-custom.py
chmod +x scripts/quality/check-custom.py
```

### Step 2: Follow the Standard Template

```python
#!/usr/bin/env python3
"""
Custom Quality Check for Lisa
Description: What this check validates
"""

import sys
import argparse

def check_custom_quality(file_path):
    """
    Perform custom quality check on deliverable

    Args:
        file_path: Path to deliverable file

    Returns:
        tuple: (passed: bool, issues: list)
    """
    issues = []

    # Read file
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
    except FileNotFoundError:
        print(f"❌ Error: File not found: {file_path}", file=sys.stderr)
        sys.exit(2)  # Configuration error

    # Perform your custom checks
    # Example: Check for specific patterns
    if "forbidden_pattern" in content:
        issues.append("Found forbidden pattern on line X")

    # Return results
    passed = len(issues) == 0
    return passed, issues

def main():
    parser = argparse.ArgumentParser(description='Custom quality check')
    parser.add_argument('file_path', help='Path to deliverable file')
    args = parser.parse_args()

    passed, issues = check_custom_quality(args.file_path)

    if passed:
        print("✅ Custom quality check passed")
        sys.exit(0)
    else:
        print("❌ Custom quality check failed\n")
        print("Issues found:")
        for issue in issues:
            print(f"- {issue}")
        sys.exit(1)

if __name__ == "__main__":
    main()
```

### Step 3: Test Your Check

```bash
# Test passing content
python3 scripts/quality/check-custom.py deliverables/test-pass.md
echo $?  # Should print 0

# Test failing content
python3 scripts/quality/check-custom.py deliverables/test-fail.md
echo $?  # Should print 1
```

### Step 4: Integrate with Lisa

Add your check to Lisa's quality check selection logic. This requires modifying Lisa's agent prompt or the setup-lisa-campaign.sh script to include your custom check for specific disciplines or deliverable types.

**Example modification to agent prompt**:

```markdown
## Quality Checks by Discipline

### Marketing
- Brand compliance
- Readability
- SEO
- Accessibility
- **Custom check** ← Add your check here

Run checks:
```bash
python3 scripts/quality/check-brand-compliance.py deliverables/{filename}
python3 scripts/quality/check-readability.py deliverables/{filename}
python3 scripts/quality/check-seo.py deliverables/{filename}
python3 scripts/quality/check-accessibility.py deliverables/{filename}
python3 scripts/quality/check-custom.py deliverables/{filename}  # New check
```
```

### Step 5: Document Your Check

Add documentation for your custom check to this file (QUALITY-GATES.md) including:
- Purpose and what it validates
- How it works
- Usage examples
- Sample passing/failing output
- Configuration options

---

## Troubleshooting

### Issue: Quality check fails with "File not found"

**Symptom**:
```
❌ Error: File not found: deliverables/MKT-001-landing-page.md
```

**Cause**: Deliverable path is incorrect or file wasn't created yet

**Solution**:
1. Verify file exists:
   ```bash
   ls -la deliverables/
   ```
2. Check file path in campaign brief matches actual filename
3. Ensure Lisa created deliverable before running quality checks

---

### Issue: Brand compliance always fails

**Symptom**:
```
❌ Brand compliance check failed
Missing required term: Product name should appear in first paragraph
```

**Cause**: `brand-config.json` has required terms that don't fit all deliverable types

**Solution**:
1. Review your brand-config.json:
   ```bash
   cat scripts/quality/brand-config.json
   ```
2. Make required terms more flexible:
   ```json
   "required_terms": {
     "product_name": ["TechFlow"],  # Only require brand name, not full product name
     "key_terms": []  # Remove overly specific requirements
   }
   ```
3. Or adjust check logic to allow some deliverable types to skip certain requirements

---

### Issue: Readability check too strict/lenient

**Symptom**:
```
❌ Readability check failed
Flesch Reading Ease: 58.3
Target: ≥ 60
```

**Cause**: Threshold doesn't match your audience's reading level

**Solution**:
1. Determine appropriate threshold for your audience (see [Readability Thresholds](#readability-thresholds))
2. Edit `scripts/quality/check-readability.py`:
   ```python
   THRESHOLDS = {
       'marketing': 55,  # Lowered from 60 for technical audience
       'pr': 60,
   }
   ```
3. Test with sample content to verify new threshold works

---

### Issue: SEO check fails on keyword density

**Symptom**:
```
❌ SEO check failed
Keyword density: 0.5% (target: 1-2%)
```

**Cause**: Keyword not used enough (or used too much)

**Solution**:
1. **If density too low**: Add keyword naturally in:
   - One H2 or H3 heading
   - 2-3 body paragraphs
   - Meta description
2. **If density too high** (>2%): Replace some keyword mentions with:
   - Pronouns (it, they, this solution)
   - Synonyms (for "automation": "workflow", "processes")
   - Related terms
3. **Never sacrifice readability for keyword density**—natural language always wins

---

### Issue: AP Style check fails on dates/times

**Symptom**:
```
❌ AP Style check failed
Date format: "1/15/2026" → Use "Jan. 15, 2026"
Time format: "9:00am" → Use "9 a.m."
```

**Cause**: Using common formats instead of AP style

**Solution**: Use these AP style conventions:

**Dates**:
- ✅ Jan. 15, 2026
- ❌ 1/15/2026, January 15th, 2026

**Times**:
- ✅ 9 a.m. ET (lowercase, space before a.m., include time zone)
- ❌ 9:00am, 9AM, 9:00 AM EST

**Numbers**:
- ✅ Spell out zero through nine: "nine customers"
- ✅ Use numerals for 10+: "10 features", "250 companies"
- ✅ Exception for ages, addresses, percentages: "5 years old", "5%"

**Refer to**: [AP Stylebook](https://www.apstylebook.com/) for complete guidelines

---

### Issue: Accessibility check fails on color references

**Symptom**:
```
❌ Accessibility check failed
Color-only instruction: "See the red box for details"
```

**Cause**: Instructions rely solely on color, which is inaccessible to colorblind users

**Solution**: Always include **non-color identifiers**:

❌ Bad:
- "Click the red button"
- "See the green box"
- "Important items are highlighted in yellow"

✅ Good:
- "Click the 'Submit' button"
- "See the 'Key Features' box on the right sidebar"
- "Important items are marked with an asterisk (*)"

---

### Issue: Quality check succeeds but deliverable still seems wrong

**Symptom**: All checks pass but content doesn't meet expectations

**Cause**: Automated checks have limitations—they can't evaluate creativity, strategy, or nuance

**Solution**:
1. **Review deliverable manually**—automated checks ensure baseline quality, not perfection
2. **Update acceptance criteria** in campaign brief to be more specific
3. **Enhance brand-config.json** with more specific guidelines
4. **Add custom quality check** for your specific requirements (see [Adding Custom Quality Checks](#adding-custom-quality-checks))
5. **Provide feedback** in learnings.txt for future campaigns

**Remember**: Quality checks catch technical issues (readability, style, accessibility). Strategic quality (messaging effectiveness, audience fit, creativity) still requires human judgment.

---

### Issue: Python dependency missing

**Symptom**:
```
ModuleNotFoundError: No module named 'textstat'
```

**Cause**: Python dependencies not installed

**Solution**:
```bash
cd .claude/plugins/lisa
pip install -r scripts/requirements.txt

# Verify installation
python3 -c "import textstat; print('✅ Dependencies installed')"
```

---

## Additional Resources

- **Brand Guidelines**: See `scripts/quality/brand-config.json` for customization
- **Quality Check Scripts**: All scripts in `scripts/quality/` with inline documentation
- **Extending Lisa**: See [EXTENDING.md](./EXTENDING.md) for adding new quality checks and deliverable types
- **Troubleshooting**: See [README.md § Troubleshooting](./README.md#troubleshooting) for general Lisa issues
- **AP Stylebook**: https://www.apstylebook.com/ (subscription required)
- **WCAG 2.1 Guidelines**: https://www.w3.org/WAI/WCAG21/quickref/ (accessibility standards)
- **Flesch Reading Ease**: https://readable.com/readability/flesch-reading-ease-flesch-kincaid-grade-level/

---

**Questions or issues?**

- GitHub Issues: https://github.com/kenziecreative/lisa-simpson-claudecode/issues
- Documentation: https://github.com/kenziecreative/lisa-simpson-claudecode#readme
- Examples: See `examples/` directory for reference campaigns and deliverables
