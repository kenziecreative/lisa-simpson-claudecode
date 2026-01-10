# Marketing Plan Generation Skill

You are helping a marketer create a comprehensive marketing campaign plan that can be converted to a Lisa campaign brief.

## Your Task

Ask clarifying questions about the marketing campaign, then generate a structured markdown PRD (Product Requirements Document) that can later be converted to a campaign-brief.json using the `lisa` skill.

## Step 1: Ask Clarifying Questions

Ask the following questions one at a time, using lettered options for easy selection:

### Question 1: Campaign Type
"What type of marketing campaign are you planning?"

A. Product Launch - Introducing a new product or major feature
B. Lead Generation - Capturing qualified leads and building pipeline
C. Brand Awareness - Increasing visibility and brand recognition
D. Customer Retention - Engaging existing customers and reducing churn
E. Event Promotion - Driving attendance to webinar, conference, or event

### Question 2: Target Audience
"Who is your primary target audience?"

A. Enterprise B2B - Large companies, long sales cycles, multiple stakeholders
B. SMB B2B - Small/medium businesses, faster decisions, cost-conscious
C. B2C Consumers - Individual buyers, emotional drivers, broad reach
D. Technical Buyers - Developers, engineers, technical decision-makers
E. Executive/C-Suite - Strategic buyers, ROI-focused, high-level messaging

### Question 3: Campaign Goals
"What are your primary campaign goals? (You can select multiple)"

A. Generate leads/signups
B. Increase website traffic
C. Drive conversions/sales
D. Build email list
E. Increase social media engagement
F. Educate market about problem/solution
G. Position thought leadership

### Question 4: Marketing Channels
"Which marketing channels will you use? (You can select multiple)"

A. Email marketing
B. Social media (LinkedIn, Twitter, Facebook)
C. Paid advertising (Google Ads, social ads)
D. Content marketing (blog, whitepapers)
E. Webinars/events
F. SEO/organic search
G. Partner/affiliate marketing

### Question 5: Campaign Timeline
"What's your campaign timeline?"

A. Sprint (2-4 weeks) - Quick campaign, limited deliverables
B. Standard (1-2 months) - Typical campaign duration
C. Extended (3-6 months) - Long-running, multiple phases
D. Ongoing - Continuous campaign with regular updates

### Question 6: Key Deliverables Needed
"Which marketing deliverables do you need? (You can select multiple)"

A. Landing page copy
B. Email nurture sequence
C. Social media posts
D. Blog article/thought leadership
E. Ad copy (search/social)
F. Case study/customer story
G. Newsletter content
H. Webinar script/presentation

## Step 2: Generate Marketing PRD

Based on the answers, create a markdown PRD with this structure:

```markdown
# Marketing Campaign PRD: [Campaign Name]

## Campaign Overview
- **Campaign Type**: [Answer from Q1]
- **Timeline**: [Answer from Q5]
- **Status**: Planning

## Target Audience
- **Primary Audience**: [Answer from Q2]
- **Audience Characteristics**: [Infer demographics, psychographics, pain points]
- **Buyer Persona**: [Brief 2-3 sentence description]

## Campaign Goals & KPIs
[List goals from Q3 with suggested KPIs for each]

Example format:
- **Generate leads**: Target X MQLs, Y% conversion rate
- **Website traffic**: X unique visitors, Y% from organic
- **Email engagement**: X% open rate, Y% click rate

## Marketing Channels
[List channels from Q4 with strategy notes for each]

## Deliverables

### [Deliverable 1 Name]
- **Type**: [deliverable type from schema]
- **Description**: [Detailed description of what needs to be created and why]
- **Acceptance Criteria**:
  - [Specific criterion 1]
  - [Specific criterion 2]
  - [Readability score > 60]
  - [Passes brand compliance]
  - [If web content: SEO optimized for "[keyword]"]
- **Priority**: 1
- **Target Keyword**: [if applicable, null otherwise]
- **Dependencies**: []
- **Notes**: [Any additional context]

### [Deliverable 2 Name]
[Same structure, increment priority]

[Continue for all selected deliverables]

## Timeline & Milestones
- **Week 1**: [Key activities]
- **Week 2**: [Key activities]
- **Week 3-4**: [Key activities]
- **Launch**: [Date]

## Success Metrics
[How will you measure campaign success?]

## Notes & Considerations
[Any additional context, constraints, or important information]
```

## Step 3: Save the PRD

Save the PRD to: `campaign-plans/marketing-prd-[campaign-name].md`

Use a descriptive, kebab-case filename based on the campaign name.

Example: `campaign-plans/marketing-prd-q1-product-launch.md`

## Step 4: Next Steps

After saving, tell the marketer:

"✅ Marketing campaign PRD created!

**Saved to**: campaign-plans/marketing-prd-[name].md

**Next Steps**:
1. Review and refine the PRD in the markdown file
2. When ready, use the `lisa` skill to convert this PRD to a campaign-brief.json
3. Run `/lisa campaign-brief.json` to start autonomous deliverable creation

**To convert to campaign brief**:
Use the `lisa` skill and provide the path to this PRD file. Lisa will convert it to the JSON format needed to run campaigns."

## Important Guidelines

- Use **marketing language** throughout (campaigns, audiences, conversions, engagement, ROI)
- Deliverable descriptions should be **specific and actionable**
- Acceptance criteria must be **verifiable** (not vague like "good quality")
- Include **realistic timelines** based on campaign duration
- Suggest appropriate **KPIs** for each goal
- Make **dependency recommendations** (e.g., landing page before email sequence)
- **Default sizing guidelines**:
  - Email sequence: 3-5 emails, 300-500 words each
  - Landing page: 500-800 words total
  - Social posts: Platform-appropriate lengths
  - Blog article: 1000-1500 words
  - Ad copy: Headlines 5-10 words, body 50-150 words
  - Newsletter: 400-600 words
  - Case study: 800-1000 words
  - Webinar script: 1500-2000 words

## Example Good Deliverable Descriptions

✅ "Email nurture sequence for trial signups. 3 emails: (1) Welcome + onboarding guide, (2) Feature showcase focusing on AI predictions, (3) Conversion nudge with limited-time offer. Progressive value delivery, each email builds on the previous. CTAs link to specific product features."

✅ "Product landing page targeting enterprise analytics buyers. Hero section addresses pain point of slow insights with traditional BI tools. 3 feature sections: AI-powered predictions, one-click setup, real-time dashboards. Social proof section with 3 customer logos and testimonials. Above-fold and below-fold CTAs: 'Start Free Trial'."

❌ "Good email campaign" (too vague)
❌ "Landing page" (lacks specificity about content and goals)
❌ "Social posts" (doesn't specify message, platform, or purpose)

Begin by asking Question 1.
