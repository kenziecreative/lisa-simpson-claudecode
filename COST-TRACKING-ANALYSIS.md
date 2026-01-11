# Cost & Token Tracking: Technical Constraints

## The Problem

LLM feedback identified "token/cost runaway" as a critical risk. However, the feasibility and approach depend on **how users access Claude**.

## User Access Models

### 1. Claude Pro Subscription (Your Case)
**How it works:**
- User pays $20/month flat rate
- No per-token billing
- No API access
- Uses Claude through web interface or Claude Code

**Token tracking implications:**
- ❌ **Cannot track actual cost** (no per-token billing)
- ✅ **Can track iterations** (we control the loop)
- ✅ **Can estimate tokens used** (approximate)
- ⚠️ **Cannot enforce cost caps** (no billing to cap)

**What we CAN do:**
- Show iteration count: "Iteration 15/30"
- Estimate tokens: "~50k tokens used this campaign"
- Warn on high usage: "This campaign has used significant compute. Consider reducing scope."
- Hard cap iterations: `--max-iterations 30` (already implemented)

**What we CANNOT do:**
- Show actual dollars spent
- Enforce dollar-based budgets
- Track against API quota

### 2. Claude API Access (Pay-per-token)
**How it works:**
- User has Anthropic API key
- Billed per input/output token
- Exact costs trackable
- Direct API access

**Token tracking implications:**
- ✅ **Can track exact tokens**
- ✅ **Can calculate exact cost**
- ✅ **Can enforce cost caps**
- ✅ **Can show real-time spend**

**What we CAN do:**
- Show exact cost: "$2.47 spent so far"
- Enforce budget: "Stop at $5"
- Track against API quota
- Generate cost reports

**Problem:**
Claude Code doesn't currently expose API billing info to plugins. We'd need to:
1. User provides API key separately
2. We make parallel tracking calls
3. Calculate costs from token counts

This is complex and error-prone.

### 3. Enterprise/Team Plans
**How it works:**
- Organization-wide access
- May have usage limits
- Typically subscription-based
- Central admin dashboard

**Token tracking implications:**
Similar to Pro subscription - no per-token visibility at plugin level.

## What Claude Code Exposes

Currently, Claude Code plugins have:
- ✅ Access to conversation history (can count messages)
- ✅ Access to tool calls (can count operations)
- ❌ No access to token counts
- ❌ No access to cost information
- ❌ No access to API usage stats

## Recommended Approach

### For v1.1.0 (Universal - Works for All Users)

**Implement iteration-based controls:**

```yaml
# In campaign state file
max_iterations: 30
current_iteration: 15
warning_threshold: 25  # Warn at 25 iterations

# Track complexity
deliverables_completed: 3
deliverables_total: 8
quality_checks_run: 47
files_created: 12
```

**Show meaningful progress:**
```
🔄 Campaign Progress (Iteration 15/30)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 50%

Deliverables: 3/8 complete
Quality checks: 47 passed, 2 failed
Estimated compute: Moderate

⚠️  Approaching max iterations. Consider:
   - Reducing deliverable complexity
   - Adjusting quality thresholds
   - Splitting into multiple campaigns
```

**Add early warning system:**
```
At iteration 25/30:
"⚠️  Running low on iterations. 5 remaining.
   Current pace: ~3 iterations per deliverable
   Remaining deliverables: 5

   Recommendation: Reduce scope or increase --max-iterations"
```

### For v1.2.0+ (API Users Only)

**Optional API token tracking:**

```bash
# User provides API key (optional)
export ANTHROPIC_API_KEY="sk-ant-..."

# Lisa can then track exact usage
/lisa:lisa campaign.json --track-tokens

# Shows real-time cost
Campaign cost so far: $2.47
Estimated total: $4.50 (based on current pace)
Budget remaining: $2.53 (if --max-cost $5 set)
```

**Make it opt-in:**
- Don't require API key
- Works fine without it (iteration-based controls)
- Advanced users can enable for exact tracking

## Differentiation Strategy

### Messaging for Subscription Users

```
Lisa tracks campaign progress through iterations, not cost.

Why? Claude Pro subscriptions have flat monthly rates, so there's
no per-token billing to track. Instead, Lisa uses:

✓ Iteration limits (--max-iterations 30)
✓ Progress indicators
✓ Warning thresholds
✓ Estimated complexity

This prevents runaway loops while respecting your unlimited usage.
```

### Messaging for API Users

```
Lisa can track exact token usage and costs if you provide an API key.

This is optional. Lisa works perfectly without it using iteration
limits. But if you want precise cost tracking:

1. Set ANTHROPIC_API_KEY environment variable
2. Add --track-tokens flag
3. Lisa will show real-time costs and enforce budgets

Example:
  /lisa:lisa campaign.json --track-tokens --max-cost 5.00
```

## Implementation Priority

### P0 (v1.1.0) - Universal Controls
- ✅ Max iterations (already done)
- 🆕 Progress indicators with iteration count
- 🆕 Warning at 80% of max iterations
- 🆕 Complexity estimation (deliverables, checks, files)
- 🆕 Early warning system for pace vs remaining work

### P1 (v1.2.0) - API Token Tracking (Optional)
- 🆕 Opt-in API key configuration
- 🆕 Real-time token counting
- 🆕 Cost calculation
- 🆕 Budget enforcement
- 🆕 Cost reports

### P2 (v1.3.0+) - Advanced Analytics
- 🆕 Cost per deliverable type
- 🆕 Efficiency metrics
- 🆕 Historical cost trends
- 🆕 Optimization suggestions

## Recommendation

**For v1.1.0, focus on iteration-based controls** that work for everyone:

1. Clear progress indicators
2. Warning system based on pace
3. Complexity estimation
4. Better messaging about what max-iterations means

**Defer actual cost tracking to v1.2.0+** as an optional feature for API users.

This approach:
- ✅ Works for subscription users (majority)
- ✅ Works for API users (without extra config)
- ✅ Provides real value immediately
- ✅ Allows upgrade path for power users
- ✅ Doesn't require API access we don't have

## User Documentation Language

### What to Say

**Good:**
- "Lisa uses iteration limits to prevent runaway loops"
- "Track campaign progress with real-time indicators"
- "Set --max-iterations based on campaign complexity"
- "Typical campaigns complete in 10-20 iterations"

**Avoid:**
- "Lisa tracks your costs" (not true for subscription users)
- "Budget your API spend" (confusing for subscription users)
- "Monitor token usage" (we don't have visibility)

### Example Documentation

```markdown
## Campaign Resource Management

Lisa prevents runaway loops through **iteration limits**, not cost tracking.

### Why Iterations, Not Costs?

Most users access Claude through subscriptions with flat monthly rates.
There's no per-token billing, so cost tracking isn't meaningful. Instead,
Lisa tracks:

- **Iterations**: How many times the agent loops
- **Progress**: Deliverables completed vs total
- **Pace**: Iterations per deliverable
- **Warnings**: When approaching limits

### Setting Max Iterations

Rule of thumb:
- Small campaigns (1-3 deliverables): --max-iterations 15
- Medium campaigns (4-8 deliverables): --max-iterations 30 (default)
- Large campaigns (9+ deliverables): --max-iterations 50

Lisa will warn you at 80% capacity and suggest adjustments.
```

---

## Conclusion

**Token/cost tracking is important but nuanced:**

1. Most users (subscription) can't track actual costs
2. We don't have API access to token counts anyway
3. Iteration-based controls work for everyone
4. Optional API tracking can come later

**For v1.1.0, let's implement universal progress tracking and warnings that work regardless of how users access Claude.**
