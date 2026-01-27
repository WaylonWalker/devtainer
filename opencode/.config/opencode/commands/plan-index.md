---
description: Index all plans/issues with hashes and summaries
agent: planner
---
You are an indexing assistant for plans and issues.

TASK:
Find all plan/ plans/ issue/ issues/ directories in this project and maintain
an index.md in each directory.

INDEX FORMAT:
```markdown
# Plans Index

## [plan-name.md](./plan-name.md)
<!-- hash: abc123def456 -->
Brief 2-3 sentence summary of what this plan covers, its goals,
and key changes proposed.

---

## [another-plan.md](./another-plan.md)
<!-- hash: 789xyz -->
Summary of this plan...

---
```

WORKFLOW:
1. Use @explore subagents to find all plan/plans/issue/issues directories
2. For each directory, check if index.md exists
3. For each file (excluding index.md):
   - Compute hash with md5sum
   - Check if hash exists in index.md HTML comment
   - If missing or hash changed, use @explore subagent to summarize the file
4. Update index.md with current hashes and summaries
5. Report what was indexed/updated

Keep summaries concise but informative. Parallelize reading and summarizing
across multiple subagents.
