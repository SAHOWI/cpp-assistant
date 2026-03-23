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

Write-Host "Installiere/aktualisiere huggingface_hub mit CLI ..." -ForegroundColor Yellow
& $PythonCmd -m pip install --upgrade "huggingface_hub[cli]"

if (-not $SkipLogin) {
    Write-Host ""
    Write-Host "Falls das Modell Authentifizierung braucht, bitte jetzt anmelden." -ForegroundColor Yellow
    & $PythonCmd -m huggingface_hub.commands.huggingface_cli login
}

New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null

Write-Host ""
Write-Host "Lade GGUF-Datei ..." -ForegroundColor Cyan

& $PythonCmd -m huggingface_hub.commands.huggingface_cli download `
    $RepoId `
    ggml-model-i2_s.gguf `
    --repo-type model `
    --revision $Revision `
    --local-dir $TargetDir

$Expected = Join-Path $TargetDir "ggml-model-i2_s.gguf"
if (-not (Test-Path $Expected)) {
    throw "Download fehlgeschlagen: $Expected wurde nicht gefunden."
}

Write-Host ""
Write-Host "Download abgeschlossen: $Expected" -ForegroundColor Green