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
Fast  <- F  #Si Fast es TRUE se recupera la última carga de datos almacenada en disco. Si no se recargan los ficheros originales

#### Parametros  de carga ####
DirDat   <- file.path(DirPro, "data" )
fichDatRaw  <- "dat201412201509.rds" #fichDat  <- "dat201412201503.rds"
fichDatTur  <- "datTur201412201509.rds" #fichDat  <- "dat201412201503.rds"
fichAux  <- "tablas_aux.rds" 
fichMod  <- "modelos.xlsx"
HojMod <- "Estudio modelos veh"
fechIni  <- as.Date('2014-12-01')
fechEnd  <- as.Date('2015-09-30')

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
  # Data Turismos (procesado)
  data_set_def <-
    readRDS(file.path(DirDat, fichDatTur))
  data_set_def$FEC_MATRICULA  <- as.Date(data_set_def$FEC_MATRICULA ,"%Y-%m-%d") 
  data_set_def$CILINDRADA_ITV <- as.numeric(as.character(data_set_def$CILINDRADA_ITV ))
  data_set_def$KW_ITV         <- as.numeric(as.character(data_set_def$KW_ITV))
  data_set_def$POTENCIA_ITV <- as.numeric(as.character(data_set_def$POTENCIA_ITV))
  data_set_def$NUM_PLAZAS <- as.numeric(as.character(data_set_def$NUM_PLAZAS))
  data_set_def$CO2_ITV <- as.numeric(as.character(data_set_def$CO2_ITV))
  data_set_def$CONSUMO.WH.KM_ITV <- as.numeric(as.character(data_set_def$CONSUMO.WH.KM_ITV))
  setDT(data_set_def) 
} else{ source(file.path(DirCode, "data_slow.R")) }
cat ("Data OK! \n") 


# cargar tablas
cat ("Cargando tablas... \n")
if(CargaIniPro) source(file.path(DirCode, "tablas.R"))
cat ("Tablas OK! \n")

# generar los graficos
cat ("Dibujando los graficos... \n")
if(CargaIniPro) source(file.path(DirCode, "graficos.R"))
cat ("Gráficos OK! \n")

