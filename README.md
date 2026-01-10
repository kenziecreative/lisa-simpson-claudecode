# Lisa Plugin

**Multi-Discipline Creative Orchestration for Claude Code**

Lisa is a Claude Code plugin that brings autonomous orchestration to marketing, PR, and branding teams. Using the Ralph Wiggum Stop hook pattern, Lisa helps creative professionals automate campaign deliverables with quality gates, institutional memory, and discipline-appropriate language.

---

## Table of Contents

- [What is Lisa?](#what-is-lisa)
- [Supported Disciplines](#supported-disciplines)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [How Lisa Works](#how-lisa-works)
- [Creating Campaign Briefs](#creating-campaign-briefs)
- [Running Campaigns](#running-campaigns)
- [Quality Gates](#quality-gates)
- [Learnings & Institutional Memory](#learnings--institutional-memory)
- [Example Workflows](#example-workflows)
- [Configuration](#configuration)
- [Troubleshooting](#troubleshooting)
- [Directory Structure](#directory-structure)
- [Examples](#examples)
- [Extending Lisa](#extending-lisa)

---

## What is Lisa?

Lisa is an AI coordinator that autonomously creates campaign deliverables for creative teams:

- 📋 **Reads** your campaign briefs and project plans
- ✍️ **Creates** deliverables one at a time (emails, press releases, brand positioning, etc.)
- ✅ **Checks** quality automatically (brand compliance, readability, SEO, AP Style, accessibility)
- 🔄 **Iterates** until all acceptance criteria are met
- 🧠 **Learns** from each campaign and captures insights for future work
- 🎯 **Adapts** language and quality checks to your discipline (marketing, PR, or branding)

**Why Lisa?**

Creative professionals spend too much time on repetitive content creation. Lisa automates the creation and quality checking, so you can focus on strategy, review, and refinement.

---

## Supported Disciplines

Lisa supports three creative disciplines, each with discipline-specific deliverable types and quality gates:

### Marketing
**Deliverable Types**: Email sequences, landing pages, social posts, ad copy, blog articles, newsletters, case studies, webinar scripts

**Quality Gates**: Brand compliance, Readability, SEO optimization, Accessibility

**Use Cases**: Product launches, lead generation, brand awareness campaigns, customer retention

### PR
**Deliverable Types**: Press releases, media pitches, press kits, crisis communications, talking points, media advisories, op-eds, Q&A documents, fact sheets

**Quality Gates**: Brand compliance, Readability, AP Style compliance, Accessibility

**Use Cases**: Product announcements, company news, thought leadership, event promotion

### Branding
**Deliverable Types**: Brand guidelines, brand positioning, voice & tone guides, messaging frameworks, taglines, brand stories

**Quality Gates**: Brand compliance, Accessibility

**Use Cases**: Brand refreshes, new brand launches, brand consolidation, guidelines updates

---

## Installation

### Prerequisites

- **Claude Code CLI**: Lisa is a Claude Code plugin. Install the command-line interface from [claude.ai/code](https://claude.ai/code) or via npm: `npm install -g @anthropic-ai/claude-code`
- **Python 3.8+**: Required for quality check scripts
- **jq**: Required for JSON parsing in bash scripts

### Easy Installation with AI Assistants

**Not technical? No problem.** Use an AI coding assistant like Cursor, Windsurf, or other AI-powered editors to handle the installation for you.

**Copy and paste this prompt into your AI assistant:**

```
Please help me install the Lisa plugin for Claude Code. Here's what needs to happen:

1. Check if I have Claude Code CLI installed (run claude --version)
   - If not installed, install it via npm: npm install -g @anthropic-ai/claude-code
   - Or guide me to download from https://claude.ai/code

2. Check if I have Python 3.8+ installed (run python3 --version)
   - If not installed or version is too old, guide me through installing Python 3.8+

3. Check if I have jq installed (run which jq)
   - If not installed, install it:
     - macOS: brew install jq
     - Linux: apt-get install jq or yum install jq
     - Windows: Download from https://jqlang.github.io/jq/

4. Clone the Lisa repository:
   git clone https://github.com/kenziecreative/lisa.git

5. Copy Lisa to my Claude Code plugins directory:
   cp -r lisa ~/.claude/plugins/lisa

6. Install Python dependencies:
   cd ~/.claude/plugins/lisa
   pip3 install -r scripts/requirements.txt

7. Verify the installation by checking if these files exist:
   ls ~/.claude/plugins/lisa/

After you've done this, let me know if everything installed successfully and what to do next.
```

Your AI assistant will handle checking prerequisites, installing missing dependencies, and setting up Lisa automatically.

---

### Manual Installation

If you prefer to install manually, follow these steps:

### Step 1: Clone the Repository

```bash
git clone https://github.com/kenziecreative/lisa.git
```

### Step 2: Copy to Claude Code Plugins Directory

```bash
# Copy the lisa directory to your Claude Code plugins folder
cp -r lisa ~/.claude/plugins/lisa

# Or if you prefer, symlink it for easier updates
ln -s /path/to/lisa ~/.claude/plugins/lisa
```

### Step 3: Install Python Dependencies

```bash
cd ~/.claude/plugins/lisa
pip install -r scripts/requirements.txt
```

This installs:
- `textstat` - Readability scoring
- `beautifulsoup4` - HTML/XML parsing
- `markdown` - Markdown to HTML conversion

### Step 4: Verify Installation

Restart Claude Code, then check that Lisa commands are available:

```
/lisa
```

You should see the Lisa command help text.

### Step 5: Customize Brand Guidelines (Optional)

Edit `scripts/brand-config.json` to match your brand:

```bash
nano ~/.claude/plugins/lisa/scripts/brand-config.json
```

Add your brand-specific approved terms, prohibited terms, and voice keywords.

---

## Quick Start

### For Marketers

```
1. Generate a marketing plan
   Use the marketing-plan skill

2. Answer the questions about your campaign
   Campaign type, audience, goals, channels, timeline, deliverables

3. Convert PRD to JSON
   Use the lisa skill with your PRD file path

4. Run the campaign
   /lisa your-campaign-brief.json

5. Check results
   deliverables/ folder contains your content
   learnings.txt captures insights
```

### For PR Professionals

```
1. Generate a PR plan
   Use the pr-plan skill

2. Answer the questions about your PR campaign
   Campaign type, target media, news angle, spokespeople, embargo details

3. Convert PRD to JSON
   Use the lisa skill with your PRD file path

4. Run the campaign
   /lisa your-campaign-brief.json

5. Check results
   deliverables/ folder contains your PR materials
```

### For Branding Professionals

```
1. Generate a branding plan
   Use the branding-plan skill

2. Answer the questions about your branding project
   Project type, scope, audience, brand attributes, positioning

3. Convert PRD to JSON
   Use the lisa skill with your PRD file path

4. Run the campaign
   /lisa your-campaign-brief.json

5. Check results
   deliverables/ folder contains your brand assets
```

---

## How Lisa Works

Lisa uses a **Stop hook pattern** to create an autonomous iteration loop:

### The Loop

1. **Read Campaign Brief**: Lisa reads your `campaign-brief.json` file
2. **Select Deliverable**: Picks the highest priority deliverable where `approved=false`
3. **Check Dependencies**: Ensures all dependencies have `approved=true`
4. **Create Content**: Generates the deliverable following the description and acceptance criteria
5. **Run Quality Checks**: Applies discipline-specific quality gates
6. **Update Brief**: If all checks pass, marks `approved=true` in the JSON
7. **Log Learnings**: Appends insights to `learnings.txt`
8. **Check Completion**: If all deliverables approved, outputs `<promise>COMPLETE</promise>` and stops
9. **Repeat**: Otherwise, continues to next deliverable

### Discipline-Specific Behavior

Lisa adapts her behavior based on `campaignType`:

**Marketing Campaigns** (`campaignType: "marketing"`):
- Uses marketing terminology (campaigns, conversions, engagement, ROI)
- Runs SEO checks for web content
- Focuses on audience targeting and channel optimization
- Progress indicators: 📊

**PR Campaigns** (`campaignType: "pr"`):
- Uses PR terminology (media relations, coverage, pitches, embargoes)
- Enforces AP Style compliance
- Emphasizes news angles and media targeting
- Progress indicators: 📰

**Branding Projects** (`campaignType: "branding"`):
- Uses branding terminology (positioning, equity, expression, touchpoints)
- Focuses on strategic consistency
- Emphasizes accessibility for inclusive brand expression
- Progress indicators: 🎨

### Stop Conditions

Lisa stops automatically when:
1. **All deliverables approved**: Every deliverable has `approved=true`
2. **Max iterations reached**: Default 30, configurable with `--max-iterations`

You can manually stop with `/cancel-lisa` at any time.

---

## Creating Campaign Briefs

Lisa needs a `campaign-brief.json` file that defines what to create. You have two options:

### Option 1: Use Skills (Recommended for Beginners)

Lisa includes interactive skills that guide you through creating a campaign brief:

#### Marketing Campaign

```
1. In Claude Code, activate the marketing-plan skill
2. Answer 6 questions about your campaign:
   - Campaign type (product launch, lead gen, brand awareness, etc.)
   - Target audience (enterprise B2B, SMB, B2C, etc.)
   - Campaign goals (leads, traffic, conversions, etc.)
   - Marketing channels (email, social, paid ads, etc.)
   - Timeline (sprint, standard, extended, ongoing)
   - Deliverables needed (landing page, emails, social, blog, etc.)
3. Skill generates a markdown PRD in campaign-plans/
4. Use the lisa skill to convert PRD to campaign-brief.json
5. Run: /lisa your-campaign-brief.json
```

#### PR Campaign

```
1. Activate the pr-plan skill
2. Answer 7 questions about your PR campaign:
   - Campaign type (product announcement, company news, thought leadership, etc.)
   - Target media (tech media, business media, trade pubs, etc.)
   - News angle (innovation, market impact, human interest, etc.)
   - Spokespeople (CEO, product leader, customer, etc.)
   - Timeline (immediate, standard, planned launch, ongoing)
   - Media embargo (yes/no, timing)
   - Deliverables needed (press release, pitch, press kit, etc.)
3. Skill generates PR PRD in campaign-plans/
4. Use the lisa skill to convert to JSON
5. Run: /lisa your-campaign-brief.json
```

#### Branding Project

```
1. Activate the branding-plan skill
2. Answer 8 questions about your branding project:
   - Project type (new brand, refresh, rebrand, sub-brand, etc.)
   - Scope (full brand system, visual only, verbal only, etc.)
   - Target audience (B2B enterprise, SMB, B2C, etc.)
   - Brand attributes (innovative, trustworthy, approachable, etc.)
   - Competitive positioning (premium, value leader, innovation leader, etc.)
   - Brand personality (expert, friend, innovator, professional, rebel)
   - Timeline (fast track, standard, comprehensive, phased)
   - Deliverables needed (positioning, voice guide, messaging, story, etc.)
3. Skill generates branding PRD
4. Convert to JSON with lisa skill
5. Run: /lisa your-campaign-brief.json
```

### Option 2: Create JSON Manually

See `examples/` directory for templates:
- `examples/q1-product-launch-marketing.json` - Marketing template
- `examples/product-announcement-pr.json` - PR template
- `examples/brand-refresh-branding.json` - Branding template

Copy a template and customize:

```json
{
  "campaign": "Your Campaign Name",
  "campaignType": "marketing",
  "description": "Brief campaign description",
  "deliverables": [
    {
      "id": "MKT-001",
      "type": "email-sequence",
      "title": "Welcome email series",
      "description": "Detailed description of what to create",
      "acceptanceCriteria": [
        "Specific, verifiable criterion 1",
        "Specific, verifiable criterion 2",
        "Passes brand compliance",
        "Readability score > 60"
      ],
      "priority": 1,
      "approved": false,
      "targetKeyword": null,
      "dependencies": []
    }
  ]
}
```

**Schema Reference**: See `schemas/campaign-brief.schema.json` for complete specification.

---

## Running Campaigns

### Basic Usage

```bash
/lisa campaign-brief.json
```

Lisa starts working immediately. You'll see:
- Campaign details and discipline
- Progress updates as deliverables are completed
- Quality check results
- Completion notification

### Advanced Options

```bash
# Custom max iterations (default: 30)
/lisa campaign-brief.json --max-iterations 50

# Custom completion promise (default: "COMPLETE")
/lisa campaign-brief.json --completion-promise "ALL DONE"

# Both options
/lisa campaign-brief.json --max-iterations 50 --completion-promise "FINISHED"
```

### Monitoring Progress

While Lisa works:

```bash
# Check current iteration
head -10 .claude/lisa-campaign.local.md

# View recent learnings
tail -20 learnings.txt

# Check campaign brief status
# Look for "approved": true flags in your JSON
```

### Stopping a Campaign

```bash
/cancel-lisa
```

This stops the loop immediately. Your campaign brief shows which deliverables completed.

---

## Quality Gates

Lisa applies automated quality checks before marking deliverables as approved. Which checks run depends on your discipline:

### Quality Gates by Discipline

| Quality Check | Marketing | PR | Branding |
|--------------|-----------|----|---------|
| Brand Compliance | ✅ | ✅ | ✅ |
| Readability | ✅ | ✅ | - |
| SEO Optimization | ✅ | - | - |
| AP Style | - | ✅ | - |
| Accessibility | ✅ | ✅ | ✅ |

### Brand Compliance Check

**What it checks**: Scans content for prohibited terms, required terms, and brand voice alignment

**Configuration**: `scripts/brand-config.json`

**Example**:
```json
{
  "approvedTerms": ["innovative", "reliable", "customer-focused"],
  "prohibitedTerms": ["cheap", "basically", "revolutionize"],
  "requiredTerms": ["YourBrand®"],
  "voiceToneKeywords": ["professional", "approachable"]
}
```

**Customize**: Edit `brand-config.json` with your brand guidelines

### Readability Check (Marketing & PR)

**What it checks**: Flesch-Kincaid Reading Ease score

**Threshold**: > 60 (8th-9th grade level, "Plain English")

**Why it matters**: Accessible content reaches more people and drives better results

**How to improve**: Use shorter sentences, simpler words, active voice

### SEO Check (Marketing Only)

**What it checks**:
- Keyword density (2-4% target range)
- Meta description (< 160 characters)
- H1 and H2 headers present
- Target keyword in H1

**When it runs**: Only for web content with a `targetKeyword` specified

### AP Style Check (PR Only)

**What it checks**:
- No Oxford comma
- Proper date/time formats
- Correct percent symbol usage
- "More than" vs "over" for quantities
- Common spelling errors

**Why it matters**: Media outlets expect AP Style for press materials

### Accessibility Check (All Disciplines)

**What it checks**:
- Heading hierarchy (H1 → H2 → H3, no skipping)
- Alt text for images
- Semantic HTML structure
- Descriptive link text

**Standard**: WCAG 2.1 AA compliance

**Why it matters**: Inclusive content reaches everyone, especially important for branding

---

## Learnings & Institutional Memory

Lisa captures insights after every deliverable in `learnings.txt`. This creates institutional memory across campaigns.

### How It Works

After completing each deliverable, Lisa automatically appends an entry:

```
[2026-01-10 14:30] - Marketing - MKT-001 - Q1 Product Launch
Created: Landing page copy (deliverables/MKT-001-product-landing-page.md)
Key insights: Benefit-driven headlines performed better than feature lists.
CTAs above and below fold increased conversions.
Marketing-specific notes: Enterprise buyers respond to ROI messaging and
customer proof points.
```

### Using Learnings

**Before starting a new campaign**:
- Read `learnings.txt` for insights
- Search for similar deliverable types
- Look for patterns in what worked well

**Example searches**:
```bash
# Find all email sequence learnings
grep "email-sequence" learnings.txt

# Find marketing-specific insights
grep "Marketing" learnings.txt

# Find press release patterns
grep "press-release" learnings.txt
```

### Learnings Structure

The file is organized into sections:
- **Brand Patterns**: Consistent brand elements across campaigns
- **Campaign Insights**: Strategic and tactical wins
- **Discipline-Specific Learnings**: Insights by marketing/PR/branding

**Important**: `learnings.txt` is append-only. Never delete or modify existing entries. This preserves institutional knowledge.

---

## Example Workflows

### Marketing: Product Launch Campaign

```
Scenario: Launching a new AI analytics product to enterprise buyers

1. Generate marketing plan
   - Activate marketing-plan skill
   - Select: Product Launch campaign
   - Audience: Enterprise B2B
   - Goals: Generate leads, increase traffic
   - Channels: Email, landing page, social, blog
   - Timeline: Standard (1-2 months)
   - Deliverables: Landing page, email sequence, social posts, blog article

2. Review and refine PRD
   - Skill saves to campaign-plans/marketing-prd-q1-product-launch.md
   - Edit if needed (add specific requirements, adjust timeline)

3. Convert to campaign brief
   - Use lisa skill: provide PRD file path
   - Skill generates q1-product-launch-campaign-brief.json
   - Validates against schema

4. Customize brand guidelines
   - Edit scripts/brand-config.json
   - Add product-specific terminology
   - Add competitor names to prohibitedTerms

5. Run campaign
   - /lisa q1-product-launch-campaign-brief.json
   - Lisa creates deliverables in order:
     1. Landing page (foundation)
     2. Email sequence (links to landing page)
     3. Social posts (drive traffic to landing page)
     4. Blog article (SEO and thought leadership)

6. Review deliverables
   - Check deliverables/ folder
   - Landing page: SEO optimized, benefit-focused, clear CTAs
   - Emails: Progressive value delivery, links to features
   - Social: Platform-appropriate, engagement hooks
   - Blog: Thought leadership, subtle product mentions

7. Refine and deploy
   - Review content, make edits as needed
   - Deploy to your CMS, email platform, social scheduler
   - Check learnings.txt for insights on next campaign
```

### PR: Product Announcement

```
Scenario: Announcing enterprise software product to tech media

1. Generate PR plan
   - Activate pr-plan skill
   - Select: Product Announcement
   - Target media: Tech Media (TechCrunch, The Verge)
   - News angle: Innovation (AI-powered automation)
   - Spokesperson: CEO
   - Timeline: Planned launch (1-3 months)
   - Embargo: Yes, for tier-1 outlets
   - Deliverables: Press release, media pitch, talking points, Q&A, fact sheet

2. Review and refine PRD
   - Skill saves to campaign-plans/pr-prd-product-announcement.md
   - Add specific embargo dates, customer names, data points

3. Convert to campaign brief
   - Use lisa skill with PRD path
   - Generates product-announcement-campaign-brief.json

4. Run campaign
   - /lisa product-announcement-campaign-brief.json
   - Lisa creates deliverables in order:
     1. Press release (foundation, includes embargo)
     2. Media pitch (references press release)
     3. Talking points (for CEO interviews)
     4. Q&A document (expands on talking points)
     5. Fact sheet (quick reference for journalists)

5. Review deliverables
   - Press release: AP Style, newsworthy lead, CEO quote, customer traction
   - Media pitch: Personalized angles, clear news hook
   - Talking points: Key messages with bridging phrases
   - Q&A: Comprehensive coverage of likely questions
   - Fact sheet: One-page reference, all key facts

6. Execute PR campaign
   - Embargo pitching begins
   - CEO media training with talking points
   - Q&A document for spokesperson prep
   - Fact sheet attached to all pitches
```

### Branding: Brand Refresh

```
Scenario: Modernizing brand for enterprise software company

1. Generate branding plan
   - Activate branding-plan skill
   - Select: Brand Refresh
   - Scope: Full Brand System
   - Audience: B2B Enterprise
   - Attributes: Innovative, Trustworthy, Approachable
   - Positioning: Innovation Leader
   - Personality: The Expert
   - Timeline: Comprehensive (4-6 months)
   - Deliverables: Positioning, voice guide, messaging framework, brand story, tagline

2. Review and refine PRD
   - Skill saves to campaign-plans/branding-prd-brand-refresh-2026.md
   - Add competitive context, customer insights, strategic rationale

3. Convert to campaign brief
   - Use lisa skill with PRD path
   - Generates brand-refresh-campaign-brief.json

4. Run campaign
   - /lisa brand-refresh-campaign-brief.json
   - Lisa creates deliverables in order:
     1. Brand positioning (strategic foundation)
     2. Voice & tone guide (personality expression)
     3. Messaging framework (hierarchical messages)
     4. Brand story (narrative)
     5. Tagline (concise promise)

5. Review deliverables
   - Positioning: Clear differentiation, target audience, proof points
   - Voice guide: Dimensions, examples, do's and don'ts
   - Messaging: Master message, pillars, proof points, usage guidance
   - Brand story: Origin, journey, values, vision
   - Tagline: Memorable, differentiated, credible options with rationale

6. Implement brand refresh
   - Stakeholder review and approval
   - Rollout plan across touchpoints
   - Website, marketing, product updates
   - Internal training on new brand
```

---

## Configuration

### Brand Guidelines

Edit `scripts/brand-config.json`:

```json
{
  "approvedTerms": [
    "innovative",
    "customer-focused",
    "reliable"
  ],
  "prohibitedTerms": [
    "CompetitorName",
    "cheap",
    "revolutionize",
    "synergy"
  ],
  "requiredTerms": [
    "YourBrand®"
  ],
  "voiceToneKeywords": [
    "professional",
    "approachable",
    "confident"
  ]
}
```

**Tips**:
- Add competitor names to `prohibitedTerms`
- Add legal required terms to `requiredTerms`
- Update `approvedTerms` with your brand vocabulary
- Keep `voiceToneKeywords` aligned with brand personality

### Quality Thresholds

You can adjust thresholds by editing quality check scripts:

**Readability**: `scripts/readability-check.py`
```python
# Default threshold: 60
# Change line: default=60
# to your preferred threshold
```

**SEO keyword density**: `scripts/seo-check.py`
```python
# Default: 2-4% range
# Adjust warning thresholds in check_seo() function
```

---

## Troubleshooting

### Lisa isn't starting

**Symptom**: `/lisa campaign-brief.json` does nothing or errors

**Solutions**:
1. **Verify file exists**: `ls campaign-brief.json`
2. **Validate JSON**: `jq empty campaign-brief.json`
3. **Check Python dependencies**: `pip install -r scripts/requirements.txt`
4. **Check jq installed**: `which jq` (install with `brew install jq` on macOS)

### Quality checks failing

**Symptom**: Deliverables not getting approved, quality check errors

**Solutions**:
1. **Review error messages**: Quality scripts output specific issues
2. **Check brand-config.json**: May have overly restrictive terms
3. **Lower thresholds temporarily**: Edit quality check scripts
4. **Check acceptance criteria**: May be too strict or vague

**Common issues**:
- **Readability too low**: Use shorter sentences, simpler words
- **SEO checks fail**: Ensure meta description exists, proper headers
- **Brand compliance fail**: Check for prohibited terms in output
- **AP Style violations**: Review dates, times, punctuation

### Deliverables not approved

**Symptom**: Lisa keeps iterating, never marks `approved=true`

**Causes**:
1. **Vague acceptance criteria**: "Good quality" can't be verified
2. **Conflicting criteria**: Requirements that contradict each other
3. **Impossible requirements**: Criteria that can't be met

**Solutions**:
1. **Make criteria specific**: "Word count: 400-600" not "appropriate length"
2. **Make criteria verifiable**: "Includes 3 customer logos" not "compelling social proof"
3. **Review criteria**: Ensure they're realistic and achievable

### Campaign won't complete

**Symptom**: Loop doesn't stop even when deliverables look done

**Solutions**:
1. **Check campaign brief**: Are ALL deliverables `approved=true`?
2. **Check dependencies**: Ensure dependency chain is complete
3. **Check completion promise**: Lisa outputs `<promise>COMPLETE</promise>` when done
4. **Manual stop**: Use `/cancel-lisa` if needed

### Python scripts not working

**Symptom**: Quality checks error with Python import errors

**Solutions**:
1. **Install requirements**: `pip install -r scripts/requirements.txt`
2. **Check Python version**: `python3 --version` (need 3.8+)
3. **Use virtual environment**:
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   pip install -r scripts/requirements.txt
   ```

### Permission denied errors

**Symptom**: `permission denied` when running scripts

**Solution**: Make scripts executable:
```bash
chmod +x scripts/*.sh
chmod +x scripts/*.py
```

---

## Directory Structure

```
.claude/plugins/lisa/
├── .claude-plugin/
│   └── plugin.json              # Plugin metadata
├── commands/
│   ├── lisa.md                  # /lisa command definition
│   └── cancel-lisa.md           # /cancel-lisa command
├── hooks/
│   ├── hooks.json               # Hook registration
│   └── stop-hook.sh             # Stop hook (autonomous loop)
├── scripts/
│   ├── setup-lisa-campaign.sh   # Campaign initialization
│   ├── brand-check.sh           # Brand compliance validation
│   ├── brand-config.json        # Brand guidelines (customize this!)
│   ├── readability-check.py     # Flesch-Kincaid scoring
│   ├── seo-check.py             # SEO validation (marketing)
│   ├── accessibility-check.py   # WCAG 2.1 AA compliance
│   ├── ap-style-check.py        # AP Style validation (PR)
│   └── requirements.txt         # Python dependencies
├── skills/
│   ├── marketing-plan/SKILL.md  # Marketing PRD generation
│   ├── pr-plan/SKILL.md         # PR PRD generation
│   ├── branding-plan/SKILL.md   # Branding PRD generation
│   └── lisa/SKILL.md            # PRD → JSON conversion
├── schemas/
│   └── campaign-brief.schema.json  # JSON schema specification
├── examples/
│   ├── q1-product-launch-marketing.json      # Marketing template
│   ├── product-announcement-pr.json          # PR template
│   └── brand-refresh-branding.json           # Branding template
├── prompts/
│   ├── marketing-agent.md       # Marketing coordinator behavior
│   ├── pr-agent.md              # PR coordinator behavior
│   └── branding-agent.md        # Branding coordinator behavior
├── .gitignore                   # Ignore user output files
└── README.md                    # This file
```

---

## Examples

The `examples/` directory contains complete campaign briefs for each discipline:

### Marketing Example
**File**: `examples/q1-product-launch-marketing.json`

**Campaign**: Q1 Product Launch for AI Analytics Dashboard

**Deliverables**: 6 marketing deliverables
- Landing page with hero and features
- Email sequence (3 emails for trial users)
- LinkedIn social posts (launch week series)
- Thought leadership blog article
- Newsletter for existing customers
- Customer success case study

**Use this for**: Product launches, feature announcements, lead generation campaigns

### PR Example
**File**: `examples/product-announcement-pr.json`

**Campaign**: Enterprise Analytics Platform Product Announcement

**Deliverables**: 6 PR deliverables
- Press release with embargo
- Media pitch for tech journalists
- CEO media interview talking points
- Q&A document for spokesperson prep
- Product fact sheet for media
- Media advisory for demo event

**Use this for**: Product announcements, company news, media engagement

### Branding Example
**File**: `examples/brand-refresh-branding.json`

**Campaign**: TechFlow Brand Refresh 2026

**Deliverables**: 5 branding deliverables
- Updated brand positioning statement
- Brand voice & tone guidelines
- Hierarchical messaging framework
- TechFlow brand story narrative
- Brand tagline with evaluation

**Use this for**: Brand refreshes, rebrands, brand strategy projects

---

## Extending Lisa

Lisa is designed to be extended. See `EXTENDING.md` for details on:

- **Adding new deliverable types**: Extend the schema enum
- **Creating new quality checks**: Add Python or bash scripts
- **Supporting new disciplines**: Add agent prompts and quality gates
- **Integrating external tools**: Connect to CMS, email platforms, media databases
- **Custom workflows**: Build on top of Lisa's orchestration

Common extensions:
- A/B testing integration
- Analytics tracking
- CMS publishing automation
- Media contact management
- Brand asset management
- Approval workflow integration

---

## Contributing

Contributions are welcome! Please see CONTRIBUTING.md for guidelines.

---

## License

MIT License - see LICENSE file for details

---

## Support

- **Issues**: [GitHub Issues](https://github.com/kenziecreative/lisa/issues)
- **Email**: kelsey@kenziecreative.com
- **Documentation**: This README and EXTENDING.md

---

## Changelog

See CHANGELOG.md for version history and updates.

---

**Lisa**: Autonomous creative orchestration for marketing, PR, and branding teams.

Built with Claude Code using the Ralph Wiggum pattern.
