# Script para agregar Foundry al PATH de Windows
# Ejecutar como Administrador o para el usuario actual

$foundryPath = "C:\Users\kelvi\.foundry\bin"
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")

# Verificar si ya está en el PATH
if ($currentPath -notlike "*$foundryPath*") {
    $newPath = $currentPath + ";" + $foundryPath
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "✅ Foundry agregado al PATH de Windows" -ForegroundColor Green
    Write-Host "⚠️  Cierra y vuelve a abrir PowerShell para que los cambios surtan efecto" -ForegroundColor Yellow
} else {
    Write-Host "✅ Foundry ya está en el PATH" -ForegroundColor Green
}

Write-Host "`nPara verificar, ejecuta en una nueva ventana de PowerShell:" -ForegroundColor Cyan
Write-Host "  forge --version" -ForegroundColor White

