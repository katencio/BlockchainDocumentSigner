#!/bin/bash
# Script para desplegar el contrato y obtener la dirección

export PATH="$HOME/.foundry/bin:$PATH"
cd /mnt/c/Users/kelvi/OneDrive/Documentos/MasterBlockchain/proyectos-solidity-web/documentSignStorage/smart-contracts

export PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

echo "Desplegando contrato DocumentRegistry..."
echo ""

forge script scripts/deploy.s.sol:DeployScript \
    --rpc-url http://localhost:8545 \
    --broadcast \
    --private-key $PRIVATE_KEY \
    -vvv

echo ""
echo "=========================================="
echo "Busca la línea que dice: 'DocumentRegistry deployed at:'"
echo "Copia esa dirección y úsala en tu archivo .env.local"
echo "=========================================="

