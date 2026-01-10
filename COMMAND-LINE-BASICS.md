# Command Line Basics for Lisa Users

**New to the command line?** This guide covers the essential commands you need to install and use Lisa. The command line (also called terminal, shell, or console) is a text-based way to interact with your computer.

---

## Opening Your Terminal

### Built-in System Terminals

**macOS**:
- Press `Cmd + Space`, type "Terminal", and press Enter
- Or find it in Applications → Utilities → Terminal

**Windows**:
- Press `Win + R`, type "cmd" or "powershell", and press Enter
- Or search for "Command Prompt" or "PowerShell" in the Start menu

**Linux**:
- Press `Ctrl + Alt + T`
- Or find Terminal in your applications menu

---

### Better Options: Smart Terminals & AI Editors

**For a better experience, consider these alternatives:**

#### Smart Terminal Tools

**[Warp](https://www.warp.dev)** - Modern terminal with AI assistance, autocomplete, and a more user-friendly interface. Great for beginners who find the traditional terminal intimidating.

#### AI Editors with Built-In Terminals

If you're using an AI coding assistant, you can open a terminal right inside the editor:

- **[Cursor](https://cursor.com/download)** - Press `` Ctrl + ` `` (backtick) to open terminal
- **[Windsurf](https://codeium.com/windsurf)** - Terminal panel available in the bottom section
- **[Google Antigravity](https://antigravity.google/download)** - Built-in terminal in the IDE

**Why this is easier**: You can work in the terminal and edit files side-by-side in the same window. If you need to check or modify a file, you don't have to switch between applications - just click on the file in the editor panel.

**Recommended for Lisa users**: Use one of these AI editors with a built-in terminal. They provide a more beginner-friendly experience and let you ask the AI for help if you get stuck on a command.

---

## Essential Commands

### 1. See Where You Are: `pwd`

**What it does**: Shows your current directory (folder) location

```bash
pwd
```

**Example output**:
```
/Users/yourname
```

**Why you need it**: Before you run commands, it helps to know where you are in your file system.

---

### 2. List Files and Folders: `ls`

**What it does**: Shows all files and folders in your current location

```bash
ls
```

**Example output**:
```
Documents    Downloads    Desktop    Pictures
```

**Useful variations**:
```bash
ls -l        # Shows detailed info (permissions, size, date)
ls -a        # Shows hidden files (those starting with .)
ls -la       # Combines both: detailed info including hidden files
```

**Why you need it**: To see what's in a folder before you navigate or work with files.

---

### 3. Change Directories: `cd`

**What it does**: Moves you to a different folder

```bash
cd Documents              # Go into the Documents folder
cd /Users/yourname        # Go to a specific path
cd ~                      # Go to your home folder
cd ..                     # Go up one level (to parent folder)
cd ../..                  # Go up two levels
```

**Example workflow**:
```bash
pwd                       # Shows: /Users/yourname
cd Documents              # Move into Documents
pwd                       # Shows: /Users/yourname/Documents
cd ..                     # Go back up
pwd                       # Shows: /Users/yourname
```

**Why you need it**: You'll need to navigate to the `~/.claude/plugins/lisa` folder to work with Lisa.

---

### 4. View File Contents: `cat`

**What it does**: Displays the contents of a file in your terminal

```bash
cat README.md             # Show the contents of README.md
cat learnings.txt         # Show your Lisa learnings file
```

**Why you need it**: To quickly check what's in a file without opening an editor.

---

### 5. Create a Directory: `mkdir`

**What it does**: Creates a new folder

```bash
mkdir my-campaigns        # Creates a folder called "my-campaigns"
mkdir -p path/to/folder   # Creates nested folders all at once
```

**Example**:
```bash
mkdir campaign-briefs
cd campaign-briefs
pwd                       # Shows: /Users/yourname/campaign-briefs
```

**Why you need it**: To organize your campaign briefs and deliverables.

---

### 6. Copy Files: `cp`

**What it does**: Copies files or folders

```bash
cp file.txt backup.txt              # Copy a file
cp -r folder new-folder             # Copy a folder (recursively)
```

**Example for Lisa**:
```bash
cp -r lisa ~/.claude/plugins/lisa   # Copy Lisa to plugins folder
```

**Why you need it**: To install Lisa by copying it to the plugins directory.

---

### 7. Move or Rename: `mv`

**What it does**: Moves files to a new location or renames them

```bash
mv old-name.txt new-name.txt        # Rename a file
mv file.txt Documents/              # Move a file to Documents
```

**Why you need it**: To organize your files or rename deliverables.

---

### 8. Remove Files: `rm`

**What it does**: Deletes files or folders

**⚠️ WARNING**: `rm` is permanent - there's no "Recycle Bin" on the command line!

```bash
rm file.txt               # Delete a file
rm -r folder              # Delete a folder and everything in it
```

**Safe practice**: Always double-check what you're deleting:
```bash
ls                        # See what's here first
rm unwanted-file.txt      # Then delete
```

**Why you need it**: To clean up test files or old deliverables.

---

## Special Paths and Shortcuts

### Home Directory: `~`

The `~` symbol is a shortcut to your home folder:
```bash
cd ~                      # Go to /Users/yourname (macOS/Linux)
cd ~/.claude              # Go to /Users/yourname/.claude
```

### Current Directory: `.`

The `.` symbol means "right here":
```bash
ls .                      # List files in current directory (same as just "ls")
cp file.txt .             # Copy file.txt to here
```

### Parent Directory: `..`

The `..` symbol means "one level up":
```bash
cd ..                     # Go up one folder
cd ../..                  # Go up two folders
ls ..                     # List files in parent folder
```

### Root Directory: `/`

The `/` symbol is the very top of your file system:
```bash
cd /                      # Go to the root (top level)
```

---

## Command Line Tips for Lisa Users

### Tab Completion

Press `Tab` to auto-complete file and folder names:
```bash
cd Doc[Tab]               # Completes to "Documents"
cd ~/.clau[Tab]           # Completes to "~/.claude"
```

**Pro tip**: This prevents typos and saves time!

---

### Command History

Use the up/down arrow keys to scroll through previous commands:
- `↑` - Previous command
- `↓` - Next command

**Pro tip**: If you need to run the same command again, just press `↑` and Enter!

---

### Clear the Screen

If your terminal gets cluttered:
```bash
clear                     # Clears the screen (Cmd+K on macOS)
```

---

### Copy and Paste

**macOS Terminal**:
- Copy: `Cmd + C`
- Paste: `Cmd + V`

**Windows Command Prompt**:
- Copy: Highlight text, right-click
- Paste: Right-click

**Windows PowerShell/Linux**:
- Copy: `Ctrl + Shift + C`
- Paste: `Ctrl + Shift + V`

---

### Stop a Running Command

If a command is taking too long or you made a mistake:
```bash
Ctrl + C                  # Stops the current command
```

---

## Common Lisa Workflows

### Installing Lisa

```bash
# 1. See where you are
pwd

# 2. Go to your home folder
cd ~

# 3. Clone the repository
git clone https://github.com/kenziecreative/lisa.git

# 4. Copy to plugins folder
cp -r lisa ~/.claude/plugins/lisa

# 5. Go into the Lisa folder
cd ~/.claude/plugins/lisa

# 6. Install dependencies
pip3 install -r scripts/requirements.txt

# 7. Verify installation
ls
```

---

### Running a Campaign

```bash
# 1. Navigate to your project folder
cd ~/my-project

# 2. Check what's here
ls

# 3. Run Lisa with your campaign brief
~/.claude/plugins/lisa/scripts/setup-lisa-campaign.sh my-campaign.json

# 4. Check deliverables were created
ls deliverables/

# 5. View a deliverable
cat deliverables/MKT-001-email-sequence.md

# 6. Check learnings
cat learnings.txt
```

---

### Viewing Quality Check Results

```bash
# Navigate to Lisa scripts
cd ~/.claude/plugins/lisa/scripts

# Run a quality check manually
python3 quality/check-readability.py ~/my-project/deliverables/MKT-001.md

# Check brand compliance
bash quality/check-brand-compliance.sh ~/my-project/deliverables/MKT-001.md
```

---

## Troubleshooting

### "Command not found"

**Problem**: The terminal can't find the command you typed.

**Solutions**:
1. Check spelling (commands are case-sensitive!)
2. Make sure the software is installed (e.g., `python3`, `git`, `jq`)
3. Try the full path: `/usr/local/bin/python3` instead of just `python3`

---

### "Permission denied"

**Problem**: You don't have permission to run or access something.

**Solutions**:
1. Check the file location - are you in the right directory?
2. On macOS/Linux, try adding `sudo` before the command (be careful with this!)
3. Check file permissions with `ls -l`

---

### "No such file or directory"

**Problem**: The file or folder doesn't exist where you think it does.

**Solutions**:
1. Use `pwd` to see where you are
2. Use `ls` to see what's available
3. Check for typos in the file name
4. Make sure you're using the right path (relative vs. absolute)

---

## Next Steps

Once you're comfortable with these basics:

1. **Return to the [README.md](README.md)** to install Lisa
2. **Try the commands** - practice makes perfect!
3. **Use Tab completion** - it will save you time and prevent errors
4. **Don't be afraid to explore** - `ls` and `cd` are safe commands that won't break anything

---

## Quick Reference

| Command | What it does | Example |
|---------|-------------|---------|
| `pwd` | Show current location | `pwd` |
| `ls` | List files and folders | `ls -la` |
| `cd` | Change directory | `cd Documents` |
| `cd ~` | Go to home folder | `cd ~` |
| `cd ..` | Go up one level | `cd ..` |
| `cat` | View file contents | `cat README.md` |
| `mkdir` | Create a folder | `mkdir campaigns` |
| `cp` | Copy files | `cp -r lisa ~/.claude/plugins/lisa` |
| `mv` | Move or rename | `mv old.txt new.txt` |
| `rm` | Delete files | `rm file.txt` |
| `clear` | Clear the screen | `clear` |
| `Ctrl + C` | Stop a command | (keyboard shortcut) |
| `Tab` | Auto-complete | (keyboard shortcut) |
| `↑` / `↓` | Command history | (keyboard shortcut) |

---

**Need more help?** Ask your AI coding assistant (Cursor, Windsurf, Google Antigravity) to walk you through any of these commands step-by-step. They can see your terminal output and guide you in real-time.
