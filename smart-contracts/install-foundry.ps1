# Script de instalación de Foundry para Windows
# Ejecutar en PowerShell como Administrador

Write-Host "Instalando Foundry (Forge)..." -ForegroundColor Green

# Método 1: Usando foundryup (requiere Git Bash o WSL)
Write-Host "`n=== Opción 1: Instalación con foundryup (Recomendado) ===" -ForegroundColor Yellow
Write-Host "Si tienes Git Bash instalado, ejecuta en Git Bash:" -ForegroundColor Cyan
Write-Host "  curl -L https://foundry.paradigm.xyz | bash" -ForegroundColor White
Write-Host "  foundryup" -ForegroundColor White

# Método 2: Descargar binarios directamente
Write-Host "`n=== Opción 2: Descarga manual de binarios ===" -ForegroundColor Yellow
Write-Host "1. Ve a: https://github.com/foundry-rs/foundry/releases" -ForegroundColor Cyan
Write-Host "2. Descarga: foundry_nightly_x86_64-pc-windows-msvc.zip" -ForegroundColor Cyan
Write-Host "3. Extrae el archivo" -ForegroundColor Cyan
Write-Host "4. Agrega la carpeta al PATH del sistema" -ForegroundColor Cyan

# Método 3: Usando cargo (si tienes Rust instalado)
Write-Host "`n=== Opción 3: Instalación con Cargo (si tienes Rust) ===" -ForegroundColor Yellow
Write-Host "  cargo install --git https://github.com/foundry-rs/foundry foundry-cli anvil --bins --locked" -ForegroundColor White

Write-Host "`n=== Verificación ===" -ForegroundColor Yellow
Write-Host "Después de instalar, verifica con:" -ForegroundColor Cyan
Write-Host "  forge --version" -ForegroundColor White
Write-Host "  cast --version" -ForegroundColor White
Write-Host "  anvil --version" -ForegroundColor White


