# Issue Tracking CLI Specification

This document describes how to work with a CLI-based issue tracking system. The CLI manages issues and plans stored as markdown files with YAML frontmatter.

## Discovery

Before using the CLI, run the explain command to get the full schema:

```bash
[cli-name] explain
```

This returns a JSON schema describing:
- All available commands and subcommands
- Required and optional parameters
- Enum values and their aliases
- Input/output formats
- Usage examples

**Always run explain first** to understand the specific CLI's capabilities.

## Core Concepts

### Issues
Issues represent work items: bugs, features, tasks, etc.

- Have metadata: title, status, priority, project, dependencies
- Have a markdown body with details
- Can have parent/child relationships (subtasks)
- Track lifecycle: created_at, started_at, completed_at

### Plans
Plans are implementation specifications for issues.

- Linked to exactly one issue via `--for-issue`
- Have a `ready` flag indicating review status
- Contain step-by-step implementation details
- Track same lifecycle as issues

### Status Flow
```
open → in-progress → completed
                  → cancelled
```

Status changes auto-set timestamps:
- `in-progress`: sets `started_at`
- `completed`: sets `completed_at`

### Priority Levels
```
high   (aliases: urgent, critical, p0, p1)
medium (aliases: normal, p2)
low    (aliases: minor, p3, backlog)
```

## Common Operations

### Listing and Searching

```bash
# List issues with filters
[cli] issue list --status open --priority high --format json
[cli] issue list --project myproject --format json
[cli] issue list --assigned-to alice --format json

# List actionable issues (open, no blocking deps)
[cli] issue actionable --format json

# Full-text search
[cli] search query 'keywords here' --format json

# List plans
[cli] plan list --for-issue <id> --format json
[cli] plan list --ready --format json
[cli] plan list --not-ready --format json
```

**Always use `--format json`** for programmatic consumption.

### Showing Details

```bash
# Show issue with all metadata
[cli] issue show <id> --format json

# Show issue as raw markdown (includes body)
[cli] issue show <id> --format markdown

# Show plan
[cli] plan show <id> --format json
[cli] plan show <id> --format markdown
```

### Creating

```bash
# Create issue (minimal)
[cli] issue create --title 'Issue title' --priority high --project myproject

# Create issue with body via stdin
echo 'Markdown body content' | [cli] issue create --title 'Title' --project myproject

# Create issue with body via --body flag (if supported)
[cli] issue create --title 'Title' --body 'Inline body' --project myproject
[cli] issue create --title 'Title' --body - --project myproject  # stdin

# Create subtask
[cli] issue create-subtask <parent-id> --title 'Subtask title'
[cli] issue create --title 'Subtask' --parent <parent-id>

# Create plan (must link to issue)
[cli] plan create --title 'Plan title' --for-issue <issue-id>
echo 'Plan body' | [cli] plan create --title 'Title' --for-issue <id>
```

### Updating

```bash
# Update issue status (auto-sets timestamps)
[cli] issue update <id> --status in-progress
[cli] issue update <id> --status completed

# Update priority
[cli] issue update <id> --priority high

# Update assignment
[cli] issue update <id> --assign alice
[cli] issue update <id> --unassign

# Update body content
[cli] issue update <id> --body 'New body content'
echo 'New body' | [cli] issue update <id> --body -

# Manage dependencies
[cli] issue update <id> --add-dep <other-id>
[cli] issue update <id> --remove-dep <other-id>

# Update plan
[cli] plan update <id> --status in-progress
[cli] plan update <id> --ready      # Mark as reviewed/ready
[cli] plan update <id> --not-ready  # Mark as draft
echo 'Updated plan' | [cli] plan update <id> --body -
```

## Workflow Patterns

### Creating an Issue with Full Body

```bash
echo '## Summary

Description of the problem or feature.

## Acceptance Criteria

- [ ] Criterion 1
- [ ] Criterion 2

## Technical Notes

Relevant technical details.
' | [cli] issue create --title 'Descriptive Title' --priority high --project myproject
```

### Planning an Issue

```bash
# 1. Get issue details
[cli] issue show <issue-id> --format json

# 2. Create plan with implementation details
echo '## Approach

Brief description of the solution.

## Files to Modify

- `src/file1.ts` - Add new function
- `src/file2.ts` - Update imports

## Implementation Steps

1. Step one details
2. Step two details
3. Step three details

## Testing

- Unit tests for new function
- Integration test for workflow
' | [cli] plan create --title 'Plan: Descriptive Title' --for-issue <issue-id>
```

### Executing a Plan

```bash
# 1. Mark plan as in-progress
[cli] plan update <plan-id> --status in-progress

# 2. (Do the implementation work)

# 3. Mark plan completed
[cli] plan update <plan-id> --status completed

# 4. Mark issue completed
[cli] issue update <issue-id> --status completed
```

### Batch Operations

```bash
# Get all actionable issues for a project
[cli] issue actionable --format json | jq '.[] | select(.project == "myproject")'

# Get all draft plans needing review
[cli] plan list --not-ready --format json

# Get issues created in last 7 days
[cli] issue list --created-since -7d --format json
```

## Best Practices

### Always Search Before Creating

```bash
# Check for existing issues
[cli] search query 'relevant keywords' --format json

# If similar exists, consider:
# - Updating existing issue
# - Creating as subtask
# - Linking as dependency
```

### Use JSON Format for Parsing

```bash
# Good - structured output
[cli] issue list --format json

# Avoid - human-readable but hard to parse
[cli] issue list
```

### Provide Complete Context in Bodies

Issues should include:
- Summary of problem/feature
- Acceptance criteria (checkboxes)
- Technical context
- Affected files (if known)

Plans should include:
- Approach summary
- Specific file paths
- Numbered implementation steps
- Testing strategy
- Acceptance criteria mapping

### Keep Status Updated

```bash
# When starting work
[cli] issue update <id> --status in-progress
[cli] plan update <id> --status in-progress

# When done
[cli] plan update <id> --status completed
[cli] issue update <id> --status completed
```

### Use Dependencies for Ordering

```bash
# Issue B depends on Issue A
[cli] issue update <issue-b-id> --add-dep <issue-a-id>

# Now issue B won't appear in actionable until A is completed
```

## Error Handling

### Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| `No such option: --flag` | Flag doesn't exist | Run `[cli] explain` to check available flags |
| `Issue not found` | Invalid ID | Verify ID with `[cli] issue list` |
| `Missing required option` | Required param missing | Check `[cli] <command> --help` |

### Validation

Before creating/updating, validate:
- Issue ID exists: `[cli] issue show <id> --format json`
- Plan links to valid issue: Check `for_issue` field
- Dependencies exist: Verify each dep ID

## CLI-Specific Discovery

Different CLIs may have variations. Always check:

```bash
# Full schema
[cli] explain

# Specific command help
[cli] issue create --help
[cli] plan update --help

# Available enum values
[cli] explain | jq '.enum_aliases'
```

Key things to discover:
- Does `create` support `--body` flag or only stdin?
- What status/priority aliases are accepted?
- Are there project-specific commands?
- What date formats are accepted for filters?
