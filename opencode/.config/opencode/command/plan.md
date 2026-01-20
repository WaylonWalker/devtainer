---
description: Convert conversation to actionable plan
agent: general
subtask: true
---

Analyze the current conversation context and create/overwrite PLAN.md with:
1. **Objective**: Clear goal statement  
2. **Current State**: Parallel assessment (!`git status` & !`git log --oneline -5`)
3. **Action Items**: Numbered tasks with dependencies and priority levels
4. **Dependencies**: Tool requirements with auto-detection
5. **Validation**: Per-task quality gates
6. **Acceptance Criteria**: Measurable completion criteria

Focus on breaking complex requests into executable chunks that agents can complete independently.
Use priority levels: [HIGH] [MEDIUM] [LOW] for task ordering.

**Auto-split detection**: If a task involves multiple components/files/systems, automatically break into subtasks.
