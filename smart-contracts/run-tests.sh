#!/bin/bash
# Script para ejecutar tests del contrato DocumentRegistry
# Uso: ./run-tests.sh

echo "=========================================="
echo "  Testing DocumentRegistry Contract"
echo "=========================================="
echo ""

# Verificar que estamos en el directorio correcto
if [ ! -f "foundry.toml" ]; then
    echo "❌ Error: foundry.toml no encontrado"
    echo "   Asegúrate de estar en el directorio smart-contracts"
    exit 1
fi

# Verificar que forge está instalado
if ! command -v forge &> /dev/null; then
    echo "❌ Error: forge no está instalado"
    echo "   Ejecuta: foundryup"
    exit 1
fi

echo "✅ Foundry encontrado: $(forge --version)"
echo ""

# Compilar
echo "📦 Compilando contrato..."
if forge build; then
    echo "✅ Compilación exitosa"
    echo ""
else
    echo "❌ Error en la compilación"
    exit 1
fi

# Ejecutar tests
echo "🧪 Ejecutando tests..."
echo ""
forge test -vvv

echo ""
echo "=========================================="
echo "  Tests completados"
echo "=========================================="

