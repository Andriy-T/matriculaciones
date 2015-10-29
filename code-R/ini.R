##################################################################
# fichero a ejecutar al iniciarla sesion
##################################################################

if (Sys.info()["user"] == "Alfonso") DirCode <- "C:/Alfonso/cosas/software/R/matriculaciones/code-R" else
  DirCode <- "C:/Users/Andrey/Documents/GitHub/matriculaciones/code-R" 

#### directorio Proyecto y librerias ####
if (Sys.info()["user"] == "Alfonso") DirPro  <- "C:/Users/Alfonso/Dropbox/proyectos/dgt" else
  DirPro  <- "C:/Users/Andrey/Dropbox/dgt"


CargaIniPro <- T # si CargaIniPro es TRUE cargamos las librerias, funciones y datos
                    # en otro caso solamente se cargan las librerias

# cargar librerias
print ("Cargando librerias")
source(file.path(DirCode, "librerias.R"))
# cargar funciones
print ("Cargando funciones")
if(CargaIniPro) source(file.path(DirCode, "funciones.R"))
# cargar data
print ("Cargando data")
if(CargaIniPro) source(file.path(DirCode, "data.R"))
# cargar data
print ("Cargando tablas")
if(CargaIniPro) source(file.path(DirCode, "tablas.R"))
