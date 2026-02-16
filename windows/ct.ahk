#Requires AutoHotkey v2.0

; Type ,ct to transform the current text field contents.
; Flow: Ctrl+A -> Ctrl+C -> run PowerShell script -> Ctrl+V
::,ct::
{
    Send '^a'
    Sleep 100
    Send '^c'
    if !ClipWait(1) {
        MsgBox 'Copy failed. Could not read selected text.'
        return
    }

    psScript := A_ScriptDir . '\\ct.ps1'
    cmd := 'powershell.exe -NoProfile -ExecutionPolicy Bypass -File "' . psScript . '"'
    RunWait cmd, , 'Hide'

    if (ErrorLevel != 0) {
        MsgBox 'Transform failed. Check GEMINI_API_KEY and SUPER_PROMPT_URL, then retry.'
        return
    }

    Send '^v'
}
