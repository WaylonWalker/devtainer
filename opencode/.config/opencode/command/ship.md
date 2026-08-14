---
description: Sequentially review, fix, validate, release, watch CI, deploy, and verify a change
agent: build
---
Load and follow the `ship-change` skill for this delivery request:

$ARGUMENTS

Act as the sole orchestrator. Execute dependent stages sequentially and wait for each specialist before continuing. Do not launch review, test, release, CI, or deployment stages in parallel. Continue through recoverable review, CI, and deployment failures using the skill's bounded fix-forward loops, and stop rather than guess when a target or destructive action is ambiguous.
