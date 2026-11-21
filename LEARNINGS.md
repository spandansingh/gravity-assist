# Learnings

Dated notes from real use. Newest first. Each one should also be reflected in SKILL.md.

- **2026-11-14** — Skill test: a fresh agent with only this skill renamed a function across
  3 files via Hydrogen, briefed in the 4-part format, verified with grep + diff, and
  committed itself. It put the brief in `/tmp`; briefs now go inside the repo.
- **2026-11-14** — Headless `agy -p` has no codebase search tool and auto-denies shell
  commands, so read-only research ("where is this env var read, what is its default")
  failed twice. Doing the lookup directly with grep took one command. Research stays with
  Claude.
- **2026-11-14** — A permission allow-rule via `--settings` (`command(node scripts/x.mjs*)`)
  did not stop the "command permission" denial in v1.5.8. Briefs now forbid shell commands
  and the orchestrator runs every check.
- **2026-11-13** — A 4,600-edit colour sweep across ~300 files: 30 batches of ~12 files,
  three parallel queues, Gemini 4 Hydrogen. Pilot batch of 4 files first; ~2–5 min per batch.
  Exact mapping table in a repo file kept results consistent across batches.
- **2026-11-13** — Mid-sweep failures printed "authentication timed out". The interactive
  status bar showed `AI: Out of credits`. Credits came back later; a one-line `Reply OK`
  probe confirms before resuming.
- **2026-11-13** — Gemini 3.8 Flash handled two exact one-line JSX edits correctly in one
  run; fine for fully specified edits.
- **2026-11-18** — A Flash run on a 3-file brief finished the first file in about a minute,
  then sat for over 10 minutes with no output and no further edits until it was stopped.
  A second Flash run (2 JSON files) wrapped in `timeout 240` finished normally. Always run
  headless agy under `timeout`, and when one file's diff lands but the rest don't move,
  review what landed and finish the rest yourself.
- 2026-11-21: Flash (`gemini-3.8-flash-medium`) applied a 4-file exact-edit brief correctly but printed nothing (exit 0), not even the requested report lines. Don't treat empty output as failure; read the diff.
- 2026-11-21: Hydrogen (`gemini-4-hydrogen-high`) printed the requested report lines with each path wrapped as a markdown link to an absolute `file://` URL (`[path](file:///…) — done`). Match on `— done` rather than a line starting with the path. Flash printed plain paths. Six briefs across both models (1–8 files, exact before/after blocks) all landed exactly as written.
