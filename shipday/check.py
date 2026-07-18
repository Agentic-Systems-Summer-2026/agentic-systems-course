#!/usr/bin/env python3
"""Ship Day self-check — no tokens spent, no data written.

Confirms your three services are set up, and (if you pass your Netlify URL)
that the live page is actually serving Tavily results through Supabase.

Usage:
    python3 shipday/check.py                       # check keys/config only
    python3 shipday/check.py https://you.netlify.app   # also check the live page
"""
import os
import sys
import urllib.request

REQUIRED = ["TAVILY_API_KEY", "SUPABASE_URL", "SUPABASE_KEY", "NETLIFY_AUTH_TOKEN"]


def check_keys() -> bool:
    ok = True
    for name in REQUIRED:
        val = os.environ.get(name, "").strip()
        if not val:
            print(f"  FAIL  {name} is not set (add it as a Codespaces secret)")
            ok = False
        else:
            print(f"  PASS  {name} is set")
    if os.environ.get("SUPABASE_URL", "").startswith("http"):
        print("  PASS  SUPABASE_URL looks like a URL")
    elif os.environ.get("SUPABASE_URL"):
        print("  WARN  SUPABASE_URL should start with https://")
    return ok


def check_page(url: str) -> bool:
    try:
        with urllib.request.urlopen(url, timeout=15) as r:
            body = r.read().decode("utf-8", "ignore")
    except Exception as e:  # noqa: BLE001
        print(f"  FAIL  could not load {url}: {e}")
        return False
    if r.status != 200:
        print(f"  FAIL  {url} returned HTTP {r.status}")
        return False
    if len(body) < 200:
        print("  WARN  page loaded but looks empty — is it reading from Supabase?")
        return False
    print(f"  PASS  {url} loads ({len(body)} bytes)")
    print("  NOTE  eyeball it: do you see your real Tavily results with links?")
    return True


def main() -> int:
    print("Ship Day check\n--------------")
    keys_ok = check_keys()
    page_ok = True
    if len(sys.argv) > 1:
        print()
        page_ok = check_page(sys.argv[1])
    else:
        print("\n  (pass your Netlify URL to also check the live page)")
    print()
    if keys_ok and page_ok:
        print("All checks passed. Submit your Netlify URL + delegation log.")
        return 0
    print("Some checks failed — fix the items above, then re-run.")
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
