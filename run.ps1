param(
    [string]$BaseDir = (Get-Location).Path,
    [string]$ModelDir = "",
    [string]$ImageName = "cpp-assistant",
    [int]$Port = 9090,
    [int]$Threads = 8,
    [string]$QuantType = "i2_s"
)

$ErrorActionPreference = "Stop"

$BaseDir = [System.IO.Path]::GetFullPath($BaseDir)
$ModelsPath = Join-Path $BaseDir "models"
$WorkspacePath = Join-Path $BaseDir "workspace"

if (-not (Test-Path $ModelsPath)) {
    New-Item -ItemType Directory -Path $ModelsPath -Force | Out-Null
}

if (-not (Test-Path $WorkspacePath)) {
    New-Item -ItemType Directory -Path $WorkspacePath -Force | Out-Null
}

if ([string]::IsNullOrWhiteSpace($ModelDir)) {
    $candidate = Join-Path $ModelsPath "Falcon3-3B-Instruct-1.58bit"
    if (Test-Path $candidate) {
        $ModelDir = "/models/Falcon3-3B-Instruct-1.58bit"
    } else {
        throw "Kein Modellordner gefunden. Erwartet wurde: $candidate"
    }
} else {
    $leaf = Split-Path $ModelDir -Leaf
    $ModelDir = "/models/$leaf"
}

Write-Host "BaseDir:    $BaseDir" -ForegroundColor Cyan
Write-Host "Models:     $ModelsPath" -ForegroundColor Cyan
Write-Host "Workspace:  $WorkspacePath" -ForegroundColor Cyan
Write-Host "ModelDir:   $ModelDir" -ForegroundColor Cyan
Write-Host "Port:       $Port" -ForegroundColor Cyan
Write-Host "Threads:    $Threads" -ForegroundColor Cyan
Write-Host ""

podman run --rm -it `
  -p 127.0.0.1:${Port}:9090 `
  --mount type=bind,src="${ModelsPath}",dst=/models `
  --mount type=bind,src="${WorkspacePath}",dst=/workspace `
  -e MODEL_DIR="${ModelDir}" `
  -e QUANT_TYPE="${QuantType}" `
  -e THREADS="${Threads}" `
  -e CC=clang `
  -e CXX=clang++ `
  $ImageName