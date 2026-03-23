param(
    [string]$RepoId = "tiiuae/Falcon3-3B-Instruct-1.58bit-GGUF",
    [string]$TargetDir = ".\models\Falcon3-3B-Instruct-1.58bit",
    [string]$Revision = "main",
    [switch]$SkipLogin
)

$ErrorActionPreference = "Stop"

function Test-Command($Name) {
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

Write-Host "== Hugging Face Modell-Download ==" -ForegroundColor Cyan
Write-Host "Repo:       $RepoId"
Write-Host "Zielordner: $TargetDir"
Write-Host ""

if (Test-Command py) {
    $PythonCmd = "py"
}
elseif (Test-Command python) {
    $PythonCmd = "python"
}
else {
    throw "Python ist nicht installiert oder nicht im PATH."
}

# huggingface_hub installieren/aktualisieren
& $PythonCmd -m pip install --upgrade huggingface_hub

# prüfen, ob hf im PATH ist
if (-not (Test-Command hf)) {
    throw @"
Die 'hf'-CLI wurde nach der Installation nicht im PATH gefunden.

Bitte öffne eine neue PowerShell und teste:
  hf --help

Alternativ installiere die CLI wie von Hugging Face empfohlen:
  powershell -ExecutionPolicy ByPass -c "irm https://hf.co/cli/install.ps1 | iex"
"@
}

if (-not $SkipLogin) {
    Write-Host "Starte Hugging-Face-Login ..." -ForegroundColor Yellow
    & hf auth login
    if ($LASTEXITCODE -ne 0) {
        throw "hf auth login ist fehlgeschlagen."
    }
}

New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null

Write-Host "Lade GGUF-Datei ..." -ForegroundColor Cyan

& hf download `
    $RepoId `
    ggml-model-i2_s.gguf `
    --repo-type model `
    --revision $Revision `
    --local-dir $TargetDir

if ($LASTEXITCODE -ne 0) {
    throw "hf download ist fehlgeschlagen."
}

$Expected = Join-Path $TargetDir "ggml-model-i2_s.gguf"
if (-not (Test-Path $Expected)) {
    throw "Download fehlgeschlagen: $Expected wurde nicht gefunden."
}

Write-Host ""
Write-Host "Download abgeschlossen: $Expected" -ForegroundColor Green