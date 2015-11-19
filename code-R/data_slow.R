###################################################################################+
###  Proyecto Automovil
###  data_slow.r
###  Carga los datos de matriculaciones y filtra registros incorrectos
###  NO carga los datos auxiliares
###################################################################################+


# los parametros se especifican en ini.r
# DirDat   <- file.path(DirPro, "data" )
# fichDat  <- "dat201412201509.rds" #fichDat  <- "dat201412201503.rds"
# fichAux  <- "tablas_aux.rds" 
# fichMod  <- "modelos.xlsx"
#   HojMod <- "Estudio modelos veh"
# fechIni  <- as.Date('2014-12-01')
# fechEnd  <- as.Date('2015-09-30')
# 
col_sel <- c("FEC_MATRICULA", "DESCRIPCION_LARGA", "MODELO"
             , "COD_PROCEDENCIA", "COD_PROPULSION", "CILINDRADA"
             , "POTENCIA", "COD_PROVINCIA_MAT", "CODIGO_POSTAL"
             , "SEXO", "KW", "NUM_PLAZAS", "CO2", "FABRICANTE"
             , "CATEGORIA_HOMOLOGACION_EUROPEA", "NIVEL_EMISIONES_EURO"
             , "CONSUMO", "CLASIFICACION_REGLAMENTO_VEHICULOS"
             , "modelo1"
)
colFech <- c("FEC_MATRICULA","FEC_TRAMITACION","FEC_TRAMITE","FEC_PRIM_MATRICULACION","FEC_DESCONOCIDA")


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

# data_set <- data_set0
# Para que las marcas de todos los ficheros tengan la misma longitud
data_set[, DESCRIPCION_LARGA := substr(as.character(DESCRIPCION_LARGA),1,23)] 

# eliminaos espacios del modelo
data_set[, MODELO := as.character(gsub("^\\s+|\\s+$", "",MODELO))]

# marca 1 = primera palabra de la marca 
f1 <- function(x){x[1]}
data_set$marca1 <-   sapply(data_set$DESCRIPCION_LARGA, strsplit, " ", simplify = T,fixed= T)
data_set$marca1 <-   sapply(data_set$marca1, f1, simplify = T)

# modelo 1 = primera palabra de la marca 
data_set$modelo1 <- sapply(as.character(data_set$MODELO), strsplit, " ", simplify = T,fixed= T)
data_set$modelo1 <- sapply(data_set$modelo1, f1, simplify = T)


# marca 2 = marca sin espacios 
data_set[, marca2 := as.character(DESCRIPCION_LARGA)]
data_set[, marca2 := gsub("^\\s+|\\s+$", "",marca2)]
#eliminamos del MODELO la marca
data_set[, MODELO :=  mapply(gsub, marca2, "", MODELO, fixed= T)]
data_set[, MODELO :=  mapply(gsub, marca1, "", MODELO, fixed= T)]

# eliminaos carcateres raros de MODELO
data_set[, MODELO := as.character(gsub("^\\s+|\\s+$", "",MODELO))]
data_set[, modelo2 := func.ToName(MODELO)]
data_set[, modelo2 :=  gsub(CTE_ToName_sep, "", modelo2, fixed = T)]


# eliminaos espacios y carcateres raros de MARCA
data_set[, marca2 := as.character(DESCRIPCION_LARGA)]
data_set[, marca2 := func.ToName(marca2)]
data_set[, marca2 :=  gsub(CTE_ToName_sep, "", marca2, fixed = T)]

data_set[, codItv2 :=  substr(as.character(CODIGO_ITV),1,8)]


data_set2 <- copy(data_set)
setkey(data_set2,"codItv2")
data_set2 <- data_set2[codItv2 != "        "]
data_set2 <- data_set2[modelo2 != ""]

# asignar la marca más frecuente a cada codItv2
data_set2[,N:=.N, by = "codItv2,marca2"] 
data_set2[,M:=max(N), by= "codItv2"] 
tab <- data_set2[N == M, c("codItv2","DESCRIPCION_LARGA","marca1","marca2"),with = F]
setkeyv(tab,c("codItv2"))
tab <- unique(tab)
data_set2[,DESCRIPCION_LARGA := NULL]
data_set2[,marca1 := NULL]
data_set2[,marca2 := NULL]
data_set2[,M := NULL]
data_set2[,N := NULL]
# data_set2[,DESCRIPCION_LARGA := NULL]
data_set2  <- merge(data_set2, tab, all.x = F,by.x = c("codItv2"), by.y = c("codItv2"))
#eliminamos del MODELO la marca
data_set2[, MODELO :=  mapply(gsub, marca2, "", MODELO, fixed= T)]
data_set2[, MODELO :=  mapply(gsub, marca1, "", MODELO, fixed= T)]
data_set2 <- rbind(data_set2,data_set[codItv2 == "        " | modelo2 == ""])

# 
# kk <-data_set2[marca2.x!=marca2.y]
# kk <- kk[,N:=.N,by ="codItv2,MODELO.x,modelo1.x,modelo2.x,DESCRIPCION_LARGA.x,marca2.x,MODELO.y,modelo1.y,modelo2.y,DESCRIPCION_LARGA.y,marca2.y"]
# kk <- kk[,c("codItv2","MODELO.x","modelo1.x","modelo2.x","DESCRIPCION_LARGA.x","marca2.x","MODELO.y","modelo1.y","modelo2.y","DESCRIPCION_LARGA.y","marca2.y","N"),with =F]
# kk <- kk[N !=1,]
# kk <- unique(kk)
# setkey(kk,"N")
# View(kk)       


# asignar el 'MODELO' más frecuente a cada codItv2
# data_set  <-  data_set[marca2 == "BMW"]
data_set2[,N:=.N, by = "codItv2,MODELO"] 
data_set2[,M:=max(N), by= "codItv2"] 
tab <- data_set2[N == M, c("MODELO","codItv2","modelo1","modelo2","DESCRIPCION_LARGA","marca2"),with = F]
setkeyv(tab,c("codItv2"))
tab <- unique(tab)
data_set2[,MODELO := NULL]
data_set2[,modelo1 := NULL]
data_set2[,modelo2 := NULL]
data_set2[,DESCRIPCION_LARGA := NULL]
data_set2[,marca2 := NULL]
data_set2[,M := NULL]
data_set2[,N := NULL]
# data_set2[,DESCRIPCION_LARGA := NULL]
data_set2  <- merge(data_set2, tab, all.x = F,by.x = c("codItv2"), by.y = c("codItv2"))
data_set2 <- rbind(data_set2,data_set[codItv2 == "        " | modelo2 == ""])

# kk <- data_set_def[data_set_def$MODELO.x != data_set_def$MODELO.y, c("codItv2","MODELO.x","MODELO.y", "DESCRIPCION_LARGA.x","DESCRIPCION_LARGA.y","marca2.x","marca2.y","modelo2.x","modelo2.y"),with =F]
# View(kk)
# asignar el 'MODELO' más frecuente a cada modelo2
# data_set2  <-  data_set[marca2 == "BMW"]
data_set2_noMod  <-  data_set2[modelo2 == ""]
data_set2  <-  data_set2[modelo2 != ""]
setkey(data_set2,"marca2")
data_set2[,N:=.N, by = "marca2,MODELO"] 
data_set2[,M:=max(N), by= "marca2,modelo2"] 
# tab <- data_set2[N == M, c("modelo2", "MODELO", "DESCRIPCION_LARGA","marca2"),with = F]
tab <- data_set2[N == M, c("modelo2", "MODELO", "marca2","modelo1"),with = F]
setkeyv(tab,c("modelo2", "marca2"))
tab <- unique(tab)
data_set2[,MODELO := NULL]
data_set2[,modelo1 := NULL]
data_set2[,M := NULL]
data_set2[,N := NULL]
data_set2  <- merge(data_set2, tab, all.x = F,by.x = c("modelo2", "marca2"), by.y = c("modelo2", "marca2"))
# kk <- head(data_set0, 100)
data_set2 <- rbind(data_set2,data_set2_noMod)
# seleccionamos las columnas que vamos a utilizar para los graficos
# data_set[,.N, by= CLASIFICACION_REGLAMENTO_VEHICULOS][order(N, decreasing = T)]
data_set2[,CODIGO_ITV := as.factor(codItv2)]
data_set2[,DESCRIPCION_LARGA := as.factor(DESCRIPCION_LARGA)]
data_set2[,MODELO:= as.factor(MODELO)]
data_set2[,modelo1:= as.factor(modelo1)]
data_set2 <- data_set2[,col_sel, with=F]


# filtraremos por marca/modelo

# Pasar las columnas apropiadas a factor


data_set_def <- data_set2
saveRDS(data_set2, file.path(DirDat, fichDatTur))

