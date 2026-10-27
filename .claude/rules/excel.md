# Hojas de cálculo (xlsx)

Al generar o modificar un Excel:

- **Nunca sobrescribas el original.** Guarda una copia con fecha: `nombre-AAAA-MM-DD.xlsx` en `reportes/`.
- **Encabezados en la fila 1, congelados** (`freeze_panes = "A2"`), en negritas.
- **Totales con fórmulas, no con valores** (`=SUM(F2:F120)`), para que el usuario pueda revisar y cambiar datos.
- **Hoja "Fuente"**: de qué archivos salió la información, fecha de generación, filas leídas, filas descartadas y por qué.
- **Formatos**: montos con `#,##0.00`, fechas como fecha (no texto), RFC en mayúsculas sin espacios.
- **Una tabla por hoja**, sin celdas combinadas, sin filas vacías intermedias: así se puede filtrar y hacer tablas dinámicas.
- Anchos de columna razonables (ajusta a la cabecera o al contenido más largo, máx. 50).
- Usa `openpyxl` desde `scripts/`; si creas un script nuevo, acepta `entrada` y `salida` como argumentos.
