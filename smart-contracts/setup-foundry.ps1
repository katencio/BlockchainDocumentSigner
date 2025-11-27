# Script para configurar Foundry en el PATH de Windows
# Ejecutar como: powershell -ExecutionPolicy Bypass -File setup-foundry.ps1

Write-Host "=== Configurando Foundry para este proyecto ===" -ForegroundColor Green
Write-Host ""

$foundryPath = "C:\Users\kelvi\.foundry\bin"

# Verificar que Foundry está instalado
if (-not (Test-Path "$foundryPath\forge.exe")) {
    Write-Host "❌ Error: Foundry no está instalado en $foundryPath" -ForegroundColor Red
    Write-Host "   Por favor, instala Foundry primero ejecutando: foundryup" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Foundry encontrado en: $foundryPath" -ForegroundColor Green

# Obtener el PATH actual del usuario
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")

# Verificar si ya está en el PATH
if ($currentPath -like "*$foundryPath*") {
    Write-Host "✅ Foundry ya está en el PATH del usuario" -ForegroundColor Green
} else {
    # Agregar al PATH
    $newPath = $currentPath + ";$foundryPath"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "✅ Foundry agregado al PATH del usuario" -ForegroundColor Green
    Write-Host "   ⚠️  Nota: Cierra y vuelve a abrir la terminal para que los cambios surtan efecto" -ForegroundColor Yellow
}

# Agregar al PATH de la sesión actual
$env:Path += ";$foundryPath"

Write-Host ""
Write-Host "=== Verificando instalación ===" -ForegroundColor Green

# Verificar que forge funciona
try {
    $forgeVersion = & "$foundryPath\forge.exe" --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Forge funciona correctamente" -ForegroundColor Green
        Write-Host "   Versión: $forgeVersion" -ForegroundColor Cyan
    } else {
        Write-Host "❌ Error al ejecutar forge" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Error: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== Próximos pasos ===" -ForegroundColor Green
Write-Host "1. Cierra y vuelve a abrir la terminal de Cursor" -ForegroundColor Yellow
Write-Host "2. Navega al directorio del proyecto:" -ForegroundColor Yellow
Write-Host "   cd smart-contracts" -ForegroundColor Cyan
Write-Host "3. Instala las dependencias:" -ForegroundColor Yellow
Write-Host "   forge install foundry-rs/forge-std" -ForegroundColor Cyan
Write-Host "4. Compila el contrato:" -ForegroundColor Yellow
Write-Host "   forge build" -ForegroundColor Cyan
Write-Host "5. Ejecuta los tests:" -ForegroundColor Yellow
Write-Host "   forge test -vvv" -ForegroundColor Cyan
Write-Host ""


