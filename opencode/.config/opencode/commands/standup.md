---
description: Generate daily/weekly work summary from raira activity
subtask: true
---
**Work Summary for: $ARGUMENTS**

(Default: today. Use: yesterday, -7d, "this week", "this month", 2025-01-15)

**Issues Completed:**
!`raira issue list --status completed --completed-since "${ARGUMENTS:-today}" --format json 2>/dev/null || raira issue list --status completed --completed-since today --format json`

**Issues In Progress:**
!`raira issue list --status in-progress --created-since "${ARGUMENTS:-today}" --format json 2>/dev/null || raira issue list --status in-progress --format json`

**Plans Completed:**
!`raira plan list --status completed --completed-since "${ARGUMENTS:-today}" --format json 2>/dev/null || raira plan list --status completed --completed-since today --format json`

---
Examples:
- `/standup` - Today's activity  
- `/standup yesterday` - Yesterday's work
- `/standup -7d` - Last 7 days
- `/standup "this week"` - This week
- `/standup "this month"` - This month
