# Guía de Despliegue Local - DocumentRegistry

## 🚀 Iniciar Blockchain Local (Anvil)

Anvil es una blockchain local de Foundry que te permite probar contratos sin necesidad de una testnet.

### Opción 1: Desde WSL Ubuntu directamente

```bash
# Abrir WSL Ubuntu
wsl -d Ubuntu

# Agregar Foundry al PATH
export PATH="$HOME/.foundry/bin:$PATH"

# Iniciar Anvil en localhost:8545
anvil --host 0.0.0.0 --port 8545
```

### Opción 2: Usando el script

```bash
# Desde PowerShell/CMD
wsl -d Ubuntu bash start-anvil.sh
```

### Opción 3: Desde la terminal de Cursor

```bash
wsl -d Ubuntu bash -c "export PATH=\$HOME/.foundry/bin:\$PATH && ~/.foundry/bin/anvil --host 0.0.0.0 --port 8545"
```

## 📦 Desplegar el Contrato

Una vez que Anvil esté corriendo, en otra terminal:

### Opción 1: Usando el script de despliegue

```bash
# Desde PowerShell/CMD
wsl -d Ubuntu bash deploy-local.sh
```

### Opción 2: Manualmente

```bash
# Desde WSL Ubuntu
export PATH="$HOME/.foundry/bin:$PATH"
cd /mnt/c/Users/kelvi/OneDrive/Documentos/MasterBlockchain/proyectos-solidity-web/documentSignStorage/smart-contracts

# Usar la clave privada por defecto de Anvil
export PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

# Desplegar
forge script scripts/deploy.s.sol:DeployScript \
    --rpc-url http://localhost:8545 \
    --broadcast \
    --private-key $PRIVATE_KEY
```

## 🔗 Información de Conexión

Una vez desplegado, tendrás:

- **RPC URL**: `http://localhost:8545`
- **Chain ID**: `31337`
- **Dirección del contrato**: Se mostrará después del despliegue

## 💰 Cuentas Disponibles en Anvil

Anvil proporciona 10 cuentas pre-fundadas para testing:

| Índice | Dirección | Clave Privada |
|--------|-----------|---------------|
| 0 | 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 | 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 |
| 1 | 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 | 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d |
| ... | ... | ... |

**⚠️ ADVERTENCIA**: Estas claves son solo para desarrollo local. NUNCA uses estas claves en mainnet o testnets públicas.

## 🧪 Interactuar con el Contrato

### Usando Cast (CLI de Foundry)

```bash
# Llamar a una función view
cast call <CONTRACT_ADDRESS> "getDocumentCount()" --rpc-url http://localhost:8545

# Enviar una transacción
cast send <CONTRACT_ADDRESS> "storeDocumentHash(bytes32,uint256,bytes,address)" \
    <hash> <timestamp> <signature> <signer> \
    --rpc-url http://localhost:8545 \
    --private-key $PRIVATE_KEY
```

### Usando Remix IDE

1. Ve a https://remix.ethereum.org
2. Compila `DocumentRegistry.sol`
3. En la pestaña "Deploy & Run":
   - Selecciona "Injected Provider" o "Web3 Provider"
   - URL: `http://localhost:8545`
   - Conecta y despliega

### Usando Hardhat/Ethers.js

```javascript
const { ethers } = require("ethers");

const provider = new ethers.providers.JsonRpcProvider("http://localhost:8545");
const wallet = new ethers.Wallet(PRIVATE_KEY, provider);
const contract = new ethers.Contract(CONTRACT_ADDRESS, ABI, wallet);

// Interactuar con el contrato
await contract.storeDocumentHash(hash, timestamp, signature, signer);
```

## 📝 Ejemplo de Uso Completo

```bash
# Terminal 1: Iniciar Anvil
wsl -d Ubuntu bash start-anvil.sh

# Terminal 2: Desplegar contrato
wsl -d Ubuntu bash deploy-local.sh

# Terminal 3: Interactuar con el contrato
wsl -d Ubuntu bash -c "export PATH=\$HOME/.foundry/bin:\$PATH && \
cast send <CONTRACT_ADDRESS> 'storeDocumentHash(bytes32,uint256,bytes,address)' \
0x1234... 1234567890 0xabcd... 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 \
--rpc-url http://localhost:8545 \
--private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
```

## 🔍 Verificar que Anvil está Corriendo

```bash
# Verificar que responde
curl http://localhost:8545

# O desde WSL
wsl -d Ubuntu bash -c "curl http://localhost:8545"
```

## 🛑 Detener Anvil

Presiona `Ctrl+C` en la terminal donde está corriendo Anvil.

## 📚 Recursos Adicionales

- [Documentación de Anvil](https://book.getfoundry.sh/anvil/)
- [Documentación de Cast](https://book.getfoundry.sh/reference/cast/)
- [Forge Scripts](https://book.getfoundry.sh/tutorials/solidity-scripting)

