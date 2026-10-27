---
name: facturas
description: |
  Convertir una carpeta de facturas electrónicas XML (CFDI 4.0, SAT México) en una tabla de Excel: UUID, fecha,
  emisor, receptor, subtotal, IVA, otros traslados, retenciones, total, forma y método de pago, uso CFDI; Ingresos, Egresos y Neto
  por mes y por emisor; detecta duplicados, CFDI sin UUID, importes que no cuadran y XML mal formados. Usa scripts/cfdi_a_tabla.py.
  TRIGGERS: "/facturas", "CFDI", "XML del SAT", "facturas de octubre", "cuánto facturó", "cuánto nos facturaron",
  "pasar las facturas a Excel".
---

# Facturas (CFDI 4.0)

## Pasos

1. **Carpeta.** Si no la indican, lista `datos/` y pregunta cuál carpeta tiene los XML. Pregunta si son facturas
   **recibidas** (gastos/compras) o **emitidas** (ventas): cambia la lectura del reporte, no el script.
2. **Correr** (con el intérprete del venv, sin activarlo: `.venv/Scripts/python.exe` en Windows, `.venv/bin/python` en mac/linux):
   `.venv/Scripts/python.exe scripts/cfdi_a_tabla.py <carpeta> reportes/facturas-AAAA-MM-DD.xlsx`
   El script lee cada `.xml`, ignora los que no son CFDI 4.0 válidos y los reporta al final sin detenerse.
3. **Revisar** la salida: hoja `Facturas` (una fila por XML válido; columnas `Duplicado` y `Cuadra`), hoja `Resumen` (por mes) y
   hoja `Resumen emisor`, ambas con **Ingresos (I)**, **Egresos (E)**, **Neto (I−E)**, IVA neto y la *cuenta* de Pagos (P), Traslados (T)
   y Nómina (N), con fila de total `=SUM`; hoja `Fuente`. Los tipos P, T y N nunca se suman a los importes.
   Los duplicados no entran al Resumen. Si el script marcó **UUID duplicados**, menciónalos primero: son la causa más
   común de totales inflados.
4. **Contar y cruzar**: **XML en la carpeta = filas en `Facturas` + XML inválidos** (los duplicados SÍ son filas, marcadas en `Duplicado`; un CFDI sin UUID
   sale como `SIN UUID` y no es duplicado). `Fuente` ya lo comprueba. Revisa también las filas con `Cuadra` = `NO CUADRA`
   (Subtotal − Descuento + IVA + OtrosTraslados − Retenciones ≠ Total, tolerancia 0.01). Si algo no cuadra,
   averigua por qué antes de entregar.
5. **Resumen en chat**: total de facturas, Ingresos, Egresos y Neto, IVA neto, los 5 emisores más grandes, XML con problema.
   Cada cifra con su origen (hoja y celda).

## Notas
- Notas de crédito (tipo `E`) se restan de los ingresos en la columna Neto; el complemento de pago (`P`), traslado (`T`) y nómina (`N`)
  solo se cuentan. El Resumen no convierte monedas: `Fuente` lista las que encontró.
- El Excel queda en `reportes/`, solo local (no se sube a git).
- Si preguntan "¿esto es deducible?": regla general + "confírmalo con tu contador".
