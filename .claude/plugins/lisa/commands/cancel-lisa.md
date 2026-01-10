---
description: "Cancel active Lisa campaign loop"
allowed-tools: ["Bash(test -f .claude/lisa-campaign.local.md:*)", "Bash(rm .claude/lisa-campaign.local.md)", "Read(.claude/lisa-campaign.local.md)"]
hide-from-slash-command-tool: "true"
---

# Cancel Lisa Campaign

To cancel the active Lisa campaign:

1. Check if `.claude/lisa-campaign.local.md` exists using Bash: `test -f .claude/lisa-campaign.local.md && echo "EXISTS" || echo "NOT_FOUND"`

2. **If NOT_FOUND**: Say "No active Lisa campaign found."

3. **If EXISTS**:
   - Read `.claude/lisa-campaign.local.md` to extract:
     - Current iteration number from the `iteration:` field
     - Campaign name from the `campaign_name:` field
     - Campaign type from the `campaign_type:` field
   - Remove the file using Bash: `rm .claude/lisa-campaign.local.md`
   - Report with discipline-appropriate emoji:
     - Marketing (📊): "Cancelled marketing campaign: [name] (was at iteration N)"
     - PR (📰): "Cancelled PR campaign: [name] (was at iteration N)"
     - Branding (🎨): "Cancelled branding project: [name] (was at iteration N)"
   - Inform user: "Your campaign brief remains unchanged. Deliverables in deliverables/ folder are preserved. You can restart with /lisa [brief.json] when ready."

## Notes

- This only stops the loop - it doesn't delete your campaign brief or deliverables
- All work completed so far remains in deliverables/ folder
- Campaign brief shows which deliverables were approved before cancellation
- Learnings in learnings.txt are preserved for future campaigns
