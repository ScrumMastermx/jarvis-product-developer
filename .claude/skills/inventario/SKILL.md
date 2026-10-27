---
name: inventario
description: |
  Analizar un archivo de inventario (xlsx/csv en datos/): existencias, rotación, punto de reorden sugerido,
  productos sin movimiento, diferencias entre conteo físico y sistema. Genera reporte md + xlsx en reportes/.
  TRIGGERS: "/inventario", "existencias", "qué hay en almacén", "qué se mueve poco", "punto de reorden",
  "conteo físico", "diferencias de inventario", "rotación".
---

# Inventario

## Pasos

1. **Identificar el archivo.** Si no lo indican, lista `datos/` y pregunta cuál es el inventario. Pregunta también:
   ¿hay archivo de movimientos (entradas/salidas) o de conteo físico? ¿Qué periodo cubre?
2. **Leer la estructura** (primeras 20 filas). Confirma con el usuario qué columna es: código/SKU, descripción,
   existencia, costo unitario, mínimo, y en movimientos: fecha, tipo (entrada/salida), cantidad.
   Nunca adivines una columna: si no es evidente, pregunta.
3. **Calcular**, citando columnas:
   - Existencias totales y valor del inventario (`existencia × costo`), por producto y total.
   - Rotación = salidas del periodo ÷ existencia promedio (si hay movimientos). Explica la fórmula en el reporte.
   - Punto de reorden sugerido = consumo diario promedio × días de reabastecimiento (pregunta los días; si no los sabe,
     usa 7 y márcalo como supuesto).
   - Productos sin movimiento en el periodo.
   - Diferencias conteo físico vs sistema: tabla con código, sistema, físico, diferencia, valor de la diferencia.
4. **Reconciliar**: la suma por producto debe dar el total. Si no cuadra, repórtalo primero.
5. **Entregar**: `reportes/inventario-AAAA-MM-DD.md` (resumen con las 10 diferencias más grandes) y
   `reportes/inventario-AAAA-MM-DD.xlsx` siguiendo `.claude/rules/excel.md` (hojas: Existencias, Sin movimiento,
   Reorden, Diferencias, Fuente).
6. **Resumen en chat**: 3 a 6 líneas con los hallazgos y los supuestos usados.

## Nunca
- Ajustar inventario en ningún sistema. Solo reportas.
- Rellenar existencias vacías con cero sin avisar.
