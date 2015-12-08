##################################################################
# fichero a ejecutar al iniciarla sesion
##################################################################

# Directorio de codigos
DirCode <- switch(Sys.info()["user"],
  "Alfonso" = "C:/Alfonso/cosas/software/R/matriculaciones/code-R",
  "Andrey" = "C:/Users/Andrey/Documents/Matriculaciones/matric_proj/matriculaciones/code-R"
                  )
    
# Directorio Proyecto y librerias
DirPro <- switch(Sys.info()["user"],
                  "Alfonso" = "C:/Users/Alfonso/Dropbox/proyectos/dgt",
                  "Andrey" = "C:/Users/Andrey/Dropbox/dgt"
)

#### Parametros  de carga ####

# Modos de carga
CargaIniPro <- T # si CargaIniPro es TRUE cargamos las librerias, funciones y datos
                    # en otro caso solamente se cargan las librerias
Fast  <- T  #Si Fast es TRUE se recupera la última carga de datos almacenada en disco. Si no se recargan los ficheros originales

# Periodo
fechIni  <- as.Date('2014-12-01')
fechEnd  <- as.Date('2015-09-30')

# directorio datos
DirDat   <- file.path(DirPro, "data" )
# nombres de ficheros con datos de matriculaciones
fichDatRaw  <- "dat201412201509.rds" #fichDat  <- "dat201412201503.rds"
fichDatTur  <- "datTur201412201509.rds" #fichDat  <- "dat201412201503.rds"
# nombres de ficheros con tablas auxiliares
fichAux  <- "tablas_aux.rds" 
fichMod  <- "modelos.xlsx"
HojMod <- "Estudio modelos veh"

# Ejecucion de codigos ######

# cargar librerias
cat ("Cargando librerias... \n")
source(file.path(DirCode, "librerias.R"))
cat ("Librerias cargadas! \n")
# cargar funciones
cat ("Cargando funciones... \n")
if(CargaIniPro) source(file.path(DirCode, "funciones.R"))
# cargar data
cat ("Funciones cargadas! \n")

cat ("Cargando data... \n")
# if(CargaIniPro) source(file.path(DirCode, "data.R"))

#### Carga datos ####
# tablas auxiliares
data_aux <- readRDS(file.path(DirDat, fichAux))

# tabla de modelos
data_modelos <- 
  read.xlsx(file.path(DirDat, HojMod, fichMod)
            , sheetIndex = 3, startRow = 1, endRow = 154, colIndex = 1:3
            , header = T, stringsAsFactors = F)

if (Fast){
    source(file.path(DirCode, "data_fast.R"))
} else {
    source(file.path(DirCode, "data_slow.R"))
}
cat ("Data OK! \n") 


# cargar tablas
cat ("Cargando tablas... \n")
if(CargaIniPro) source(file.path(DirCode, "tablas.R"))
cat ("Tablas OK! \n")

# generar los graficos
cat ("Dibujando los graficos... \n")
if(CargaIniPro) source(file.path(DirCode, "graficos.R"))
cat ("Gráficos OK! \n")

