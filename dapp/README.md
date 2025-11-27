# Document Sign Storage dApp

Aplicación web descentralizada (dApp) para firmar y almacenar documentos en la blockchain usando Next.js, TypeScript, Ethers.js y Tailwind CSS.

## 🚀 Características

- **Subir y Firmar Documentos**: Calcula el hash del documento y permite firmarlo con una wallet
- **Verificar Documentos**: Verifica si un documento está almacenado en la blockchain y valida el firmante
- **Historial**: Muestra todos los documentos almacenados en la blockchain
- **Integración con Anvil**: Usa wallets derivadas del mnemonic de Anvil para desarrollo local
- **Sin MetaMask**: No requiere MetaMask, funciona directamente con Anvil usando JsonRpcProvider

## 📋 Requisitos Previos

- Node.js 18+ y npm
- Anvil corriendo en `http://localhost:8545`
- Contrato `DocumentRegistry` desplegado en Anvil

## 🛠️ Instalación

1. Instala las dependencias:

```bash
npm install
```

2. Configura las variables de entorno:

Crea un archivo `.env.local` en la raíz del proyecto con:

```env
NEXT_PUBLIC_CONTRACT_ADDRESS=<DIRECCION_DEL_CONTRATO>
NEXT_PUBLIC_RPC_URL=http://localhost:8545
NEXT_PUBLIC_CHAIN_ID=31337
NEXT_PUBLIC_MNEMONIC="test test test test test test test test test test test junk"
```

**Nota**: Reemplaza `<DIRECCION_DEL_CONTRATO>` con la dirección del contrato desplegado.

## 🏃 Ejecutar la Aplicación

1. Asegúrate de que Anvil esté corriendo:

```bash
# Desde WSL Ubuntu
wsl -d Ubuntu bash -c "export PATH=\$HOME/.foundry/bin:\$PATH && ~/.foundry/bin/anvil --host 0.0.0.0 --port 8545"
```

2. Inicia el servidor de desarrollo:

```bash
npm run dev
```

3. Abre [http://localhost:3000](http://localhost:3000) en tu navegador.

## 📁 Estructura del Proyecto

```
dapp/
├── app/
│   ├── layout.tsx          # Layout principal con MetaMaskProvider
│   ├── page.tsx            # Página principal con tabs
│   └── globals.css         # Estilos globales
├── components/
│   ├── FileUploader.tsx    # Componente para subir archivos y calcular hash
│   ├── DocumentSigner.tsx  # Componente para firmar documentos
│   ├── DocumentVerifier.tsx # Componente para verificar documentos
│   └── DocumentHistory.tsx # Componente para mostrar historial
├── contexts/
│   └── MetaMaskContext.tsx # Context para manejar wallets de Anvil
├── hooks/
│   └── useContract.ts      # Hook para interactuar con el contrato
└── package.json
```

## 🔧 Funcionalidades

### 1. Upload & Sign

- Sube un archivo y calcula su hash usando Keccak256
- Firma el hash con la wallet conectada
- Almacena el documento en la blockchain

### 2. Verify

- Sube un archivo para verificar
- Ingresa la dirección del firmante esperado
- Verifica si el documento está almacenado y si el firmante coincide

### 3. History

- Muestra todos los documentos almacenados en la blockchain
- Muestra hash, firmante, timestamp y firma de cada documento

## 🔐 Wallets de Anvil

La aplicación deriva automáticamente 10 wallets desde el mnemonic de Anvil. Puedes seleccionar cualquier wallet desde el dropdown en el header.

**⚠️ ADVERTENCIA**: Estas wallets son solo para desarrollo local. NUNCA uses estas claves en mainnet o testnets públicas.

## 🐛 Solución de Problemas

### Error: "Contract not available"
- Verifica que `NEXT_PUBLIC_CONTRACT_ADDRESS` esté configurado en `.env.local`
- Asegúrate de que el contrato esté desplegado en Anvil

### Error: "No wallet connected"
- Conecta una wallet usando el selector en el header

### Error de conexión a Anvil
- Verifica que Anvil esté corriendo en `http://localhost:8545`
- Verifica que el puerto 8545 no esté bloqueado por firewall

## 📚 Tecnologías Utilizadas

- **Next.js 14**: Framework de React
- **TypeScript**: Tipado estático
- **Ethers.js 6**: Biblioteca para interactuar con Ethereum
- **Tailwind CSS**: Framework de CSS
- **Lucide React**: Iconos

## 📝 Notas

- La aplicación usa `JsonRpcProvider` en lugar de `BrowserProvider` para trabajar directamente con Anvil
- No se requiere MetaMask ni ninguna extensión de navegador
- Las wallets se derivan dinámicamente desde el mnemonic de Anvil

