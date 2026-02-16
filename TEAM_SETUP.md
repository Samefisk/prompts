# Team Setup: No-Terminal Windows Onboarding (`super-prompt.md` + `,ct`)

This setup avoids terminal use for teammates.
They only install AutoHotkey, download files, run one setup script, and use `,ct`.

## 1) Team links

Repo:
`https://github.com/Samefisk/prompts`

Raw prompt URL (always latest):
`https://raw.githubusercontent.com/Samefisk/prompts/main/super-prompt.md`

## 2) Your maintainer workflow

When you update `super.json`, push to `main`.
`super-prompt.md` is auto-generated from `super.json` by GitHub Actions.

## 3) Teammate onboarding (no terminal)

### A. Install AutoHotkey
1. Go to https://www.autohotkey.com/
2. Install AutoHotkey v2

### B. Download the package
1. Open `https://github.com/Samefisk/prompts`
2. Click **Code** -> **Download ZIP**
3. Extract ZIP
4. Open the `windows` folder

### C. Run one-time setup wizard
1. Double-click `setup_ct.ahk`
2. Paste Gemini API key when prompted
3. Press OK on defaults unless you want custom values

This creates `ct-config.json` in the same folder.

### D. Start the hotkey
1. Double-click `ct.ahk`
2. In any text field, type `,ct`

## 4) What `,ct` does

1. Selects all text (`Ctrl+A`) and copies (`Ctrl+C`)
2. Downloads latest `super-prompt.md`
3. Sends prompt + text to Gemini (`gemini-3-pro-preview`, thinking `LOW` by default)
4. Pastes result into the same field

## 5) Troubleshooting

- `Setup required` message:
  - Run `setup_ct.ahk` first.
- Transform failed:
  - Re-run `setup_ct.ahk` and verify API key.
- Prompt URL issue:
  - Open `https://raw.githubusercontent.com/Samefisk/prompts/main/super-prompt.md` in browser.
- Need logs:
  - Check `%TEMP%\ct_gemini_debug.log` on Windows.

## 6) Optional polish for teammates

- Put `ct.ahk` in Windows Startup folder for auto-launch on login.
- Keep all three files together:
  - `ct.ahk`
  - `ct.ps1`
  - `setup_ct.ahk`
