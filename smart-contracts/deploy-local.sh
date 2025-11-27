#!/bin/bash
# Script para desplegar el contrato en Anvil local
# Uso: wsl -d Ubuntu bash deploy-local.sh

# Configurar PATH
export PATH="$HOME/.foundry/bin:$PATH"

# Navegar al directorio del proyecto
cd /mnt/c/Users/kelvi/OneDrive/Documentos/MasterBlockchain/proyectos-solidity-web/documentSignStorage/smart-contracts

# Verificar que Anvil está corriendo
if ! curl -s http://localhost:8545 > /dev/null 2>&1; then
    echo "❌ Error: Anvil no está corriendo en localhost:8545"
    echo "   Por favor, inicia Anvil primero:"
    echo "   wsl -d Ubuntu bash start-anvil.sh"
    exit 1
fi

echo "✅ Anvil detectado en localhost:8545"
echo ""

# Usar la primera cuenta de Anvil (ya tiene fondos)
# La clave privada por defecto de Anvil es: 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
export PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

echo "📦 Desplegando DocumentRegistry..."
echo ""

# Desplegar el contrato
~/.foundry/bin/forge script scripts/deploy.s.sol:DeployScript \
    --rpc-url http://localhost:8545 \
    --broadcast \
    --private-key $PRIVATE_KEY

echo ""
echo "✅ Contrato desplegado exitosamente!"
echo ""
echo "Puedes interactuar con el contrato usando:"
echo "  - Remix IDE: Conecta a http://localhost:8545"
echo "  - Hardhat/ethers.js desde tu frontend"
echo "  - cast (CLI de Foundry)"


