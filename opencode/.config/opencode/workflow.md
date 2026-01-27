# OpenCode + Raira: A Structured Workflow for AI-Assisted Development

Managing issues, plans, and code changes across a team can quickly become chaotic. This post describes a workflow that combines **OpenCode** (an AI coding agent) with **Raira** (a CLI-based issue tracker) to create a structured, traceable development process.

## The Problem

Traditional workflows often suffer from:
- Context switching between issue trackers, IDEs, and terminals
- Loss of context when moving from issue to implementation
- No clear audit trail from problem to solution
- Duplicate issues and scattered plans

## The Solution: Specialized Agents + Structured Commands

The workflow uses **specialized AI agents** for different phases of work, each with appropriate permissions, combined with **slash commands** that automate common operations.

```mermaid
flowchart TD
    subgraph Capture["1. Capture"]
        A[Problem Reported] --> B{Duplicate?}
        B -->|Yes| C[Update Existing Issue]
        B -->|No| D[Create New Issue]
        C --> E[Issue in Raira]
        D --> E
    end

    subgraph Plan["2. Plan"]
        E --> F[/plan-issue]
        F --> G[@explore agents research codebase]
        G --> H[Create Linked Plan]
        H --> I[Plan in Raira]
    end

    subgraph Review["3. Review"]
        I --> J[/review-plan]
        J --> K{Approved?}
        K -->|Needs Work| H
        K -->|Yes| L[Plan Approved]
    end

    subgraph Execute["4. Execute"]
        L --> M[/exec]
        M --> N[Status: in-progress]
        N --> O[Implement Changes]
        O --> P[@general subagents]
        P --> Q{Tests Pass?}
        Q -->|No| O
        Q -->|Yes| R[Status: completed]
    end

    subgraph Merge["5. Merge"]
        R --> S[/review-staged]
        S --> T[/commit]
        T --> U[/review]
        U --> V{Approved?}
        V -->|No| O
        V -->|Yes| W[Merge to Main]
        W --> X[Issue Closed]
    end

    style Capture fill:#e1f5fe
    style Plan fill:#fff3e0
    style Review fill:#fce4ec
    style Execute fill:#e8f5e9
    style Merge fill:#f3e5f5
```

## Agents

The workflow uses four primary agents, each with specific permissions:

| Agent | Purpose | Can Write To |
|-------|---------|--------------|
| `build` | Default coding agent | Anywhere |
| `plan` | Read-only analysis | Nothing (asks first) |
| `issue` | Capture and triage issues | `issues/` directory only |
| `planner` | Create implementation plans | `plans/` and `issues/` only |

Switch between agents with **Tab** in the OpenCode TUI.

### Why Restricted Permissions?

The `issue` and `planner` agents are intentionally restricted:
- They can't accidentally modify source code
- They're forced to use Raira CLI for tracking
- All work is captured in the issue/plan system
- Creates an audit trail from problem to solution

## Commands

Slash commands automate common operations:

### Issue Management
```
/actionable              # List issues ready to work on
/search <query>          # Search issues and plans  
/standup [period]        # Work summary (today, -7d, "this week")
/close <id>              # Mark issue completed
```

### Planning & Execution
```
/plan-issue <id>         # Create plan from issue
/review-plan <path>      # Architect review
/exec <id>               # Execute plan (auto-sets in-progress)
```

### Code Review
```
/review-staged           # Review before commit
/commit                  # Suggest commit message
/review                  # Review branch before merge
```

## The Workflow in Practice

### 1. Capture an Issue

Switch to the `issue` agent and describe the problem:

```
Tab → issue agent

"Users report that batch jobs fail silently without logging errors"
```

The agent will:
1. Search for existing issues to avoid duplicates
2. Ask before creating if similar issues exist
3. Create via `raira issue create` with proper metadata
4. Auto-set `created_by` from current user

### 2. Create a Plan

```
/plan-issue abc123
```

The `planner` agent:
1. Fetches issue details from Raira
2. Spawns `@explore` subagents to research the codebase in parallel
3. Synthesizes findings into an actionable plan
4. Creates the plan linked to the issue

### 3. Review the Plan

```
/review-plan plans/fix-batch-logging.md
```

A senior architect review focusing on:
- Project-wide impact
- Long-term maintainability
- Security and performance implications
- Alternative approaches

Once approved, mark the plan as ready:

```bash
raira plan update <id> --ready
```

### 4. Execute

```
/exec def456
```

This automatically:
1. Sets plan status to `in-progress`
2. Shows plan details
3. Implements changes with full tool access
4. Uses `@general` subagents for parallel work
5. Marks plan and linked issue as `completed` when done

### 5. Review and Merge

```
/review-staged    # Before committing
/commit           # Get commit message suggestion
/review           # Before merging to main
```

## Daily Standup

Track what you've accomplished:

```
/standup              # Today's activity
/standup yesterday    # Yesterday's work
/standup -7d          # Last 7 days
/standup "this week"  # This week
```

Shows issues completed, in-progress, and plans completed for the period.

## Raira CLI Quick Reference

```bash
# Issues
raira issue list                        # List all (top-level only)
raira issue list --include-subtasks     # Include subtasks
raira issue list --parent <id>          # Show subtasks of parent
raira issue list --assigned-to alice    # By assignee
raira issue list --created-by bob       # By creator
raira issue actionable                  # Ready to work on
raira issue show <id>                   # Details (shows subtasks)
raira issue create --title 'X'          # Create (auto-sets created_by)
raira issue create-subtask <parent> --title 'Y'  # Create subtask
raira issue update <id> --assign alice  # Assign
raira issue update <id> --status done   # Status (aliases: done, wip, etc.)
raira issue update <id> --body 'New content'    # Update body

# Plans  
raira plan list --for-issue <id>        # Plans for issue
raira plan list --ready                 # Ready-to-execute plans
raira plan list --not-ready             # Plans needing review
raira plan create --title 'Y' --for-issue <id>
raira plan update <id> --status wip     # Status aliases work here too
raira plan update <id> --ready          # Mark ready for execution
raira plan update <id> --body -         # Update body from stdin

# Search & Users
raira search query 'keywords'
raira user show-current

# Maintenance
raira validate                          # Check data integrity
raira fix --dry-run                     # Preview fixes
```

### Status Aliases

Raira accepts natural aliases for status and priority:

| Canonical | Aliases |
|-----------|---------|
| `open` | new, todo, pending |
| `in-progress` | wip, active, working, started, doing |
| `completed` | done, finished, closed, resolved, shipped |
| `cancelled` | canceled, rejected, abandoned, dropped, wontfix |
| `high` | urgent, critical, p0, p1, blocker |
| `medium` | normal, p2, standard, default |
| `low` | minor, p3, trivial, backlog |

## Breaking Down Large Issues

For complex features, use subtasks to break work into smaller pieces:

```bash
# Create parent issue
raira issue create --title 'User authentication system' --priority high

# Break into subtasks
raira issue create-subtask abc123 --title 'Database schema for users'
raira issue create-subtask abc123 --title 'Login API endpoint'
raira issue create-subtask abc123 --title 'Session management'
raira issue create-subtask abc123 --title 'Frontend login form'

# View subtasks
raira issue show abc123  # Shows subtask list
raira issue list --parent abc123  # List only subtasks
```

Subtasks:
- Inherit project from parent
- Default to parent's priority (can override)
- Are hidden from default list (use `--include-subtasks`)
- Can be promoted: `raira issue update <id> --no-parent`

## Benefits

1. **Traceability**: Every change links back to an issue and plan
2. **Appropriate Permissions**: Agents can only modify what they should
3. **Parallel Research**: Subagents explore codebase concurrently
4. **Automated Status**: Lifecycle dates set automatically
5. **Duplicate Prevention**: Agent asks before creating similar issues
6. **Daily Visibility**: Standup command shows work at a glance
7. **Plan Readiness**: Clear signal when plans are ready for execution
8. **Subtask Support**: Break large issues into manageable pieces

## Getting Started

1. Install OpenCode and configure your provider
2. Install Raira globally: `uv tool install raira`
3. Set your current user: `raira user add <id> --name 'Your Name' --set-current`
4. Copy the agent and command configurations to `~/.config/opencode/`
5. Run `/workflow` to see all available commands

The key insight is that **constraints enable focus**. By restricting what each agent can do, we ensure work flows through the proper channels and nothing gets lost.
