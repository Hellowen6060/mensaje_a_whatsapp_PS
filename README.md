# MENSAJES INSTANTÁNEOS A WHATSAPP

Proyecto desarrollado en **PowerShell** para enviar mensajes instantáneos a números de celular vía **WhatsApp Web**, con gestión de contactos y verificación de indicativos internacionales.

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
  - `Indicativos.bin` para almacenar países e indicativos.
  - `Contactos.bin` para la agenda de contactos.

---

## 📂 Estructura de archivos

- `MensajesWhatsApp.ps1` → Script principal.
- `Indicativos.bin` → Archivo con continentes, países e indicativos.
- `Contactos.bin` → Agenda de contactos (se crea automáticamente si no existe).

---

## 🖥️ Uso

1. Clona o descarga este repositorio así:

Instala Git (si no lo tienes):

Descárgalo desde: https://git-scm.com/downloads
ó desde PowerShell:
```powershell
winget install --id Git.Git -e --source winget
```

Ve al directorio donde quieres clonar el repositorio, por ejemplo:
```powershell
cd C:\Hell
```

Ejecuta el comando de clonación:
```powershell
git clone https://github.com/Hellowen6060/mensaje_a_whatsapp_PS.git
```

Ejecuta:
```powershell
C:\Hell\mensaje_a_whatsapp_PS\Mensaje_Whatsapp.ps1
```

2. Asegúrate de tener **PowerShell** en Windows.
3. Coloca los archivos `Indicativos.bin` y `Contactos.bin` en el mismo directorio que el `.ps1`. (Solo si descargaste manualmente el .zip)
4. Ejecuta el script: Mensaje_Whatsapp.ps1
5. Navega por el menú principal

👨‍💻 Créditos
Autor: Diego Garcia R.
Asistente IA: Microsoft Copilot

📜 Licencia
Este proyecto se distribuye para fines educativos y personales.
Puedes modificarlo y adaptarlo libremente, siempre dando crédito al autor original.

