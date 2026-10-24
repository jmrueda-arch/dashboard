# Observatorio de ventas · LATAM

Tablero interactivo (dashboard) que lee directamente un archivo Excel y muestra
KPIs, mapa, evolución mensual, ranking de países, productos más vendidos y detalle
por país. No necesita base de datos ni backend: todo se calcula en el navegador.

## Archivos

| Archivo | Para qué sirve |
|---|---|
| `index.html` | El dashboard. |
| `BD Analitica de Datos.xlsx` | La base de datos. Hoja **«Ventas»** con una fila por venta. |
| `xlsx.full.min.js` | Librería que lee el Excel (incluida para que funcione sin internet). |
| `Iniciar dashboard.bat` | Lanzador para usarlo en tu PC (opcional, solo local). |
| `server.ps1` | Mini-servidor que usa el `.bat` (opcional, solo local). |

Los cinco deben estar en la **misma carpeta**.

## Verlo online (GitHub Pages)

1. Sube todos los archivos al repositorio (incluido `.nojekyll`).
2. En GitHub: **Settings → Pages → Build and deployment → Source: Deploy from a branch**,
   rama `main`, carpeta `/ (root)`. Guarda.
3. En un par de minutos el tablero estará en `https://<tu-usuario>.github.io/<tu-repo>/`.

La página lee el Excel automáticamente (lectura por `fetch`).

## Actualizar los datos

- **En tu PC:** abre `Iniciar dashboard.bat`, edita el Excel y pulsa **↻ Recargar Excel**.
- **En GitHub Pages:** edita el Excel, haz *commit* y *push* del nuevo archivo.
  Tras el redespliegue (1–2 min, a veces más por la caché), recarga la página.

## Nota sobre la moneda

El Excel no registra la moneda de cada venta, así que los importes **sumados entre
países no representan un total financiero comparable**. El tablero lo advierte.
