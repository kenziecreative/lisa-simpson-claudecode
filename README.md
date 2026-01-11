# Lisa for Claude Code

**Multi-Discipline Creative Orchestration for Marketing, PR, and Branding Teams**

**Version:** 1.0.0 | **Released:** January 11, 2026

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
- [Setting Up Lisa for Your Company](#setting-up-lisa-for-your-company)
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

### Quick Install (Recommended)

**For macOS and Linux users** - one command installs everything:

```bash
curl -sSL https://raw.githubusercontent.com/kenziecreative/lisa-simpson-claudecode/main/setup.sh | bash
```

This automated script will:
- ✅ Detect your operating system
- ✅ Install all prerequisites (Python, jq, git, Node.js, Claude Code CLI)
- ✅ Download and install Lisa
- ✅ Verify everything works

**Time:** 5-10 minutes | **No technical knowledge required**

**What you'll see:** The script will ask for your password once - this is normal and safe. It needs permission to install software on your computer.

---

### New to the Command Line?

If you're not comfortable working in the terminal, **start here first**: [Command Line Basics for Lisa Users](COMMAND-LINE-BASICS.md)

This guide covers the essential commands you need:
- `ls` - List files and folders
- `cd` - Change directories
- `cat` - View file contents
- `mkdir` - Create folders
- And how to navigate between directories

**5-minute read** · Beginner-friendly · No prior experience needed

---

### Easy Installation with AI Assistants

**Not technical? No problem.** Use an AI coding assistant like [Cursor](https://cursor.com/download), [Windsurf](https://codeium.com/windsurf), [Google Antigravity](https://antigravity.google/download), or other AI-powered editors to handle the installation for you.

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
   git clone https://github.com/kenziecreative/lisa-simpson-claudecode.git

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

**For advanced users** who want full control over the installation process.

#### Prerequisites

Before installing Lisa manually, you'll need:

- **git**: Version control system for downloading Lisa
  - macOS: `brew install git` or install Xcode Command Line Tools
  - Linux: `sudo apt-get install git` (Ubuntu/Debian) or `sudo yum install git` (CentOS/RHEL)
  - Verify: `git --version`

- **Python 3.8+**: Required for quality check scripts
  - macOS: `brew install python3` or download from [python.org](https://www.python.org/downloads/)
  - Linux: `sudo apt-get install python3 python3-pip`
  - Verify: `python3 --version` (should show 3.8 or higher)

- **jq**: JSON processor for bash scripts
  - macOS: `brew install jq`
  - Linux: `sudo apt-get install jq`
  - Verify: `jq --version`

- **Claude Code CLI**: The command-line interface for Claude Code
  - Install via npm: `npm install -g @anthropic-ai/claude-code`
  - Or download from [claude.ai/code](https://claude.ai/code)
  - Verify: `claude --version`

#### Installation Steps

##### Step 1: Clone the Repository

```bash
git clone https://github.com/kenziecreative/lisa-simpson-claudecode.git
```

##### Step 2: Copy to Claude Code Plugins Directory

```bash
# Copy the lisa directory to your Claude Code plugins folder
cp -r lisa ~/.claude/plugins/lisa

# Or if you prefer, symlink it for easier updates
ln -s /path/to/lisa ~/.claude/plugins/lisa
```

##### Step 3: Install Python Dependencies

```bash
cd ~/.claude/plugins/lisa
pip3 install -r scripts/requirements.txt
```

This installs:
- `textstat` - Readability scoring (Flesch reading ease)
- `beautifulsoup4` - HTML/XML parsing
- `markdown` - Markdown to HTML conversion

##### Step 4: Verify Installation

Check that all Python dependencies installed correctly:

```bash
python3 -c "import textstat, bs4, markdown; print('✓ All dependencies installed')"
```

Verify Lisa is in the correct location:

```bash
ls ~/.claude/plugins/lisa/.claude-plugin/plugin.json
```

If you see the file path, Lisa is installed correctly.

##### Step 5: Start Using Lisa

Restart Claude Code (if it's running), then check that Lisa commands are available:

```
/marketing
/pr
/branding
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

## Setting Up Lisa for Your Company

**Most Important Step**: To get personalized, on-brand content instead of generic AI output, set up your company context files. This takes 10-15 minutes and dramatically improves Lisa's output quality.

### Quick Setup (Recommended)

The fastest way to set up Lisa is with the `setup-company` skill, which extracts information from your existing brand documents:

1. **Run the setup skill**:
   ```bash
   # In Claude Code
   /setup-company
   ```

2. **Provide your brand documents**:
   - Brand guidelines or brand book (PDF, paste from Google Docs/Notion, Markdown)
   - Style guide or editorial guidelines
   - Company info sheet or "About Us" page
   - Marketing messaging documents

3. **Answer follow-up questions**: Lisa will ask about any missing information like:
   - Company metrics (customer count, growth, revenue)
   - Executive information for press release quotes
   - Standard boilerplate for PR materials

4. **Review and approve**: Lisa shows a preview before saving. Check it's accurate.

5. **Run verification test**: Lisa creates a test campaign to verify context is loading correctly.

### What You're Creating

Lisa uses **5 context files** to understand your company:

#### 1. company-profile.json
**Core company facts that rarely change**

```json
{
  "companyName": "Acme Analytics",
  "industry": "SaaS - Business Intelligence",
  "foundedYear": 2019,
  "teamSize": "75-100",
  "mission": "Make data accessible to everyone, not just data teams",
  "valuePropositions": [
    {
      "audience": "Small businesses",
      "proposition": "Enterprise-grade analytics without enterprise complexity"
    }
  ],
  "targetAudience": {
    "description": "Small to mid-size B2B companies (10-500 employees)",
    "painPoints": [
      "Too much time spent on manual reports",
      "BI tools too complex for non-technical users",
      "Can't afford dedicated data team"
    ]
  },
  "keyProducts": [
    {
      "name": "Acme Analytics Platform",
      "description": "Self-service business intelligence",
      "keyFeatures": ["No-code dashboards", "Real-time data sync", "Slack/email alerts"]
    }
  ],
  "metrics": {
    "customers": "2,500+ companies",
    "revenue": "$15M ARR",
    "growth": "250% YoY",
    "otherMetrics": ["4.9/5 G2 rating with 500+ reviews"]
  },
  "boilerplate": "Acme Analytics helps small businesses make data-driven decisions without hiring a data team. With no-code dashboards and real-time insights, over 2,500 companies use Acme to turn their data into action. Founded in 2019, Acme has raised $25M from top investors and is growing 250% year-over-year."
}
```

**Used for**: Press releases, company facts, customer numbers, product descriptions

#### 2. brand-voice.json
**How your company communicates**

```json
{
  "voiceAttributes": [
    {
      "attribute": "Clear & Direct",
      "description": "We don't use jargon or buzzwords. We explain what we do in plain English.",
      "examples": [
        "✅ 'Setup takes one hour' (not 'seamlessly integrate your infrastructure')",
        "✅ 'No SQL knowledge required' (not 'democratize data access')"
      ]
    },
    {
      "attribute": "Confident but Humble",
      "description": "We know we're good, but we don't oversell or hype.",
      "examples": [
        "✅ 'Our customers save 10 hours per week on reports'",
        "❌ 'Revolutionary AI-powered insights that will transform your business'"
      ]
    }
  ],
  "prohibitedPatterns": [
    {
      "pattern": "Revolutionize / disrupt / game-changing",
      "reason": "Overused tech buzzwords that sound like hype",
      "alternative": "Change how teams work with data / Make BI accessible"
    },
    {
      "pattern": "Synergy / leverage / paradigm shift",
      "reason": "Corporate jargon that obscures meaning",
      "alternative": "Use specific, plain language"
    }
  ],
  "signatureMoves": [
    {
      "move": "Three short sentences for emphasis",
      "example": "No SQL. No waiting. No data team.",
      "whenToUse": "Headlines, key benefits, CTAs"
    }
  ],
  "toneGuidelines": {
    "marketing": "Confident and benefit-focused. Lead with customer outcomes.",
    "pr": "Professional but approachable. Lead with news value.",
    "crisis": "Direct and empathetic. Acknowledge issue, explain action."
  }
}
```

**Used for**: Matching voice in all content, avoiding off-brand language

#### 3. style-preferences.json
**Formatting, style rules, and readability thresholds**

```json
{
  "styleGuide": "AP",
  "spellingChoices": {
    "preferredSpellings": {
      "email": "email (not e-mail)",
      "login": "log in (verb) / login (noun)"
    },
    "hyphenationRules": ["Self-service (always hyphenated)", "Real-time (hyphenated as adjective)"]
  },
  "formattingRules": {
    "headings": "Sentence case (not Title Case)",
    "lists": "Parallel structure, end with periods if complete sentences",
    "links": "Descriptive link text (not 'click here')",
    "numbers": "Spell out one through nine, use numerals for 10+"
  },
  "readabilityThresholds": {
    "_comment": "Based on comprehensive testing of all 23 deliverable types",
    "globalDefault": 60,
    "byDeliverableType": {
      "email-sequence": 65,
      "press-release": 60,
      "thought-leadership": 55,
      "crisis-response": 70,
      "visual-identity-brief": 50
    }
  },
  "legalDisclaimers": [
    {
      "text": "Results may vary. Individual outcomes depend on usage and configuration.",
      "whenToUse": "Case studies, testimonials, performance claims"
    }
  ]
}
```

**Used for**: Consistent formatting, appropriate readability levels

**Pro Tip**: You don't need to configure all 23 deliverable types. Only override the ones where you want different readability levels. Lisa uses this fallback chain:

1. **Deliverable's acceptance criteria** (highest priority) - campaign-specific override
2. **Your style-preferences.json** - your company defaults
3. **Built-in defaults from testing** (lowest priority) - Lisa's tested values

#### 4. lisa-memory-core.json
**Permanent facts about your company**

```json
{
  "version": "1.0",
  "lastUpdated": "2026-01-11T00:00:00Z",
  "entries": [
    {
      "id": "mem-exec-001",
      "content": "CEO: Jane Smith, jane@acme.com. Preferred title: 'CEO and co-founder'. Bio: Former Director of Analytics at Google, Stanford CS degree.",
      "category": "people",
      "tags": ["executives", "press-releases", "quotes"]
    },
    {
      "id": "mem-product-001",
      "content": "Major product launch: Acme AI Assistant launched March 2026. First AI-powered query builder for business users.",
      "category": "product",
      "tags": ["product-launches", "ai-features"]
    },
    {
      "id": "mem-milestone-001",
      "content": "Series B funding: $25M Series B led by Sequoia in January 2026. Use this for credibility in press releases.",
      "category": "milestones",
      "tags": ["funding", "press-releases"]
    }
  ]
}
```

**Used for**: Executive bios, key dates, major announcements, awards

**When to add entries**: When you have permanent facts that should be referenced in future campaigns (executive names, major milestones, key dates).

#### 5. lisa-memory-contextual.json
**Learned patterns from feedback**

This file is automatically updated when you give Lisa feedback during campaigns. You can also edit it manually.

```json
{
  "version": "1.0",
  "lastUpdated": "2026-01-11T14:30:00Z",
  "entries": [
    {
      "id": "mem-1704983421",
      "name": "Avoid 'customers' in enterprise content",
      "category": "voice",
      "whenToUse": "When writing for enterprise audience (press releases, thought leadership)",
      "tags": ["enterprise", "voice", "terminology"],
      "content": "User prefers 'companies' or 'organizations' over 'customers' when targeting enterprise buyers. 'Customers' sounds too transactional for B2B.",
      "learnedFrom": "user-feedback-Q1-Product-Launch",
      "learnedDate": "2026-01-11T14:30:00Z"
    }
  ]
}
```

**How it works**: When you provide feedback like "I wouldn't say it like that", Lisa immediately adds an entry and applies it to future deliverables.

**View your memory**: Run `/lisa:show-memory` to see all learned patterns.

### Manual Setup (If You Prefer)

If you want to create context files manually:

1. **Copy templates to context directory**:
   ```bash
   cd ~/.claude/plugins/marketplaces/local/plugins/lisa
   cp context/templates/*.json context/
   ```

2. **Edit each file** with your company information:
   - `context/company-profile.json`
   - `context/brand-voice.json`
   - `context/style-preferences.json`
   - `context/lisa-memory-core.json`
   - `context/lisa-memory-contextual.json`

3. **Run verification test** (see below)

### Verification Test

After setup, verify Lisa is using your context:

```bash
# Create a simple test campaign
cat > test-context.json << 'EOF'
{
  "campaign": "Context Verification",
  "campaignType": "marketing",
  "deliverables": [{
    "id": "TEST-001",
    "type": "email-sequence",
    "title": "Test email to verify context",
    "description": "Simple promotional email",
    "acceptanceCriteria": [
      "Uses correct company name and products",
      "Matches brand voice",
      "Includes boilerplate if appropriate"
    ],
    "priority": 1,
    "approved": false
  }]
}
EOF

# Run the test
/lisa:lisa test-context.json --max-iterations 5
```

Check the generated email for:
- ✅ Company name and products mentioned correctly
- ✅ Voice matches your brand attributes
- ✅ Boilerplate included where appropriate
- ✅ Style preferences applied

### Troubleshooting

**My content still feels generic**

1. **Check if context files were loaded**:
   - When you start a campaign, Lisa displays: "Context: ✅ Loaded 5 context file(s)"
   - If you see "⚠️ No context files found", files aren't in the right location

2. **Verify file location**:
   ```bash
   ls -la ~/.claude/plugins/marketplaces/local/plugins/lisa/context/
   ```
   You should see: `company-profile.json`, `brand-voice.json`, etc.

3. **Check file is valid JSON**:
   ```bash
   jq empty ~/.claude/plugins/marketplaces/local/plugins/lisa/context/company-profile.json
   ```
   If you see errors, fix JSON syntax.

4. **Review context section in state file**:
   ```bash
   cat .claude/lisa-campaign.local.md
   ```
   You should see a "# Company Context" section with your company information.

**Lisa isn't matching my brand voice**

1. Add more specific examples to `brand-voice.json` voiceAttributes
2. Add prohibited patterns for phrases you want to avoid
3. Provide feedback during campaigns: "I wouldn't say it like that"
4. Lisa will learn and add to contextual memory

**How do I update context as my company evolves?**

- **Company profile**: Edit when major changes occur (new product, funding, updated metrics)
- **Brand voice**: Edit when brand guidelines evolve
- **Style preferences**: Edit when you want different readability thresholds or formatting rules
- **Core memory**: Add new facts as they become relevant (new executives, major announcements)
- **Contextual memory**: Lisa updates automatically from feedback, but you can manually edit

### What Each File Does (Plain Language)

| File | What It Stores | When Lisa Uses It |
|------|----------------|-------------------|
| `company-profile.json` | Company facts (name, products, metrics, boilerplate) | Press releases, company descriptions, product mentions |
| `brand-voice.json` | How you communicate (voice attributes, prohibited words) | Every deliverable - keeps content on-brand |
| `style-preferences.json` | Formatting rules, readability levels | Formatting all content, checking readability |
| `lisa-memory-core.json` | Permanent facts (exec names, key dates, major news) | When relevant to the deliverable |
| `lisa-memory-contextual.json` | Learned patterns from your feedback | Automatically when conditions match |

### Privacy Note

Context files contain your company's private information and are **not committed to git**.

If you want version control:
1. Create a private repo for your context: `mkdir ~/my-company-lisa-context && cd ~/my-company-lisa-context && git init`
2. Move context directory: `mv ~/.claude/plugins/marketplaces/local/plugins/lisa/context ~/my-company-lisa-context/`
3. Symlink it back: `ln -s ~/my-company-lisa-context/context ~/.claude/plugins/marketplaces/local/plugins/lisa/context`
4. Now your context is version controlled separately

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

### Lisa commands require approval every time (Claude Code Issue #145)

**Symptom**: Claude Code asks for permission every time you run `/lisa`, even after approving once

**Cause**: This is a known bug in Claude Code (Issue #145) where the `${CLAUDE_PLUGIN_ROOT}` variable doesn't expand correctly in `allowed-tools` patterns defined in plugin.json.

**Solution**: The setup.sh script automatically applies a workaround by adding Lisa's setup script to your `~/.claude/settings.json` permissions. If you installed Lisa manually or the workaround didn't apply, you can add it manually:

1. Open `~/.claude/settings.json` in a text editor
2. Add this to the `permissions.allow` array:
   ```json
   {
     "permissions": {
       "allow": [
         "Bash(/Users/YOUR_USERNAME/.claude/plugins/marketplaces/local/plugins/lisa/scripts/setup-lisa-campaign.sh:*)"
       ]
     }
   }
   ```
   Replace `YOUR_USERNAME` with your actual username.

3. Save the file and restart Claude Code

**Note**: This workaround will be removed once Claude Code Issue #145 is resolved. Track the issue at: https://github.com/anthropics/claude-code/issues/145

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

- **Issues**: [GitHub Issues](https://github.com/kenziecreative/lisa-simpson-claudecode/issues)
- **Email**: kelsey@kenziecreative.com
- **Documentation**: This README and EXTENDING.md

---

## Changelog

See CHANGELOG.md for version history and updates.

---

**Lisa**: Autonomous creative orchestration for marketing, PR, and branding teams.

Built with Claude Code using the Ralph Wiggum pattern.
