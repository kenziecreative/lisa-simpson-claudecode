# Lisa Skill: PRD to Campaign Brief Converter

You are converting a markdown PRD (Product Requirements Document) into a Lisa campaign-brief.json file that can be executed with the `/lisa` command.

## Your Task

Read the provided PRD markdown file and convert it to a structured JSON campaign brief following the Lisa campaign-brief schema.

## Step 1: Read and Analyze the PRD

Use the Read tool to read the PRD file path provided by the user.

Identify:
1. **Campaign/Project Name**: Extract from title or overview
2. **Discipline Type**: Determine if this is marketing, PR, or branding based on content
   - Marketing: Contains goals like "leads", "conversions", "traffic"; channels like "email", "social", "ads"
   - PR: Contains "media", "press", "coverage", "journalists", "spokespeople"
   - Branding: Contains "positioning", "identity", "voice & tone", "brand attributes"
3. **Deliverables**: Extract all deliverables listed in the PRD
4. **Timeline/Dependencies**: Note any dependencies or sequencing

## Step 2: Detect Campaign Type

Based on PRD content, set `campaignType` field:

**Marketing indicators**:
- Keywords: "campaign", "leads", "conversion", "email", "landing page", "social media", "ads", "SEO", "traffic", "engagement"
- Deliverable types: email-sequence, landing-page-copy, social-posts, ad-copy, blog-article, newsletter, case-study, webinar-script

**PR indicators**:
- Keywords: "media", "press release", "journalist", "coverage", "pitch", "spokesperson", "announcement", "embargo"
- Deliverable types: press-release, media-pitch, press-kit, talking-points, media-advisory, op-ed, qa-document, fact-sheet, crisis-communication

**Branding indicators**:
- Keywords: "brand", "positioning", "identity", "voice", "tone", "attributes", "guidelines", "visual identity", "tagline"
- Deliverable types: brand-guidelines, brand-positioning, voice-tone-guide, messaging-framework, tagline, brand-story

## Step 3: Convert Deliverables

For each deliverable in the PRD, create a JSON deliverable object:

```json
{
  "id": "DEL-001",
  "type": "[deliverable-type]",
  "title": "[Short descriptive title]",
  "description": "[Full description from PRD]",
  "acceptanceCriteria": [
    "[Criterion 1]",
    "[Criterion 2]",
    "..."
  ],
  "priority": 1,
  "approved": false,
  "targetKeyword": "[keyword or null]",
  "dependencies": [],
  "notes": "[Optional notes]"
}
```

### Important Conversion Rules:

1. **IDs**: Use discipline-appropriate prefixes
   - Marketing: "MKT-001", "MKT-002", etc.
   - PR: "PR-001", "PR-002", etc.
   - Branding: "BRD-001", "BRD-002", etc.

2. **Types**: Map deliverable descriptions to schema types
   - Marketing types: email-sequence, landing-page-copy, social-posts, ad-copy, blog-article, newsletter, case-study, webinar-script
   - PR types: press-release, media-pitch, press-kit, crisis-communication, talking-points, media-advisory, op-ed, qa-document, fact-sheet
   - Branding types: brand-guidelines, brand-positioning, voice-tone-guide, messaging-framework, tagline, brand-story

3. **Acceptance Criteria**: Extract specific, verifiable criteria from PRD
   - Add discipline-appropriate quality checks:
     - Marketing: "Passes brand compliance", "Readability score > 60", "SEO optimized for '[keyword]'"
     - PR: "Passes brand compliance", "Readability score > 60", "Follows AP Style"
     - Branding: "Passes brand compliance", "Passes accessibility check"

4. **Priority**: Assign based on:
   - Dependencies (dependencies come first)
   - PRD sequencing/timeline
   - Logical order (e.g., foundation before details)

5. **Dependencies**: Create dependency array
   - If deliverable mentions "after X" or "based on Y", add dependency
   - Logical dependencies (landing page before email sequence)

6. **Target Keyword**:
   - Marketing web content: Extract SEO keyword if mentioned
   - Otherwise: null

## Step 4: Validate Against Schema

Ensure the generated JSON matches the campaign-brief schema:

**Required top-level fields**:
- `campaign` (string)
- `campaignType` ("marketing" | "pr" | "branding")
- `description` (string)
- `deliverables` (array, min 1 item)

**Required per deliverable**:
- `id` (pattern: `^[A-Z]+-[0-9]+$`)
- `type` (must be valid schema enum value)
- `title` (non-empty string)
- `description` (non-empty string)
- `acceptanceCriteria` (array, min 1 item)
- `priority` (integer, min 1)
- `approved` (boolean, always false initially)

**Validation checks**:
- All dependency IDs exist in deliverables array
- Dependencies have lower priority numbers than dependents
- No circular dependencies
- Acceptance criteria are specific and verifiable (not vague like "good quality")

## Step 5: Quality Checks

Review the conversion for common issues:

**Deliverable Sizing**:
- Marketing email: Too many emails? (3-5 typical)
- Blog article: Reasonable length? (1000-1500 words typical)
- Press release: Standard length? (400-600 words)
- Brand guidelines: Comprehensive? (2000-3000 words)

Warn if deliverables seem too large. Suggest breaking into multiple deliverables.

**Acceptance Criteria Quality**:
- ❌ Vague: "Good quality", "Professional", "Compelling"
- ✅ Specific: "3 emails", "Readability > 60", "Includes H1 and H2 headers"

**Dependency Logic**:
- Landing page should come before email sequences that link to it
- Brand positioning should come before messaging framework
- Press release should come before media pitch

## Step 6: Save Campaign Brief

Save the JSON to: `[campaign-name]-campaign-brief.json`

Use kebab-case for the filename based on the campaign name.

Example: `q1-product-launch-campaign-brief.json`

## Step 7: Provide Next Steps

After saving, tell the user:

"✅ Campaign brief created!

**Saved to**: [filename].json
**Campaign Type**: [marketing/PR/branding]
**Deliverables**: [count] deliverables

**Campaign Overview**:
[List deliverables with priorities]

**Next Steps**:
1. Review the campaign-brief.json file and adjust if needed
2. Customize brand-config.json for your brand guidelines
3. Install Python dependencies: `pip install -r .claude/plugins/lisa/scripts/requirements.txt`
4. Run the campaign: `/lisa [filename].json`

**Quality Gates for [discipline]**:
[List which quality checks will run for this discipline]

Lisa will work through deliverables autonomously, creating content and checking quality until all deliverables are approved."

## Example Conversion

**Input PRD excerpt**:
```markdown
### Email Nurture Sequence for Trial Signups
3-email sequence for users who start free trial. Progressive value delivery.
- Email 1: Welcome and getting started
- Email 2: Feature showcase (AI predictions)
- Email 3: Conversion nudge with offer
Each email should be under 500 words with clear CTA.
```

**Output JSON**:
```json
{
  "id": "MKT-001",
  "type": "email-sequence",
  "title": "Welcome email series for trial signups",
  "description": "3-email nurture sequence for users who start a free trial. Progressive education on features with gentle conversion nudges.",
  "acceptanceCriteria": [
    "3 emails: welcome + getting started, feature highlight (AI predictions), conversion nudge with limited-time offer",
    "Each email < 500 words",
    "Clear CTAs linking to product features",
    "Passes brand compliance",
    "Readability score > 60"
  ],
  "priority": 2,
  "approved": false,
  "targetKeyword": null,
  "dependencies": ["MKT-001"],
  "notes": "Links should point to onboarding flow"
}
```

## Error Handling

If PRD is incomplete or unclear:
- Ask user for clarification
- Suggest missing information
- Provide examples of what's needed

If deliverable type can't be determined:
- List possible types from schema
- Ask user to specify

If acceptance criteria are vague:
- Suggest specific, verifiable alternatives
- Explain why vague criteria won't work with Lisa

## Important Notes

- **Always start with approved: false** for all deliverables
- **IDs must be unique** within the campaign
- **Dependencies must exist** before referents
- **Priority order matters** - Lisa picks highest priority incomplete item
- **Acceptance criteria** must be testable, not subjective

Begin by asking the user for the PRD file path to convert.
