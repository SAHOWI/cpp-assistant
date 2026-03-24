param(
    [string]$BaseDir = (Get-Location).Path,
    [string]$ImageName = "cpp-assistant",
    [int]$Port = 9090,
    [int]$Threads = 4,
    [string]$QuantType = "i2_s"
)

$ErrorActionPreference = "Stop"

$BaseDir = [System.IO.Path]::GetFullPath($BaseDir)
$ModelsPath = Join-Path $BaseDir "models"
$WorkspacePath = Join-Path $BaseDir "workspace"
$ModelFolder = Join-Path $ModelsPath "Falcon3-3B-Instruct-1.58bit"

New-Item -ItemType Directory -Path $ModelsPath -Force | Out-Null
New-Item -ItemType Directory -Path $WorkspacePath -Force | Out-Null

if (-not (Test-Path $ModelFolder)) {
    throw "Modellordner fehlt: $ModelFolder"
}

Write-Host "BaseDir:    $BaseDir"
Write-Host "Models:     $ModelsPath"
Write-Host "Workspace:  $WorkspacePath"
Write-Host "ModelDir:   /models/Falcon3-3B-Instruct-1.58bit"
Write-Host ""

podman run --rm -it `
  -p 127.0.0.1:${Port}:9090 `
  --mount type=bind,src="${ModelsPath}",dst=/models `
  --mount type=bind,src="${WorkspacePath}",dst=/workspace `
  -e MODEL_DIR="/models/Falcon3-3B-Instruct-1.58bit" `
  -e QUANT_TYPE="${QuantType}" `
  -e THREADS="${Threads}" `
  -e CC=clang `
  -e CXX=clang++ `
  $ImageName