# Privacidad

- `datos/` contiene información real de clientes, proveedores y bancos. **Nunca se sube a git** (está en
  `.gitignore`) y **nunca se pega** en un chat, correo o servicio externo.
- `reportes/` también es solo local (ignorado por git): los Excel generados llevan RFC, nombres y cifras reales dentro, y el scrub no puede revisar archivos binarios.
- `notes/` sí se sube a git: nunca escribas ahí nombres, RFC, cifras ni archivos de clientes; solo reglas y preferencias de trabajo.
- Los scripts escriben en el Excel solo el nombre del archivo o carpeta, nunca la ruta completa.
- Antes de cualquier `git add`, confirma que no se incluye nada de `datos/` ni `reportes/` (`.gitignore` las excluye; `scripts/scrub.sh` revisa credenciales y rutas personales, no RFC).
- Los archivos de `ejemplos/` son ficticios: nombres inventados ("Proveedor Ejemplo S.A. de C.V.") y RFC
  genéricos (`XAXX010101000`, `XEXX010101000`). Al crear un ejemplo nuevo, anonimiza siempre.
- Si el usuario pide compartir un reporte, genera una versión en `reportes/` (se queda en tu computadora; compártela tú por el canal que elijas) y recuérdale revisar que no
  lleve datos sensibles de más.
