---
name: plan-review
description: Review implementation plans for technical soundness and project fit
---
Review the implementation plan against these criteria:

## Must Pass (reject if any fail)

- **Correctness**: Will this actually solve the stated problem?
- **Safety**: No data loss risks, security holes, or breaking changes without migration path
- **Dependencies**: All referenced code/APIs exist and are used correctly
- **Scope**: Changes are focused; no unrelated refactoring bundled in

## Should Evaluate

- **Alternatives**: Is there a simpler approach? Over-engineering?
- **Patterns**: Follows existing codebase conventions, or justifies deviation
- **Edge cases**: Error handling, empty states, concurrent access considered
- **Testability**: Can the changes be verified?

## Research Before Judging

Use `@explore` subagents to investigate:
- How similar problems are solved elsewhere in the codebase
- What patterns exist in affected areas
- Whether referenced code/APIs work as the plan assumes

Launch multiple @explore tasks in parallel when investigating different areas.

## Output Format

Provide:
1. **Summary**: One sentence assessment
2. **Findings**: Specific issues or confirmations, with file/line references where relevant
3. **Verdict**: One of:
   - **(approved)** - Ready to implement
   - **(approved with suggestions)** - Good, with optional improvements noted
   - **(needs revision)** - Blocking issues listed above must be addressed
