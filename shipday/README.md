# Ship Day — Research → Store → Show (15 pts, due Fri Jul 24, 11:59 PM CT)

**Objective.** Build a tiny agent pipeline that (1) **researches** a topic you
pick with **Tavily**, (2) **stores** what it finds in a real **Supabase**
table, and (3) **shows** it on a live web page you **deploy to Netlify**. Then
submit the public URL. This is your first time wiring an agent to real
outside services — hosting, a database, and web search — the same three pieces
almost every capstone needs.

**You are not graded on writing code.** Have OpenClaw write all of it. You are
graded on getting three real services working together, keeping your keys
safe, and being able to explain what you built.

**Low stress by design.** The pipeline is fixed and small: one search, one
table, one page. All the creativity is in the topic you choose and how you
present it. A student who has kept up finishes this in an evening.

## One-time setup — get three free keys (no credit card)

Set each of these as a **Codespaces secret** (your repo → Settings → Secrets
and variables → Codespaces → New secret). Never paste a key into a file you
commit.

| Service | What it does | Where to get the key | Secret name(s) |
|---|---|---|---|
| **Tavily** | web search for your agent | tavily.com → Get API Key (1,000 free credits/mo) | `TAVILY_API_KEY` |
| **Supabase** | your database | supabase.com → New project → Project Settings → API | `SUPABASE_URL`, `SUPABASE_KEY` |
| **Netlify** | hosts your page | app.netlify.com → User settings → Applications → Personal access token | `NETLIFY_AUTH_TOKEN` |

> **Supabase note:** free projects **pause after 7 days of inactivity**. Keep
> yours active until this is graded, or the page will look broken.

## The workflow (pick → research → store → show → submit)

1. **Pick any topic you are curious about.** Your choice is the creative part:
   best taco spots in Norman, sci-fi movies coming out this fall, D1 pitchers
   to watch, anything Tavily can look up.

2. **Research it with Tavily.** Tell OpenClaw: *"install the Tavily client,
   read TAVILY_API_KEY from the environment, search for `<my topic>`, and
   return the top 5 results as title, one-line summary, and source URL."*

3. **Store it in Supabase.** Make **one** table (e.g. `finds` with columns
   `title`, `summary`, `link`, `fetched_at`). Tell OpenClaw: *"using
   SUPABASE_URL and SUPABASE_KEY from the environment, insert these results
   into my `finds` table."*

4. **Show it on Netlify.** Tell OpenClaw: *"build a small web page that reads
   my `finds` table from Supabase and lists each item with its link, then
   deploy it to Netlify with the Netlify CLI using NETLIFY_AUTH_TOKEN."* You
   will get a public `*.netlify.app` URL.

5. **Submit** on Canvas: your **live Netlify URL** + a **5-line delegation
   log** (which agent, one prompt that worked, one thing that broke and how
   you fixed it).

## Verify before you submit

Run `python3 shipday/check.py`. It confirms your three keys are present and
your Netlify URL returns real Tavily data that came through Supabase — the
same thing the grader checks. Fix anything it flags before submitting.

## Acceptance check

- Your **live Netlify URL loads** and lists **real Tavily results** that were
  read from **your Supabase table** (not hard-coded into the page).
- Your submission includes the **delegation log**.
- **No API keys are committed** to your repo — they live in Codespaces
  secrets / environment variables only.

**Rubric (15 pts).** Live page loads and shows real results served from
Supabase (7) · all three services wired correctly — Tavily → Supabase →
Netlify (4) · delegation log (2) · key hygiene: nothing secret committed (2).

**Optional stretch (no extra points, for the curious):** have the agent write
a one-sentence overall summary across your results, or add a second column you
can sort or filter by.

Pairing is encouraged; submissions are individual. Be ready to explain how the
data flows from search to page — "the AI did it and I don't know how" is the
one answer that costs points.
