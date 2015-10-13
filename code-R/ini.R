# fichero a ejecutar al iniciarla sesión

# DirCode <- "C:/Users/Alfonso/Documents/GitHub/matriculaciones/code-R"  # ¡¡¡ cambiar
DirCode <- "C:/Users/Andrey/Documents/GitHub/matriculaciones/code-R"

#### directorio Proyecto y librerias ####
# DirPro  <- "C:/Users/Alfonso/Dropbox/proyectos/dgt"
DirPro  <- "C:/Users/Andrey/Dropbox/dgt"

CargaIniPro <- TRUE # si CargaIniPro es TRUE cargamos las funciones y datos
                    # en otro caso solamente se cargan las librerías

# cargar librerias
if(!CargaIniPro) source(file.path(DirCode, "librerias.R"))
# cargar funciones
if(CargaIniPro) source(file.path(DirCode, "funciones.R"))
# cargar data
if(CargaIniPro) source(file.path(DirCode, "data.R"))
