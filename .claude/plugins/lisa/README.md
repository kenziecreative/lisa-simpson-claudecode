# Lisa Plugin

**Multi-Discipline Creative Orchestration for Claude Code**

Lisa is a Claude Code plugin that brings autonomous orchestration to marketing, PR, and branding teams. Using the Ralph Wiggum Stop hook pattern, Lisa helps creative professionals automate campaign deliverables with quality gates, institutional memory, and discipline-appropriate language.

## What is Lisa?

Lisa is an AI coordinator that:
- 📋 Reads your campaign briefs and project plans
- ✍️ Creates deliverables one at a time
- ✅ Checks quality (brand compliance, readability, SEO, accessibility, AP Style)
- 🧠 Learns from each campaign

## Supported Disciplines

- **Marketing**: Email sequences, landing pages, social posts, ad copy, blog articles, newsletters, case studies, webinar scripts
- **PR**: Press releases, media pitches, press kits, crisis communications, talking points, media advisories, op-eds, Q&A documents, fact sheets
- **Branding**: Brand guidelines, brand positioning, voice & tone guides, messaging frameworks, taglines, brand stories

## Quick Start

### 1. Installation

The Lisa plugin is included in this repository at `.claude/plugins/lisa/`.

### 2. Create a Campaign Brief

Use one of the skills to generate a campaign brief:

```
# For marketing campaigns
Use the marketing-plan skill

# For PR campaigns
Use the pr-plan skill

# For branding projects
Use the branding-plan skill
```

Or create a `campaign-brief.json` manually (see `examples/` for templates).

### 3. Run Lisa

```
/lisa campaign-brief.json
```

Lisa will autonomously work through your deliverables, checking quality at each step.

### 4. Review Results

- **Deliverables**: Check the `deliverables/` folder
- **Progress**: Review `learnings.txt` for insights
- **Campaign Brief**: See updated `approved` flags in your JSON

## How It Works

Lisa uses a **Stop hook pattern** (inspired by Ralph Wiggum):

1. **Read**: Lisa reads your campaign brief and picks the highest priority deliverable where `approved=false`
2. **Create**: Lisa generates the deliverable content
3. **Validate**: Runs discipline-specific quality checks (brand, readability, SEO, etc.)
4. **Update**: If checks pass, marks `approved=true` in the campaign brief
5. **Learn**: Appends insights to `learnings.txt` for future campaigns
6. **Repeat**: Continues until all deliverables are approved

### Stop Conditions

Lisa stops when:
- All deliverables have `approved=true`, OR
- Maximum iterations reached (default: 30)

## Campaign Brief Format

```json
{
  "campaign": "Q1 Product Launch",
  "campaignType": "marketing",
  "description": "Launch campaign for new AI product",
  "deliverables": [
    {
      "id": "DEL-001",
      "type": "email-sequence",
      "title": "Welcome email series",
      "description": "3-email nurture sequence for trial signups",
      "acceptanceCriteria": [
        "3 emails with progressive value proposition",
        "CTAs link to onboarding",
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

## Quality Gates

Lisa applies different quality checks based on discipline:

| Discipline | Quality Gates |
|------------|---------------|
| **Marketing** | Brand compliance, Readability, SEO, Accessibility |
| **PR** | Brand compliance, Readability, AP Style, Accessibility |
| **Branding** | Brand compliance, Accessibility |

See `QUALITY-GATES.md` for configuration details.

## Commands

- `/lisa <brief.json>` - Start a campaign loop
- `/cancel-lisa` - Stop the active campaign

## Skills

- **marketing-plan** - Generate a marketing campaign PRD
- **pr-plan** - Generate a PR campaign PRD
- **branding-plan** - Generate a branding project PRD
- **lisa** - Convert markdown PRD to campaign-brief.json

## Directory Structure

```
.claude/plugins/lisa/
├── .claude-plugin/
│   └── plugin.json          # Plugin metadata
├── commands/
│   ├── lisa.md              # /lisa command
│   └── cancel-lisa.md       # /cancel-lisa command
├── hooks/
│   ├── hooks.json           # Hook registration
│   └── stop-hook.sh         # Stop hook implementation
├── scripts/
│   ├── setup-lisa-campaign.sh    # Campaign initialization
│   ├── brand-check.sh            # Brand compliance validation
│   ├── brand-config.json         # Brand guidelines config
│   ├── readability-check.py      # Readability scoring
│   ├── seo-check.py              # SEO validation
│   ├── accessibility-check.py    # Accessibility validation
│   ├── ap-style-check.py         # AP Style validation
│   └── requirements.txt          # Python dependencies
├── skills/
│   ├── marketing-plan/      # Marketing PRD generation
│   ├── pr-plan/             # PR PRD generation
│   ├── branding-plan/       # Branding PRD generation
│   └── lisa/                # PRD → JSON conversion
├── schemas/
│   └── campaign-brief.schema.json  # Campaign brief JSON schema
├── examples/
│   ├── q1-product-launch-marketing.json
│   ├── product-announcement-pr.json
│   ├── brand-refresh-branding.json
│   └── deliverables/        # Example output
├── prompts/
│   ├── marketing-agent.md   # Marketing coordinator prompt
│   ├── pr-agent.md          # PR coordinator prompt
│   └── branding-agent.md    # Branding coordinator prompt
└── README.md                # This file
```

## Configuration

### Brand Guidelines

Edit `scripts/brand-config.json` to customize brand compliance checks:

```json
{
  "approvedTerms": ["your", "brand", "terms"],
  "prohibitedTerms": ["competitors", "jargon"],
  "requiredTerms": ["trademark"],
  "voiceToneKeywords": ["professional", "friendly"]
}
```

### Quality Thresholds

- **Readability**: Default > 60 (Flesch-Kincaid Reading Ease)
- **SEO keyword density**: 2-4%
- **Accessibility**: WCAG 2.1 AA standards

## Extending Lisa

See `EXTENDING.md` for:
- Adding new deliverable types
- Creating new quality checks
- Adding support for additional disciplines
- Integrating with external tools (CMS, email platforms, etc.)

## Troubleshooting

### Lisa isn't starting

- Ensure campaign-brief.json is valid JSON
- Check that file paths are correct
- Verify Python dependencies are installed: `pip install -r scripts/requirements.txt`

### Quality checks failing

- Review specific error messages from quality scripts
- Check `QUALITY-GATES.md` for configuration options
- Customize thresholds in quality check scripts

### Deliverables not approved

- Check acceptance criteria are specific and verifiable
- Review quality gate outputs for specific issues
- Verify deliverable content meets all criteria

## Examples

See the `examples/` directory for:
- Marketing campaign brief (Q1 product launch)
- PR campaign brief (product announcement)
- Branding project brief (brand refresh)
- Example deliverables (emails, press releases, brand positioning)

## License

MIT

## Author

Kelsey Ruger (kelsey@kenziecreative.com)

---

**Lisa**: Autonomous creative orchestration for marketing, PR, and branding teams.
