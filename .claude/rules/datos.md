# Datos y cifras

- **Trazabilidad.** Toda cifra cita su origen: `archivo!Hoja!Celda` para Excel (`ventas-2026-09.xlsx!Ventas!F14`),
  `archivo:fila` para CSV, `archivo.xml` (UUID) para facturas.
- **Moneda.** Pesos mexicanos (MXN) por defecto. Si un archivo trae otra moneda, pregúntalo antes de sumar.
  Formato: `$12,345.67 MXN`.
- **Fechas** en ISO `AAAA-MM-DD`. Si un archivo mezcla `dd/mm/aaaa` con `mm/dd/aaaa`, detente y pregunta.
- **Redondeo** a 2 decimales **solo al final**. Suma con los valores completos.
- **Totales** siempre reconciliados: la suma de las filas debe dar el total de la sección, y las secciones el total
  general. Si no cuadra, el reporte lo dice en la primera línea.
- **Duplicados.** Antes de sumar facturas, revisa UUID repetidos; antes de sumar movimientos, revisa
  misma fecha + mismo monto + misma referencia.
- **Datos faltantes.** Celdas vacías no son cero. Reporta cuántas hay y en qué columnas.
