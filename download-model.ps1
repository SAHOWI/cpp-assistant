param(
    [string]$RepoId = "tiiuae/Falcon3-3B-Instruct-1.58bit-GGUF",
    [string]$TargetDir = ".\models\Falcon3-3B-Instruct-1.58bit",
    [string]$Filename = "ggml-model-i2_s.gguf",
    [string]$Revision = "main",
    [switch]$SkipLogin
)

$ErrorActionPreference = "Stop"

function Test-Command($Name) {
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

if (Test-Command py) {
    $PythonCmd = "py"
}
elseif (Test-Command python) {
    $PythonCmd = "python"
}
else {
    throw "Python ist nicht installiert oder nicht im PATH."
}

Write-Host "== Hugging Face Modell-Download ==" -ForegroundColor Cyan
Write-Host "Repo:       $RepoId"
Write-Host "Datei:      $Filename"
Write-Host "Zielordner: $TargetDir"
Write-Host ""

& $PythonCmd -m pip install --upgrade huggingface_hub
if ($LASTEXITCODE -ne 0) {
    throw "Installation von huggingface_hub ist fehlgeschlagen."
}

if (-not $SkipLogin) {
    Write-Host "Anmeldung bei Hugging Face..." -ForegroundColor Yellow
    & $PythonCmd -c "from huggingface_hub import login; login()"
    if ($LASTEXITCODE -ne 0) {
        throw "Hugging-Face-Login ist fehlgeschlagen."
    }
}

New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null

$TempPy = Join-Path $env:TEMP "hf_download_model.py"

$PyScript = @'
from pathlib import Path
import shutil
from huggingface_hub import hf_hub_download

repo_id = "tiiuae/Falcon3-3B-Instruct-1.58bit-GGUF"
filename = "ggml-model-i2_s.gguf"
revision = "main"
target_dir = Path(r".\models\Falcon3-3B-Instruct-1.58bit")

target_dir.mkdir(parents=True, exist_ok=True)

downloaded = hf_hub_download(
    repo_id=repo_id,
    filename=filename,
    revision=revision,
    repo_type="model"
)

src = Path(downloaded)
dst = target_dir / filename
shutil.copy2(src, dst)

print(dst)
'@

$PyScript = $PyScript.Replace('tiiuae/Falcon3-3B-Instruct-1.58bit-GGUF', $RepoId)
$PyScript = $PyScript.Replace('ggml-model-i2_s.gguf', $Filename)
$PyScript = $PyScript.Replace('main', $Revision)
$PyScript = $PyScript.Replace('.\models\Falcon3-3B-Instruct-1.58bit', $TargetDir)

Set-Content -Path $TempPy -Value $PyScript -Encoding UTF8

& $PythonCmd $TempPy
if ($LASTEXITCODE -ne 0) {
    Remove-Item $TempPy -ErrorAction SilentlyContinue
    throw "Der Download ist fehlgeschlagen."
}

Remove-Item $TempPy -ErrorAction SilentlyContinue

$Expected = Join-Path $TargetDir $Filename
if (-not (Test-Path $Expected)) {
    throw "Download fehlgeschlagen: $Expected wurde nicht gefunden."
}

Write-Host ""
Write-Host "Download abgeschlossen: $Expected" -ForegroundColor Green