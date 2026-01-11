---
name: show-memory
description: View Lisa's learned patterns and memory from past campaigns
allowed-tools: [Read]
---

# Show Lisa's Memory

Display the learned patterns that Lisa has accumulated from your feedback across campaigns.

## What You'll See

Read and display both memory files:

1. **Core Memory** (`context/lisa-memory-core.json`): Permanent facts you've added
2. **Contextual Memory** (`context/lisa-memory-contextual.json`): Patterns learned from your feedback

Use the Read tool to load:
- `~/.claude/plugins/marketplaces/local/plugins/lisa/context/lisa-memory-core.json`
- `~/.claude/plugins/marketplaces/local/plugins/lisa/context/lisa-memory-contextual.json`

## Display Format

For each memory file, show:

### Core Memory
```
## Core Memory (Permanent Facts)

Total entries: [count]

[For each entry:]
- **[name]** ([category])
  Content: [content]
  [If tags exist:] Tags: [tags]
```

### Contextual Memory
```
## Contextual Memory (Learned Patterns)

Total entries: [count]

[For each entry grouped by category:]

### [Category] ([count] patterns)

- **[name]**
  When to use: [whenToUse]
  Pattern: [content]
  Learned from: [learnedFrom] on [learnedDate]
  Tags: [tags]
```

## If Files Don't Exist

If either file doesn't exist, show:

```
No [core/contextual] memory found yet.

Lisa will start building memory as you:
- Provide feedback during campaigns
- Add permanent facts manually

To get started:
1. Copy templates: cp context/templates/*.json context/
2. Run a campaign and provide feedback
3. Run /lisa:show-memory again to see what Lisa learned
```

## After Displaying

Remind the user:

```
💡 Tips:
- Edit these files directly to add or modify patterns
- Contextual memory grows automatically from feedback
- Core memory is for facts you add manually
- Both files persist across all campaigns
```
