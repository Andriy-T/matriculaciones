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
fichAux  <- "tablas_aux.rds" 
fichMod  <- "modelos.xlsx"
  HojMod <- "Estudio modelos veh"
fichDat  <- "dat201412201503.rds"   #  "dat201501.rds" # 

col_sel <- c("FEC_MATRICULA", "DESCRIPCION_LARGA", "MODELO"
             , "COD_PROCEDENCIA", "COD_PROPULSION", "CILINDRADA"
             , "POTENCIA", "COD_PROVINCIA_MAT", "CODIGO_POSTAL"
             , "SEXO", "KW", "NUM_PLAZAS", "CO2", "FABRICANTE"
             , "CATEGORIA_HOMOLOGACION_EUROPEA", "NIVEL_EMISIONES_EURO"
             , "CONSUMO", "CLASIFICACION_REGLAMENTO_VEHICULOS")


#### Carga datos y filtros ####

# tablas auxiliares
data_aux <- readRDS(file.path(DirDat, fichAux))


# tabla de modelos
data_modelos <- 
    read.xlsx(file.path(DirDat, HojMod, fichMod)
              , sheetIndex = 3, startRow = 1, endRow = 154, colIndex = 1:3
              , header = T, stringsAsFactors = F)

# raw data
data_all <- 
    readRDS(file.path(DirDat, "dat201412201503.rds"))
setDT(data_all)

# data_all <- data_all[COD_CLASE_MAT==0]

# eliminacion de varios registros por vehi?culo
data_all[,BASTIDOR := as.character(BASTIDOR)]

bast_resto <- data_all[nchar(as.character(gsub("^\\s+|\\s+$", "",BASTIDOR)))!=17,]
bast_17 <- data_all[nchar(as.character(gsub("^\\s+|\\s+$", "",BASTIDOR)))==17,]

# nrow(bast_resto)+nrow(bast_17)

# comprobando los bastidores correctos unicos
bast_17[,.N,by=BASTIDOR][,.N,by=N]
bast_unico <- bast_17[,.N,by=BASTIDOR][order(N, decreasing = T)]

bast_17_unico <- bast_17[BASTIDOR %in% bast_unico[N==1, BASTIDOR],]
bast_17_no_unico <- bast_17[BASTIDOR %in% bast_unico[N!=1,BASTIDOR],]
nrow(bast_17_unico)+nrow(bast_17_no_unico)

nrow(bast_17_unico)/nrow(data_all)

data_set <- bast_17_unico
rm(bast_17, bast_17_no_unico, bast_17_unico, bast_unico, bast_resto)
gc()


# nos quedamos con data_set que son los valores unicos por vehículo
rm(data_all)

# trabajamos con 2 data_set:
# 1 para gráficos-descriptivos generales (turismos principalmente)
# 2 para evoluciones por marca (aqui seleccionamos las principales)

# filtramos solo turismos para la primera aproximación
data_set[,.N, by= COD_TIPO][order(N, decreasing = T)]
data_set_turismos <- data_set[COD_TIPO == "40"]

# seleccionamos las columnas que vamos a utilizar para los graficos
data_set_turismos[,.N, by= CLASIFICACION_REGLAMENTO_VEHICULOS][order(N, decreasing = T)]


data_set_def <- data_set_turismos[,col_sel, with=F]
rm(data_set, data_set_turismos)
gc()
# filtraremos por marca/modelo

# data_set_modelos <- 
#     data_set_def[DESCRIPCION_LARGA %in% data_modelos[["marca"]] &
#              MODELO %in% data_modelos[["modelo"]]]



