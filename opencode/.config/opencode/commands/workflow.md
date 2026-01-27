---
description: List available workflow commands
subtask: true
---
Here are the available workflow commands:

**Raira Issue Management:**
- `/actionable` - List issues ready to work on (no blocking deps)
- `/search <query>` - Search issues and plans
- `/raira-stats` - Show database stats and summaries
- `/standup [period]` - Work summary (today, yesterday, -7d, "this week")

**Issue & Planning Workflow:**
1. `/plan-issue <id>` - Create a plan from a raira issue
2. `/plan-index` - Index all plans/issues with hashes and summaries
3. `/plan-summarize <path>` - Summarize a plan file
4. `/review-plan <path>` - Senior architect review of a plan

**Execution:**
5. `/exec <id>` - Execute a plan by raira ID (must be `--ready`)
6. `/close <id>` - Mark an issue as completed

**Code Review:**
7. `/review` - Review branch changes before merge to main
8. `/review-staged` - Review staged changes before commit

**Utilities:**
9. `/commit` - Suggest commit message for staged changes
10. `/agents-init` - Initialize/update AGENTS.md for the project

**Agents (switch with Tab or use @mention):**
- `issue` - Capture issues via raira CLI (supports subtasks)
- `planner` - Create plans via raira CLI (marks ready when reviewed)

**Raira CLI Quick Reference:**
```bash
raira issue list --format json              # List top-level issues
raira issue list --include-subtasks --format json  # Include subtasks
raira issue list --parent <id> --format json  # Show subtasks only
raira issue actionable --format json        # Ready-to-work issues
raira issue show <id> --format json         # Show issue + subtasks
raira issue create --title 'X'              # Create (auto-sets created_by)
raira issue create-subtask <id> --title 'Y'  # Create subtask
raira issue update <id> --status done       # Status (aliases: done, wip, etc.)
raira plan list --ready --format json       # Plans ready for execution
raira plan list --not-ready --format json   # Plans needing review
raira plan update <id> --ready              # Mark plan ready
raira search query 'keywords' --format json  # Full-text search
raira validate                              # Check data integrity
```

**Typical Workflow:**
1. `/actionable` - Find an issue to work on
2. `/plan-issue <id>` - Create an actionable plan
3. `/review-plan <path>` - Get architect review
4. `raira plan update <id> --ready` - Mark plan ready
5. `/exec <id>` - Execute the plan
6. `/review` - Review changes before merge

Which command would you like to run?
