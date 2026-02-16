# AGENTS.md

## Scope
These rules apply to all prompt edits in this folder, especially `super.json`.
They must be continuously refined after each user request as understanding improves.

## Primary intent
- Treat `super.json` as a production prompt spec, not creative prose.
- Optimize for deterministic behavior, style consistency, and low ambiguity.
- Prefer rule-level instruction improvements over adding more examples.

## Change strategy for `super.json`
- Edit the `prompt` field directly and preserve all non-prompt mode settings unless explicitly requested.
- Prefer targeted, minimal diffs that fix behavior without broad rewrites.
- Keep terminology consistent across all sections so one rule does not conflict with another.
- When changing a core convention, update all duplicate sections that restate it (rules, templates, checklist, and examples).

## Type 2 style and tone policy
- Type 2 premise flavor should default to formal bridges, not conversational tone.
- Prefer `and thus`, `therefore`, or permission-forward bridges such as `allowing me to` / `allowing it to`.
- Avoid `so` unless explicitly requested by the user/transcript.
- Do not use em dashes (`—`) in final card output punctuation.
- Preserve legal grammar under strip-test requirements (mechanical rule must remain complete when brackets are removed).

## Example usage policy
- Do not rely on examples as the primary control mechanism.
- Use short structural patterns only when needed; avoid expanding example volume.
- Ensure instructions are enforceable as rules even if examples are removed.

## Quality checks after every edit
- Validate there are no contradictory templates across sections.
- Search for stale phrasing that conflicts with the updated rule set.
- Confirm Type 2C wording supports both timing-scope and permission-forward ordering where requested.
- Ensure flavor and mechanics separation rules still hold.

## Collaboration behavior
- If a requested style preference is clear, encode it as a direct rule, not just an example.
- If wording preferences affect multiple effect types, propagate them intentionally and note the propagation.
- Keep user-facing summaries concise and focused on what changed and why.

## Continuous learning loop (required every request)
- After each user request, extract any new preference, constraint, or quality signal and update this file when it adds durable guidance.
- Treat rule updates as part of completion criteria, not optional follow-up.
- Deepen, do not just append: merge overlapping rules, remove ambiguity, and keep the rule set coherent.
- Keep a lightweight history section (`Learning Log`) with date-stamped entries describing what was learned and how it changed editing behavior.
- If no durable new learning exists for a request, explicitly record "no rule change" in the `Learning Log`.

## Learning Log
- 2026-02-16: For team-facing prompt distribution, prefer publishing an isolated prompt artifact (`.md`) derived from mode JSON rather than sharing the full JSON file; keep automation/docs aligned to the artifact URL.
- 2026-02-16: When adapting teammate automation tooling, mirror the user-provided reference script structure and provider defaults; encode explicit model/reasoning requirements as defaults in implementation docs and scripts.
- 2026-02-16: No rule change (execution request to run push/auth flow; no new durable prompt-edit preference introduced).
- 2026-02-16: For distribution/onboarding requests, provide beginner-friendly Git steps and copy-paste commands; avoid assuming prior Git experience.
- 2026-02-15: Established deterministic prompt-edit workflow for `super.json`; prioritize rule-level changes over examples.
- 2026-02-15: Enforced formal Type 2 premise tone (`and thus`/`therefore`/`allowing ...`) and avoid informal `so` by default.
- 2026-02-15: Added mandatory continuous rule refinement after each request, with explicit logging.
- 2026-02-15: Prioritized Type 2C comprehension by preferring embedded flavor after `When` trigger clauses; accepted binder pattern `When ..., [flavor, allowing me/it] to ...` when clearer.
- 2026-02-15: Banned em dashes in final output text; use semicolon or formal connector punctuation instead.
- 2026-02-15: Added spoken directive `update`: treat selected/transcribed legacy text as mechanics source only and reconstruct wording to current standards while preserving mechanics.
- 2026-02-15: When adding anchor phrases, update both the dictionary table and all downstream targeting/ambiguity checks that reference anchor-implied single-target behavior.
- 2026-02-15: Added Punch-equivalent anchors (`Headbutt`, `Claw`, `Gouge`, `Ram`, `Maul`) and propagated them to all single-target anchor checks.
- 2026-02-15: Prefer pruning redundant anchors when semantics overlap heavily (e.g., keep one canonical anchor and remove near-duplicates), and propagate removals to all validation lists.
- 2026-02-15: For persistent damage buffs, prefer explicit scoped wording (`Magic damage X deals is increased by N`) over ambiguous `X deals +N Magic damage`; keep flavor at premise start or justification end for clarity.
- 2026-02-15: Refined persistent damage-buff style: with flavor, prefer premise-first plus mechanical continuation (`[Flavor], increasing the Magic damage X deals by N`) for better readability and scope clarity.
