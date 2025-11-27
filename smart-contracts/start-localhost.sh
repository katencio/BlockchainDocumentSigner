#!/bin/bash
# Script completo: Inicia Anvil y despliega el contrato
# Uso: wsl -d Ubuntu bash start-localhost.sh

# Configurar PATH
export PATH="$HOME/.foundry/bin:$PATH"

# Navegar al directorio del proyecto
cd /mnt/c/Users/kelvi/OneDrive/Documentos/MasterBlockchain/proyectos-solidity-web/documentSignStorage/smart-contracts

echo "🚀 Iniciando Anvil en localhost:8545..."
echo ""

# Iniciar Anvil en background
~/.foundry/bin/anvil --host 0.0.0.0 --port 8545 > /tmp/anvil.log 2>&1 &
ANVIL_PID=$!

# Esperar a que Anvil esté listo
echo "⏳ Esperando a que Anvil esté listo..."
sleep 3

# Verificar que Anvil está corriendo
if ! curl -s http://localhost:8545 > /dev/null 2>&1; then
    echo "❌ Error: No se pudo conectar a Anvil"
    kill $ANVIL_PID 2>/dev/null
    exit 1
fi

echo "✅ Anvil corriendo en localhost:8545 (PID: $ANVIL_PID)"
echo ""

# Clave privada por defecto de Anvil
export PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

echo "📦 Desplegando DocumentRegistry..."
echo ""

# Desplegar el contrato
~/.foundry/bin/forge script scripts/deploy.s.sol:DeployScript \
    --rpc-url http://localhost:8545 \
    --broadcast \
    --private-key $PRIVATE_KEY

echo ""
echo "✅ Contrato desplegado!"
echo ""
echo "📍 Información de conexión:"
echo "   RPC URL: http://localhost:8545"
echo "   Chain ID: 31337"
echo ""
echo "🛑 Para detener Anvil, ejecuta:"
echo "   kill $ANVIL_PID"
echo "   o busca el proceso: ps aux | grep anvil"
echo ""


