---
name: excel
description: |
  Crear, limpiar o arreglar una hoja de cálculo: quitar duplicados, normalizar RFC/fechas/montos, agregar
  fórmulas de totales, validaciones, formato. Sigue .claude/rules/excel.md.
  TRIGGERS: "/excel", "limpia este Excel", "arregla la hoja", "quita duplicados", "ponle totales", "haz una plantilla".
---

# Excel

## Pasos

1. **Entender el pedido** en una frase y confirmarlo ("quieres quitar filas con el mismo RFC y fecha, y que la
   columna Total tenga fórmula"). Si el archivo está en `datos/`, nunca lo sobrescribes: la salida va a
   `reportes/<nombre>-AAAA-MM-DD.xlsx`.
2. **Leer** las primeras filas y describir lo que ves (hojas, columnas, filas, celdas vacías, tipos mezclados).
3. **Escribir un script corto** en `scripts/` (openpyxl, con `entrada` y `salida` como argumentos) o reutilizar
   uno existente. Explica qué hará antes de correrlo.
4. **Limpiezas típicas**: RFC en mayúsculas sin espacios; fechas a tipo fecha ISO; montos a número (quitar `$` y comas);
   duplicados por clave que el usuario confirme; totales con `=SUM`; encabezados congelados; hoja Fuente.
5. **Verificar**: filas antes vs después (cuántas se quitaron y por qué), totales antes vs después.
6. **Entregar**: ruta del archivo nuevo + 3 líneas de qué cambió.

## Plantillas
Si piden una plantilla nueva (kardex, control de caja chica, antigüedad de saldos), crea el xlsx con
encabezados, validaciones de datos y fórmulas, y guarda el script en `scripts/plantilla_<nombre>.py` para
regenerarla.
