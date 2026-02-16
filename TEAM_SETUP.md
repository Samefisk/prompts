# Team Setup: Shared `super-prompt.md` + Windows `,ct`

This setup gives your team a shared, always-latest prompt Markdown file and a Windows `,ct` shortcut.

## 1) Repo and prompt URL

Repo:
`https://github.com/Samefisk/prompts`

Raw prompt URL (latest on every push):
`https://raw.githubusercontent.com/Samefisk/prompts/main/super-prompt.md`

## 2) Your update workflow (so team always has latest)

Whenever you change `super.json`:

```bash
git -C /Users/christofferandersen/Documents/superwhisper/modes add super.json
git -C /Users/christofferandersen/Documents/superwhisper/modes commit -m "Update super prompt"
git -C /Users/christofferandersen/Documents/superwhisper/modes push
```

`super-prompt.md` is auto-generated from `super.json` by GitHub Actions after push.
Teammates do not need to pull git changes for prompt content if their script downloads from the raw URL each run.

## 3) Windows teammate install

### A. Install requirements
1. Install AutoHotkey v2: https://www.autohotkey.com/
2. Confirm PowerShell is available (default on Windows)

### B. Copy files to Windows machine
Copy both files from this repo:
- `windows/ct.ahk`
- `windows/ct.ps1`

Put both in the same folder, for example:
`C:\superwhisper\`

### C. Set environment variables in PowerShell
Open PowerShell and run (replace only API key):

```powershell
setx GEMINI_API_KEY "<YOUR_GEMINI_API_KEY>"
setx SUPER_PROMPT_URL "https://raw.githubusercontent.com/Samefisk/prompts/main/super-prompt.md"
setx GEMINI_MODEL "gemini-3-pro-preview"
setx GEMINI_THINKING_LEVEL "LOW"
```

Then close and reopen apps so env vars reload.

### D. Start the hotkey script
Double-click `ct.ahk`.

## 4) How `,ct` works

In any text input field:
1. Type `,ct`
2. Script sends Ctrl+A and Ctrl+C
3. Script downloads latest `super-prompt.md`
4. Script sends prompt + selected text to Gemini
5. Script pastes model response back into the field

## 5) Troubleshooting

- Error about API key:
  - Verify `GEMINI_API_KEY` was set and app was reopened.
- Error about prompt URL:
  - Open the raw URL in browser and confirm `super-prompt.md` loads.
- No replacement text:
  - Confirm there is text in the field before typing `,ct`.
- First run is slow:
  - Normal. It depends on network + model latency.

## 6) Optional hardening later

- Add prompt URL fallback/mirroring.
- Add local prompt caching (e.g., 5 minutes) to reduce HTTP calls.
- Move from per-user API key to a small shared backend.
