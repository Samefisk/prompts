# AGENTS.md

## Scope
These rules apply to all prompt edits in this folder, especially `super-prompt.md` and the synced `super.json` mode file.
They must be continuously refined after each user request as understanding improves.

## Primary intent
- Treat the prompt as a production prompt spec, not creative prose.
- Treat `super-prompt.md` as the canonical edit surface for the `super` prompt.
- Optimize for deterministic behavior, style consistency, and low ambiguity.
- Prefer rule-level instruction improvements over adding more examples.

## Change strategy for the super prompt
- Do not edit the `prompt` field inside `super.json` directly.
- For all prompt text changes, edit `super-prompt.md` first, then run `node scripts/super-prompt.mjs import` to inject it into the `prompt` field of `super.json`.
- Only edit `super.json` directly for non-prompt mode settings, and preserve those settings unless explicitly requested.
- If an external tool or merge changes `super.json` directly, immediately run `node scripts/super-prompt.mjs export` to restore `super-prompt.md` as the readable canonical copy before making further prompt edits.
- Prefer targeted, minimal diffs that fix behavior without broad rewrites.
- Keep terminology consistent across all sections so one rule does not conflict with another.
- When changing a core convention, update all duplicate sections that restate it (rules, templates, checklist, and examples).
- When replacing a core term (taxonomy changes), perform full migration of the old term across dictionary entries, templates, examples, edge cases, and checklist language.

## Type 2 style and tone policy
- Type 2 premise flavor should default to formal bridges, not conversational tone.
- Prefer `and thus`, `therefore`, or permission-forward bridges such as `allowing me to` / `allowing it to`.
- Avoid `so` unless explicitly requested by the user/transcript.
- Do not use em dashes (`—`) in final card output punctuation.
- Preserve legal grammar under strip-test requirements (mechanical rule must remain complete when brackets are removed).
- No effect segment may end with flavor; move any tail flavor into premise or embedded positions.

## Example usage policy
- Do not rely on examples as the primary control mechanism.
- Use short structural patterns only when needed; avoid expanding example volume.
- Ensure instructions are enforceable as rules even if examples are removed.
- Do not wrap ordinary prompt instructions or examples in fenced code blocks; reserve code fences only for content that truly must render as literal code.
- When removing code fences, preserve hierarchy with Markdown headings, numbered sections, and nested bullets rather than leaving separator text as plain prose.

## Quality checks after every edit
- Validate there are no contradictory templates across sections.
- Search for stale phrasing that conflicts with the updated rule set.
- Run `node scripts/super-prompt.mjs check` before committing prompt changes.
- Confirm Type 2C wording supports both timing-scope and permission-forward ordering where requested.
- Ensure flavor and mechanics separation rules still hold.

## Collaboration behavior
- If a requested style preference is clear, encode it as a direct rule, not just an example.
- If wording preferences affect multiple effect types, propagate them intentionally and note the propagation.
- Keep user-facing summaries concise and focused on what changed and why.
- When the super prompt changes, commit and `git push` `super-prompt.md` and `super.json` together in the same execution flow unless the user explicitly tells you not to push.

## Continuous learning loop (required every request)
- After each user request, extract any new preference, constraint, or quality signal and update this file when it adds durable guidance.
- Treat rule updates as part of completion criteria, not optional follow-up.
- Deepen, do not just append: merge overlapping rules, remove ambiguity, and keep the rule set coherent.
- Do not maintain an append-only learning log; it bloats future LLM context.
- Encode durable learnings in the active rule sections above, replacing or superseding older wording directly.
- Keep `Recent Changes` to at most 3 short bullets. Delete older notes once their guidance is represented in active rules.
- If no durable new learning exists for a request, do not add a note.

## Recent Changes
- 2026-05-12: For flavored duration-scoped continuations after `->`, keep duration first, then embedded consequence-state flavor, then the mechanical sentence.
- 2026-05-12: Rewrite Section 6.6 around syntactic integration: brackets must be removable or grammatically bridge surrounding text, and no segment may end with flavor.
- 2026-05-12: Do not keep Guard-specific flavor patterns in the general Type 1 weaving examples; rely on broad placement rules instead.
