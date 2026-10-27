---
name: conciliar
description: |
  Conciliación bancaria: estado de cuenta del banco vs libro/auxiliar contable (csv o xlsx). Partidas conciliadas,
  pendientes de cada lado, posibles duplicados y resumen. Salida: reportes/conciliacion-AAAA-MM.xlsx + md.
  TRIGGERS: "/conciliar", "conciliación", "conciliar banco", "estado de cuenta vs libro", "qué no cuadra con el banco".
---

# Conciliación bancaria

## Pasos

1. **Archivos.** Pide o identifica en `datos/`: (a) estado de cuenta del banco, (b) libro/auxiliar de bancos.
   Pregunta el periodo (mes) y el saldo inicial de cada lado si no está en los archivos.
2. **Normalizar a CSV** con columnas `fecha,descripcion,monto` (banco) y `fecha,referencia,monto` (libro).
   Si vienen en xlsx, exporta a CSV con un script corto en `scripts/` (sin tocar el original). Cargos negativos,
   abonos positivos; confirma la convención con el usuario si el archivo no la deja clara.
3. **Correr** `.venv/Scripts/python.exe scripts/conciliar.py <banco.csv> <libro.csv> reportes/conciliacion-AAAA-MM.xlsx`
   (en mac/linux: `.venv/bin/python`; no se activa el venv). Empareja por monto exacto y fecha ±3 días. Primero empareja las parejas con la misma fecha y luego las de menor diferencia de días.
   Otra tolerancia: `--dias N`. Si el libro registra los cargos como positivos, `--invertir-libro` (el script avisa si con el signo
   invertido sí habría coincidencias). Acepta CSV de Excel en Windows (codificación detectada, anotada en la hoja `Fuente`), montos
   como `(350.00)` o `$1,234.50`, y fechas `AAAA-MM-DD`, con hora o `DD/MM/AAAA`; las filas sin monto se omiten con aviso.
4. **Revisar el resultado**: hojas Conciliadas, Solo banco, Solo libro, Resumen (totales con `=SUM`) y Fuente. Explica cada partida pendiente
   en lenguaje llano ("el banco cobró $350.00 el 12 de octubre y no está en el libro: ¿comisión?").
5. **Reconciliar**: saldo inicial + conciliadas + solo banco debe explicar el saldo final del banco; lo mismo del lado del libro.
   Si no cuadra, dilo primero y muestra la diferencia.
6. **Entregar** el xlsx + `reportes/conciliacion-AAAA-MM.md` con el resumen y la lista de pendientes.

## Nunca
- Registrar pólizas o movimientos en ningún sistema. Propones el asiento; él lo captura.
- Dar por conciliada una partida con monto distinto aunque la descripción se parezca. Márcala como "posible".
