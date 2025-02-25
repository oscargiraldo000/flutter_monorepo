## Flujo de Trabajo Recomendado

Este flujo de trabajo está diseñado para ayudarte a gestionar el monorepo de manera eficiente, desde la configuración inicial hasta la implementación de cambios. Sigue estos pasos para mantener un código limpio, funcional y bien estructurado.

---

### 1. **Configuración Inicial**
Antes de comenzar a trabajar en el monorepo, asegúrate de que todas las dependencias estén correctamente instaladas y configuradas.

```bash
melos run setup
```

Este comando ejecuta `melos bootstrap`, que instala las dependencias de todos los paquetes y configura el entorno del monorepo.

---

### 2. **Limpieza del Proyecto**
Si encuentras problemas con builds anteriores o cachés corruptos, limpia el proyecto para empezar desde cero.

```bash
melos run clean
```

Este comando ejecuta `flutter clean` en todos los paquetes para eliminar builds y cachés.

---

### 3. **Verificación de Dependencias**
Asegúrate de que todas las dependencias estén correctamente instaladas y actualizadas.

```bash
melos run check-dependencies
```

Este comando ejecuta `flutter pub get` en todos los paquetes para verificar las dependencias.

---

### 4. **Formateo del Código**
Mantén un estilo de código consistente en todo el monorepo utilizando el formateador de Dart.

```bash
melos run format
```

Este comando formatea el código en todos los paquetes según las reglas de Dart. Si hay cambios no formateados, el comando fallará (`--set-exit-if-changed`).

---

### 5. **Análisis de Código**
Ejecuta un análisis estático para detectar problemas en el código, como errores de sintaxis o malas prácticas.

```bash
melos run analyze
```

Este comando ejecuta `flutter analyze` en todos los paquetes para identificar posibles problemas.

---

### 6. **Corrección Automática de Errores**
Aplica correcciones automáticas a problemas comunes en el código.

```bash
melos run fix
```

Este comando ejecuta `dart fix --apply` para aplicar correcciones automáticas en todos los paquetes.

---

### 7. **Generación de Código**
Si trabajas con paquetes que utilizan `build_runner`, genera el código necesario.

```bash
melos run build-runner
```

Este comando ejecuta `dart run build_runner build --delete-conflicting-outputs` para generar código automáticamente.

---

### 8. **Verificación de Build Runner**
Verifica que los archivos generados con `build_runner` estén actualizados.

```bash
melos run check-build-runner
```

Este comando ejecuta `dart run build_runner check` para asegurarse de que no haya discrepancias en los archivos generados.

---

### 9. **Ejecución de Pruebas**
Ejecuta todas las pruebas unitarias en los paquetes del monorepo para garantizar que todo funcione correctamente.

```bash
melos run test
```

Este comando ejecuta `flutter test` en todos los paquetes.

---

### 10. **Pruebas con Cobertura**
Genera un informe de cobertura para verificar la calidad de las pruebas.

```bash
melos run test-coverage
```

Este comando ejecuta `flutter test --coverage` y genera un informe en formato HTML en la carpeta `coverage/html`. Abre el archivo `index.html` en tu navegador para revisar los resultados.

---

### 11. **Actualización de Dependencias**
Mantén las dependencias actualizadas para aprovechar las últimas mejoras y correcciones.

```bash
melos run upgrade
```

Este comando ejecuta `flutter pub upgrade` en todos los paquetes para actualizar las dependencias.

---

### 12. **Modo Observador de Build Runner**
Si estás trabajando en un paquete que utiliza `build_runner`, ejecuta el modo observador para regenerar código automáticamente cuando detecte cambios.

```bash
melos run generate
```

Este comando ejecuta `dart run build_runner watch` en todos los paquetes.

---

## Resumen del Flujo de Trabajo

1. **Configuración Inicial**: `melos run setup`
2. **Limpieza**: `melos run clean` (opcional, si es necesario)
3. **Verificación de Dependencias**: `melos run check-dependencies`
4. **Formateo**: `melos run format`
5. **Análisis**: `melos run analyze`
6. **Correcciones Automáticas**: `melos run fix`
7. **Generación de Código**: `melos run build-runner`
8. **Verificación de Build Runner**: `melos run check-build-runner`
9. **Pruebas**: `melos run test`
10. **Cobertura**: `melos run test-coverage` (opcional)
11. **Actualización de Dependencias**: `melos run upgrade` (opcional)
12. **Modo Observador**: `melos run generate` (opcional, si trabajas con `build_runner`)