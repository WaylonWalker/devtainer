---
description: List actionable issues from raira - optionally filter by project
subtask: true
---
Here are the actionable issues (open, no blocking dependencies):

!`raira issue actionable --format json $ARGUMENTS`

To work on an issue:
1. `/plan-issue <id>` - Create a plan for this issue
2. Switch to `planner` agent (Tab) for free-form planning

To see full issue details: `raira issue show <id> --format json`
To see subtasks: `raira issue list --parent <id> --format json`

Usage: `/actionable [--priority <level>]`
