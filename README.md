# gravity-assist

A [Claude Code](https://claude.com/claude-code) skill for handing execution work to
Google's [Antigravity CLI](https://antigravity.google) (`agy`) and its Gemini models,
while Claude keeps planning, judgment and review.

A gravity assist borrows a planet's pull to travel further on less fuel. This skill
borrows Gemini for the bulk edits so the orchestrating model's budget goes to the
decisions.

## What it covers

- Which model gets which work (Gemini 4 Hydrogen, Gemini 3.8 Flash, or Claude itself).
- The exact `agy -p` invocation and a brief format that keeps batches consistent.
- Batching and parallel queues for large sweeps (`scripts/agy-batch.sh`).
- Failure modes of headless `agy` seen in real use and what to do about each.

## Install

```bash
git clone https://github.com/spandansingh/gravity-assist ~/.claude/skills/gravity-assist
```

Needs the Antigravity CLI (`agy --version`), signed in once interactively.
Claude Code picks the skill up from `~/.claude/skills/`. Other agents that read
`~/.agents/skills/` can use the same folder.

## Contributing

Found a new failure mode or a better pattern? Add it to `SKILL.md` and a dated line to
`LEARNINGS.md`, then open a pull request.

## License

MIT
