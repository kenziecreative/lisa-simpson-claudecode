---
name: setup-company
description: Set up company context by extracting structured data from existing brand documents. Upload or paste your brand guide, company info, or style guide, and Lisa will populate company-profile.json, brand-voice.json, and style-preferences.json automatically.
---

# Company Setup from Documents

You're going to help the user set up their company context by extracting structured information from their existing brand documents.

## Your Goal

Transform prose brand documents (brand guides, style guides, company info) into structured JSON context files that Lisa uses for all campaigns.

## Step 1: Request Documents

Ask the user to provide their existing brand materials. Be friendly and clear about what you need:

**Message to user:**
```
I'll help you set up Lisa with your company's brand information.

Please provide any existing brand documents you have. I can work with:
- Brand guidelines or brand books
- Style guides or editorial guidelines
- Company info sheets or "About Us" documents
- Marketing messaging documents
- Any other brand or company documentation

You can:
- **Upload files** (PDF, Markdown, text files)
- **Paste content** directly (from Google Docs, Notion, etc.)
- **Provide multiple documents** - I'll extract from all of them

What would you like to share first?
```

## Step 2: Extract Structured Data

When the user provides documents, read through them carefully and extract information into these categories:

### company-profile.json fields to extract:
- **companyName**: Official company name
- **industry**: Industry or sector (e.g., "SaaS", "Healthcare", "Fintech")
- **foundedYear**: Year company was founded
- **teamSize**: Team size range (e.g., "50-100", "500+")
- **mission**: Mission statement or company purpose
- **valuePropositions**: Array of {audience, proposition} objects
- **targetAudience**: {description, painPoints[]}
- **keyProducts**: Array of {name, description, keyFeatures[]} objects
- **metrics**: {customers, revenue, growth, other achievements}
- **boilerplate**: Standard company description for press releases (usually 1-2 paragraphs)

### brand-voice.json fields to extract:
- **voiceAttributes**: Array of {attribute, description, examples[]} - look for words like "clear", "authentic", "technical", "friendly"
- **toneGuidelines**: {marketing, pr, crisis} - how tone varies by context
- **prohibitedPatterns**: Array of {pattern, reason, alternative} - words/phrases to avoid
- **signatureMoves**: Array of {move, example, whenToUse} - distinctive patterns
- **guardrails**: Array of rules that should never be broken

### style-preferences.json fields to extract:
- **styleGuide**: Which style guide to follow (e.g., "AP", "Chicago", "Company Custom")
- **spellingChoices**: {preferredSpellings, hyphenationRules, capitalizationRules}
- **formattingRules**: {headings, lists, links, dates, numbers}
- **legalDisclaimers**: Array of required disclaimers with whenToUse
- **accessibilityStandards**: {altTextRules, linkTextRules, headingStructure}
- **readabilityThresholds**: Leave as defaults from template unless user explicitly specifies

## Step 3: Identify Gaps

After extracting what you can, identify **missing critical information**:

**Common gaps:**
- No executive names or titles for quotes/bios
- No specific metrics (customers, revenue, growth)
- Voice attributes described but no concrete examples
- Unclear prohibited words/phrases
- No boilerplate provided
- Missing product feature details
- No target audience pain points specified

## Step 4: Ask Follow-Up Questions

For each gap, ask targeted questions to fill in the missing information:

**Examples:**
```
I found most of your brand information, but I'm missing a few details:

1. **Company metrics**: How many customers do you serve? What's your growth story?
   (This helps with press releases and case studies)

2. **Executive information**: Who are your key executives?
   - CEO name and title?
   - Any other executives who give quotes for PR?

3. **Boilerplate**: Do you have a standard company description for press releases?
   (Usually 1-2 paragraphs about what you do and why it matters)

4. **Voice examples**: I see your voice is "clear and confident". Can you share:
   - A sentence that captures this perfectly?
   - A sentence that would be OFF-brand?
```

Be specific about **why** you need each piece of information (include the use case).

## Step 5: Show Preview

Before saving, show the user a **clear preview** of what will be saved to each file:

**Format:**
```
Here's what I extracted from your documents:

## company-profile.json
- Company: [name]
- Industry: [industry]
- Mission: [mission]
- Products: [list key products]
- Metrics: [key metrics]
- Boilerplate: [first 50 words]...

## brand-voice.json
- Voice attributes: [list attributes]
- Prohibited patterns: [list key prohibitions]
- Signature moves: [list 1-2 examples]

## style-preferences.json
- Style guide: [which guide]
- Key formatting rules: [list 2-3 key rules]
- Readability thresholds: Using defaults (can customize per content type)

Does this look accurate? Should I adjust anything before saving?
```

## Step 6: Validate and Save

Once user approves:

1. **Load templates** from `~/.claude/plugins/marketplaces/local/plugins/lisa/context/templates/`
2. **Populate with extracted data**
3. **Validate required fields** are present
4. **Save to** `~/.claude/plugins/marketplaces/local/plugins/lisa/context/`
   - `context/company-profile.json`
   - `context/brand-voice.json`
   - `context/style-preferences.json`

Use the Read tool to load templates, Edit tool to populate, Write tool to save to context/ directory.

## Step 7: Run Verification Test

After saving context files, create a simple test campaign to verify Lisa can load and use the context:

```json
{
  "campaign": "Context Verification Test",
  "campaignType": "marketing",
  "deliverables": [{
    "id": "VERIFY-001",
    "type": "email-sequence",
    "title": "Test email using new company context",
    "description": "Simple promotional email that should reflect company info and brand voice",
    "acceptanceCriteria": [
      "Uses correct company name",
      "Reflects brand voice attributes",
      "Includes key product benefits",
      "Matches style preferences"
    ],
    "priority": 1,
    "approved": false
  }]
}
```

Save this to `context-verification-test.json` and tell the user:

```
Context files saved!

To verify everything is working, run this test campaign:
/lisa:lisa context-verification-test.json --max-iterations 5

Check the generated email to confirm:
✅ Company name and products mentioned correctly
✅ Voice matches your brand attributes
✅ Style preferences applied
✅ Content feels on-brand

If anything seems off, you can edit the context files directly in:
~/.claude/plugins/marketplaces/local/plugins/lisa/context/
```

## Key Principles

1. **Meet users where they are**: They already have brand docs, don't make them fill out forms
2. **Extract, don't interrogate**: Pull as much as possible from documents before asking questions
3. **Be specific about gaps**: Don't ask for "more info", ask for "CEO name for press release quotes"
4. **Show preview**: Let them see and approve before saving
5. **Test immediately**: Verification test gives instant feedback on setup quality

## Handling Different Document Types

### Brand Guidelines (common format):
- Usually has mission, values, voice/tone, logo usage, colors
- Extract company info and brand voice
- May have style rules

### Style Guides:
- Focus on formatting, spelling, grammar choices
- Extract style-preferences.json data
- May reference external style guide (AP, Chicago)

### Company Info Sheets:
- Focus on factual data: products, metrics, team, history
- Extract company-profile.json data
- Often has boilerplate

### Multiple Documents:
- Merge information from all sources
- If conflicting info, ask user which is current
- Prioritize most recent documents

## Error Handling

**If document is unclear/ambiguous:**
- Extract what you can
- Flag ambiguous sections in follow-up questions
- Example: "I found two different mission statements - which one should I use?"

**If document is too sparse:**
- Extract the basics
- Ask targeted questions for the rest
- Example: "Your brand guide covers visual identity but not voice. Let's define your brand voice..."

**If no documents provided:**
- Offer to do guided setup instead
- Ask key questions one at a time
- Build up context files interactively

## Success Criteria

Setup is complete when:
- ✅ All three context files saved with required fields populated
- ✅ No critical gaps in company info, brand voice, or style preferences
- ✅ User reviewed and approved preview
- ✅ Verification test campaign created and instructions provided
- ✅ User knows where to edit context files if needed
