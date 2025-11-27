# Comandos para Probar el Contrato DocumentRegistry

## ⚠️ Importante: Usa Git Bash

Foundry está instalado en Git Bash, por lo que **debes usar Git Bash** (no PowerShell ni CMD) para ejecutar estos comandos.

## Pasos para Probar el Contrato

### 1. Abre Git Bash

Abre **Git Bash** desde el menú de inicio o desde cualquier carpeta haciendo clic derecho → "Git Bash Here"

### 2. Navega al directorio del proyecto

```bash
cd "C:/Users/kelvi/OneDrive/Documentos/MasterBlockchain/proyectos-solidity-web/documentSignStorage/smart-contracts"
```

O si ya estás en la carpeta del proyecto:
```bash
cd smart-contracts
```

### 3. Compila el contrato

```bash
forge build
```

Esto compilará `DocumentRegistry.sol` y verificará que no hay errores de sintaxis.

### 4. Ejecuta los tests

```bash
# Ejecutar todos los tests
forge test

# Ejecutar tests con más detalle (recomendado)
forge test -vvv

# Ejecutar tests con máximo detalle
forge test -vvvv

# Ejecutar tests con reporte de gas
forge test --gas-report
```

### 5. Ejecutar un test específico

```bash
# Ejecutar solo un test por nombre
forge test --match-test test_StoreDocumentHash_Success

# Ejecutar tests que contengan un patrón
forge test --match-test "test_Store*"
```

## Comandos Útiles Adicionales

### Ver información del contrato

```bash
# Ver el tamaño del contrato compilado
forge build --sizes

# Ver el código bytecode
forge build --extra-output evm.bytecode
```

### Limpiar archivos compilados

```bash
forge clean
```

### Verificar formato del código

```bash
forge fmt
```

## Estructura Esperada de Salida

Cuando ejecutes `forge test -vvv`, deberías ver algo como:

```
[PASS] test_StoreDocumentHash_Success() (gas: XXXX)
[PASS] test_StoreDocumentHash_RejectDuplicate() (gas: XXXX)
[PASS] test_VerifyDocument_Success() (gas: XXXX)
...
Test result: ok. X passed; 0 failed; finished in X.XXs
```

## Solución de Problemas

### Error: "forge: command not found"
- Asegúrate de estar usando **Git Bash**, no PowerShell
- Verifica que Foundry esté instalado: `foundryup`

### Error de compilación
- Verifica que `foundry.toml` existe en el directorio
- Asegúrate de tener Solidity 0.8.0 o superior

### Tests fallan
- Ejecuta con `-vvvv` para ver más detalles
- Verifica que todos los archivos estén en su lugar:
  - `src/DocumentRegistry.sol`
  - `test/DocumentRegistry.t.sol`

