param(
  [string]$ConfigPath
)

$ErrorActionPreference = 'Stop'

$logFile = "$env:TEMP\ct_gemini_debug.log"
function Write-DebugLog {
  param([string]$message)
  Add-Content -Path $logFile -Value "[$(Get-Date -Format 'HH:mm:ss')] $message"
}

Write-DebugLog '========================================'
Write-DebugLog 'Script started.'

if ([string]::IsNullOrWhiteSpace($ConfigPath)) {
  $ConfigPath = Join-Path $PSScriptRoot 'ct-config.json'
}

$config = $null
if (Test-Path -LiteralPath $ConfigPath) {
  try {
    $configRaw = Get-Content -LiteralPath $ConfigPath -Raw
    $config = $configRaw | ConvertFrom-Json
  } catch {
    Write-Error "Config parse failed: $ConfigPath"
    Write-DebugLog "CRITICAL: Config parse failed: $ConfigPath"
    exit 1
  }
}

$apiKey = if ($null -ne $config) { $config.api_key } else { $null }
if ([string]::IsNullOrWhiteSpace($apiKey)) {
  $apiKey = $env:GEMINI_API_KEY
}
if ([string]::IsNullOrWhiteSpace($apiKey)) {
  $apiKey = $env:GOOGLE_API_KEY
}
if ([string]::IsNullOrWhiteSpace($apiKey)) {
  Write-Error 'Gemini API key missing. Run setup_ct.ahk or set GEMINI_API_KEY.'
  Write-DebugLog 'CRITICAL: API key empty.'
  exit 1
}

$promptUrl = if ($null -ne $config) { $config.prompt_url } else { $null }
if ([string]::IsNullOrWhiteSpace($promptUrl)) {
  $promptUrl = $env:SUPER_PROMPT_URL
}
if ([string]::IsNullOrWhiteSpace($promptUrl)) {
  $promptUrl = 'https://raw.githubusercontent.com/Samefisk/prompts/main/super-prompt.md'
}

$model = if ($null -ne $config) { $config.model } else { $null }
if ([string]::IsNullOrWhiteSpace($model)) {
  $model = $env:GEMINI_MODEL
}
if ([string]::IsNullOrWhiteSpace($model)) {
  $model = 'gemini-3-pro-preview'
}

$thinkingLevel = if ($null -ne $config) { $config.thinking_level } else { $null }
if ([string]::IsNullOrWhiteSpace($thinkingLevel)) {
  $thinkingLevel = $env:GEMINI_THINKING_LEVEL
}
if ([string]::IsNullOrWhiteSpace($thinkingLevel)) {
  $thinkingLevel = 'LOW'
} else {
  $thinkingLevel = $thinkingLevel.ToUpperInvariant()
}
if ($thinkingLevel -notin @('MINIMAL', 'LOW', 'MEDIUM', 'HIGH')) {
  $thinkingLevel = 'LOW'
}

$userText = Get-Clipboard -Raw
if ([string]::IsNullOrWhiteSpace($userText)) {
  Write-Error 'Clipboard is empty. Nothing to transform.'
  Write-DebugLog 'CRITICAL: Clipboard empty.'
  exit 1
}

$prompt = (Invoke-WebRequest -Uri $promptUrl -UseBasicParsing).Content
if ([string]::IsNullOrWhiteSpace($prompt)) {
  Write-Error "Prompt download failed from $promptUrl"
  Write-DebugLog "CRITICAL: Prompt download failed from $promptUrl"
  exit 1
}

$inputText = "$prompt`n`n### User Text`n$userText"
Write-DebugLog "Model: $model | Thinking: $thinkingLevel | Input chars: $($inputText.Length)"

$body = @{
  contents = @(
    @{
      parts = @(
        @{
          text = $inputText
        }
      )
    }
  )
  generationConfig = @{
    thinkingConfig = @{
      thinkingLevel = $thinkingLevel
      includeThoughts = $false
    }
  }
} | ConvertTo-Json -Depth 12

$uri = "https://generativelanguage.googleapis.com/v1beta/models/$model`:generateContent?key=$apiKey"
Write-DebugLog 'Sending request to Gemini...'
$response = Invoke-RestMethod -Uri $uri -Method Post -ContentType 'application/json' -Body $body

if ($null -ne $response.error -and -not [string]::IsNullOrWhiteSpace($response.error.message)) {
  Write-Error "Gemini API Error: $($response.error.message)"
  Write-DebugLog "API ERROR: $($response.error.message)"
  exit 1
}

$outputText = ''
if ($null -ne $response.candidates) {
  foreach ($candidate in $response.candidates) {
    if ($null -eq $candidate.content -or $null -eq $candidate.content.parts) {
      continue
    }
    foreach ($part in $candidate.content.parts) {
      if (-not [string]::IsNullOrWhiteSpace($part.text)) {
        $outputText += $part.text
      }
    }
    if (-not [string]::IsNullOrWhiteSpace($outputText)) {
      break
    }
  }
}

if ([string]::IsNullOrWhiteSpace($outputText)) {
  Write-Error 'Error: No text returned from Gemini.'
  Write-DebugLog 'CRITICAL: Empty Gemini response text.'
  exit 1
}

Set-Clipboard -Value $outputText
Write-DebugLog 'Success. Clipboard updated.'
exit 0
