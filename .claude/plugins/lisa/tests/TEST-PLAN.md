# Lisa Integration Test Plan

**Purpose**: Verify Lisa works end-to-end for all three creative disciplines (marketing, PR, branding)

**Test files**:
- `test-marketing-campaign.json` - 2 marketing deliverables (social posts, email)
- `test-pr-campaign.json` - 2 PR deliverables (press release, media pitch)
- `test-branding-campaign.json` - 2 branding deliverables (positioning, tagline with dependency)

---

## Prerequisites

Before running tests:

1. **Install dependencies**:
   ```bash
   cd .claude/plugins/lisa
   pip install -r scripts/requirements.txt
   ```

2. **Verify jq installed**:
   ```bash
   which jq
   # If not found: brew install jq (macOS) or apt-get install jq (Linux)
   ```

3. **Clean state** (remove any previous test runs):
   ```bash
   rm -rf deliverables/TEST-*
   rm -f .claude/lisa-campaign.local.md
   rm -f learnings.txt
   ```

---

## Test 1: Marketing Campaign

### Run the test

```bash
# From project root
.claude/plugins/lisa/scripts/setup-lisa-campaign.sh \
  .claude/plugins/lisa/tests/test-marketing-campaign.json \
  --max-iterations 10 \
  --completion-promise "COMPLETE"
```

### Expected behavior

1. **State file created**: `.claude/lisa-campaign.local.md` with marketing agent prompt
2. **Progress indicator**: 📊 Marketing campaign
3. **Agent starts working**: Creates deliverables in priority order
4. **First deliverable** (TEST-MKT-001 social-posts):
   - File created: `deliverables/TEST-MKT-001-social-posts.md`
   - Quality checks run:
     - `check-brand-compliance.py` ✅
     - `check-readability.py` ✅ (Flesch >= 60)
     - `check-seo.py --keyword "enterprise automation"` ✅
     - `check-accessibility.py` ✅
   - If checks pass: `approved: true` in JSON
   - If checks fail: Revise and retry (up to 3 attempts)
5. **Second deliverable** (TEST-MKT-002 email-sequence):
   - File created: `deliverables/TEST-MKT-002-email-sequence.md`
   - Quality checks run (all 4 marketing checks)
   - Marked approved when all pass
6. **Learnings updated**: `learnings.txt` contains 2 entries with discipline "Marketing"
7. **Completion**: Agent outputs `<promise>COMPLETE</promise>`
8. **Cleanup**: State file deleted (campaign complete)

### Verification checklist

```bash
# 1. Check deliverables created
ls deliverables/TEST-MKT-*.md
# Expected: TEST-MKT-001-social-posts.md, TEST-MKT-002-email-sequence.md (or similar names)

# 2. Check both approved in JSON
jq '.deliverables[] | select(.approved == true) | .id' .claude/plugins/lisa/tests/test-marketing-campaign.json
# Expected: TEST-MKT-001, TEST-MKT-002

# 3. Check learnings populated
grep "Marketing" learnings.txt | wc -l
# Expected: 2 (one entry per deliverable)

# 4. Check state file deleted (campaign complete)
ls .claude/lisa-campaign.local.md
# Expected: file not found

# 5. Check deliverable content quality
cat deliverables/TEST-MKT-001-social-posts.md
# Verify: 3 distinct posts, professional tone, target keyword present

cat deliverables/TEST-MKT-002-email-sequence.md
# Verify: Subject, body, CTA, target keyword present
```

### Pass criteria

✅ Both deliverables created
✅ Both marked `approved: true`
✅ Both entries in learnings.txt with "Marketing" discipline
✅ Quality checks passed (brand, readability, SEO, accessibility)
✅ State file deleted after completion
✅ Content meets acceptance criteria

---

## Test 2: PR Campaign

### Run the test

```bash
# Clean state first
rm -rf deliverables/TEST-*
rm -f learnings.txt

# Run PR test
.claude/plugins/lisa/scripts/setup-lisa-campaign.sh \
  .claude/plugins/lisa/tests/test-pr-campaign.json \
  --max-iterations 10 \
  --completion-promise "COMPLETE"
```

### Expected behavior

1. **State file created**: `.claude/lisa-campaign.local.md` with PR agent prompt
2. **Progress indicator**: 📰 PR campaign
3. **Agent starts working**: Creates PR deliverables
4. **First deliverable** (TEST-PR-001 press-release):
   - File created: `deliverables/TEST-PR-001-press-release.md`
   - Quality checks run:
     - `check-brand-compliance.py` ✅
     - `check-readability.py` ✅ (Flesch >= 60)
     - `check-ap-style.py` ✅ (dates, times, numbers in AP Style)
   - Note: NO SEO check for PR (not published on web)
   - Marked approved when checks pass
5. **Second deliverable** (TEST-PR-002 media-pitch):
   - File created: `deliverables/TEST-PR-002-media-pitch.md`
   - Quality checks run (brand, readability, AP Style)
   - Marked approved when checks pass
6. **Learnings updated**: 2 entries with discipline "PR"
7. **Completion**: `<promise>COMPLETE</promise>` output
8. **Cleanup**: State file deleted

### Verification checklist

```bash
# 1. Check deliverables created
ls deliverables/TEST-PR-*.md
# Expected: TEST-PR-001-press-release.md, TEST-PR-002-media-pitch.md

# 2. Check both approved
jq '.deliverables[] | select(.approved == true) | .id' .claude/plugins/lisa/tests/test-pr-campaign.json
# Expected: TEST-PR-001, TEST-PR-002

# 3. Check learnings populated
grep "PR" learnings.txt | wc -l
# Expected: 2

# 4. Check state file deleted
ls .claude/lisa-campaign.local.md
# Expected: file not found

# 5. Check AP Style compliance
cat deliverables/TEST-PR-001-press-release.md
# Verify: dates like "Jan. 15, 2026", times like "9 a.m. ET", numbers spelled out one-nine

cat deliverables/TEST-PR-002-media-pitch.md
# Verify: subject line, under 250 words, professional tone, AP Style
```

### Pass criteria

✅ Both deliverables created
✅ Both marked `approved: true`
✅ Both entries in learnings.txt with "PR" discipline
✅ Quality checks passed (brand, readability, AP Style - NOT SEO)
✅ State file deleted after completion
✅ Content follows AP Style conventions

---

## Test 3: Branding Campaign

### Run the test

```bash
# Clean state first
rm -rf deliverables/TEST-*
rm -f learnings.txt

# Run branding test
.claude/plugins/lisa/scripts/setup-lisa-campaign.sh \
  .claude/plugins/lisa/tests/test-branding-campaign.json \
  --max-iterations 10 \
  --completion-promise "COMPLETE"
```

### Expected behavior

1. **State file created**: `.claude/lisa-campaign.local.md` with branding agent prompt
2. **Progress indicator**: 🎨 Branding project
3. **Agent starts working**: Creates branding deliverables
4. **First deliverable** (TEST-BRD-001 brand-positioning):
   - File created: `deliverables/TEST-BRD-001-brand-positioning.md`
   - Quality checks run:
     - `check-brand-compliance.py` ✅
     - `check-accessibility.py` ✅ (heading hierarchy, no color-only instructions)
   - Note: NO readability score check (branding docs vary in complexity)
   - Note: NO SEO check (strategic docs, not web content)
   - Marked approved when checks pass
5. **Second deliverable** (TEST-BRD-002 tagline):
   - **Dependency check**: Waits for TEST-BRD-001 to be approved first
   - File created: `deliverables/TEST-BRD-002-tagline.md`
   - Quality checks run (brand, accessibility)
   - Marked approved when checks pass
6. **Learnings updated**: 2 entries with discipline "Branding"
7. **Completion**: `<promise>COMPLETE</promise>` output
8. **Cleanup**: State file deleted

### Verification checklist

```bash
# 1. Check deliverables created
ls deliverables/TEST-BRD-*.md
# Expected: TEST-BRD-001-brand-positioning.md, TEST-BRD-002-tagline.md

# 2. Check both approved
jq '.deliverables[] | select(.approved == true) | .id' .claude/plugins/lisa/tests/test-branding-campaign.json
# Expected: TEST-BRD-001, TEST-BRD-002

# 3. Check dependency handling
# BRD-002 should not be created until BRD-001 is approved
# Verify in learnings.txt that BRD-001 timestamp is before BRD-002

# 4. Check learnings populated
grep "Branding" learnings.txt | wc -l
# Expected: 2

# 5. Check state file deleted
ls .claude/lisa-campaign.local.md
# Expected: file not found

# 6. Check accessibility compliance
cat deliverables/TEST-BRD-001-brand-positioning.md
# Verify: proper heading hierarchy (H1 > H2 > H3), no skipped levels

cat deliverables/TEST-BRD-002-tagline.md
# Verify: 5 taglines, each 3-7 words, evaluation criteria, no color-only instructions
```

### Pass criteria

✅ Both deliverables created
✅ Both marked `approved: true`
✅ Both entries in learnings.txt with "Branding" discipline
✅ Quality checks passed (brand, accessibility - NOT readability or SEO)
✅ Dependency handled correctly (BRD-002 after BRD-001)
✅ State file deleted after completion
✅ Content accessible (heading hierarchy, no color-only instructions)

---

## Quality Gates Matrix Verification

Confirm each discipline runs the correct quality checks:

| Quality Gate | Marketing | PR | Branding |
|--------------|-----------|-----|----------|
| Brand Compliance | ✅ | ✅ | ✅ |
| Readability | ✅ | ✅ | ❌ |
| SEO | ✅ | ❌ | ❌ |
| Accessibility | ✅ | ❌ | ✅ |
| AP Style | ❌ | ✅ | ❌ |

**Verification**:
- Marketing tests should run 4 checks (brand, readability, SEO, accessibility)
- PR tests should run 3 checks (brand, readability, AP Style)
- Branding tests should run 2 checks (brand, accessibility)

---

## Troubleshooting

### Test hangs or doesn't complete

**Symptom**: Agent runs but never outputs `<promise>COMPLETE</promise>`

**Diagnosis**:
```bash
# Check iteration count
head -20 .claude/lisa-campaign.local.md
# Look for: iteration: X, max_iterations: 10
```

**Solutions**:
- If iteration >= max_iterations: Increase `--max-iterations 20`
- If quality checks failing repeatedly: Check `deliverables/` files for quality issues
- If stuck on one deliverable: Check acceptance criteria aren't too strict

### Quality check failures

**Symptom**: Deliverable created but not approved, agent retrying

**Diagnosis**:
```bash
# Run quality checks manually
python3 .claude/plugins/lisa/scripts/quality/check-brand-compliance.py deliverables/TEST-MKT-001*.md
python3 .claude/plugins/lisa/scripts/quality/check-readability.py deliverables/TEST-MKT-001*.md
```

**Solutions**:
- Review failure output for specific issues
- Check brand-config.json for overly strict rules
- Adjust thresholds if needed for tests

### State file not deleted

**Symptom**: Campaign completes but `.claude/lisa-campaign.local.md` still exists

**Diagnosis**: Check if `<promise>COMPLETE</promise>` was output

**Solutions**:
- If missing, agent didn't recognize completion
- Manually delete: `rm .claude/lisa-campaign.local.md`
- Check learnings.txt to see how many deliverables were completed

### Deliverables not created

**Symptom**: Campaign runs but no files in `deliverables/`

**Diagnosis**: Check if agent had permission to write files

**Solutions**:
- Ensure Write tool permission in Claude Code settings
- Check campaign brief JSON is valid
- Review agent prompt in state file

---

## Test Results Template

Document test results in this format:

```markdown
## Integration Test Results

**Date**: 2026-01-10
**Environment**: Claude Code, macOS
**Lisa Version**: 1.0

### Test 1: Marketing Campaign

**Status**: ✅ PASS

**Deliverables created**:
- TEST-MKT-001: Social posts (3 posts, 250 words total)
- TEST-MKT-002: Email sequence (1 email, 320 words)

**Quality checks**:
- Brand compliance: ✅ PASS
- Readability: ✅ PASS (Flesch scores: 68, 64)
- SEO: ✅ PASS (keywords present, proper density)
- Accessibility: ✅ PASS (descriptive links, heading hierarchy)

**Iterations**: 3 (both deliverables completed on first try)

**Time**: ~8 minutes

**Learnings**: 2 entries populated correctly

---

### Test 2: PR Campaign

**Status**: ✅ PASS

**Deliverables created**:
- TEST-PR-001: Press release (478 words, AP Style)
- TEST-PR-002: Media pitch (218 words, email format)

**Quality checks**:
- Brand compliance: ✅ PASS
- Readability: ✅ PASS (Flesch scores: 62, 66)
- AP Style: ✅ PASS (dates, times, numbers correct)

**Iterations**: 4 (PR-001 required one revision for AP Style date format)

**Time**: ~10 minutes

**Learnings**: 2 entries with PR discipline tags

---

### Test 3: Branding Campaign

**Status**: ✅ PASS

**Deliverables created**:
- TEST-BRD-001: Brand positioning (485 words, strategic framework)
- TEST-BRD-002: Tagline options (5 options, 380 words total)

**Quality checks**:
- Brand compliance: ✅ PASS
- Accessibility: ✅ PASS (proper heading hierarchy, no color-only)

**Iterations**: 3 (dependency handled correctly, BRD-002 waited for BRD-001)

**Time**: ~9 minutes

**Learnings**: 2 entries with Branding discipline tags

---

### Overall Results

✅ All 3 disciplines tested successfully
✅ 6/6 deliverables created and approved
✅ Quality gates matrix validated (correct checks for each discipline)
✅ Dependency handling works (branding test)
✅ Learnings populated correctly for all disciplines
✅ State cleanup works (files deleted after completion)

**Conclusion**: Lisa works end-to-end for marketing, PR, and branding campaigns.
```

---

## Next Steps After Testing

1. **Document results**: Copy test results to README.md under "Testing" section
2. **Update version**: If tests pass, ready for v1.0 release
3. **Create release**: Tag git commit, push to GitHub
4. **Share with team**: Announce Lisa is ready for use

---

**Test execution notes**:
- Run tests in separate terminal sessions to avoid conflicts
- Clean state between tests (`rm deliverables/TEST-* learnings.txt`)
- Save test output for documentation
- Report any failures as GitHub issues with reproduction steps
