param(
    [string]$Url = "https://huggingface.co/tiiuae/Falcon3-3B-Instruct-1.58bit-GGUF/resolve/main/ggml-model-i2_s.gguf",
    [string]$TargetFile = ".\models\Falcon3-3B-Instruct-1.58bit\ggml-model-i2_s.gguf"
)

$ErrorActionPreference = "Stop"

$Dir = Split-Path $TargetFile
New-Item -ItemType Directory -Force -Path $Dir | Out-Null

Write-Host "Starte Download..." -ForegroundColor Cyan
Write-Host $Url

# Fortschritt anzeigen
Invoke-WebRequest `
    -Uri $Url `
    -OutFile $TargetFile `
    -UseBasicParsing

if (-not (Test-Path $TargetFile)) {
    throw "Download fehlgeschlagen"
}

Write-Host ""
Write-Host "Download abgeschlossen: $TargetFile" -ForegroundColor Green