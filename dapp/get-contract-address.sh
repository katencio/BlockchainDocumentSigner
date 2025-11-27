#!/bin/bash
# Script para desplegar el contrato y extraer la dirección

export PATH="$HOME/.foundry/bin:$PATH"
cd /mnt/c/Users/kelvi/OneDrive/Documentos/MasterBlockchain/proyectos-solidity-web/documentSignStorage/smart-contracts

export PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

echo "Desplegando contrato DocumentRegistry..."
echo ""

# Ejecutar el despliegue y capturar la salida
OUTPUT=$(forge script scripts/deploy.s.sol:DeployScript \
    --rpc-url http://localhost:8545 \
    --broadcast \
    --private-key $PRIVATE_KEY 2>&1)

# Mostrar toda la salida
echo "$OUTPUT"
echo ""

# Extraer la dirección del contrato
CONTRACT_ADDRESS=$(echo "$OUTPUT" | grep -i "DocumentRegistry deployed at:" | grep -oE '0x[a-fA-F0-9]{40}' | head -1)

if [ -z "$CONTRACT_ADDRESS" ]; then
    # Intentar otro patrón
    CONTRACT_ADDRESS=$(echo "$OUTPUT" | grep -oE '0x[a-fA-F0-9]{40}' | tail -1)
fi

if [ -n "$CONTRACT_ADDRESS" ]; then
    echo "=========================================="
    echo "✅ Dirección del contrato encontrada:"
    echo "$CONTRACT_ADDRESS"
    echo "=========================================="
    echo ""
    echo "Copia esta dirección y úsala en tu archivo .env.local:"
    echo "NEXT_PUBLIC_CONTRACT_ADDRESS=$CONTRACT_ADDRESS"
    echo ""
else
    echo "⚠️  No se pudo extraer la dirección automáticamente."
    echo "Busca manualmente en la salida la línea que dice 'DocumentRegistry deployed at:'"
fi

