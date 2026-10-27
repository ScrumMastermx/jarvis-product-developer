---
name: reporte
description: |
  Reporte mensual (ventas, compras, gastos, inventario) a partir de los archivos en datos/. Pregunta periodo y
  fuentes, arma tablas reconciliadas, guarda md + xlsx en reportes/.
  TRIGGERS: "/reporte", "reporte del mes", "cierre de mes", "cómo nos fue en", "resumen mensual".
---

# Reporte mensual

## Pasos

1. **Preguntar** antes de leer nada: ¿qué periodo? ¿qué secciones (ventas, compras, gastos, inventario, bancos)?
   ¿qué archivos de `datos/` alimentan cada sección? Si ya existe un reporte anterior en `reportes/`, úsalo
   como plantilla de secciones.
2. **Por sección**: leer el archivo, confirmar columnas, calcular totales, anotar origen de cada cifra.
   Si una sección sale de facturas XML, corre primero `/facturas`; si sale de bancos, `/conciliar`.
3. **Reconciliar**: fila → sección → total general. Comparar con el mes anterior si hay reporte previo
   (diferencia en pesos y %).
4. **Entregar**:
   - `reportes/reporte-AAAA-MM.md`: una página. Primera línea = el dato más importante. Tabla por sección con
     total, variación vs mes anterior y origen. Lista "Falta el dato" al final.
   - `reportes/reporte-AAAA-MM.xlsx`: una hoja por sección + Resumen + Fuente (`.claude/rules/excel.md`).
5. **Resumen en chat**: 5 líneas máximo.

## Nunca
- Rellenar una sección sin archivo con estimaciones. Se marca "sin fuente".
- Mezclar periodos. Si un archivo trae más de un mes, filtra y dilo.
