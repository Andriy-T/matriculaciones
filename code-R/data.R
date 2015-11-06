###################################################################################+
###  Proyecto Automovil
###  data_v2.r
###  Carga los datos de matriculaciones y filtra registros incorrectos
###################################################################################+


# todas las transformaciones/filtros a partir de raw_data
# tabla resultante tiene que llevar todo lo necesaria para la app
# posteriores filtros sobre la tabla se realizan en shiny server.R

#### Parametros ####
DirDat   <- file.path(DirPro, "data" )
fichDatRaw  <- "dat201412201509.rds" #fichDat  <- "dat201412201503.rds"
fichDatTur  <- "datTur201412201509.rds" #fichDat  <- "dat201412201503.rds"
fichAux  <- "tablas_aux.rds" 
fichMod  <- "modelos.xlsx"
  HojMod <- "Estudio modelos veh"
fechIni  <- as.Date('2014-12-01')
fechEnd  <- as.Date('2015-09-30')

col_sel <- c("FEC_MATRICULA", "DESCRIPCION_LARGA", "MODELO"
             , "COD_PROCEDENCIA", "COD_PROPULSION", "CILINDRADA"
             , "POTENCIA", "COD_PROVINCIA_MAT", "CODIGO_POSTAL"
             , "SEXO", "KW", "NUM_PLAZAS", "CO2", "FABRICANTE"
             , "CATEGORIA_HOMOLOGACION_EUROPEA", "NIVEL_EMISIONES_EURO"
             , "CONSUMO", "CLASIFICACION_REGLAMENTO_VEHICULOS")
colFech <- c("FEC_MATRICULA","FEC_TRAMITACION","FEC_TRAMITE","FEC_PRIM_MATRICULACION","FEC_DESCONOCIDA")

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
  setDT(data_set_def) 
} else{ source(file.path(DirCode, "data_slow.R")) }



