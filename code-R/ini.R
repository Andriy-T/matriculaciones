# fichero a ejecutar al iniciarla sesi?n

if(Sys.info()[7] == "Alfonso")
    DirCode <- "C:/Users/Alfonso/Documents/GitHub/matriculaciones/code-R"
if(Sys.info()[7] == "Andrey")
    DirCode <- "C:/Users/Andrey/Documents/GitHub/matriculaciones/code-R"

#### directorio Proyecto y librerias ####
# DirPro  <- "C:/Users/Alfonso/Dropbox/proyectos/dgt"
DirPro  <- "C:/Users/Andrey/Dropbox/dgt"

CargaIniPro <- TRUE # si CargaIniPro es TRUE cargamos las funciones y datos
                    # en otro caso solamente se cargan las librer?as

# cargar librerias
if(!CargaIniPro) source(file.path(DirCode, "librerias.R"))
# cargar funciones
if(CargaIniPro) source(file.path(DirCode, "funciones.R"))
# cargar data
if(CargaIniPro) source(file.path(DirCode, "data.R"))
