$ErrorActionPreference = 'Stop'

$apiKey = $env:OPENAI_API_KEY
if ([string]::IsNullOrWhiteSpace($apiKey)) {
  Write-Error 'OPENAI_API_KEY is not set.'
  exit 1
}

$promptUrl = $env:SUPER_PROMPT_URL
if ([string]::IsNullOrWhiteSpace($promptUrl)) {
  # Replace this with your raw GitHub URL after publishing.
  $promptUrl = 'https://raw.githubusercontent.com/REPLACE_ME/REPLACE_ME/main/super.json'
}

$model = $env:OPENAI_MODEL
if ([string]::IsNullOrWhiteSpace($model)) {
  $model = 'gpt-4.1-mini'
}

$userText = Get-Clipboard -Raw
if ([string]::IsNullOrWhiteSpace($userText)) {
  Write-Error 'Clipboard is empty. Nothing to transform.'
  exit 1
}

$prompt = (Invoke-WebRequest -Uri $promptUrl -UseBasicParsing).Content
if ([string]::IsNullOrWhiteSpace($prompt)) {
  Write-Error "Prompt download failed from $promptUrl"
  exit 1
}

$inputText = "$prompt`n`n### User Text`n$userText"

$body = @{
  model = $model
  input = $inputText
} | ConvertTo-Json -Depth 10

$headers = @{ Authorization = "Bearer $apiKey" }
$response = Invoke-RestMethod -Uri 'https://api.openai.com/v1/responses' -Method Post -Headers $headers -ContentType 'application/json' -Body $body

$outputText = $response.output_text
if ([string]::IsNullOrWhiteSpace($outputText)) {
  $outputText = ''
  foreach ($item in $response.output) {
    foreach ($content in $item.content) {
      if ($content.type -eq 'output_text' -and -not [string]::IsNullOrWhiteSpace($content.text)) {
        $outputText += $content.text
      }
    }
  }
}

if ([string]::IsNullOrWhiteSpace($outputText)) {
  Write-Error 'Model returned no output text.'
  exit 1
}

Set-Clipboard -Value $outputText
exit 0
