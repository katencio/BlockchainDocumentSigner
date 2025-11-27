# Document Sign Storage

Sistema completo de almacenamiento y verificación de documentos en blockchain, compuesto por un contrato inteligente optimizado y una aplicación web descentralizada (dApp) moderna.

## 📋 Descripción del Proyecto

**Document Sign Storage** es una solución completa que permite:
- **Firmar documentos digitales** de forma segura usando criptografía
- **Almacenar hashes de documentos** en la blockchain de Ethereum
- **Verificar la autenticidad** de documentos almacenados
- **Consultar el historial** completo de documentos firmados

El sistema está optimizado para reducir el consumo de gas en ~39% mediante técnicas avanzadas de almacenamiento en Solidity.

## 🏗️ Arquitectura del Proyecto

El proyecto se divide en dos componentes principales:

### 1. Smart Contracts (`smart-contracts/`)
Contrato inteligente `DocumentRegistry` escrito en Solidity que gestiona el almacenamiento y verificación de documentos en la blockchain.

**Características principales:**
- ✅ Optimización de gas (~39% menos consumo)
- ✅ 17 tests unitarios (100% de cobertura)
- ✅ Validación de datos con modificadores
- ✅ Eventos para seguimiento de transacciones
- ✅ Funciones de consulta eficientes

### 2. Aplicación Web (dApp) (`dapp/`)
Interfaz web moderna construida con Next.js que permite interactuar con el contrato inteligente.

**Características principales:**
- 📤 Subir y firmar documentos
- ✅ Verificar documentos almacenados
- 📜 Historial completo de documentos
- 🔐 Integración con wallets de Anvil (sin MetaMask)
- 🎨 Interfaz moderna con Tailwind CSS

## 🚀 Inicio Rápido

### Requisitos Previos

- **WSL Ubuntu** instalado y configurado
- **Foundry** instalado en WSL Ubuntu (para smart contracts)
- **Node.js 18+** y npm (para la dApp)
- **Git** inicializado en el proyecto

### Pasos de Instalación

#### 1. Clonar/Acceder al Proyecto

```bash
cd documentSignStorage
```

#### 2. Configurar Smart Contracts

```bash
cd smart-contracts

# Agregar Foundry al PATH
export PATH="$HOME/.foundry/bin:$PATH"

# Instalar dependencias
forge install foundry-rs/forge-std

# Compilar
forge build

# Ejecutar tests
forge test
```

#### 3. Desplegar el Contrato

```bash
# Terminal 1: Iniciar Anvil
wsl -d Ubuntu bash start-anvil.sh

# Terminal 2: Desplegar contrato
wsl -d Ubuntu bash deploy-local.sh
```

**Importante**: Copia la dirección del contrato que aparece después del despliegue.

#### 4. Configurar la dApp

```bash
cd ../dapp

# Instalar dependencias
npm install

# Crear archivo .env.local
cat > .env.local << EOF
NEXT_PUBLIC_CONTRACT_ADDRESS=<DIRECCION_DEL_CONTRATO>
NEXT_PUBLIC_RPC_URL=http://localhost:8545
NEXT_PUBLIC_CHAIN_ID=31337
NEXT_PUBLIC_MNEMONIC="test test test test test test test test test test test junk"
EOF
```

Reemplaza `<DIRECCION_DEL_CONTRATO>` con la dirección real del contrato desplegado.

#### 5. Iniciar la Aplicación

```bash
# Asegúrate de que Anvil esté corriendo
# Luego inicia la dApp
npm run dev
```

Abre [http://localhost:3000](http://localhost:3000) en tu navegador.

## 📁 Estructura del Proyecto

```
documentSignStorage/
├── smart-contracts/          # Contratos inteligentes
│   ├── src/
│   │   └── DocumentRegistry.sol    # Contrato principal
│   ├── test/
│   │   └── DocumentRegistry.t.sol # Tests del contrato
│   ├── scripts/
│   │   └── deploy.s.sol            # Script de despliegue
│   ├── README.md                    # Documentación detallada
│   ├── start-anvil.sh              # Script para iniciar Anvil
│   └── deploy-local.sh             # Script para desplegar
│
├── dapp/                     # Aplicación web
│   ├── app/                  # Páginas Next.js
│   ├── components/           # Componentes React
│   │   ├── FileUploader.tsx
│   │   ├── DocumentSigner.tsx
│   │   ├── DocumentVerifier.tsx
│   │   └── DocumentHistory.tsx
│   ├── contexts/             # Context API
│   │   └── MetaMaskContext.tsx
│   ├── hooks/                # Custom hooks
│   │   └── useContract.ts
│   ├── README.md             # Documentación detallada
│   └── package.json
│
└── README.md                 # Este archivo
```

## 🔧 Funcionalidades

### Smart Contract (DocumentRegistry)

#### Funciones Principales

- `storeDocumentHash()`: Almacena un documento en el registro
- `getDocumentInfo()`: Obtiene la información completa de un documento
- `isDocumentStored()`: Verifica si un documento está almacenado
- `verifyDocument()`: Verifica un documento comparando hash, signer y signature
- `getDocumentCount()`: Obtiene el número total de documentos
- `getDocumentHashByIndex()`: Obtiene el hash de un documento por índice

#### Optimizaciones

- Uso de `documents[hash].signer != address(0)` para verificar existencia (ahorra ~39% de gas)
- Modificadores para validación de datos
- Estructura eficiente para almacenamiento

### Aplicación Web (dApp)

#### Módulos

1. **Upload & Sign**
   - Sube archivos y calcula hash Keccak256
   - Firma documentos con wallets de Anvil
   - Almacena documentos en la blockchain

2. **Verify**
   - Verifica si un documento está almacenado
   - Valida el firmante del documento
   - Muestra información detallada del documento

3. **History**
   - Lista todos los documentos almacenados
   - Muestra hash, firmante, timestamp y firma
   - Actualización en tiempo real

## 🛠️ Tecnologías Utilizadas

### Smart Contracts
- **Solidity** ^0.8.0
- **Foundry** (Forge, Anvil, Cast)
- **forge-std** (biblioteca de testing)

### Aplicación Web
- **Next.js 14** (App Router)
- **React 18**
- **TypeScript**
- **Ethers.js 6**
- **Tailwind CSS**
- **Lucide React** (iconos)

## 📚 Documentación Detallada

- **[Smart Contracts README](./smart-contracts/README.md)**: Guía completa de instalación, testing y despliegue de los contratos
- **[dApp README](./dapp/README.md)**: Guía completa de la aplicación web

## 🧪 Testing

### Smart Contracts

El contrato incluye **17 tests unitarios** que cubren:
- Almacenamiento de documentos
- Verificación de documentos
- Validación de datos
- Optimizaciones de gas
- Casos límite y errores

```bash
cd smart-contracts
forge test -vvv
```

## 🔐 Seguridad

### Desarrollo Local

- El proyecto usa **Anvil** (blockchain local) para desarrollo
- Wallets de prueba pre-configuradas (solo para desarrollo)
- **NUNCA** uses las claves privadas de Anvil en mainnet o testnets públicas

### Producción

- Usa wallets seguras y gestiona las claves privadas adecuadamente
- Despliega en testnets primero para pruebas
- Realiza auditorías de seguridad antes de desplegar en mainnet

## 🐛 Solución de Problemas

### Error: "forge: command not found"
```bash
export PATH="$HOME/.foundry/bin:$PATH"
```

### Error: "Contract not available"
- Verifica que el contrato esté desplegado
- Verifica que `NEXT_PUBLIC_CONTRACT_ADDRESS` esté configurado en `.env.local`

### Error: "Anvil no responde"
```bash
# Verificar que Anvil esté corriendo
curl http://localhost:8545
```

### Error: "No wallet connected"
- Conecta una wallet usando el selector en el header de la dApp

## 📝 Flujo de Trabajo Completo

1. **Iniciar Anvil** (blockchain local)
   ```bash
   cd smart-contracts
   wsl -d Ubuntu bash start-anvil.sh
   ```

2. **Desplegar Contrato**
   ```bash
   cd smart-contracts
   wsl -d Ubuntu bash deploy-local.sh
   ```

3. **Configurar dApp**
   - Copiar dirección del contrato
   - Crear `.env.local` con la dirección

4. **Iniciar dApp**
   ```bash
   cd dapp
   npm run dev
   ```

5. **Usar la Aplicación**
   - Abrir http://localhost:3000
   - Conectar wallet
   - Subir y firmar documentos
   - Verificar documentos
   - Consultar historial

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 👥 Kelvin Atencio

Desarrollado como parte del Master en Blockchain.

## 🙏 Agradecimientos

- Foundry por las herramientas de desarrollo
- Next.js por el framework web
- Ethers.js por la biblioteca de Ethereum

---

**⚠️ ADVERTENCIA**: Este proyecto es para fines educativos y de desarrollo. No uses las claves privadas de Anvil en producción.

