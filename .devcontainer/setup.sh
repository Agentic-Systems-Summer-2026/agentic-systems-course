#!/usr/bin/env bash
# postCreateCommand: install OpenClaw and configure it for the OU LiteLLM gateway.
# No onboarding wizard — the gateway + TUI auto-start when the Codespace opens.
#
# TRANSPARENCY: everything this script does is shown live in the Codespace
# creation log (Command Palette → "Codespaces: View Creation Log") AND saved
# to ~/.openclaw/setup.log so you can review it any time afterwards.
set -euo pipefail
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Mirror all output (stdout + stderr) to a persistent log.
mkdir -p "${HOME}/.openclaw"
SETUP_LOG="${HOME}/.openclaw/setup.log"
exec > >(tee -a "${SETUP_LOG}") 2>&1

step() {
  echo
  echo "─────────────────────────────────────────────────────────────"
  echo "  [$(date '+%H:%M:%S')] $*"
  echo "─────────────────────────────────────────────────────────────"
}

echo "═════════════════════════════════════════════════════════════"
echo "  OpenClaw Codespace setup — started $(date '+%Y-%m-%d %H:%M:%S %Z')"
echo "  Live log: this terminal   ·   Saved log: ~/.openclaw/setup.log"
echo "═════════════════════════════════════════════════════════════"

step "Step 1/6 — Install OpenClaw (official installer; can take a few minutes)"
bash "${REPO_DIR}/scripts/install-openclaw.sh" \
  || echo "!! OpenClaw install failed. Retry later with: bash .devcontainer/setup.sh" >&2

export PATH="${HOME}/.local/bin:${HOME}/.npm-global/bin:/usr/local/share/npm-global/bin:${PATH}"
echo "openclaw resolves to: $(command -v openclaw || echo '(not found yet — the Gateway task will retry the install)')"

step "Step 2/6 — Write OpenClaw config for OU LiteLLM (~/.openclaw/openclaw.json)"
bash "${REPO_DIR}/scripts/configure.sh" || true

step "Step 3/6 — Put 'openclaw' on PATH for future terminals (~/.bashrc)"
MARKER="# >>> openclaw-codespace path >>>"
if ! grep -qF "${MARKER}" "${HOME}/.bashrc" 2>/dev/null; then
  cat >> "${HOME}/.bashrc" <<EOF

${MARKER}
export PATH="\${HOME}/.local/bin:\${HOME}/.npm-global/bin:/usr/local/share/npm-global/bin:\${PATH}"
# <<< openclaw-codespace path <<<
EOF
  echo "PATH block added to ~/.bashrc."
else
  echo "PATH block already present — nothing to do."
fi

step "Step 4/6 — Python tooling (pytest for the BC4 eval gate; flask for demo UIs)"
(python3 -m pip --version >/dev/null 2>&1 || sudo apt-get update -qq && sudo apt-get install -y -qq python3-pip) || true
python3 -m pip install --user -q pytest flask 2>/dev/null || python3 -m pip install --user -q --break-system-packages pytest flask || true
echo "pytest: $(python3 -m pytest --version 2>/dev/null | head -1 || echo 'install failed — run: python3 -m pip install --user pytest')"

step "Step 5/6 — Course toolbelt (tunnels, JSON, recording, and friends)"
# Debian-packaged utilities (best-effort; nothing here is fatal):
#   jq        - JSON wrangling for traces & API responses
#   sqlite3   - local storage for retrieval/memory labs and agent state
#   tmux      - keep long-running agents alive across disconnects (BC3)
#   ripgrep   - fast search through logs and traces
#   httpie    - friendly HTTP client for poking APIs
#   asciinema - terminal recordings, an official demo-evidence format
#   tree/htop/entr - orientation, resource view, auto-rerun on change
sudo apt-get update -qq || true
sudo apt-get install -y -qq jq sqlite3 tmux ripgrep httpie asciinema tree htop entr 2>/dev/null || true

# cloudflared — quick tunnels to share your demo (Day 15, capstone):
#   cloudflared tunnel --url http://localhost:5000
if ! command -v cloudflared >/dev/null 2>&1; then
  curl -fsSL -o /tmp/cloudflared.deb \
    https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb \
    && sudo dpkg -i /tmp/cloudflared.deb >/dev/null 2>&1 && rm -f /tmp/cloudflared.deb || true
fi

# GitHub CLI — check your Actions eval runs from the terminal (gh run list):
if ! command -v gh >/dev/null 2>&1; then
  (sudo mkdir -p -m 755 /etc/apt/keyrings \
   && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
      | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null \
   && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
      | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null \
   && sudo apt-get update -qq && sudo apt-get install -y -qq gh) 2>/dev/null || true
fi

echo "toolbelt: $(for t in jq sqlite3 tmux rg http asciinema tree htop entr cloudflared gh; do command -v $t >/dev/null && printf '%s ' $t; done)"
echo "missing:  $(for t in jq sqlite3 tmux rg http asciinema tree htop entr cloudflared gh; do command -v $t >/dev/null || printf '%s ' $t; done)"

step "Step 6/6 — Model-picker keyboard shortcut (Ctrl/Cmd+Alt+M, best-effort)"
# USER-scoped, so only written when no keybindings.json exists yet (never clobbers yours).
SRC="${REPO_DIR}/.vscode/keybindings.sample.jsonc"
if [[ -f "${SRC}" ]]; then
  for D in "${HOME}/.vscode-remote/data/User" "${HOME}/.vscode-server/data/User" "${HOME}/.vscode-server-insiders/data/User"; do
    [[ -d "${D}" ]] || continue
    if [[ ! -e "${D}/keybindings.json" ]]; then
      cp "${SRC}" "${D}/keybindings.json" && echo "Installed model-picker shortcut (Ctrl/Cmd+Alt+M)."
    else
      echo "Existing keybindings.json found — shortcut not auto-added (see .vscode/keybindings.sample.jsonc)."
    fi
    break
  done
fi

echo
echo "═════════════════════════════════════════════════════════════"
echo "  [$(date '+%H:%M:%S')] Setup complete."
echo "  What happens next (automatic):"
echo "   • Gateway auto-starts in the background → log: ~/.openclaw/gateway.log"
echo "   • Two terminals open: 'OpenClaw: Gateway' (live log) + 'OpenClaw: TUI'"
echo "  Review this setup later:  cat ~/.openclaw/setup.log"
echo "═════════════════════════════════════════════════════════════"
