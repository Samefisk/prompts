# Team Setup: Shared `super.json` + Windows `,ct`

This setup gives your team a shared, always-latest `super.json` and a Windows `,ct` shortcut.

## 1) Publish this folder to GitHub (first time)

### A. Create a GitHub repo in browser
1. Go to https://github.com/new
2. Repository name: `superwhisper-modes` (or any name you want)
3. Visibility: Public
4. Do not add README/gitignore/license on GitHub for this first push
5. Click **Create repository**

### B. Run these commands in this folder
Open Terminal in:
`/Users/christofferandersen/Documents/superwhisper/modes`

Replace `<YOUR_GITHUB_USERNAME>` and `<YOUR_REPO_NAME>` first.

```bash
git init
git branch -M main
git add .
git commit -m "Initial team-sharing setup"
git remote add origin https://github.com/<YOUR_GITHUB_USERNAME>/<YOUR_REPO_NAME>.git
git push -u origin main
```

After that, your shared prompt URL is:

`https://raw.githubusercontent.com/<YOUR_GITHUB_USERNAME>/<YOUR_REPO_NAME>/main/super.json`

## 2) Your update workflow (so team always has latest)

Whenever you change `super.json`:

```bash
git add super.json
git commit -m "Update super prompt"
git push
```

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
Open PowerShell and run (replace values):

```powershell
setx OPENAI_API_KEY "<YOUR_OPENAI_API_KEY>"
setx SUPER_PROMPT_URL "https://raw.githubusercontent.com/<YOUR_GITHUB_USERNAME>/<YOUR_REPO_NAME>/main/super.json"
setx OPENAI_MODEL "gpt-4.1-mini"
```

Then close and reopen apps so env vars reload.

### D. Start the hotkey script
Double-click `ct.ahk`.

## 4) How `,ct` works

In any text input field:
1. Type `,ct`
2. Script sends Ctrl+A and Ctrl+C
3. Script downloads latest `super.json`
4. Script sends prompt + selected text to OpenAI
5. Script pastes model response back into the field

## 5) Troubleshooting

- Error about API key:
  - Verify `OPENAI_API_KEY` was set and app was reopened.
- Error about prompt URL:
  - Open `SUPER_PROMPT_URL` in browser and confirm `super.json` loads.
- No replacement text:
  - Confirm there is text in the field before typing `,ct`.
- First run is slow:
  - Normal. It depends on network + model latency.

## 6) Optional hardening later

- Add prompt URL fallback/mirroring.
- Add local prompt caching (e.g., 5 minutes) to reduce HTTP calls.
- Move from per-user API key to a small shared backend.
