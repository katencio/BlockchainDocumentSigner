# Guía de Testing - DocumentRegistry

## ✅ Estado Actual

- ✅ Foundry instalado en WSL Ubuntu
- ✅ Dependencia `forge-std` instalada
- ✅ Contrato compilado exitosamente
- ✅ **17 tests pasando (100% éxito)**

## 🚀 Cómo Ejecutar Tests

### Opción 1: Desde WSL Ubuntu directamente

```bash
# Abrir WSL Ubuntu
wsl -d Ubuntu

# Navegar al proyecto
cd /mnt/c/Users/kelvi/OneDrive/Documentos/MasterBlockchain/proyectos-solidity-web/documentSignStorage/smart-contracts

# Agregar Foundry al PATH (solo necesario una vez por sesión)
export PATH="$HOME/.foundry/bin:$PATH"

# Compilar
forge build

# Ejecutar tests
forge test -vvv
```

### Opción 2: Usando el script desde Windows

```powershell
# Desde PowerShell o CMD
wsl -d Ubuntu bash test-wsl.sh build
wsl -d Ubuntu bash test-wsl.sh test
wsl -d Ubuntu bash test-wsl.sh test-gas
```

### Opción 3: Desde la terminal de Cursor

```bash
# Compilar
wsl -d Ubuntu bash -c "export PATH=\$HOME/.foundry/bin:\$PATH && cd /mnt/c/Users/kelvi/OneDrive/Documentos/MasterBlockchain/proyectos-solidity-web/documentSignStorage/smart-contracts && forge build"

# Ejecutar tests
wsl -d Ubuntu bash -c "export PATH=\$HOME/.foundry/bin:\$PATH && cd /mnt/c/Users/kelvi/OneDrive/Documentos/MasterBlockchain/proyectos-solidity-web/documentSignStorage/smart-contracts && forge test -vvv"
```

## 📊 Resultados de Tests

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

## 🔧 Comandos Útiles

```bash
# Compilar
forge build

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

## 📁 Estructura del Proyecto

```
smart-contracts/
├── src/
│   └── DocumentRegistry.sol      # Contrato principal
├── test/
│   └── DocumentRegistry.t.sol   # Tests del contrato
├── lib/
│   └── forge-std/                # Dependencia de testing
├── foundry.toml                  # Configuración de Foundry
└── test-wsl.sh                   # Script helper
```

## ⚠️ Notas Importantes

1. **WSL Ubuntu**: Foundry está instalado en WSL Ubuntu, no en Windows directamente
2. **PATH**: Necesitas agregar `~/.foundry/bin` al PATH en cada sesión nueva de WSL
3. **Git**: El proyecto necesita ser un repositorio git para instalar dependencias (ya inicializado)

## 🐛 Solución de Problemas

### Error: "forge: command not found"
```bash
export PATH="$HOME/.foundry/bin:$PATH"
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

