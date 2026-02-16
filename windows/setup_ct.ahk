#Requires AutoHotkey v2.0

defaultPromptUrl := 'https://raw.githubusercontent.com/Samefisk/prompts/main/super-prompt.md'
defaultModel := 'gemini-3-pro-preview'
defaultThinking := 'LOW'
configPath := A_ScriptDir . '\ct-config.json'

apiKey := PromptRequired('Gemini API Key', 'Paste your Gemini API key:', '')
if (apiKey = '') {
    ExitApp
}

promptUrl := PromptOptional('Prompt URL', 'Prompt URL (press OK for default):', defaultPromptUrl)
if (promptUrl = '') {
    ExitApp
}

model := PromptOptional('Gemini Model', 'Model (press OK for default):', defaultModel)
if (model = '') {
    ExitApp
}

thinking := PromptOptional('Reasoning', 'Thinking level MINIMAL/LOW/MEDIUM/HIGH (default LOW):', defaultThinking)
if (thinking = '') {
    ExitApp
}
thinkingUpper := StrUpper(Trim(thinking))
if !(thinkingUpper = 'MINIMAL' || thinkingUpper = 'LOW' || thinkingUpper = 'MEDIUM' || thinkingUpper = 'HIGH') {
    thinkingUpper := 'LOW'
}

json := '{`n'
json .= '  "api_key": "' . JsonEscape(apiKey) . '",`n'
json .= '  "prompt_url": "' . JsonEscape(Trim(promptUrl)) . '",`n'
json .= '  "model": "' . JsonEscape(Trim(model)) . '",`n'
json .= '  "thinking_level": "' . JsonEscape(thinkingUpper) . '"`n'
json .= '}`n'

if FileExist(configPath) {
    FileDelete configPath
}
FileAppend json, configPath, 'UTF-8-RAW'

MsgBox 'Setup complete. Config saved to:`n' . configPath . '`n`nNow run ct.ahk and type ,ct in any text field.'

PromptRequired(title, prompt, defaultValue) {
    loop {
        ib := InputBox(prompt, title, '', defaultValue)
        if (ib.Result = 'Cancel') {
            return ''
        }
        value := Trim(ib.Value)
        if (value != '') {
            return value
        }
        MsgBox 'This field is required.'
    }
}

PromptOptional(title, prompt, defaultValue) {
    ib := InputBox(prompt, title, '', defaultValue)
    if (ib.Result = 'Cancel') {
        return ''
    }
    value := Trim(ib.Value)
    if (value = '') {
        return defaultValue
    }
    return value
}

JsonEscape(value) {
    escaped := StrReplace(value, '\\', '\\\\')
    escaped := StrReplace(escaped, '"', '\"')
    escaped := StrReplace(escaped, '`r', '\r')
    escaped := StrReplace(escaped, '`n', '\n')
    return escaped
}
