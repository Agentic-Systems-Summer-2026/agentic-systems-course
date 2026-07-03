# Agentic Systems Course Repo — SDI 4243/5243 (OU)

Your personal course repository for the Summer 2026 July Block. Everything
you build this course lives here: five Build Challenges, your prompts, your
Build Journal, and a CI eval gate. By August 7 this repo *is* your portfolio.

## Get started (once)

1. Click **Use this template → Create a new repository** (your account;
   private is fine). Do **not** fork.
2. On your new repo: **Code → Codespaces → Create codespace on main.**
   You'll be prompted for your `LITELLM_API_KEY` (your OU AI Sandbox key,
   starts with `sk-`). `OPENROUTER_API_KEY` is optional.
3. Wait for setup to finish (watch the numbered steps). The OpenClaw gateway
   auto-starts in the background and two terminals open: **Gateway** (live
   log) and **TUI** (chat with your agent). Full details on how this works:
   [openclaw-codespace-starter](https://github.com/jhassell/openclaw-codespace-starter)
   — this repo includes the same machinery.
4. Smoke test: `python3 bc1-tools/agent.py "what do my notes say about the demo?"`

## Layout

| Path | What it is |
|---|---|
| `bc1-tools/` … `bc5-observability/` | One folder per Build Challenge: a runnable starter + `README.md` with the spec, acceptance check, and rubric |
| `common/llm.py` | Shared Sandbox client (stdlib): `chat()`, `STATS` (cost tracking), `cache=True`, `load_prompt()` |
| `prompts/` + `PROMPTS.md` | Prompts as files + the required changelog. Prompts are software artifacts. |
| `JOURNAL.md` | Your Build Journal (graded, cumulative, also your AI-use disclosure record) |
| `.github/workflows/eval.yml` | CI regression gate — runs your BC4 eval harness on every push |
| `.devcontainer/`, `scripts/`, `.vscode/` | Codespace machinery (OpenClaw + OU LiteLLM gateway) — you shouldn't need to touch these |

## Working rhythm

Each dated Canvas module tells you what to build. Build it in the matching
folder, commit as you go (small commits with real messages — your history is
part of the evidence), push, and add a `JOURNAL.md` entry. Due 11:59 PM CT.

### Getting instructor updates

Your repo is a **snapshot** of the template at the moment you created it —
instructor fixes pushed to the template afterward do *not* arrive
automatically, and plain `git pull` only syncs **your own** repo. If an
update is announced, run (first time):

```bash
git remote add upstream https://github.com/Agentic-Systems-Summer-2026/agentic-systems-course
git pull upstream main --allow-unrelated-histories
```

and after that just `git pull upstream main`. Grading and assignment
details never require this — they live in Canvas, not in the repo.

**Keys stay out of git.** Your Sandbox key lives in Codespaces secrets and
(from BC4 on) a GitHub Actions repository secret. `.env` files are
gitignored. If a key ever lands in a commit: rotate it, then fix history.

## CI eval gate (from BC4)

The included workflow runs `bc4-evals/` on every push — a small live sweep
(~5 cases, cached, capped). Until you add the `LITELLM_API_KEY` repository
secret it passes with a notice, so early pushes stay green. From BC4 onward
a red X means your change regressed the evals — read the failure, fix or
justify, never just raise the threshold.

## Toolbelt (pre-installed)

Beyond Python/Node/git, setup installs: `cloudflared` (share a running demo:
`cloudflared tunnel --url http://localhost:5000`), `jq` (JSON wrangling),
`gh` (check your CI eval runs: `gh run list`), `sqlite3` (retrieval/memory
labs, agent state), `tmux` (keep long-running agents alive — BC3),
`asciinema` (terminal recordings — an official demo-evidence format:
`asciinema rec demo.cast`, then commit the file), `ripgrep`, `httpie`,
`tree`, `htop`, `entr` (auto-rerun on change:
`ls bc4-evals/*.py | entr python3 bc4-evals/harness.py`), and `flask`
(serve a capstone demo UI behind your tunnel).

## Model notes

Default model: `Qwen3 Coder 30B` (set in the Codespace config). Route
individual calls to cheaper models with `chat(..., model="gemma4-small")` —
you'll use that in the Day 9 cost lab. Switch the TUI's model any time with
`scripts/select-model.sh` or `Ctrl/Cmd+Alt+M`.
