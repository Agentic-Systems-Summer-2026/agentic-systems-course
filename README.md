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

**Keys stay out of git.** Your Sandbox key lives in Codespaces secrets and
(from BC4 on) a GitHub Actions repository secret. `.env` files are
gitignored. If a key ever lands in a commit: rotate it, then fix history.

## CI eval gate (from BC4)

The included workflow runs `bc4-evals/` on every push — a small live sweep
(~5 cases, cached, capped). Until you add the `LITELLM_API_KEY` repository
secret it passes with a notice, so early pushes stay green. From BC4 onward
a red X means your change regressed the evals — read the failure, fix or
justify, never just raise the threshold.

## Model notes

Default model: `Qwen3 Coder 30B` (set in the Codespace config). Route
individual calls to cheaper models with `chat(..., model="gemma4-small")` —
you'll use that in the Day 9 cost lab. Switch the TUI's model any time with
`scripts/select-model.sh` or `Ctrl/Cmd+Alt+M`.
