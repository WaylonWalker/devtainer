---
description: Search issues and plans in raira
subtask: true
---
Searching for: $ARGUMENTS

**Issues:**
!`raira search query '$ARGUMENTS' --type issue --limit 10 --format json`

**Plans:**
!`raira search query '$ARGUMENTS' --type plan --limit 10 --format json`

To see details: `raira issue show <id> --format json` or `raira plan show <id> --format json`
