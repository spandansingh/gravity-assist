---
name: gravity-assist
description: Use when handing execution work (multi-file edits, mechanical sweeps, refactors, renames, small fixes) from Claude Code to Google's Antigravity CLI (`agy`) and its Gemini models, when choosing between Gemini 4 Hydrogen and Gemini 3.8 Flash, or when an `agy -p` run fails with "no output produced", "a tool required the command permission", "authentication timed out" or "Out of credits".
---

# Gravity Assist

Claude plans, decides and reviews. Antigravity (`agy`) does the bulk edits on Gemini.
Like a spacecraft borrowing a planet's pull: more distance, less of your own fuel.

**Core rule:** agy edits files. Claude does everything that needs a shell, a search, a
judgment call or git, and reviews every diff before anything is committed.

## Pick the model

| Work | Model id | Why |
|---|---|---|
| Multi-file, agentic: sweeps, refactors, features, fixing tests | `gemini-4-hydrogen-high` | Terminal-Bench 4.1 57% vs 18.2% for Flash; ~2.5x faster per Google |
| One file, fully specified: exact find/replace, a rename, a one-line fix | `gemini-3.8-flash-medium` | About half the token price; fine when there is nothing to decide |
| Design, product calls, contrast/brand judgment, review | Claude | Mistakes here repeat across every file |
| Read-only lookups ("where is X read, what is its default") | Claude, directly with grep/rg | Headless agy has no search tool (see Limits) |

`agy models` lists what the account can use. Re-check benchmarks when a new model ships.

## Run it

```bash
cd <repo or worktree>
~/.local/bin/agy -p "<brief>" --model gemini-4-hydrogen-high \
  --mode accept-edits --print-timeout 0 2>&1 | grep -v "logging before"
```

The brief is a contract. Its parts, in order:
1. **Scope:** "Edit ONLY these files:" plus the exact list.
2. **Rules:** "Do not run any shell command (not even checks); only read and edit files.
   Do not run git, commit, install or touch other files."
3. **The change:** an exact mapping table or exact before/after. Short briefs go inline;
   a long one goes in a file **inside the repo** (`Follow docs/.../brief.md exactly`),
   because agy resolves paths from the repo and can't reach `/tmp`. Delete it after if it
   isn't worth keeping.
4. **Report:** "Print one line per file: `path — done` or `path — left: n (why)`."

Then Claude: run the project's check (linter, guard script, typecheck, narrowest test) on
those files, read the diff, fix or re-brief, and commit. No check script? Grep for what
should be gone (the old name, the old class) and read the whole diff.

## Batches and parallel runs

- **Batch size:** about 12 files or 200 edits per run. That took 2 to 5 minutes on Hydrogen.
- **Parallel:** run 2 to 3 queues at once, each on disjoint files, from one worktree.
  `bash scripts/agy-batch.sh <batch-dir> <queue-index> <queue-count> <brief-file> <model>`
  runs one queue over `b*.txt` file lists and logs `bNN exit <code>` to `logs/done.txt`.
- **Pilot first:** run one small batch, read its diff, then fan out. A bad brief repeats
  across every batch.
- Keep files that another job is editing out of every brief.

## Limits found in use (headless `agy -p`)

| Symptom | Cause | What to do |
|---|---|---|
| `no output produced — a tool required the "command" permission` | Headless mode auto-denies shell tools. `--settings '{"permissions":{"allow":["command(...)"]}}'` did not take (v1.5.8). | Tell agy not to run commands; Claude runs the checks. Avoid `--dangerously-skip-permissions`. |
| Plan-mode lookups refuse: "no grep_search / find_by_name tools" | Headless agy has no codebase search tool | Do read-only research yourself with rg/grep; it is faster |
| `Waiting for authentication… authentication timed out` mid-sweep | Usually the account ran out of AI credits, not a sign-in problem | Run `agy` interactively once: the status bar shows `AI: Out of credits`. Fall back to a Claude subagent (Sonnet) for the rest; re-test later with `agy -p "Reply with exactly: OK" --model <id> --mode plan` |
| One batch in a queue exits 1, others 0 | Same credit or auth cut-off mid-run | Re-run that batch's remaining files; the guard/check output gives the list |
| Edits land but inline comments sit in odd JSX spots (`/* color-allow */` after an attribute) | Literal reading of the brief | Valid JSX; accept, or say where comments go in the brief |

## Common mistakes

- Letting agy commit, push, run migrations, touch secrets or production. Never.
- Briefing in prose ("make it theme-aware") instead of a mapping table. Prose gets
  interpreted differently per batch.
- Trusting the report. Its `done` lines are claims; the check script and the diff are proof.
- Sending research to agy. Lookups are cheaper and more reliable done directly.

## Keep this skill current

When agy behaves differently from what this file says, or a better pattern turns up,
update this file and add a dated line to `LEARNINGS.md` in the same change, then commit
and push this folder (it is the public repo `spandansingh/gravity-assist`).
