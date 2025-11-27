# Guía de Configuración Rápida

## Pasos para Ejecutar la dApp

### 1. Verificar que Anvil esté corriendo

```bash
# Desde WSL Ubuntu
wsl -d Ubuntu bash -c "curl http://localhost:8545"
```

Si no está corriendo, inícialo:

```bash
wsl -d Ubuntu bash -c "export PATH=\$HOME/.foundry/bin:\$PATH && ~/.foundry/bin/anvil --host 0.0.0.0 --port 8545"
```

### 2. Desplegar el Contrato (si aún no está desplegado)

```bash
# Desde WSL Ubuntu
wsl -d Ubuntu bash -c "export PATH=\$HOME/.foundry/bin:\$PATH && cd /mnt/c/Users/kelvi/OneDrive/Documentos/MasterBlockchain/proyectos-solidity-web/documentSignStorage/smart-contracts && export PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 && forge script scripts/deploy.s.sol:DeployScript --rpc-url http://localhost:8545 --broadcast --private-key \$PRIVATE_KEY"
```

**IMPORTANTE**: Copia la dirección del contrato que aparece después del despliegue.

### 3. Crear archivo `.env.local`

Crea el archivo `.env.local` en la carpeta `dapp` con el siguiente contenido:

```env
NEXT_PUBLIC_CONTRACT_ADDRESS=<DIRECCION_DEL_CONTRATO_AQUI>
NEXT_PUBLIC_RPC_URL=http://localhost:8545
NEXT_PUBLIC_CHAIN_ID=31337
NEXT_PUBLIC_MNEMONIC="test test test test test test test test test test test junk"
```

**Reemplaza** `<DIRECCION_DEL_CONTRATO_AQUI>` con la dirección real del contrato desplegado.

### 4. Iniciar la aplicación

```bash
# Desde WSL Ubuntu
wsl -d Ubuntu bash -c "cd /mnt/c/Users/kelvi/OneDrive/Documentos/MasterBlockchain/proyectos-solidity-web/documentSignStorage/dapp && export NVM_DIR=\"\$HOME/.nvm\" && [ -s \"\$NVM_DIR/nvm.sh\" ] && \. \"\$NVM_DIR/nvm.sh\" && npm run dev"
```

O manualmente desde WSL:

```bash
wsl -d Ubuntu
cd /mnt/c/Users/kelvi/OneDrive/Documentos/MasterBlockchain/proyectos-solidity-web/documentSignStorage/dapp
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
npm run dev
```

### 5. Abrir en el navegador

Abre [http://localhost:3000](http://localhost:3000) en tu navegador.

## Verificación Rápida

- ✅ Anvil corriendo en `http://localhost:8545`
- ✅ Contrato desplegado (tienes la dirección)
- ✅ Archivo `.env.local` creado con la dirección del contrato
- ✅ `npm install` completado
- ✅ `npm run dev` ejecutándose

## Solución de Problemas

### Error: "Contract not available"
- Verifica que `NEXT_PUBLIC_CONTRACT_ADDRESS` esté configurado en `.env.local`
- Asegúrate de que el contrato esté desplegado

### Error de conexión a Anvil
- Verifica que Anvil esté corriendo: `curl http://localhost:8545`
- Verifica que el puerto 8545 no esté bloqueado

### Error: "No wallet connected"
- Conecta una wallet usando el selector en el header de la aplicación

