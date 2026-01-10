# Extending Lisa

**How to customize and extend Lisa for your needs**

Lisa is designed to be extensible. This guide shows you how to add new deliverable types, quality checks, skills, and even entirely new creative disciplines.

---

## Table of Contents

- [Plugin Architecture Overview](#plugin-architecture-overview)
- [Adding New Deliverable Types](#adding-new-deliverable-types)
- [Adding New Quality Check Scripts](#adding-new-quality-check-scripts)
- [Creating New Skills](#creating-new-skills)
- [Adding New Creative Disciplines](#adding-new-creative-disciplines)
- [Integrating with External Tools](#integrating-with-external-tools)
- [Hook Points for Future Enhancements](#hook-points-for-future-enhancements)
- [Extension Examples](#extension-examples)
- [Code Structure Walkthrough](#code-structure-walkthrough)

---

## Plugin Architecture Overview

Lisa follows the **Claude Code Plugin Architecture** with these key components:

### Directory Structure

```
.claude/plugins/lisa/
├── plugin.json              # Plugin metadata and configuration
├── README.md                # User-facing documentation
├── QUALITY-GATES.md         # Quality check documentation
├── EXTENDING.md             # This file
│
├── commands/                # Slash commands
│   ├── lisa.md              # /lisa command - runs campaigns
│   └── cancel-lisa.md       # /cancel-lisa - stops campaigns
│
├── hooks/                   # Lifecycle hooks
│   └── stop/
│       └── lisa-stop.sh     # Intercepts exit to continue campaign loops
│
├── skills/                  # Interactive workflow skills
│   ├── marketing-plan/
│   ├── pr-plan/
│   ├── branding-plan/
│   └── lisa/                # PRD→JSON conversion skill
│
├── scripts/                 # Automation and processing scripts
│   ├── setup-lisa-campaign.sh          # Campaign initialization
│   ├── requirements.txt                # Python dependencies
│   └── quality/                        # Quality check scripts
│       ├── check-brand-compliance.py
│       ├── check-readability.py
│       ├── check-seo.py
│       ├── check-accessibility.py
│       ├── check-ap-style.py
│       └── brand-config.json           # Brand guidelines
│
├── prompts/                 # Agent prompt templates (future)
│   ├── marketing-agent.md
│   ├── pr-agent.md
│   └── branding-agent.md
│
└── examples/                # Reference materials
    ├── product-launch-marketing.json
    ├── product-announcement-pr.json
    ├── brand-refresh-branding.json
    └── deliverables/        # Example outputs
```

### How Lisa Works

1. **User activates skill** (e.g., `/marketing-plan`) → generates PRD
2. **User converts PRD** (`/lisa`) → creates campaign-brief.json
3. **User runs campaign** (`/lisa campaign-brief.json`) → setup-lisa-campaign.sh creates state file
4. **Stop hook intercepts exit** → re-injects agent prompt
5. **Agent processes deliverables** → create, check quality, update brief, log learnings
6. **Loop continues** until all deliverables approved or max iterations reached

### Extension Points

Lisa is designed with these extension points:

- **Deliverable types**: Add new types to campaign briefs (see [Adding New Deliverable Types](#adding-new-deliverable-types))
- **Quality checks**: Add new validation scripts (see [Adding New Quality Check Scripts](#adding-new-quality-check-scripts))
- **Skills**: Add new interactive workflows (see [Creating New Skills](#creating-new-skills))
- **Disciplines**: Add entirely new creative disciplines (see [Adding New Creative Disciplines](#adding-new-creative-disciplines))
- **External integrations**: Connect to CMS, email platforms, media databases (see [Integrating with External Tools](#integrating-with-external-tools))

---

## Adding New Deliverable Types

Deliverable types define what Lisa can create. Each type has specific characteristics and quality requirements.

### Current Deliverable Types

**Marketing** (10 types):
- email-sequence, landing-page-copy, social-posts, blog-post, case-study, whitepaper, webinar-script, ad-copy, email-nurture, product-messaging

**PR** (8 types):
- press-release, media-pitch, talking-points, qa-document, fact-sheet, media-advisory, op-ed, statement

**Branding** (7 types):
- brand-guidelines, brand-positioning, voice-tone-guide, messaging-framework, tagline, brand-story, visual-identity-brief

### How to Add a New Deliverable Type

#### Step 1: Define the Deliverable Type

Choose a unique, descriptive type ID (lowercase, hyphens for spaces).

**Example**: Adding "video-script" to marketing

```json
{
  "type": "video-script",
  "description": "What it is and what makes a good one"
}
```

#### Step 2: Add to Campaign Brief Schema

Campaign briefs support any deliverable type. No schema change needed—just include it in your brief:

```json
{
  "campaign": "Product Launch Campaign",
  "campaignType": "marketing",
  "deliverables": [
    {
      "id": "MKT-004",
      "type": "video-script",
      "title": "Product demo video script",
      "description": "2-minute product demo video script for YouTube. Opening hook in first 10 seconds (problem statement). Feature walkthrough with screen demos (60 seconds). Customer testimonial (20 seconds). CTA with trial link (10 seconds). Conversational tone, benefit-focused, includes on-screen text suggestions.",
      "acceptanceCriteria": [
        "Word count: 250-300 words (approximately 2 minutes speaking time)",
        "Opening hook addresses customer pain point in first 10 seconds",
        "3-5 key product features demonstrated with specific use cases",
        "Includes on-screen text suggestions for key points",
        "Conversational, benefit-focused language (not feature list)",
        "Clear CTA with trial link at end",
        "Passes brand compliance",
        "Passes readability check"
      ],
      "priority": 4,
      "approved": false
    }
  ]
}
```

#### Step 3: Update Quality Gates (Optional)

Decide which quality checks apply to your new type. By default, Lisa uses discipline-level checks:

- **Marketing**: brand, readability, SEO, accessibility
- **PR**: brand, readability, AP Style
- **Branding**: brand, accessibility

If your deliverable type needs different checks, document it in `QUALITY-GATES.md`:

```markdown
### Video Script Quality Checks

**Applies to**: video-script deliverable type

**Quality gates**:
- Brand compliance ✓
- Readability ✓ (should be conversational, 70+ Flesch score)
- SEO ✗ (not published on web)
- Accessibility ✓ (on-screen text suggestions required)
```

#### Step 4: Add Example (Optional but Recommended)

Create an example deliverable in `examples/deliverables/`:

```bash
# Create example video script
cat > examples/deliverables/video-script.md <<'EOF'
# Product Demo Video Script

**Duration**: 2 minutes
**Platform**: YouTube, website
**Tone**: Conversational, benefit-focused

---

## Opening Hook (0:00-0:10)

**[Visual: Person frustrated at desk with multiple tabs open]**

**Voiceover**: "Drowning in data but starving for insights? You're not alone."

**[On-screen text: "80% of business users can't access their own data"]**

...

EOF
```

#### Step 5: Test Your New Type

Create a test campaign brief with your new deliverable type and run it:

```bash
# Create test brief
cat > test-video-script.json <<'EOF'
{
  "campaign": "Video Script Test",
  "campaignType": "marketing",
  "deliverables": [
    {
      "id": "VID-001",
      "type": "video-script",
      "title": "Product demo video script",
      "description": "2-minute demo script...",
      "acceptanceCriteria": [...],
      "priority": 1,
      "approved": false
    }
  ]
}
EOF

# Run campaign
.claude/plugins/lisa/scripts/setup-lisa-campaign.sh test-video-script.json
```

---

## Adding New Quality Check Scripts

Quality checks ensure deliverables meet standards. You can add custom checks for your specific needs.

### Quality Check Requirements

All quality check scripts must:

1. **Accept file path** as first argument
2. **Return exit codes**: 0 (pass), 1 (fail), 2 (configuration error)
3. **Output clear messages**: What passed/failed and why
4. **Be executable**: `chmod +x script-name.py`

### Template for New Quality Check

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

    # Perform your checks
    # Example: Check for specific pattern
    if "forbidden_pattern" in content:
        issues.append("Found forbidden pattern")

    # Example: Check line length
    lines = content.split('\n')
    for i, line in enumerate(lines, 1):
        if len(line) > 120:
            issues.append(f"Line {i} exceeds 120 characters")

    # Return results
    passed = len(issues) == 0
    return passed, issues

def main():
    parser = argparse.ArgumentParser(
        description='Custom quality check for Lisa deliverables'
    )
    parser.add_argument('file_path', help='Path to deliverable file')
    parser.add_argument('--verbose', action='store_true',
                       help='Show detailed output')
    args = parser.parse_args()

    passed, issues = check_custom_quality(args.file_path)

    if passed:
        print("✅ Custom quality check passed")
        if args.verbose:
            print("\nAll validations passed successfully")
        sys.exit(0)
    else:
        print("❌ Custom quality check failed\n")
        print("Issues found:")
        for issue in issues:
            print(f"- {issue}")

        if args.verbose:
            print(f"\nTotal issues: {len(issues)}")
            print("Fix these issues and run the check again")
        sys.exit(1)

if __name__ == "__main__":
    main()
```

### Example: Adding a "Tone Check"

Let's create a quality check that validates content tone (formal vs. casual).

**Step 1: Create the script**

```bash
cat > .claude/plugins/lisa/scripts/quality/check-tone.py <<'EOF'
#!/usr/bin/env python3
"""
Tone Quality Check for Lisa
Validates content tone matches target audience expectations
"""

import sys
import argparse
import re

def check_tone(file_path, target_tone='professional'):
    """
    Check if content tone matches target

    Args:
        file_path: Path to deliverable file
        target_tone: 'professional' or 'casual'

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
        sys.exit(2)

    # Casual indicators
    casual_patterns = [
        r'\b(gonna|wanna|gotta|kinda|sorta)\b',
        r'\b(yeah|yep|nope|yup)\b',
        r'!{2,}',  # Multiple exclamation points
        r'\b(super|really|very)\s+(cool|awesome|great)\b'
    ]

    # Professional indicators
    professional_required = [
        r'[A-Z][a-z]+',  # Proper capitalization
    ]

    if target_tone == 'professional':
        # Check for casual language
        for pattern in casual_patterns:
            matches = re.findall(pattern, content, re.IGNORECASE)
            if matches:
                issues.append(
                    f"Casual language detected: '{matches[0]}' "
                    f"(use formal alternative)"
                )

    elif target_tone == 'casual':
        # Check if too formal
        formal_words = ['utilize', 'leverage', 'facilitate', 'synergy']
        for word in formal_words:
            if word in content.lower():
                issues.append(
                    f"Overly formal word: '{word}' "
                    f"(use simpler alternative like 'use', 'take advantage of')"
                )

    passed = len(issues) == 0
    return passed, issues

def main():
    parser = argparse.ArgumentParser(description='Tone quality check')
    parser.add_argument('file_path', help='Path to deliverable file')
    parser.add_argument('--tone', default='professional',
                       choices=['professional', 'casual'],
                       help='Target tone (default: professional)')
    args = parser.parse_args()

    passed, issues = check_tone(args.file_path, args.tone)

    if passed:
        print(f"✅ Tone check passed (target: {args.tone})")
        sys.exit(0)
    else:
        print(f"❌ Tone check failed (target: {args.tone})\n")
        print("Issues found:")
        for issue in issues:
            print(f"- {issue}")
        sys.exit(1)

if __name__ == "__main__":
    main()
EOF

chmod +x .claude/plugins/lisa/scripts/quality/check-tone.py
```

**Step 2: Test the check**

```bash
# Test with professional content
echo "This document utilizes advanced methodologies." > test-formal.md
python3 scripts/quality/check-tone.py test-formal.md --tone casual
# Should fail (too formal for casual tone)

# Test with casual content
echo "We're gonna make this super awesome!" > test-casual.md
python3 scripts/quality/check-tone.py test-casual.md --tone professional
# Should fail (too casual for professional tone)
```

**Step 3: Integrate with Lisa**

Add to agent prompt or setup script to run tone check on specific deliverable types:

```bash
# In setup-lisa-campaign.sh or agent prompt
python3 scripts/quality/check-tone.py deliverables/MKT-001.md --tone professional
```

**Step 4: Document in QUALITY-GATES.md**

Add your new check to the quality gates documentation so users know it exists and how to configure it.

---

## Creating New Skills

Skills are interactive workflows that help users create campaign briefs. They ask questions, gather requirements, and generate structured PRDs.

### Skill Structure

```
skills/
└── my-skill/
    ├── SKILL.md          # Skill definition (required)
    └── icon.png          # Optional icon (64x64)
```

### SKILL.md Format

```markdown
# Skill Name

**Invocation**: /my-skill

**Description**: One-line description of what this skill does

**Category**: The category (e.g., Marketing, PR, Branding, Custom)

---

## Prompt

You are a [role] helping the user create [output].

### Your Task

1. Ask clarifying questions
2. Generate a structured output
3. Save to appropriate location

### Questions to Ask

Present questions one at a time. Use multiple choice where appropriate.

#### Question 1: [Topic]

"[Question text]?"

A. [Option A] - [Description]
B. [Option B] - [Description]
C. [Option C] - [Description]
D. Other (please specify)

#### Question 2: [Topic]

...

### Output Format

After gathering all information, create a markdown document with this structure:

```
[Template for output document]
```

Save to: campaign-plans/[descriptive-filename].md

### Completion

When done:
1. Confirm file saved successfully
2. Show user the file path
3. Suggest next steps (e.g., "Run /lisa to convert this to a campaign brief")
```

### Example: Adding a "Content Calendar Skill"

```bash
mkdir -p .claude/plugins/lisa/skills/content-calendar
```

Create `.claude/plugins/lisa/skills/content-calendar/SKILL.md`:

```markdown
# Content Calendar Generator

**Invocation**: /content-calendar

**Description**: Create a content calendar for blog posts, social media, and email campaigns

**Category**: Marketing

---

## Prompt

You are a content strategist helping the user create a multi-channel content calendar.

### Your Task

1. Ask clarifying questions about goals, channels, frequency, and themes
2. Generate a structured content calendar in markdown
3. Save to campaign-plans/ directory

### Questions to Ask

#### Question 1: Calendar Duration

"What time period should this calendar cover?"

A. 1 month (4 weeks)
B. 1 quarter (3 months)
C. 6 months
D. 1 year
E. Other (please specify)

#### Question 2: Content Channels

"Which content channels are you planning for? (Select all that apply)"

A. Blog posts
B. Social media (LinkedIn, Twitter, etc.)
C. Email newsletters
D. Video content
E. Podcast episodes
F. Webinars
G. Other (please specify)

#### Question 3: Publishing Frequency

"How often will you publish on each channel?"

For each selected channel, ask:
- "[Channel]: How many pieces per week/month?"

#### Question 4: Content Themes

"What are your main content themes or pillars?"

Ask user to provide 3-5 themes. Examples:
- Product education
- Customer success stories
- Industry trends
- Thought leadership
- Company updates

#### Question 5: Target Audience

"Who is your primary audience?"

Get details on:
- Role/title
- Industry
- Pain points
- Content preferences

#### Question 6: Goals

"What are you trying to achieve with this content?"

A. Lead generation
B. Brand awareness
C. Customer education
D. Thought leadership
E. Product adoption
F. Other (please specify)

### Output Format

Create a markdown document with this structure:

```
# [Duration] Content Calendar

**Period**: [Start Date] - [End Date]
**Channels**: [List of channels]
**Publishing frequency**: [Summary]
**Goals**: [Primary goals]
**Target audience**: [Brief description]

---

## Content Themes

1. **[Theme 1]**: [Description]
2. **[Theme 2]**: [Description]
3. **[Theme 3]**: [Description]

---

## Weekly Calendar

### Week 1: [Dates]

**Theme focus**: [Primary theme for this week]

| Day | Channel | Content Type | Topic | Theme | Status |
|-----|---------|--------------|-------|-------|--------|
| Mon | Blog | How-to guide | [Topic] | [Theme] | Draft |
| Wed | LinkedIn | Case study post | [Topic] | [Theme] | Draft |
| Fri | Email | Newsletter | [Weekly roundup] | Mixed | Draft |

### Week 2: [Dates]

...

---

## Content Ideas by Theme

### [Theme 1]

- Blog: [Idea 1]
- Social: [Idea 2]
- Email: [Idea 3]

### [Theme 2]

...

---

## Production Notes

**Lead time**: [How far in advance to create content]
**Review process**: [Who reviews before publishing]
**Promotion strategy**: [How to amplify published content]
```

Save to: `campaign-plans/content-calendar-[duration]-[date].md`

### Completion

When done:
1. Show user the file path
2. Summarize key details (duration, channels, publishing frequency)
3. Suggest next steps:
   - "Review and adjust topics as needed"
   - "Use /lisa to convert specific content pieces into campaign deliverables"
   - "Share with your team for feedback"
```

**Test your skill**:

```bash
# In Claude Code, invoke the skill
/content-calendar

# Answer the questions interactively

# Verify output file created
ls campaign-plans/content-calendar-*.md
```

---

## Adding New Creative Disciplines

Lisa currently supports Marketing, PR, and Branding. You can add entirely new disciplines (e.g., Content Strategy, Social Media Management, Event Planning).

### Steps to Add a New Discipline

#### 1. Define Discipline Characteristics

**Example: "Content Strategy" Discipline**

- **Category**: content-strategy
- **Focus**: Content audits, editorial calendars, content governance
- **Deliverable types**: content-audit, editorial-guidelines, content-calendar, taxonomy, governance-framework
- **Quality gates**: brand-compliance, readability, accessibility (NOT SEO or AP Style)
- **Progress indicator**: 📝 (or appropriate emoji)

#### 2. Create Discipline-Specific Deliverable Types

Document 5-10 deliverable types for your discipline:

```json
{
  "content-strategy-deliverable-types": [
    {
      "type": "content-audit",
      "description": "Comprehensive audit of existing content with quality scores, gaps, and recommendations"
    },
    {
      "type": "editorial-guidelines",
      "description": "Guidelines for content creation including style, structure, SEO, and governance"
    },
    {
      "type": "content-calendar",
      "description": "Multi-channel editorial calendar with topics, themes, and publishing schedule"
    },
    {
      "type": "content-taxonomy",
      "description": "Hierarchical taxonomy for organizing and tagging content across channels"
    },
    {
      "type": "governance-framework",
      "description": "Roles, workflows, and approval processes for content creation and publishing"
    }
  ]
}
```

#### 3. Update scripts/setup-lisa-campaign.sh

Add your discipline to the supported campaignType validation:

```bash
# Line ~125 in setup-lisa-campaign.sh
if [[ "$CAMPAIGN_TYPE" != "marketing" ]] && [[ "$CAMPAIGN_TYPE" != "pr" ]] && [[ "$CAMPAIGN_TYPE" != "branding" ]] && [[ "$CAMPAIGN_TYPE" != "content-strategy" ]]; then
  echo "❌ Error: Invalid campaignType in brief" >&2
  echo "   Found: $CAMPAIGN_TYPE" >&2
  echo "   Expected: 'marketing', 'pr', 'branding', or 'content-strategy'" >&2
  exit 1
fi

# Line ~319 - Add progress indicator
case "$CAMPAIGN_TYPE" in
  marketing)
    EMOJI="📊"
    DISCIPLINE_NAME="Marketing campaign"
    ;;
  pr)
    EMOJI="📰"
    DISCIPLINE_NAME="PR campaign"
    ;;
  branding)
    EMOJI="🎨"
    DISCIPLINE_NAME="Branding project"
    ;;
  content-strategy)
    EMOJI="📝"
    DISCIPLINE_NAME="Content strategy project"
    ;;
esac
```

#### 4. Create Planning Skill

Create a skill for users to generate content strategy plans:

```bash
mkdir -p .claude/plugins/lisa/skills/content-strategy-plan
```

Create `SKILL.md` following the pattern from `marketing-plan`, `pr-plan`, or `branding-plan`.

#### 5. Create Example Campaign Brief

```bash
cat > .claude/plugins/lisa/examples/website-redesign-content-strategy.json <<'EOF'
{
  "campaign": "Website Redesign - Content Strategy 2026",
  "campaignType": "content-strategy",
  "description": "Comprehensive content strategy for website redesign including audit, taxonomy, guidelines, and governance.",
  "deliverables": [
    {
      "id": "CS-001",
      "type": "content-audit",
      "title": "Current website content audit",
      "description": "Audit of all existing website content (500+ pages) with quality scores, traffic data, SEO performance, and recommendations. Categorize by: keep as-is, update, consolidate, or retire. Include content gaps analysis.",
      "acceptanceCriteria": [
        "Audit includes all 500+ pages from current website",
        "Quality scores (0-10) for each page: relevance, accuracy, completeness, SEO",
        "Traffic data: pageviews, bounce rate, time on page (last 6 months)",
        "Categorization: Keep (200 pages), Update (150), Consolidate (100), Retire (50)",
        "Content gaps: 10-15 topics missing that should be covered",
        "Recommendations with priority (high/medium/low) and effort (hours)",
        "Passes brand compliance",
        "Passes accessibility check"
      ],
      "priority": 1,
      "approved": false
    },
    {
      "id": "CS-002",
      "type": "content-taxonomy",
      "title": "Website taxonomy and tagging structure",
      "description": "Hierarchical taxonomy for organizing website content. Primary categories (5-7), subcategories (3-5 per primary), and tags (50-100 total). Maps to navigation structure. Includes content types, audience segments, and topics. Guidelines for applying taxonomy consistently.",
      "acceptanceCriteria": [
        "5-7 primary categories aligned with business goals and user needs",
        "3-5 subcategories per primary category",
        "50-100 tags covering topics, content types, audience segments",
        "Visual hierarchy diagram showing relationships",
        "Mapping to proposed navigation structure",
        "Tagging guidelines with examples for each tag",
        "Governance: who can create new categories/tags",
        "Passes brand compliance",
        "Passes accessibility check"
      ],
      "priority": 2,
      "approved": false,
      "dependencies": ["CS-001"]
    }
  ]
}
EOF
```

#### 6. Update Documentation

- **README.md**: Add content-strategy to supported disciplines list
- **QUALITY-GATES.md**: Document which quality gates apply to content-strategy
- **EXTENDING.md** (this file): List content-strategy as example of added discipline

#### 7. Test End-to-End

```bash
# Run campaign
.claude/plugins/lisa/scripts/setup-lisa-campaign.sh examples/website-redesign-content-strategy.json --max-iterations 10

# Verify:
# - State file created with correct campaignType
# - Agent prompt mentions "content strategy"
# - Progress indicator shows 📝
# - Deliverables created in deliverables/ folder
# - Quality checks run (brand compliance, accessibility)
# - approved=true when complete
# - learnings.txt updated with "Content Strategy" entry
```

---

## Integrating with External Tools

Lisa can integrate with external tools to publish deliverables, sync contacts, or automate workflows.

### Integration Patterns

#### Pattern 1: Post-Generation Hooks

Add a hook that runs after a deliverable is created and approved:

**Example: Publish to CMS**

```bash
# Create hook script
cat > .claude/plugins/lisa/scripts/hooks/post-deliverable.sh <<'EOF'
#!/bin/bash
# Post-deliverable hook - runs after each approved deliverable

set -euo pipefail

DELIVERABLE_ID=$1
DELIVERABLE_FILE=$2
CAMPAIGN_TYPE=$3

# Example: Publish blog posts to WordPress
if [[ "$CAMPAIGN_TYPE" == "marketing" ]] && [[ "$DELIVERABLE_FILE" == *"blog-post"* ]]; then
  echo "Publishing blog post to WordPress..."

  # Extract title and content
  TITLE=$(grep "^# " "$DELIVERABLE_FILE" | head -1 | sed 's/^# //')
  CONTENT=$(cat "$DELIVERABLE_FILE")

  # Post to WordPress via WP-CLI or API
  wp post create \
    --post_title="$TITLE" \
    --post_content="$CONTENT" \
    --post_status=draft \
    --post_type=post

  echo "✅ Published to WordPress as draft"
fi
EOF

chmod +x .claude/plugins/lisa/scripts/hooks/post-deliverable.sh
```

Update agent prompt or setup script to call this hook after approving deliverables.

#### Pattern 2: External API Integration

**Example: Add media contacts to database**

```python
# Create integration script
cat > .claude/plugins/lisa/scripts/integrations/sync-media-contacts.py <<'EOF'
#!/usr/bin/env python3
"""
Sync media contacts from PR pitches to external database
"""

import json
import re
import requests
import sys

def extract_contacts_from_pitch(file_path):
    """Extract media contacts from pitch file"""
    with open(file_path, 'r') as f:
        content = f.read()

    contacts = []

    # Look for "To:" lines with name, title, outlet
    pattern = r'\*\*To\*\*:\s*([^,]+),\s*([^,]+),\s*([^\n]+)'
    matches = re.findall(pattern, content)

    for match in matches:
        contacts.append({
            'name': match[0].strip(),
            'title': match[1].strip(),
            'outlet': match[2].strip()
        })

    return contacts

def sync_to_database(contacts, api_url, api_key):
    """Sync contacts to external media database"""
    headers = {
        'Authorization': f'Bearer {api_key}',
        'Content-Type': 'application/json'
    }

    for contact in contacts:
        response = requests.post(
            f'{api_url}/contacts',
            headers=headers,
            json=contact
        )

        if response.status_code == 201:
            print(f"✅ Synced: {contact['name']} ({contact['outlet']})")
        else:
            print(f"❌ Failed: {contact['name']} - {response.text}")

def main():
    if len(sys.argv) < 2:
        print("Usage: sync-media-contacts.py <pitch-file>")
        sys.exit(1)

    file_path = sys.argv[1]

    # Load config
    with open('.claude/plugins/lisa/config/media-db-config.json') as f:
        config = json.load(f)

    contacts = extract_contacts_from_pitch(file_path)

    if contacts:
        print(f"Found {len(contacts)} contacts to sync")
        sync_to_database(
            contacts,
            config['api_url'],
            config['api_key']
        )
    else:
        print("No contacts found in pitch")

if __name__ == "__main__":
    main()
EOF

chmod +x .claude/plugins/lisa/scripts/integrations/sync-media-contacts.py
```

#### Pattern 3: Slash Command for Publishing

Create a slash command that publishes approved deliverables to external platforms:

```bash
mkdir -p .claude/plugins/lisa/commands

cat > .claude/plugins/lisa/commands/publish-deliverables.md <<'EOF'
# Publish Deliverables

Publish approved deliverables to external platforms (CMS, social media, email platform).

## Usage

```
/publish-deliverables <campaign-brief.json> [--platform <platform>]
```

## Options

- `--platform <platform>`: Specific platform (wordpress, hubspot, mailchimp, buffer)
- `--dry-run`: Show what would be published without actually publishing

## Supported Platforms

- **wordpress**: Blog posts, pages
- **hubspot**: Landing pages, blog posts, emails
- **mailchimp**: Email campaigns
- **buffer**: Social media posts

## Configuration

Configure API credentials in `.claude/plugins/lisa/config/publish-config.json`:

```json
{
  "wordpress": {
    "url": "https://yoursite.com",
    "username": "admin",
    "api_key": "your-api-key"
  },
  "hubspot": {
    "api_key": "your-hubspot-api-key"
  },
  "mailchimp": {
    "api_key": "your-mailchimp-api-key",
    "list_id": "your-list-id"
  },
  "buffer": {
    "access_token": "your-buffer-token"
  }
}
```

## Example

```bash
# Publish all approved deliverables to WordPress
/publish-deliverables campaign-brief.json --platform wordpress

# Dry run to see what would be published
/publish-deliverables campaign-brief.json --dry-run
```

## What Gets Published

Only deliverables with `approved: true` are published. Lisa checks:

1. Deliverable is approved in campaign brief
2. Platform is configured with API credentials
3. Deliverable type is supported by platform
4. Quality checks passed

After publishing:
- Updates campaign brief with published URL
- Logs publication to learnings.txt
- Shows summary of published items
EOF
```

---

## Hook Points for Future Enhancements

Lisa exposes these hook points for extending functionality:

### 1. Before Campaign Start

**Hook**: `.claude/plugins/lisa/hooks/pre-campaign.sh`

**Triggered**: Before setup-lisa-campaign.sh initializes campaign

**Use cases**:
- Validate campaign brief against custom schema
- Check API credentials for external integrations
- Pre-populate brand-config.json from company database
- Send Slack notification: "Campaign starting..."

**Arguments passed**:
- `$1`: Campaign brief path
- `$2`: Campaign name
- `$3`: Campaign type

### 2. After Each Deliverable

**Hook**: `.claude/plugins/lisa/hooks/post-deliverable.sh`

**Triggered**: After deliverable approved and learnings logged

**Use cases**:
- Publish to CMS automatically
- Sync media contacts to database
- Send preview email to stakeholders
- Update project management tool (Asana, Jira)

**Arguments passed**:
- `$1`: Deliverable ID
- `$2`: Deliverable file path
- `$3`: Campaign type
- `$4`: Deliverable type

### 3. Campaign Complete

**Hook**: `.claude/plugins/lisa/hooks/post-campaign.sh`

**Triggered**: After all deliverables approved and campaign completes

**Use cases**:
- Generate campaign summary report
- Send completion notification to team
- Archive deliverables to shared drive
- Update campaign tracker spreadsheet

**Arguments passed**:
- `$1`: Campaign brief path
- `$2`: Campaign name
- `$3`: Total deliverables count

### 4. Quality Check Failed

**Hook**: `.claude/plugins/lisa/hooks/quality-failed.sh`

**Triggered**: When deliverable fails quality check

**Use cases**:
- Send alert to quality team
- Log failure to monitoring system
- Suggest specific fixes based on failure type

**Arguments passed**:
- `$1`: Deliverable file path
- `$2`: Failed check name
- `$3`: Failure output

### 5. Custom Event Hooks

You can create custom hooks by modifying the agent prompt or setup script to emit events at specific points:

```bash
# Example: Emit custom event from agent prompt
echo "HOOK:custom-event:data" > /tmp/lisa-hook-event

# Hook processor checks for events
if [[ -f /tmp/lisa-hook-event ]]; then
  EVENT=$(cat /tmp/lisa-hook-event)
  .claude/plugins/lisa/hooks/custom-handler.sh "$EVENT"
fi
```

---

## Extension Examples

### Example 1: A/B Testing Integration

**Goal**: Generate A/B test variants for marketing deliverables

**Implementation**:

1. **Add deliverable type**: `ab-test-variants`
2. **Create skill**: `/ab-test-plan` asks for control, number of variants, what to test
3. **Generate deliverables**: Create multiple variants with systematic differences
4. **Quality check**: Ensure variants differ only on intended variable
5. **Integration**: Sync to testing platform (Optimizely, VWO)

**Files to create**:
- `skills/ab-test-plan/SKILL.md`
- `scripts/integrations/sync-to-optimizely.py`
- `examples/ab-test-landing-page.json`

### Example 2: Analytics Integration

**Goal**: Track performance of published deliverables

**Implementation**:

1. **Post-publish hook**: Tag published content with campaign ID
2. **Analytics script**: Fetch metrics from Google Analytics, social platforms
3. **Report generation**: Create performance report comparing deliverables
4. **Learnings update**: Append performance data to learnings.txt

**Files to create**:
- `scripts/integrations/fetch-analytics.py`
- `scripts/reports/campaign-performance.py`
- `hooks/analytics-update.sh` (runs weekly)

### Example 3: Translation Workflow

**Goal**: Generate deliverables in multiple languages

**Implementation**:

1. **Add deliverable metadata**: `language: "en"` field in campaign brief
2. **Translation skill**: `/translate-campaign` creates new brief with all deliverables in target language
3. **Quality check**: Language-specific readability checks
4. **Workflow**: Original approved → translate → review → approve translation

**Files to create**:
- `skills/translate-campaign/SKILL.md`
- `scripts/quality/check-readability-es.py` (Spanish readability)
- `examples/multilingual-campaign.json`

### Example 4: Approval Workflow

**Goal**: Multi-stakeholder approval before marking deliverables as approved

**Implementation**:

1. **Approval hook**: After deliverable created, send for review
2. **Review interface**: Simple web UI or email with approve/reject/comment
3. **State tracking**: Store approval status in campaign brief
4. **Agent logic**: Only mark `approved: true` after all reviewers approve

**Files to create**:
- `scripts/approvals/send-for-review.py`
- `scripts/approvals/check-approval-status.py`
- `hooks/pre-approval.sh`
- `config/reviewers.json` (map deliverable types to reviewers)

---

## Code Structure Walkthrough

### Entry Points

**User initiates campaign**:
```
User runs: /lisa campaign-brief.json
           ↓
commands/lisa.md expands
           ↓
Claude reads campaign brief
           ↓
Calls scripts/setup-lisa-campaign.sh
           ↓
Creates .claude/lisa-campaign.local.md (state file)
           ↓
State file contains agent prompt
           ↓
Claude starts working
```

**Stop hook loop**:
```
Claude attempts to exit
           ↓
hooks/stop/lisa-stop.sh intercepts
           ↓
Checks .claude/lisa-campaign.local.md exists
           ↓
Reads iteration count, max_iterations, completion_promise
           ↓
If campaign active AND (iterations < max OR no completion promise):
    ↓
    Re-inject prompt from state file
    ↓
    Claude continues working
Else:
    ↓
    Allow exit (campaign complete or stopped)
```

### State Management

**Campaign state** (`.claude/lisa-campaign.local.md`):
```yaml
---
active: true
iteration: 5
max_iterations: 30
completion_promise: "COMPLETE"
campaign_name: "Q1 Product Launch"
campaign_type: "marketing"
started_at: "2026-01-10T14:30:00Z"
---

[Agent prompt injected here]
```

**Campaign brief** (`campaign-brief.json`):
```json
{
  "campaign": "...",
  "campaignType": "marketing",
  "deliverables": [
    {
      "id": "MKT-001",
      "approved": false  ← Lisa updates this
    }
  ]
}
```

**Learnings log** (`learnings.txt`):
```
[2026-01-10 15:45] - Marketing - MKT-001 - Q1 Product Launch
Created: Landing page copy
Key insights: ...
Marketing-specific notes: ...
```

### Quality Check Flow

```
Lisa creates deliverable
         ↓
Saves to deliverables/MKT-001-landing-page.md
         ↓
Runs quality checks based on discipline:
   - scripts/quality/check-brand-compliance.py deliverables/MKT-001-landing-page.md
   - scripts/quality/check-readability.py deliverables/MKT-001-landing-page.md
   - scripts/quality/check-seo.py deliverables/MKT-001-landing-page.md --keyword "..."
   - scripts/quality/check-accessibility.py deliverables/MKT-001-landing-page.md
         ↓
If all return exit code 0:
   ✅ All checks passed
         ↓
   Mark approved=true in campaign brief
         ↓
   Log to learnings.txt
         ↓
   Move to next deliverable
Else:
   ❌ Check failed
         ↓
   Read failure output
         ↓
   Revise deliverable
         ↓
   Re-run quality checks
         ↓
   (Retry up to 3 times)
```

### File Modification Flow

```
Lisa reads: campaign-brief.json (approved=false)
         ↓
Creates deliverable
         ↓
Quality checks pass
         ↓
Lisa uses Edit tool to update campaign-brief.json:
   - Finds: "approved": false
   - Replaces with: "approved": true
         ↓
Appends to learnings.txt (never modifies existing entries)
         ↓
Git commit (if user configured auto-commit)
         ↓
Checks if more deliverables remain
```

---

## Development Best Practices

### 1. Test Incrementally

Don't build an entire new discipline at once. Test each component:

1. ✅ New deliverable type works in campaign brief
2. ✅ Quality checks run correctly
3. ✅ Skill generates proper PRD
4. ✅ Agent creates deliverable matching acceptance criteria
5. ✅ Integration (if any) syncs data correctly

### 2. Follow Naming Conventions

- **Deliverable types**: lowercase-with-hyphens (e.g., `video-script`)
- **Campaign types**: lowercase-with-hyphens (e.g., `content-strategy`)
- **Quality check scripts**: `check-[name].py` (e.g., `check-tone.py`)
- **Skills**: descriptive-name (e.g., `content-calendar`)
- **Files**: Descriptive names, no spaces (e.g., `brand-positioning.md`)

### 3. Document Everything

- Add new deliverable types to README
- Document quality checks in QUALITY-GATES.md
- Create examples in examples/ directory
- Update this file (EXTENDING.md) with your extension

### 4. Make It Configurable

Don't hardcode values. Use configuration files:

```json
// config/my-integration.json
{
  "api_url": "https://api.example.com",
  "timeout": 30,
  "retry_attempts": 3
}
```

### 5. Handle Errors Gracefully

```python
try:
    result = risky_operation()
except SpecificException as e:
    print(f"❌ Error: {e}", file=sys.stderr)
    print("Suggestion: [how to fix]", file=sys.stderr)
    sys.exit(2)  # Configuration error, not quality failure
```

### 6. Use Exit Codes Consistently

- `0`: Success
- `1`: Validation/quality failure (expected, Lisa will retry)
- `2`: Configuration/setup error (unexpected, Lisa should alert user)

---

## Questions or Issues?

- **GitHub Issues**: https://github.com/kenziecreative/lisa/issues
- **Documentation**: README.md, QUALITY-GATES.md
- **Examples**: See `examples/` directory for reference implementations

---

**Version**: 1.0 (Jan. 10, 2026)
**Maintainer**: [email protected]
