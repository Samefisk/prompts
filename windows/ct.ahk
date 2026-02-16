#Requires AutoHotkey v2.0

; Type ,ct to transform the current text field contents.
; Flow: Ctrl+A -> Ctrl+C -> run PowerShell script -> Ctrl+V
::,ct::
{
    configPath := A_ScriptDir . '\ct-config.json'
    if !FileExist(configPath) {
        MsgBox 'Setup required. Run setup_ct.ahk once before using ,ct.'
        return
    }

    Send '^a'
    Sleep 100
    Send '^c'
    if !ClipWait(1) {
        MsgBox 'Copy failed. Could not read selected text.'
        return
    }

    psScript := A_ScriptDir . '\ct.ps1'
    cmd := 'powershell.exe -NoProfile -ExecutionPolicy Bypass -File "' . psScript . '" -ConfigPath "' . configPath . '"'
    RunWait cmd, , 'Hide'

    if (ErrorLevel != 0) {
        MsgBox 'Transform failed. Check setup_ct.ahk config and internet connection, then retry.'
        return
    }

    Send '^v'
}
