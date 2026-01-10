---
description: "Start Lisa campaign loop for marketing, PR, or branding deliverables"
argument-hint: "campaign-brief.json [--max-iterations N] [--completion-promise TEXT]"
allowed-tools: ["Bash(${CLAUDE_PLUGIN_ROOT}/scripts/setup-lisa-campaign.sh:*)"]
hide-from-slash-command-tool: "true"
---

# Lisa Campaign Command

Execute the setup script to initialize a Lisa campaign loop:

```!
"${CLAUDE_PLUGIN_ROOT}/scripts/setup-lisa-campaign.sh" $ARGUMENTS
```

Lisa will work through your campaign deliverables autonomously, creating content,
checking quality, and updating your campaign brief as she progresses. When you try
to exit, the Stop hook will continue the loop until all deliverables are approved
or max iterations is reached.

## How It Works

1. Lisa reads your campaign brief and picks the highest priority deliverable where approved=false
2. Creates the deliverable content following your description and acceptance criteria
3. Runs discipline-appropriate quality checks (brand compliance, readability, SEO, AP Style, accessibility)
4. If all checks pass, marks approved=true in your campaign brief
5. Logs learnings to learnings.txt for institutional memory
6. Repeats until all deliverables have approved=true

## Usage Examples

**Marketing campaign:**
```
/lisa examples/q1-product-launch-marketing.json
```

**PR campaign:**
```
/lisa examples/product-announcement-pr.json --max-iterations 50
```

**Branding project:**
```
/lisa examples/brand-refresh-branding.json --completion-promise "ALL COMPLETE"
```

**Custom campaign:**
```
/lisa my-campaign-brief.json --max-iterations 30
```

## Campaign Brief Format

Your campaign-brief.json should include:
- `campaign`: Campaign name
- `campaignType`: "marketing", "pr", or "branding"
- `deliverables`: Array of deliverables with acceptance criteria, priorities, and dependencies

See examples/ directory for templates.

## Completion

Lisa outputs `<promise>COMPLETE</promise>` (or your custom completion promise) when ALL
deliverables have approved=true.

CRITICAL RULE: Lisa may ONLY output the completion promise when ALL deliverables are
genuinely approved and the statement is completely TRUE. Never output false promises
to escape the loop, even if stuck or running long. Trust the iterative process.

## During the Campaign

- Check progress: `head -20 .claude/lisa-campaign.local.md`
- View learnings: `tail -50 learnings.txt`
- Check brief: Read your campaign-brief.json to see which deliverables are approved
- Cancel: Use `/cancel-lisa` to stop the campaign

## Output

Deliverables are saved to the `deliverables/` folder with descriptive filenames.
Check learnings.txt for insights that carry forward to future campaigns.
