#!/bin/bash
# Script para ejecutar tests desde WSL Ubuntu
# Uso: wsl -d Ubuntu bash test-wsl.sh

# Configurar PATH
export PATH="$HOME/.foundry/bin:$PATH"

# Navegar al directorio del proyecto
cd /mnt/c/Users/kelvi/OneDrive/Documentos/MasterBlockchain/proyectos-solidity-web/documentSignStorage/smart-contracts

# Ejecutar comandos según el argumento
case "$1" in
    build)
        echo "🔨 Compilando contrato..."
        forge build
        ;;
    test)
        echo "🧪 Ejecutando tests..."
        forge test -vvv
        ;;
    test-gas)
        echo "🧪 Ejecutando tests con reporte de gas..."
        forge test --gas-report
        ;;
    clean)
        echo "🧹 Limpiando archivos compilados..."
        forge clean
        ;;
    *)
        echo "Uso: $0 {build|test|test-gas|clean}"
        echo ""
        echo "Comandos disponibles:"
        echo "  build     - Compilar el contrato"
        echo "  test      - Ejecutar tests con detalles"
        echo "  test-gas  - Ejecutar tests con reporte de gas"
        echo "  clean     - Limpiar archivos compilados"
        exit 1
        ;;
esac

