# Lisa Context Files

This directory stores company-specific context that Lisa uses to create personalized content.

## Quick Start

1. **Copy template files to this directory:**
   ```bash
   cp templates/company-profile.json ./company-profile.json
   cp templates/brand-voice.json ./brand-voice.json
   cp templates/style-preferences.json ./style-preferences.json
   cp templates/lisa-memory-core.json ./lisa-memory-core.json
   cp templates/lisa-memory-contextual.json ./lisa-memory-contextual.json
   ```

2. **Edit each file** to match your company's information and preferences

3. **Run a test campaign** to verify Lisa is using your context correctly

## What Each File Does

### company-profile.json
**Core company information** that rarely changes: name, industry, mission, products, metrics, boilerplate.

Lisa uses this to understand your business and include accurate facts in content.

### brand-voice.json
**Voice attributes and guardrails** that define how your company communicates.

Lisa uses this to match your brand's tone and avoid prohibited patterns.

### style-preferences.json
**Style guide and formatting rules** including readability thresholds for each content type.

Lisa uses this to apply consistent formatting and appropriate readability levels.

**Key Feature: Configurable Readability Thresholds**
- Based on testing all 23 deliverable types
- Different thresholds for different content types (e.g., visual-identity-brief=50, crisis-response=70)
- Override specific types without configuring all 23
- Fallback chain: acceptanceCriteria → your preferences → built-in defaults

### lisa-memory-core.json
**Permanent facts** about your company, products, people, and processes.

Lisa loads these at every campaign start. Add key dates, executive names, major announcements.

### lisa-memory-contextual.json
**Learned patterns** from user feedback during campaigns.

Lisa automatically adds entries when you provide feedback like "I wouldn't say it like that" or "This worked well."

## File Format

All files are JSON with:
- `_comment` fields for documentation (ignored by Lisa)
- `_usage` fields explaining when/how to use
- `_schema` references to full schema definitions

See `schemas/context-files.schema.json` for complete field definitions.

## Privacy

These files contain your company's private information and are **not committed to git**.

If you want version control:
1. Create a private repo for your context files
2. Move this directory: `mv context ~/my-company-context`
3. Symlink it back: `ln -s ~/my-company-context ~/.claude/plugins/marketplaces/local/plugins/lisa/context`

## Updating Context

- **company-profile.json**: Update when major company changes occur (new product, funding, metrics)
- **brand-voice.json**: Update when brand guidelines evolve
- **style-preferences.json**: Update when style preferences change or you want different readability thresholds
- **lisa-memory-core.json**: Add new permanent facts as they become relevant
- **lisa-memory-contextual.json**: Lisa updates automatically, but you can manually add or edit patterns

## Testing

After setting up context files, run a test campaign:

```bash
# Create a simple test campaign brief
cat > test-context-campaign.json << 'EOF'
{
  "campaign": "Context Test",
  "campaignType": "marketing",
  "deliverables": [{
    "id": "TEST-001",
    "type": "email-sequence",
    "title": "Test email to verify context loading",
    "description": "Simple email that should reflect company info and brand voice",
    "acceptanceCriteria": ["Uses company name", "Matches brand voice", "Includes boilerplate"],
    "priority": 1,
    "approved": false
  }]
}
EOF

# Run the test campaign
/lisa:lisa test-context-campaign.json --max-iterations 5
```

Check the generated email to verify:
- Company name and products mentioned correctly
- Voice matches your brand-voice.json attributes
- Boilerplate included if appropriate
- Style preferences applied

## Troubleshooting

**Content feels generic?**
- Verify context files exist in this directory (not just in templates/)
- Check that files are valid JSON (no syntax errors)
- Review campaign output - does it mention loading context?

**Wrong company information?**
- Update company-profile.json
- Check spelling of companyName matches what you expect

**Voice doesn't match brand?**
- Review brand-voice.json voiceAttributes
- Add specific prohibitedPatterns for phrases you want to avoid
- Provide feedback during campaigns so Lisa learns preferences

**Need different readability levels?**
- Edit style-preferences.json readabilityThresholds.byDeliverableType
- Only override types where you need different thresholds
- See testing data in PRD for recommended thresholds
