##################################################################
# fichero a ejecutar al iniciarla sesion
##################################################################


if (Sys.info()["user"] == "Alfonso") DirCode <- "C:/Alfonso/cosas/software/R/matriculaciones/code-R" 
else  DirCode <- "C:/Users/Andrey/Documents/GitHub/matriculaciones/code-R" 
DirCode <- "C:/Users/Andrey/Documents/GitHub/matriculaciones/code-R"

#### directorio Proyecto y librerias ####
# DirPro  <- "C:/Users/Alfonso/Dropbox/proyectos/dgt"

if (Sys.info()["user"] == "Alfonso") DirPro  <- "C:/Users/Alfonso/Dropbox/proyectos/dgt"
else  DirPro  <- "C:/Users/Andrey/Dropbox/dgt"

CargaIniPro <- TRUE # si CargaIniPro es TRUE cargamos las funciones y datos
# en otro caso solamente se cargan las librerias

if(!CargaIniPro) source(file.path(DirCode, "librerias.R"))
if(CargaIniPro) source(file.path(DirCode, "funciones.R"))
# cargar data
if(CargaIniPro) source(file.path(DirCode, "data.R"))
