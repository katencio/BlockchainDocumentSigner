# Instalación de Foundry (Forge) en Windows

## Método 1: Usando Git Bash (Recomendado) ⭐

Si tienes **Git para Windows** instalado (que incluye Git Bash):

1. Abre **Git Bash** (no PowerShell ni CMD)
2. Ejecuta el siguiente comando:
   ```bash
   curl -L https://foundry.paradigm.xyz | bash
   ```
3. Cierra y vuelve a abrir Git Bash
4. Ejecuta:
   ```bash
   foundryup
   ```
5. Verifica la instalación:
   ```bash
   forge --version
   ```

## Método 2: Descarga Manual de Binarios

1. Ve a: https://github.com/foundry-rs/foundry/releases/latest
2. Descarga el archivo: `foundry_nightly_x86_64-pc-windows-msvc.zip`
3. Extrae el archivo ZIP en una carpeta (ej: `C:\foundry`)
4. Agrega la carpeta al PATH del sistema:
   - Abre "Variables de entorno" en Windows
   - Edita la variable "Path"
   - Agrega la ruta donde extrajiste Foundry (ej: `C:\foundry`)
5. Abre una nueva terminal y verifica:
   ```bash
   forge --version
   ```

## Método 3: Usando Cargo (si tienes Rust instalado)

Si ya tienes Rust y Cargo instalados:

```bash
cargo install --git https://github.com/foundry-rs/foundry foundry-cli anvil --bins --locked
```

## Método 4: Usando WSL (Windows Subsystem for Linux)

Si tienes WSL instalado:

1. Abre WSL (Ubuntu, etc.)
2. Ejecuta:
   ```bash
   curl -L https://foundry.paradigm.xyz | bash
   foundryup
   ```
3. Usa Foundry desde WSL

## Verificación de Instalación

Después de instalar, verifica que todo funciona:

```bash
forge --version
cast --version
anvil --version
```

## Probar el Contrato

Una vez instalado Foundry, navega a la carpeta del proyecto y ejecuta:

```bash
cd documentSignStorage/smart-contracts
forge build
forge test
```

Para ver los tests con más detalle:

```bash
forge test -vvv
```

Para ver el reporte de gas:

```bash
forge test --gas-report
```

## Solución de Problemas

### Error: "forge no se reconoce como comando"
- Asegúrate de haber agregado Foundry al PATH
- Cierra y vuelve a abrir la terminal
- Verifica que la instalación fue exitosa

### Error al compilar
- Verifica que tienes `foundry.toml` en la carpeta del proyecto
- Asegúrate de tener Solidity 0.8.0 o superior

### Problemas de conexión
- Intenta descargar los binarios manualmente (Método 2)
- Verifica tu conexión a internet

