# Ejemplos (datos ficticios)

Archivos inventados para probar los comandos sin tocar datos reales. Nombres y RFC genéricos
(`XAXX010101000`, `XEXX010101000`); los montos no corresponden a ningún negocio real.

- `cfdi/` — dos facturas CFDI 4.0 mínimas → `/facturas ejemplos/cfdi`
- `banco.csv` + `libro.csv` — un mes de movimientos → `/conciliar` o
  `.venv/Scripts/python.exe scripts/conciliar.py ejemplos/banco.csv ejemplos/libro.csv reportes/prueba.xlsx`
