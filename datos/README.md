# datos/ — tus archivos reales

Aquí van los Excel, CSV y XML del negocio (estados de cuenta, inventarios, facturas).
Esta carpeta está en `.gitignore`: **nada de lo que pongas aquí se sube a internet**.
Lo mismo vale para `reportes/`: los Excel que se generan llevan RFC, nombres y cifras reales y se quedan solo en tu computadora.

Sugerencia de orden:
```
datos/facturas/2026-10/     XML del mes
datos/bancos/2026-10.csv    estado de cuenta exportado
datos/inventario.xlsx       inventario actual
```
