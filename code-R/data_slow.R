###################################################################################+
###  Proyecto Automovil
###  data_slow.r
###  Carga los datos de matriculaciones y filtra registros incorrectos
###  NO carga los datos auxiliares
###################################################################################+


# los parametros se especifican en data.r
# DirDat   <- file.path(DirPro, "data" )
# fichDat  <- "dat201412201509.rds" #fichDat  <- "dat201412201503.rds"
# fichAux  <- "tablas_aux.rds" 
# fichMod  <- "modelos.xlsx"
#   HojMod <- "Estudio modelos veh"
# fechIni  <- as.Date('2014-12-01')
# fechEnd  <- as.Date('2015-09-30')
# 
# col_sel <- c("FEC_MATRICULA", "DESCRIPCION_LARGA", "MODELO"
#              , "COD_PROCEDENCIA", "COD_PROPULSION", "CILINDRADA"
#              , "POTENCIA", "COD_PROVINCIA_MAT", "CODIGO_POSTAL"
#              , "SEXO", "KW", "NUM_PLAZAS", "CO2", "FABRICANTE"
#              , "CATEGORIA_HOMOLOGACION_EUROPEA", "NIVEL_EMISIONES_EURO"
#              , "CONSUMO", "CLASIFICACION_REGLAMENTO_VEHICULOS")
# colFech <- c("FEC_MATRICULA","FEC_TRAMITACION","FEC_TRAMITE","FEC_PRIM_MATRICULACION","FEC_DESCONOCIDA")


# raw data
data_all <- 
    readRDS(file.path(DirDat, fichDatRaw))
setDT(data_all)


#### filtros

# eliminacion de fechas anteriores a fechaIni y porsteriores a fechaEnd
numReg <- length(data_all[[1]])
data_all <- data_all[FEC_MATRICULA >= fechIni  & FEC_MATRICULA <= fechEnd]
if (numReg != length(data_all[[1]]) ){
  warning(cat("Eliminados", numReg - length(data_all[[1]]) , "registros ("
              ,100*round((numReg - length(data_all[[1]])) /numReg,4)
              ,"%) debido a fechas anteriores a ",as.character(fechIni)
              ," y porsteriores a ", as.character(fechEnd),"\n"))        
}

# eliminacion de bastidores que no tengan 17 caracteres
numReg <- length(data_all[[1]])
data_all[,BASTIDOR := as.character(BASTIDOR)]
bast_17 <- data_all[nchar(as.character(gsub("^\\s+|\\s+$", "",BASTIDOR)))==17,]
if (length(bast_17[[1]] ) != numReg ){ 
  warning(cat("Eliminados", numReg - length(bast_17[[1]]) , "registros ("
              ,100*round((numReg - length(bast_17[[1]]))/ numReg,4)
              ,"%) con num bastidor != 17 caracteres\n" ))
}

# eliminacion de bastidores repetidos
############################################################################################
# Esto no está bien estás pillando los bastidores que aparecen una vez
############################################################################################
# bast_17[,.N,by=BASTIDOR][,.N,by=N]
# bast_unico <- bast_17[,.N,by=BASTIDOR][order(N, decreasing = T)]
# data_set <- bast_17[BASTIDOR %in% bast_unico[N==1, BASTIDOR],]

# Hay un unique que hace esto que si no es un pollo
setkey(bast_17, BASTIDOR)
data_set <- unique(bast_17)
if (length(data_set[[1]]) != numReg ){ 
  warning(cat("Eliminados ", numReg - length(data_set[[1]]) , "registros ("
              ,100*round((numReg - length(data_set[[1]]))/ numReg,4)
              ,"%) debido a bastidores repetidos\n" ))
}

# nos quedamos con data_set que son los valores unicos por vehÃ???culo
rm(bast_17,data_all)
gc()

# trabajamos con 2 data_set:
# 1 para grÃ¡ficos-descriptivos generales (turismos principalmente)
# 2 para evoluciones por marca (aqui seleccionamos las principales)

# filtramos solo turismos y todo terreno para la primera aproximaciÃ³n
# data_set[,.N, by= COD_TIPO][order(N, decreasing = T)]
data_set <- data_set[COD_TIPO == "40" | COD_TIPO == "25"]



# Unificamos en los modelos de vehciculos
# 1 eliminamos espacios y caracteres raros
# 2 quitamos la marca del nombre del modelo

# Para que las marcas de todos los ficheros tengan la misma longitud
data_set[, DESCRIPCION_LARGA := substr(as.character(DESCRIPCION_LARGA),1,23)] 

data_set[, modelo2 := as.character(MODELO)]
data_set[, modelo2 := func.ToName(modelo2)]
data_set[, modelo2 :=  gsub(CTE_ToName_sep, "", modelo2, fixed = T)]
data_set[, marca2 := as.character(DESCRIPCION_LARGA)]
data_set[, marca2 := func.ToName(marca2)]
data_set[, marca2 :=  gsub(CTE_ToName_sep, "", marca2, fixed = T)]
data_set[, modelo2 :=  mapply(gsub, marca2, "", modelo2, fixed= T)]

# asignar el 'MODELO' más usado a cada modelo2

#data_set2 = copy(data_set)
#data_set = copy(data_set2)
setkey(data_set,"marca2")
# data_set  <-  data_set[marca2 == "BMW"]
data_set[,N:=.N, by = "marca2,MODELO"] 
data_set[,M:=max(N), by= "marca2,modelo2"] 

tab <- data_set[N == M, c("modelo2", "MODELO", "DESCRIPCION_LARGA","marca2"),with = F]
setkeyv(tab,c("modelo2", "marca2"))
tab <- unique(tab)
data_set[,MODELO := NULL]
data_set[,DESCRIPCION_LARGA := NULL]
data_set[,M := NULL]
data_set_def  <- merge(data_set, tab, all.x = F,by.x = c("modelo2", "marca2"), by.y = c("modelo2", "marca2"))
# kk <- head(data_set0, 100)

# seleccionamos las columnas que vamos a utilizar para los graficos
# data_set[,.N, by= CLASIFICACION_REGLAMENTO_VEHICULOS][order(N, decreasing = T)]
data_set_def <- data_set_def[,col_sel, with=F]

# filtraremos por marca/modelo

# data_set_def <- 
#     data_set_def[DESCRIPCION_LARGA %in% data_modelos[["marca"]] &
#              MODELO %in% data_modelos[["modelo"]]]

saveRDS(data_set_def, file.path(DirDat, fichDatTur))

