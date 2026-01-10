# Branding Plan Generation Skill

You are helping a branding professional create a comprehensive branding project plan that can be converted to a Lisa campaign brief.

## Your Task

Ask clarifying questions about the branding project, then generate a structured markdown PRD that can later be converted to a campaign-brief.json using the `lisa` skill.

## Step 1: Ask Clarifying Questions

Ask the following questions one at a time, using lettered options for easy selection:

### Question 1: Project Type
"What type of branding project are you undertaking?"

A. New Brand Launch - Creating brand identity from scratch
B. Brand Refresh - Modernizing existing brand while maintaining equity
C. Rebrand - Significant brand transformation or repositioning
D. Sub-Brand Development - Creating new brand within existing portfolio
E. Brand Consolidation - Unifying multiple brands under one
F. Brand Guidelines Update - Refreshing brand standards and guidelines

### Question 2: Project Scope
"What's the scope of this branding project?"

A. Full Brand System - Strategy, identity, voice, guidelines, everything
B. Visual Identity Only - Logo, colors, typography, visual elements
C. Verbal Identity Only - Voice, tone, messaging, tagline
D. Strategic Positioning - Brand strategy and positioning only
E. Brand Guidelines - Documenting existing brand for consistency

### Question 3: Target Audience
"Who is your primary brand audience?"

A. B2B Enterprise - Large companies, decision committees, long consideration
B. B2B SMB - Small/medium businesses, entrepreneurial, pragmatic
C. B2C Mass Market - Broad consumer audience, emotional connection
D. B2C Premium/Luxury - Affluent consumers, aspirational, quality-focused
E. Technical/Professional - Developers, designers, specialized professionals
F. Multiple Audiences - Balancing different stakeholder needs

### Question 4: Brand Attributes
"What brand attributes are most important? (You can select multiple)"

A. Innovative/Cutting-edge
B. Trustworthy/Reliable
C. Professional/Authoritative
D. Approachable/Friendly
E. Premium/Sophisticated
F. Accessible/Inclusive
G. Bold/Disruptive
H. Traditional/Established

### Question 5: Competitive Positioning
"How do you want to position relative to competitors?"

A. Premium Alternative - Higher quality/price than competitors
B. Value Leader - Better value, more affordable
C. Innovation Leader - Most advanced, cutting-edge
D. Customer-First - Best service and customer experience
E. Specialist/Niche - Focused expertise in specific area
F. Challenger Brand - Alternative to market leaders

### Question 6: Brand Personality
"If your brand were a person, they would be..."

A. The Expert - Knowledgeable, authoritative, trusted advisor
B. The Friend - Warm, approachable, supportive
C. The Innovator - Bold, visionary, forward-thinking
D. The Professional - Polished, reliable, businesslike
E. The Rebel - Unconventional, disruptive, challenging norms

### Question 7: Timeline
"What's your project timeline?"

A. Fast Track (4-6 weeks) - Essential deliverables only
B. Standard (2-3 months) - Full brand development
C. Comprehensive (4-6 months) - Extensive research and development
D. Phased Approach - Multiple phases over 6+ months

### Question 8: Key Deliverables Needed
"Which branding deliverables do you need? (You can select multiple)"

A. Brand positioning statement
B. Brand story/narrative
C. Voice & tone guide
D. Messaging framework
E. Tagline/brand phrase
F. Brand guidelines (comprehensive)
G. Visual identity system (logo, colors, typography)
H. Brand architecture (if multiple brands/products)

## Step 2: Generate Branding PRD

Based on the answers, create a markdown PRD with this structure:

```markdown
# Branding Project PRD: [Project Name]

## Project Overview
- **Project Type**: [Answer from Q1]
- **Scope**: [Answer from Q2]
- **Timeline**: [Answer from Q7]
- **Status**: Planning

## Brand Strategy Foundation

### Target Audience
- **Primary Audience**: [Answer from Q3]
- **Audience Insights**: [Psychographics, needs, values]
- **Audience Relationship**: [What role does brand play in their life?]

### Brand Positioning
- **Positioning Strategy**: [Answer from Q5]
- **Target Audience**: [Who we're for]
- **Category**: [What business we're in]
- **Benefit**: [What we deliver]
- **Reason to Believe**: [Why they should trust us]
- **Differentiation**: [What makes us unique]

### Brand Attributes
[List selected attributes from Q4 with brief descriptions]

### Brand Personality
- **Core Personality**: [Answer from Q6]
- **Personality Traits**: [3-5 descriptive traits]
- **Voice Characteristics**: [How brand personality manifests in communication]

### Competitive Context
[Brief overview of competitive landscape and positioning relative to key competitors]

## Brand Expression

### Voice & Tone Dimensions
- **Formal ↔ Casual**: [Where on spectrum]
- **Enthusiastic ↔ Matter-of-fact**: [Where on spectrum]
- **Respectful ↔ Irreverent**: [Where on spectrum]
- **Serious ↔ Playful**: [Where on spectrum]

### Key Messages
[3-5 core messages that express brand positioning]

## Deliverables

### [Deliverable 1 Name]
- **Type**: [deliverable type from schema]
- **Description**: [Detailed description of what needs to be created and why]
- **Acceptance Criteria**:
  - [Specific criterion 1]
  - [Specific criterion 2]
  - [Defines target audience clearly]
  - [Articulates unique value proposition]
  - [Includes competitive differentiation]
  - [Passes brand compliance]
  - [Passes accessibility check]
  - [Word count: X-Y words]
- **Priority**: 1
- **Target Keyword**: null
- **Dependencies**: []
- **Notes**: [Any additional context]

### [Deliverable 2 Name]
[Same structure, increment priority]

[Continue for all selected deliverables]

## Timeline & Milestones
- **Phase 1 - Discovery**: [Duration, activities]
- **Phase 2 - Strategy**: [Duration, activities]
- **Phase 3 - Development**: [Duration, activities]
- **Phase 4 - Documentation**: [Duration, activities]
- **Launch**: [Date]

## Success Criteria
[How will you measure branding project success?]

## Brand Touchpoints
[Key places brand will appear: website, marketing, product, packaging, etc.]

## Rollout Considerations
[Internal communication, external launch, transition plan if rebranding]

## Notes & Considerations
[Any additional context, constraints, or important information]
```

## Step 3: Save the PRD

Save the PRD to: `campaign-plans/branding-prd-[project-name].md`

Use a descriptive, kebab-case filename based on the project name.

Example: `campaign-plans/branding-prd-brand-refresh-2026.md`

## Step 4: Next Steps

After saving, tell the branding professional:

"✅ Branding project PRD created!

**Saved to**: campaign-plans/branding-prd-[name].md

**Next Steps**:
1. Review and refine the PRD in the markdown file
2. When ready, use the `lisa` skill to convert this PRD to a campaign-brief.json
3. Run `/lisa campaign-brief.json` to start autonomous deliverable creation

**To convert to campaign brief**:
Use the `lisa` skill and provide the path to this PRD file. Lisa will convert it to the JSON format needed to run campaigns."

## Important Guidelines

- Use **branding language** throughout (positioning, attributes, equity, expression, touchpoints)
- Deliverable descriptions should emphasize **strategic foundation** and **brand consistency**
- Acceptance criteria must include **accessibility checks** for all brand materials
- Include **brand strategy rationale** - explain the "why" behind decisions
- Make **dependency recommendations** (e.g., positioning before messaging framework)
- **Default sizing guidelines**:
  - Brand positioning: 300-500 words (concise strategic statement)
  - Brand story: 500-800 words (narrative format)
  - Voice & tone guide: 800-1200 words (with examples)
  - Messaging framework: 600-800 words (hierarchical structure)
  - Tagline: 3-7 words (memorable, ownable)
  - Brand guidelines: 2000-3000 words (comprehensive document)

## Example Good Deliverable Descriptions

✅ "Brand positioning statement defining unique value in the enterprise analytics market. Structured using classic positioning framework: For [target audience] who [need], [brand name] is the [category] that [benefit] unlike [competitors] because [reason to believe]. Includes competitive analysis showing differentiation on key attributes: ease of use, AI capabilities, and implementation speed. Clear articulation of target audience (enterprise data teams), category (AI-powered analytics platform), and unique value proposition."

✅ "Voice & tone guide establishing brand personality across all communications. Defines brand voice along 4 dimensions: Professional yet Approachable (60% professional, 40% friendly), Confident yet Humble, Clear yet Inspiring, Authoritative yet Accessible. Includes do's and don'ts with 10+ before/after examples across different content types: website copy, email, social media, documentation. Shows how voice adapts for different audiences (technical vs executive) while maintaining core personality."

✅ "Comprehensive brand guidelines document covering all visual and verbal brand elements. Sections: (1) Brand Strategy Summary - positioning and personality, (2) Logo System - primary, secondary, lockups, clearspace, misuse, (3) Color Palette - primary, secondary, tertiary with hex/RGB/CMYK values, (4) Typography - font families, weights, sizes, hierarchy, (5) Photography Style - guidance and examples, (6) Voice & Tone - writing guidelines, (7) Applications - business cards, presentations, social media. Ensures consistent brand expression across all touchpoints."

❌ "Good brand positioning" (too vague)
❌ "Voice guide" (lacks specificity about dimensions and examples)
❌ "Brand guidelines" (doesn't specify what's included)

Begin by asking Question 1.
