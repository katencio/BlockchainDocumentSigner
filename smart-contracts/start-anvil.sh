#!/bin/bash
# Script para iniciar Anvil (blockchain local) en localhost:8545
# Uso: wsl -d Ubuntu bash start-anvil.sh

# Configurar PATH
export PATH="$HOME/.foundry/bin:$PATH"

echo "🚀 Iniciando Anvil en localhost:8545..."
echo ""
echo "Anvil proporcionará:"
echo "  - RPC URL: http://localhost:8545"
echo "  - 10 cuentas con fondos para testing"
echo "  - Chain ID: 31337"
echo ""
echo "Presiona Ctrl+C para detener Anvil"
echo ""

# Iniciar Anvil
~/.foundry/bin/anvil --host 0.0.0.0 --port 8545


