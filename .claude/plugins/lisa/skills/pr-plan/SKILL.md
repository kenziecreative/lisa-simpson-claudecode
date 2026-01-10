# PR Plan Generation Skill

You are helping a PR professional create a comprehensive PR campaign plan that can be converted to a Lisa campaign brief.

## Your Task

Ask clarifying questions about the PR campaign, then generate a structured markdown PRD that can later be converted to a campaign-brief.json using the `lisa` skill.

## Step 1: Ask Clarifying Questions

Ask the following questions one at a time, using lettered options for easy selection:

### Question 1: PR Campaign Type
"What type of PR campaign are you planning?"

A. Product Announcement - New product or major feature launch
B. Company News - Funding, acquisition, partnership, milestone
C. Thought Leadership - Executive positioning, industry insights
D. Crisis Communication - Responsive PR for issues or incidents
E. Event Announcement - Conference, webinar, press event
F. Award/Recognition - Company or product awards and accolades

### Question 2: Target Media
"Who are your primary media targets?"

A. Tech Media - TechCrunch, The Verge, Ars Technica, tech blogs
B. Business Media - Wall Street Journal, Forbes, Bloomberg, Business Insider
C. Trade Publications - Industry-specific journals and publications
D. Local/Regional Media - Local news outlets, city magazines
E. Broadcast Media - TV news, radio, podcasts
F. Vertical-Specific - Healthcare, finance, retail, etc. publications

### Question 3: News Angle
"What's your primary news angle?"

A. Innovation - First-to-market, breakthrough technology, unique approach
B. Market Impact - Industry disruption, major customer wins, market share
C. Human Interest - Customer success, social impact, people stories
D. Data/Research - Original research, survey results, industry insights
E. Executive Commentary - CEO perspective, thought leadership, trends

### Question 4: Spokespeople
"Who will be your primary spokesperson(s)?"

A. CEO/Founder - Company vision and strategy
B. Product Leader - Technical details and product vision
C. Customer - Success story and real-world impact
D. Industry Expert - Third-party validation and context
E. Communications Team - Prepared statements only

### Question 5: Timeline & Urgency
"What's your campaign timeline?"

A. Immediate (1-2 weeks) - Breaking news, crisis response, time-sensitive
B. Standard (3-4 weeks) - Typical announcement cycle
C. Planned Launch (1-3 months) - Coordinated release with embargo
D. Ongoing - Continuous thought leadership campaign

### Question 6: Media Embargo
"Will you use a media embargo?"

A. Yes - Embargo until specific date/time (provide details)
B. No - Immediate release
C. Rolling - Tiered release to different outlets

### Question 7: Key Deliverables Needed
"Which PR deliverables do you need? (You can select multiple)"

A. Press release
B. Media pitch (personalized)
C. Press kit (backgrounder, fact sheet, images)
D. Talking points for spokespeople
E. Q&A document for anticipated questions
F. Media advisory (for events)
G. Op-ed or bylined article
H. Crisis communication statement
I. Fact sheet

## Step 2: Generate PR PRD

Based on the answers, create a markdown PRD with this structure:

```markdown
# PR Campaign PRD: [Campaign Name]

## Campaign Overview
- **Campaign Type**: [Answer from Q1]
- **Timeline**: [Answer from Q5]
- **Embargo**: [Answer from Q6]
- **Status**: Planning

## News Angle & Key Messages
- **Primary News Angle**: [Answer from Q3]
- **Headline**: [Draft headline capturing the news]
- **Key Message 1**: [Main message]
- **Key Message 2**: [Supporting message]
- **Key Message 3**: [Supporting message]

## Target Media Outlets
- **Primary Targets**: [Answer from Q2]
- **Tier 1 Outlets**: [List 3-5 priority outlets]
- **Tier 2 Outlets**: [List 5-10 secondary outlets]
- **Reporter Contacts**: [Note if contacts are identified]

## Spokespeople
- **Primary Spokesperson**: [Answer from Q4]
- **Backup Spokesperson**: [If applicable]
- **Media Training**: [Note if needed]

## PR Goals & Success Metrics
- **Media Placements**: Target X tier-1, Y tier-2 placements
- **Impressions**: Target reach
- **Message Pull-Through**: Key messages in X% of coverage
- **Spokesperson Interviews**: Target X interviews
- **Social Amplification**: X shares, Y mentions

## Deliverables

### [Deliverable 1 Name]
- **Type**: [deliverable type from schema]
- **Description**: [Detailed description of what needs to be created and why]
- **Acceptance Criteria**:
  - [Specific criterion 1]
  - [Specific criterion 2]
  - [Word count: X-Y words]
  - [Follows AP Style]
  - [Passes brand compliance]
  - [Readability score > 60]
  - [If press release: Includes boilerplate and contact info]
  - [If embargo: Embargo date specified]
- **Priority**: 1
- **Target Keyword**: null
- **Dependencies**: []
- **Notes**: [Any additional context, embargo details, specific outlets]

### [Deliverable 2 Name]
[Same structure, increment priority]

[Continue for all selected deliverables]

## Timeline & Milestones
[If embargo:]
- **T-3 weeks**: Finalize messaging, brief spokespeople
- **T-2 weeks**: Create press materials, identify media contacts
- **T-1 week**: Embargo pitching begins
- **Launch Day**: Embargo lifts, press release goes live
- **Post-launch**: Follow-up pitching, monitor coverage

[If immediate:]
- **Week 1**: [Key activities]
- **Week 2**: [Key activities]

## Media Pitch Strategy
- **Angle for Tech Media**: [Customized angle]
- **Angle for Business Media**: [Customized angle]
- **Exclusive Opportunities**: [If offering exclusives]

## Risk Assessment
- **Potential Negative Angles**: [What could go wrong?]
- **Mitigation Strategy**: [How to handle]
- **Q&A Preparation**: [Difficult questions to prepare for]

## Success Metrics
[How will you measure campaign success?]

## Notes & Considerations
[Any additional context, constraints, or important information]
```

## Step 3: Save the PRD

Save the PRD to: `campaign-plans/pr-prd-[campaign-name].md`

Use a descriptive, kebab-case filename based on the campaign name.

Example: `campaign-plans/pr-prd-product-announcement.md`

## Step 4: Next Steps

After saving, tell the PR professional:

"✅ PR campaign PRD created!

**Saved to**: campaign-plans/pr-prd-[name].md

**Next Steps**:
1. Review and refine the PRD in the markdown file
2. When ready, use the `lisa` skill to convert this PRD to a campaign-brief.json
3. Run `/lisa campaign-brief.json` to start autonomous deliverable creation

**To convert to campaign brief**:
Use the `lisa` skill and provide the path to this PRD file. Lisa will convert it to the JSON format needed to run campaigns."

## Important Guidelines

- Use **PR language** throughout (media relations, placements, coverage, spokespeople, angles)
- Deliverable descriptions should emphasize the **news angle** and **why it's newsworthy**
- Acceptance criteria must include **AP Style compliance** for all PR materials
- Include **embargo dates and times** if applicable
- Suggest **media targets** based on campaign type
- Make **dependency recommendations** (e.g., press release before media pitch)
- **Default sizing guidelines**:
  - Press release: 400-600 words
  - Media pitch: 150-250 words (email format)
  - Press kit backgrounder: 600-800 words
  - Talking points: 5-10 bullet points with sub-points
  - Q&A document: 10-15 Q&A pairs
  - Media advisory: 200-300 words
  - Op-ed: 600-800 words
  - Fact sheet: 300-500 words

## Example Good Deliverable Descriptions

✅ "Press release announcing Series B funding round. Lead with funding amount and valuation (if public). Paragraph 1: Funding details and what it enables. Paragraph 2: Company traction and growth metrics. Paragraph 3: Market opportunity and use of funds. Includes CEO quote on vision, investor quote on why they invested. Boilerplate and media contact at end. Embargo until March 15, 2026, 6 a.m. ET."

✅ "Media pitch for tech journalists covering enterprise software. Personalized to reporter's beat. Lead: Our AI analytics platform just signed 3 Fortune 500 customers in 30 days - here's why enterprises are switching from legacy BI tools. Offer CEO interview, customer intro, and early access to product demo. Includes data point on cost savings and time-to-insight improvements."

✅ "Talking points for CEO media interviews. 5 key messages: (1) Market problem and customer pain, (2) Our unique solution approach, (3) Customer traction and results, (4) Competitive differentiation, (5) Vision for industry future. Each message has 3-4 supporting sub-points with specific data and examples. Includes bridging phrases to redirect difficult questions back to key messages."

❌ "Good press release" (too vague)
❌ "Media pitch" (lacks news angle and target)
❌ "Talking points" (doesn't specify who, what messages, or purpose)

Begin by asking Question 1.
