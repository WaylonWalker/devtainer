---
description: Plan from an issue - fetch issue from raira and create actionable plan
agent: planner
---
Create a plan for issue $ARGUMENTS.

First, fetch the issue details:
!`raira issue show $ARGUMENTS --format json`

Then:
1. Use @explore subagents to research the codebase in parallel
2. Search for related issues/plans: `raira search query '<keywords>' --format json`
3. Gather comprehensive context about affected areas
4. Synthesize findings into a clear, actionable plan
5. Create the plan via raira: `raira plan create --title '<title>' --for-issue $ARGUMENTS`

Plan thoroughly without asking unnecessary questions. Focus on creating clear,
actionable plans with specific file paths and implementation details.
