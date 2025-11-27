#!/bin/bash
# Script para iniciar la aplicación en modo desarrollo

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

cd /mnt/c/Users/kelvi/OneDrive/Documentos/MasterBlockchain/proyectos-solidity-web/documentSignStorage/dapp

echo "Iniciando servidor de desarrollo Next.js..."
echo "La aplicación estará disponible en: http://localhost:3000"
echo ""

npm run dev

