# MENSAJES INSTANTÁNEOS A WHATSAPP

Proyecto desarrollado en **PowerShell** para enviar mensajes instantáneos a números de celular vía **WhatsApp Web**, con gestión de contactos y verificación de indicativos internacionales.

Creado por **Diego Garcia R.** y **Microsoft Copilot**.

<img width="1110" height="627" alt="001_Menu" src="https://github.com/user-attachments/assets/58f25b6c-6f60-4843-80c4-9f41420562f9" />

## 🚀 Características principales

- **Menú principal interactivo** con opciones claras y navegación mediante `0. Regresar`.
- **Envío de mensajes** a números locales o internacionales usando indicativos.
- **Gestión de contactos**:
  - Ver agenda
  - Agregar contacto
  - Eliminar contacto
  - Modificar contacto
- **Listado de indicativos por continente** con validación de entradas.
- **Validaciones robustas**:
  - Evita entradas vacías.
  - Control de errores con mensajes en rojo.
  - Confirmaciones con `ENTER` y cancelaciones con `ESC`.
- **Integración con archivos externos**:
  - `Indicativos.txt` (o extensión personalizada como `.fua`) para almacenar países e indicativos.
  - `Contactos.txt` (o `.fua`) para la agenda de contactos.
- **Autocreación de archivos**:
  - Si `Contactos.txt` no existe, se crea automáticamente.
  - Si `Indicativos.txt` no existe, el script se detiene con un mensaje claro.

---

## 📂 Estructura de archivos

- `MensajesWhatsApp.ps1` → Script principal.
- `Indicativos.txt` → Archivo con continentes, países e indicativos.
- `Contactos.txt` → Agenda de contactos (se crea automáticamente si no existe).

> ⚠️ Puedes cambiar las extensiones (`.txt` → `.fua` u otra inventada). Solo asegúrate de modificar las referencias en el script.

---

## 🖥️ Uso

1. Clona o descarga este repositorio.
2. Asegúrate de tener **PowerShell** en Windows.
3. Coloca los archivos `Indicativos.txt` y `Contactos.txt` en el mismo directorio que el `.ps1`.
4. Ejecuta el script:
5. Navega por el menú principal:

1 → Enviar mensaje

2 → Ver listado de indicativos

3 → Contactos

4 → Finalizar

📑 Ejemplo de flujo
Selecciona Ver agenda.

Escoge un contacto.

Confirma con ENTER si es del país detectado, o ESC para elegir otro continente.

Si vienes desde agenda con ESC, el número se guarda y solo se pide el mensaje después de seleccionar país.

🛡️ Validaciones implementadas
Entradas vacías → Mensaje en rojo y reintento.

Opción inválida → Mensaje en rojo y recarga del menú.

Número celular → Solo dígitos permitidos.

Mensajes → No se permiten vacíos.

Indicativos → Si falta el archivo, se detiene el script.

👨‍💻 Créditos
Autor: Diego Garcia R.

Asistente IA: Microsoft Copilot

Lenguaje: PowerShell

Ubicación: Bogotá, Colombia

📜 Licencia
Este proyecto se distribuye para fines educativos y personales.
Puedes modificarlo y adaptarlo libremente, siempre dando crédito al autor original.
   ```powershell
   .\MensajesWhatsApp.ps1
