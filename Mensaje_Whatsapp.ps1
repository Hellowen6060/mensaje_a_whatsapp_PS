# MENSAJES INSTANTANEOS A WHATSAPP
# Creado por Diego Garcia R. y Microsoft Copilot

Add-Type -AssemblyName System.Web  # Necesario para usar HttpUtility

function Mostrar-Titulo {
    Clear-Host
    $titulo = "MENSAJES INSTANTANEOS A WHATSAPP"
    $marco = ("=" * ($titulo.Length + 4))
    Write-Host $marco -ForegroundColor White
    Write-Host "= " -NoNewline -ForegroundColor White
    Write-Host $titulo -ForegroundColor Green -NoNewline
    Write-Host " =" -ForegroundColor White
    Write-Host $marco -ForegroundColor White
    Write-Host ""
}

function Obtener-PaisLocal {
    try {
        $region = [System.Globalization.RegionInfo]::CurrentRegion
        $nombreRegion = $region.NativeName  # Ejemplo: "Colombia"

        $indicativo = ""
        $lineas = Get-Content ".\Indicativos.bin"
        foreach ($linea in $lineas) {
            if ($linea.Trim() -eq "" -or $linea -like "##*") { continue }
            $partes = $linea.Split(" ")
            $pais = $partes[0..($partes.Length-2)] -join " "
            if ($pais -eq $nombreRegion) {
                $indicativo = $partes[-1]
                break
            }
        }

        return @{Pais=$nombreRegion; Indicativo=$indicativo}
    } catch {
        return @{Pais="Desconocido"; Indicativo=""}
    }
}

# ==============================
# Verificación de archivos necesarios
# ==============================
$indicativosPath = Join-Path $PSScriptRoot "Indicativos.bin"
$contactosPath   = Join-Path $PSScriptRoot "Contactos.bin"

# Verificar Indicativos.bin
if (-not (Test-Path $indicativosPath)) {
    Write-Host "Indicativos no encontrados, por favor descarga nuevamente esta herramienta!" -ForegroundColor Red
    Write-Host "Presiona ENTER para cerrar..." -ForegroundColor White
    Read-Host   # ✅ Pausa sin límite de tiempo
    exit        # ✅ Cierra todo el script
} else {
    Write-Host "Indicativos encontrados." -ForegroundColor Green
}

# Verificar Contactos.bin
if (-not (Test-Path $contactosPath)) {
    Write-Host "Contactos no encontrados, se creará una nueva base!" -ForegroundColor Yellow
    New-Item -Path $contactosPath -ItemType File -Force | Out-Null
    Write-Host "Presiona ENTER para continuar..." -ForegroundColor White
    Read-Host   # ✅ Pausa para que el cliente lo vea
    Start-Sleep -Seconds 1
} else {
    Write-Host "Contactos encontrados." -ForegroundColor Cyan
    Start-Sleep -Seconds 1
}

function Opcion-EnviarMensaje {
    do {
        Mostrar-Titulo
        Write-Host "Enviar mensaje" -ForegroundColor Cyan
        Write-Host ""

        # ✅ Opción 0 para regresar
        Write-Host "0. Regresar" -ForegroundColor DarkRed
        Write-Host ""

        $numero = Read-Host "Ingresa el número celular sin indicativo (o digita 0 para regresar)"
        if ($numero -eq "0") {
            MenuPrincipal
            return
        }
        if ([string]::IsNullOrWhiteSpace($numero)) {
            Write-Host "El número no puede estar vacío." -ForegroundColor Red
            Start-Sleep -Seconds 2
            continue
        }
        if ($numero -notmatch '^\d+$') {
            Write-Host "El número debe contener solo dígitos." -ForegroundColor Red
            Start-Sleep -Seconds 2
            continue
        }

        Mostrar-Titulo
        Write-Host "Enviar mensaje" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "0. Regresar" -ForegroundColor DarkRed
        Write-Host ""

        $mensaje = Read-Host "Escribe el mensaje a enviar (o digita 0 para regresar)"
        if ($mensaje -eq "0") {
            MenuPrincipal
            return
        }
        if ([string]::IsNullOrWhiteSpace($mensaje)) {
            Write-Host "El mensaje no puede estar vacío." -ForegroundColor Red
            Start-Sleep -Seconds 2
            continue
        }

        # Obtener indicativo local
        $info = Obtener-PaisLocal
        $indicativo = $info.Indicativo

        # Codificar mensaje
        $mensajeEncoded = [System.Web.HttpUtility]::UrlEncode($mensaje)
        $url = "https://api.whatsapp.com/send?phone=$($indicativo.Replace('+',''))$numero&text=$mensajeEncoded"

        # Abrir WhatsApp
        Start-Process $url

        # ✅ Al terminar, regresar al menú principal
        MenuPrincipal
        break
    } while ($true)
}

function Opcion-VerIndicativos {
    Mostrar-Titulo
    Write-Host "Selecciona el continente:" -ForegroundColor White
    Write-Host ""
    Write-Host "1. África" -ForegroundColor Yellow
    Write-Host "2. América" -ForegroundColor Green
    Write-Host "3. Asia" -ForegroundColor DarkYellow
    Write-Host "4. Europa" -ForegroundColor Magenta
    Write-Host "5. Oceanía" -ForegroundColor Blue
    Write-Host "6. Regresar" -ForegroundColor DarkRed
    Write-Host ""

    $opCont = Read-Host "Ingresa tu opción (1-6)"

    if ([string]::IsNullOrWhiteSpace($opCont)) {
        Write-Host ">> No seleccionaste ninguna opción, intenta de nuevo." -ForegroundColor Red
        Start-Sleep -Seconds 2
        Opcion-VerIndicativos
        return
    }

    switch ($opCont) {
        1 { Mostrar-Paises "África" }
        2 { Mostrar-Paises "América" }
        3 { Mostrar-Paises "Asia" }
        4 { Mostrar-Paises "Europa" }
        5 { Mostrar-Paises "Oceanía" }
        6 { Mostrar-Menu }
        default { 
            Write-Host "Opción inválida." -ForegroundColor Red
            Start-Sleep -Seconds 2
            Opcion-VerIndicativos
        }
    }
}

function Mostrar-Paises($continente) {
    Mostrar-Titulo
    Write-Host "Selecciona el país deseado:" -ForegroundColor White
    Write-Host ""

    $lineas = Get-Content ".\Indicativos.bin"
    $grupo = $false
    $paises = @()
    foreach ($linea in $lineas) {
        if ($linea -match "## $continente") { $grupo = $true; continue }
        elseif ($linea -match "## ") { $grupo = $false }
        elseif ($grupo -and $linea.Trim() -ne "") { $paises += $linea }
    }

    # ✅ Opción 0 para regresar
    Write-Host "0. Regresar" -ForegroundColor Red

    $i = 1
    foreach ($pais in $paises) {
        Write-Host "$i. $pais" -ForegroundColor Yellow
        $i++
    }

    Write-Host ""
    $opPais = Read-Host "Selecciona el país (0 para regresar)"

    if ([string]::IsNullOrWhiteSpace($opPais)) {
        Write-Host ">> No seleccionaste ninguna opción, intenta de nuevo." -ForegroundColor Red
        Start-Sleep -Seconds 2
        Mostrar-Paises $continente
        return
    }

    if ($opPais -eq "0") {
        Opcion-VerIndicativos
        return
    }

    if ($opPais -match '^\d+$' -and [int]$opPais -le $paises.Count) {
        $seleccion = $paises[[int]$opPais-1]

        $partes = $seleccion.Split(" ")
        $paisNombre = $partes[0..($partes.Length-2)] -join " "
        $indicativo = $partes[-1]

        # ✅ Si ya hay número guardado desde Ver-Agenda
        if ($Global:NumeroSeleccionado) {
            $cel = $Global:NumeroSeleccionado
            Write-Host ""
            Write-Host ">> Usando número previamente seleccionado: $cel" -ForegroundColor Cyan
        } else {
            # ✅ Número con validación y opción 0
            Mostrar-Titulo
            Write-Host "0. Regresar" -ForegroundColor Red
            $cel = Read-Host "Ingresa el número celular ($indicativo) o 0 para regresar"
            if ([string]::IsNullOrWhiteSpace($cel)) {
                Write-Host ">> No ingresaste ningún número, intenta de nuevo." -ForegroundColor Red
                Start-Sleep -Seconds 2
                Mostrar-Paises $continente
                return
            }
            if ($cel -eq "0") {
                Opcion-VerIndicativos
                return
            }
            if ($cel -notmatch '^\d+$') {
                Write-Host ">> El número debe contener solo dígitos." -ForegroundColor Red
                Start-Sleep -Seconds 2
                Mostrar-Paises $continente
                return
            }
        }

        # ✅ Mensaje con validación y opción 0
        Mostrar-Titulo
        Write-Host "0. Regresar" -ForegroundColor Red
        $mensaje = Read-Host "Escribe el mensaje a enviar (o digita 0 para regresar)"
        if ([string]::IsNullOrWhiteSpace($mensaje)) {
            Write-Host ">> No escribiste ningún mensaje, intenta de nuevo." -ForegroundColor Red
            Start-Sleep -Seconds 2
            Mostrar-Paises $continente
            return
        }
        if ($mensaje -eq "0") {
            Opcion-VerIndicativos
            return
        }

        $Global:IndicativoSeleccionado = $indicativo
        $mensajeEncoded = [System.Web.HttpUtility]::UrlEncode($mensaje)
        $url = "https://api.whatsapp.com/send?phone=$($indicativo.Replace('+',''))$cel&text=$mensajeEncoded"

        Start-Process $url

        # ✅ Limpiar número global después de usarlo
        $Global:NumeroSeleccionado = $null
        Mostrar-Menu
    } else {
        Write-Host "Opción inválida, intenta de nuevo." -ForegroundColor Red
        Start-Sleep -Seconds 2
        Mostrar-Paises $continente
    }
}

# ==============================
# SUBMENÚ DE CONTACTOS
# ==============================
function Menu-Contactos {
    Mostrar-Titulo
    Write-Host "Selecciona la opción más conveniente:" -ForegroundColor White
    Write-Host ""
    Write-Host "1. Ver agenda" -ForegroundColor Blue
    Write-Host "2. Agregar contacto" -ForegroundColor Green
    Write-Host "3. Eliminar contacto" -ForegroundColor Red
    Write-Host "4. Modificar contacto" -ForegroundColor Yellow
    Write-Host "5. Regresar al menú principal" -ForegroundColor DarkRed
    Write-Host ""

    $opC = Read-Host "Ingresa tu opción (1-5)"
    switch ($opC) {
        1 { Ver-Agenda }
        2 { Agregar-Contacto }
        3 { Eliminar-Contacto }
        4 { Modificar-Contacto }
        5 { Mostrar-Menu }   # 🔴 Aquí llamamos al menú principal de todo el ps1
        default { Write-Host "Opción inválida." -ForegroundColor Red }
    }
}

function Ver-Agenda {
    Mostrar-Titulo
    Write-Host "Ver agenda" -ForegroundColor Cyan
    Write-Host ""

    if (Test-Path ".\Contactos.bin") {
        $contactos = Get-Content ".\Contactos.bin"

        # Agrupar en bloques de 5 líneas: (Contacto_X:, Nombre, Número, Empresa, línea en blanco)
        $bloques = @()
        for ($i=0; $i -lt $contactos.Count; $i+=5) {
            if ($i + 3 -lt $contactos.Count) {
                $bloques += ,@($contactos[$i..($i+3)])
            }
        }

        # ✅ Opción 0 para regresar
        Write-Host "0. Regresar" -ForegroundColor DarkRed

        $j = 1
        foreach ($b in $bloques) {
            $nombre = $b[1]
            $numero = $b[2]
            $empresa = $b[3]
            Write-Host "$j. $nombre - $numero - $empresa" -ForegroundColor Yellow
            $j++
        }

        Write-Host ""
        $opSel = Read-Host "Selecciona un contacto (digita número) o 0 para regresar:"

        if ($opSel -eq "0") {
            Menu-Contactos
            return
        }

        if ($opSel -match '^\d+$' -and [int]$opSel -le $bloques.Count) {
            $seleccion = $bloques[[int]$opSel-1]
            $nombre = $seleccion[1]
            $numero = $seleccion[2]
            $empresa = $seleccion[3]

            $info = Obtener-PaisLocal
            $paisLocal = $info.Pais
            $indicativo = $info.Indicativo

            Write-Host ""
            Write-Host "Este número celular es de $paisLocal ? ENTER para confirmar, ESC para otro país." -ForegroundColor White
            $key = [Console]::ReadKey($true)

            if ($key.Key -eq "Enter") {
                # ✅ ENTER: guarda número + indicativo
                $Global:NumeroSeleccionado = $numero
                $Global:IndicativoSeleccionado = $indicativo

                Mostrar-Titulo
                $mensaje = Read-Host "Escribe el mensaje a enviar"
                $mensajeEncoded = [System.Web.HttpUtility]::UrlEncode($mensaje)
                $url = "https://api.whatsapp.com/send?phone=$($indicativo.Replace('+',''))$numero&text=$mensajeEncoded"
                Start-Process $url
                Menu-Contactos
            } elseif ($key.Key -eq "Escape") {
                # ✅ ESC: guarda número, limpia indicativo y redirige a continentes
                $Global:NumeroSeleccionado = $numero
                $Global:IndicativoSeleccionado = $null
                Opcion-VerIndicativos
            }
        } else {
            Write-Host "Selección inválida, intenta de nuevo." -ForegroundColor Red
            Start-Sleep -Seconds 2
            Ver-Agenda
        }
    } else {
        Write-Host "No hay contactos guardados aún." -ForegroundColor Red
        Start-Sleep -Seconds 2
        Menu-Contactos
    }
}

function Agregar-Contacto {
    do {
        Mostrar-Titulo
        Write-Host "Agregar contacto" -ForegroundColor Cyan
        Write-Host ""

        # ✅ Opción 0 para regresar
        Write-Host "0. Regresar" -ForegroundColor DarkRed
        Write-Host ""

        $nombre = Read-Host "Agrega Nombre(s) y Apellido(s) (o digita 0 para regresar)"
        if ($nombre -eq "0") {
            Menu-Contactos
            return
        }
        if ([string]::IsNullOrWhiteSpace($nombre)) {
            Write-Host "El nombre no puede estar vacío." -ForegroundColor Red
            Start-Sleep -Seconds 2
            continue
        }

        $numero = Read-Host "Agrega Número celular sin indicativo (o digita 0 para regresar)"
        if ($numero -eq "0") {
            Menu-Contactos
            return
        }
        if ([string]::IsNullOrWhiteSpace($numero)) {
            Write-Host "El número no puede estar vacío." -ForegroundColor Red
            Start-Sleep -Seconds 2
            continue
        }
        if ($numero -notmatch '^\d+$') {
            Write-Host "El número debe contener solo dígitos." -ForegroundColor Red
            Start-Sleep -Seconds 2
            continue
        }

        $empresa = Read-Host "Empresa (o digita 0 para regresar)"
        if ($empresa -eq "0") {
            Menu-Contactos
            return
        }
        if ([string]::IsNullOrWhiteSpace($empresa)) {
            Write-Host "La empresa no puede estar vacía." -ForegroundColor Red
            Start-Sleep -Seconds 2
            continue
        }

        # Contar cuántos contactos hay ya en el archivo
        $contador = 0
        if (Test-Path ".\Contactos.bin") {
            $lineas = Get-Content ".\Contactos.bin"
            $contador = ($lineas | Where-Object { $_ -like "Contacto_*:" }).Count
        }

        Write-Host ""
        Write-Host "Contacto_$($contador+1):" -ForegroundColor Yellow
        Write-Host $nombre -ForegroundColor Yellow
        Write-Host $numero -ForegroundColor Yellow
        Write-Host $empresa -ForegroundColor Yellow
        Write-Host ""
        Write-Host "¿Los datos son correctos? ENTER para guardar, ESC para reiniciar." -ForegroundColor White
        $key = [Console]::ReadKey($true)

        if ($key.Key -eq "Enter") {
            Add-Content ".\Contactos.bin" "Contacto_$($contador+1):"
            Add-Content ".\Contactos.bin" $nombre
            Add-Content ".\Contactos.bin" $numero
            Add-Content ".\Contactos.bin" $empresa
            Add-Content ".\Contactos.bin" ""   # línea en blanco de separación

            Write-Host ""
            Write-Host ">> Contacto guardado." -ForegroundColor Green
            Start-Sleep -Seconds 2
            Menu-Contactos
            break
        } elseif ($key.Key -eq "Escape") {
            # Reinicia el ciclo de ingreso
            continue
        }
    } while ($true)
}

function Eliminar-Contacto {
    do {
        Mostrar-Titulo
        Write-Host "Eliminar contacto" -ForegroundColor Cyan
        Write-Host ""

        if (Test-Path ".\Contactos.bin") {
            $contactos = Get-Content ".\Contactos.bin"

            # Agrupar en bloques de 5 líneas: (Contacto_X:, Nombre, Número, Empresa, línea en blanco)
            $bloques = @()
            for ($i=0; $i -lt $contactos.Count; $i+=5) {
                if ($i + 3 -lt $contactos.Count) {
                    $bloques += ,@($contactos[$i..($i+3)])
                }
            }

            # ✅ Opción 0 para regresar
            Write-Host "0. Regresar" -ForegroundColor DarkRed

            $j = 1
            foreach ($b in $bloques) {
                $nombre = $b[1]
                $numero = $b[2]
                $empresa = $b[3]
                Write-Host "$j. $nombre - $numero - $empresa" -ForegroundColor Yellow
                $j++
            }

            Write-Host ""
            $opSel = Read-Host "Selecciona un contacto (digita número) o 0 para regresar:"

            if ($opSel -eq "0") {
                Menu-Contactos
                return
            }

            if ($opSel -match '^\d+$' -and [int]$opSel -le $bloques.Count) {
                $seleccion = $bloques[[int]$opSel-1]
                $nombre = $seleccion[1]
                $numero = $seleccion[2]
                $empresa = $seleccion[3]

                Write-Host ""
                Write-Host "¿Estás seguro de eliminar $nombre - $numero - $empresa ?" -ForegroundColor Red
                Write-Host "ENTER para confirmar, ESC para cancelar." -ForegroundColor White
                $key = [Console]::ReadKey($true)

                if ($key.Key -eq "Enter") {
                    # ✅ ENTER: eliminamos el bloque completo
                    $nuevoListado = @()
                    foreach ($b in $bloques) {
                        if ($b[1] -ne $nombre -or $b[2] -ne $numero -or $b[3] -ne $empresa) {
                            $nuevoListado += $b
                            $nuevoListado += ""  # línea en blanco de separación
                        }
                    }
                    $nuevoListado | Set-Content ".\Contactos.bin"

                    Write-Host ""
                    Write-Host ">> Contacto eliminado." -ForegroundColor Green
                    Start-Sleep -Seconds 2
                    Menu-Contactos
                    break
                } elseif ($key.Key -eq "Escape") {
                    # ✅ ESC: recargamos listado
                    Eliminar-Contacto
                }
            } else {
                Write-Host "Selección inválida, intenta de nuevo." -ForegroundColor Red
                Start-Sleep -Seconds 2
                Eliminar-Contacto
            }
        } else {
            Write-Host "No hay contactos guardados aún." -ForegroundColor Red
            Start-Sleep -Seconds 2
            Menu-Contactos
            break
        }
    } while ($true)
}

function Modificar-Contacto {
    do {
        Mostrar-Titulo
        Write-Host "Modificar contacto" -ForegroundColor Cyan
        Write-Host ""

        if (Test-Path ".\Contactos.bin") {
            $contactos = Get-Content ".\Contactos.bin"

            # Agrupar en bloques de 5 líneas: (Contacto_X:, Nombre, Número, Empresa, línea en blanco)
            $bloques = @()
            for ($i=0; $i -lt $contactos.Count; $i+=5) {
                if ($i + 3 -lt $contactos.Count) {
                    $bloques += ,@($contactos[$i..($i+3)])
                }
            }

            # ✅ Opción 0 para regresar
            Write-Host "0. Regresar" -ForegroundColor Red

            $j = 1
            foreach ($b in $bloques) {
                $nombre = $b[1]
                $numero = $b[2]
                $empresa = $b[3]
                Write-Host "$j. $nombre - $numero - $empresa" -ForegroundColor Yellow
                $j++
            }

            Write-Host ""
            $opSel = Read-Host "Selecciona un contacto para modificar (digita número) o 0 para regresar:"

            if ($opSel -eq "0") {
                MenuPrincipal
                return
            }

            if ($opSel -match '^\d+$' -and [int]$opSel -le $bloques.Count) {
                $seleccion = $bloques[[int]$opSel-1]
                $nombreActual = $seleccion[1]
                $numeroActual = $seleccion[2]
                $empresaActual = $seleccion[3]

                Write-Host ""
                Write-Host "Contacto actual: $nombreActual - $numeroActual - $empresaActual" -ForegroundColor Cyan

                # ✅ Nuevos datos con opción 0 para regresar
                $nuevoNombre = Read-Host "Nuevo nombre (o digita 0 para regresar)"
                if ($nuevoNombre -eq "0") { MenuPrincipal; return }
                if ([string]::IsNullOrWhiteSpace($nuevoNombre)) { $nuevoNombre = $nombreActual }

                $nuevoNumero = Read-Host "Nuevo número celular (o digita 0 para regresar)"
                if ($nuevoNumero -eq "0") { MenuPrincipal; return }
                if ([string]::IsNullOrWhiteSpace($nuevoNumero)) { $nuevoNumero = $numeroActual }
                if ($nuevoNumero -notmatch '^\d+$') {
                    Write-Host "El número debe contener solo dígitos." -ForegroundColor Red
                    Start-Sleep -Seconds 2
                    continue
                }

                $nuevaEmpresa = Read-Host "Nueva empresa (o digita 0 para regresar)"
                if ($nuevaEmpresa -eq "0") { MenuPrincipal; return }
                if ([string]::IsNullOrWhiteSpace($nuevaEmpresa)) { $nuevaEmpresa = $empresaActual }

                Write-Host ""
                Write-Host "¿Confirmas la modificación a: $nuevoNombre - $nuevoNumero - $nuevaEmpresa ?" -ForegroundColor Yellow
                Write-Host "ENTER para confirmar, ESC para cancelar." -ForegroundColor White
                $key = [Console]::ReadKey($true)

                if ($key.Key -eq "Enter") {
                    # ✅ Reemplazar bloque
                    $nuevoListado = @()
                    foreach ($b in $bloques) {
                        if ($b[1] -eq $nombreActual -and $b[2] -eq $numeroActual -and $b[3] -eq $empresaActual) {
                            $nuevoListado += $b[0]   # etiqueta Contacto_X:
                            $nuevoListado += $nuevoNombre
                            $nuevoListado += $nuevoNumero
                            $nuevoListado += $nuevaEmpresa
                            $nuevoListado += ""       # línea en blanco
                        } else {
                            $nuevoListado += $b
                            $nuevoListado += ""
                        }
                    }
                    $nuevoListado | Set-Content ".\Contactos.bin"

                    Write-Host ""
                    Write-Host ">> Contacto modificado correctamente." -ForegroundColor Green
                    Start-Sleep -Seconds 2
                    MenuPrincipal
                    break
                } elseif ($key.Key -eq "Escape") {
                    Modificar-Contacto
                }
            } else {
                Write-Host "Selección inválida, intenta de nuevo." -ForegroundColor Red
                Start-Sleep -Seconds 2
                Modificar-Contacto
            }
        } else {
            Write-Host "No hay contactos guardados aún." -ForegroundColor Red
            Start-Sleep -Seconds 2
            MenuPrincipal
            break
        }
    } while ($true)
}

# ==============================
# MENÚ PRINCIPAL
# ==============================
function Mostrar-Menu {
    Mostrar-Titulo
    $paisLocal = (Obtener-PaisLocal).Pais
    Write-Host "Selecciona la opción más conveniente:" -ForegroundColor White
    Write-Host ""
    Write-Host "1. Enviar mensaje a número celular en $paisLocal" -ForegroundColor Yellow
    Write-Host "2. Ver listado de indicativos" -ForegroundColor DarkYellow
    Write-Host "3. Contactos" -ForegroundColor DarkGreen
    Write-Host "4. Finalizar" -ForegroundColor DarkRed
    Write-Host ""
    Write-Host "Creado por Diego Garcia R. y Microsoft Copilot" -ForegroundColor Cyan
	Write-Host ""
}

# Ciclo principal
do {
    Mostrar-Menu
    $opcion = Read-Host "Ingresa tu opción (1-4)"

    switch ($opcion) {
        1 {
            # Opción 1: Enviar mensaje a número celular en $paisLocal
            Opcion-EnviarMensaje
        }
        2 {
            # Opción 2: Ver listado de indicativos
            Opcion-VerIndicativos
        }
        3 {
            # Opción 3: Submenú de contactos
            Menu-Contactos
        }
        4 {
            # Opción 4: Finalizar
            Write-Host ""
            Write-Host ">> Finalizando..." -ForegroundColor DarkRed
        }
        default {
            Write-Host ""
            Write-Host "Opción inválida, intenta de nuevo." -ForegroundColor Red
        }
    }

} while ($opcion -ne 4)
