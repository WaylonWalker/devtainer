---
description: Show raira database stats and summary
subtask: true
---
**Raira Database Statistics:**
!`raira db stats --format json`

**Open Issues by Priority:**
!`raira issue list --status open --limit 20 --format json`

**Actionable Issues (ready to work on):**
!`raira issue actionable --limit 10 --format json`
