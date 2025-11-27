# DocumentRegistry - Smart Contract

Contrato inteligente optimizado para almacenar y verificar documentos en la blockchain. Utiliza una optimización de gas que reduce el consumo en ~39% al usar `documents[hash].signer != address(0)` para verificar existencia.

## 📋 Tabla de Contenidos

- [Requisitos Previos](#requisitos-previos)
- [Instalación](#instalación)
- [Compilación](#compilación)
- [Testing](#testing)
- [Despliegue](#despliegue)
- [Interacción con el Contrato](#interacción-con-el-contrato)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Solución de Problemas](#solución-de-problemas)
- [Recursos Adicionales](#recursos-adicionales)

## 🔧 Requisitos Previos

- **WSL Ubuntu** instalado y configurado
- **Foundry** instalado en WSL Ubuntu
- **Git** inicializado en el proyecto (para instalar dependencias)

### Verificar Instalación

```bash
# Verificar Foundry
wsl -d Ubuntu bash -c "export PATH=\$HOME/.foundry/bin:\$PATH && forge --version"

# Verificar Git
wsl -d Ubuntu bash -c "git --version"
```

## 📦 Instalación

### 1. Instalar Dependencias

```bash
# Desde WSL Ubuntu
wsl -d Ubuntu
cd ~/proyectos-solidity-web/documentSignStorage/smart-contracts

# Agregar Foundry al PATH
export PATH="$HOME/.foundry/bin:$PATH"

# Instalar dependencias (forge-std)
forge install foundry-rs/forge-std
```

### 2. Configurar PATH (Cada Sesión)

```bash
export PATH="$HOME/.foundry/bin:$PATH"
```

O agregar a `~/.bashrc`:

```bash
echo 'export PATH="$HOME/.foundry/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

## 🔨 Compilación

```bash
# Desde WSL Ubuntu
export PATH="$HOME/.foundry/bin:$PATH"
cd ~/proyectos-solidity-web/documentSignStorage/smart-contracts
forge build
```

### Opción: Usando Script

```bash
wsl -d Ubuntu bash test-wsl.sh build
```

## ✅ Testing

### Estado Actual

- ✅ Foundry instalado en WSL Ubuntu
- ✅ Dependencia `forge-std` instalada
- ✅ Contrato compilado exitosamente
- ✅ **17 tests pasando (100% éxito)**

### Ejecutar Tests

#### Opción 1: Desde WSL Ubuntu directamente

```bash
# Abrir WSL Ubuntu
wsl -d Ubuntu

# Navegar al proyecto
cd ~/proyectos-solidity-web/documentSignStorage/smart-contracts

# Agregar Foundry al PATH
export PATH="$HOME/.foundry/bin:$PATH"

# Compilar
forge build

# Ejecutar tests
forge test -vvv
```

#### Opción 2: Usando el script desde Windows

```powershell
# Desde PowerShell o CMD
wsl -d Ubuntu bash test-wsl.sh build
wsl -d Ubuntu bash test-wsl.sh test
wsl -d Ubuntu bash test-wsl.sh test-gas
```

#### Opción 3: Desde la terminal de Cursor

```bash
# Compilar
wsl -d Ubuntu bash -c "export PATH=\$HOME/.foundry/bin:\$PATH && cd ~/proyectos-solidity-web/documentSignStorage/smart-contracts && forge build"

# Ejecutar tests
wsl -d Ubuntu bash -c "export PATH=\$HOME/.foundry/bin:\$PATH && cd ~/proyectos-solidity-web/documentSignStorage/smart-contracts && forge test -vvv"
```

### Resultados de Tests

```
✅ 17 tests pasando:
- test_GetDocumentCount()
- test_GetDocumentHashByIndex_OutOfBounds()
- test_GetDocumentHashByIndex_Success()
- test_GetDocumentInfo_NonExistent()
- test_GetDocumentInfo_Success()
- test_IsDocumentStored_Exists()
- test_IsDocumentStored_NotExists()
- test_IterateAllDocuments()
- test_Optimization_UseSignerForExistence()
- test_StoreDocumentHash_RejectDuplicate()
- test_StoreDocumentHash_RejectInvalidHash()
- test_StoreDocumentHash_RejectInvalidSigner()
- test_StoreDocumentHash_Success()
- test_VerifyDocument_NonExistent()
- test_VerifyDocument_Success()
- test_VerifyDocument_WrongSignature()
- test_VerifyDocument_WrongSigner()
```

### Comandos Útiles de Testing

```bash
# Ejecutar todos los tests
forge test

# Tests con detalles
forge test -vvv

# Tests con máximo detalle
forge test -vvvv

# Tests con reporte de gas
forge test --gas-report

# Ejecutar un test específico
forge test --match-test test_StoreDocumentHash_Success

# Limpiar archivos compilados
forge clean

# Verificar formato
forge fmt
```

## 🚀 Despliegue

### Iniciar Blockchain Local (Anvil)

Anvil es una blockchain local de Foundry que te permite probar contratos sin necesidad de una testnet.

#### Opción 1: Desde WSL Ubuntu directamente

```bash
# Abrir WSL Ubuntu
wsl -d Ubuntu

# Agregar Foundry al PATH
export PATH="$HOME/.foundry/bin:$PATH"

# Iniciar Anvil en localhost:8545
anvil --host 0.0.0.0 --port 8545
```

#### Opción 2: Usando el script

```bash
# Desde PowerShell/CMD
wsl -d Ubuntu bash start-anvil.sh
```

#### Opción 3: Desde la terminal de Cursor

```bash
wsl -d Ubuntu bash -c "export PATH=\$HOME/.foundry/bin:\$PATH && ~/.foundry/bin/anvil --host 0.0.0.0 --port 8545"
```

### Desplegar el Contrato

Una vez que Anvil esté corriendo, en otra terminal:

#### Opción 1: Usando el script de despliegue

```bash
# Desde PowerShell/CMD
wsl -d Ubuntu bash deploy-local.sh
```

#### Opción 2: Manualmente

```bash
# Desde WSL Ubuntu
export PATH="$HOME/.foundry/bin:$PATH"
cd ~/proyectos-solidity-web/documentSignStorage/smart-contracts

# Usar la clave privada por defecto de Anvil
export PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

# Desplegar
forge script scripts/deploy.s.sol:DeployScript \
    --rpc-url http://localhost:8545 \
    --broadcast \
    --private-key $PRIVATE_KEY
```

### Información de Conexión

Una vez desplegado, tendrás:

- **RPC URL**: `http://localhost:8545`
- **Chain ID**: `31337`
- **Dirección del contrato**: Se mostrará después del despliegue (busca la línea "DocumentRegistry deployed at:")

### Cuentas Disponibles en Anvil

Anvil proporciona 10 cuentas pre-fundadas para testing:

| Índice | Dirección | Clave Privada |
|--------|-----------|---------------|
| 0 | 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 | 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 |
| 1 | 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 | 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d |
| ... | ... | ... |

**⚠️ ADVERTENCIA**: Estas claves son solo para desarrollo local. NUNCA uses estas claves en mainnet o testnets públicas.

### Verificar que Anvil está Corriendo

```bash
# Verificar que responde
curl http://localhost:8545

# O desde WSL
wsl -d Ubuntu bash -c "curl http://localhost:8545"
```

### Detener Anvil

Presiona `Ctrl+C` en la terminal donde está corriendo Anvil.

## 🔌 Interacción con el Contrato

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

### Ejemplo de Uso Completo

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

## 📁 Estructura del Proyecto

```
smart-contracts/
├── src/
│   └── DocumentRegistry.sol      # Contrato principal
├── test/
│   └── DocumentRegistry.t.sol   # Tests del contrato
├── scripts/
│   └── deploy.s.sol              # Script de despliegue
├── lib/
│   └── forge-std/                # Dependencia de testing
├── foundry.toml                  # Configuración de Foundry
├── start-anvil.sh                # Script para iniciar Anvil
├── deploy-local.sh               # Script para desplegar localmente
└── test-wsl.sh                   # Script helper para tests
```

## 🐛 Solución de Problemas

### Error: "forge: command not found"

```bash
export PATH="$HOME/.foundry/bin:$PATH"
```

O agregar permanentemente a `~/.bashrc`:

```bash
echo 'export PATH="$HOME/.foundry/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Error: "forge-std not found"

```bash
forge install foundry-rs/forge-std
```

### Error: "not a git repository"

```bash
git init
forge install foundry-rs/forge-std
```

### Error: "Anvil no responde"

1. Verifica que Anvil esté corriendo: `curl http://localhost:8545`
2. Verifica que el puerto 8545 no esté bloqueado por firewall
3. Reinicia Anvil: `Ctrl+C` y luego inícialo de nuevo

### Error: "Contract deployment failed"

1. Verifica que Anvil esté corriendo
2. Verifica que tengas suficiente balance (Anvil proporciona cuentas pre-fundadas)
3. Verifica que la clave privada sea correcta

## ⚠️ Notas Importantes

1. **WSL Ubuntu**: Foundry está instalado en WSL Ubuntu, no en Windows directamente
2. **PATH**: Necesitas agregar `~/.foundry/bin` al PATH en cada sesión nueva de WSL (o agregarlo a `~/.bashrc`)
3. **Git**: El proyecto necesita ser un repositorio git para instalar dependencias (ya inicializado)
4. **Claves Privadas**: Las claves de Anvil son solo para desarrollo local. NUNCA las uses en mainnet o testnets públicas

## 📚 Recursos Adicionales

- [Documentación de Foundry](https://book.getfoundry.sh/)
- [Documentación de Anvil](https://book.getfoundry.sh/anvil/)
- [Documentación de Cast](https://book.getfoundry.sh/reference/cast/)
- [Forge Scripts](https://book.getfoundry.sh/tutorials/solidity-scripting)
- [Forge Testing](https://book.getfoundry.sh/forge/tests)

## 📝 Funcionalidades del Contrato

### Funciones Principales

- `storeDocumentHash(bytes32 _hash, uint256 _timestamp, bytes memory _signature, address _signer)`: Almacena un documento en el registro
- `getDocumentInfo(bytes32 _hash)`: Obtiene la información completa de un documento
- `isDocumentStored(bytes32 _hash)`: Verifica si un documento está almacenado
- `verifyDocument(bytes32 _hash, address _signer, bytes memory _signature)`: Verifica un documento
- `getDocumentCount()`: Obtiene el número total de documentos
- `getDocumentHashByIndex(uint256 _index)`: Obtiene el hash de un documento por índice

### Eventos

- `DocumentStored(bytes32 indexed hash, address indexed signer, uint256 timestamp)`: Emitido cuando se almacena un documento
- `DocumentVerified(bytes32 indexed hash, address indexed signer, bool verified)`: Emitido cuando se verifica un documento

### Optimizaciones

- Uso de `documents[hash].signer != address(0)` para verificar existencia (ahorra ~39% de gas)
- Modificadores para validación de datos
- Estructura eficiente para almacenamiento

