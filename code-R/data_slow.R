###################################################################################+
###  Proyecto Automovil
###  data_slow.r
###  Carga los datos de matriculaciones y filtra registros incorrectos
###  NO carga los datos auxiliares
###################################################################################+

# lee raw data
# filtros
# Parametros

#### Parametros
# los parametros  de carga se especifican en ini.r
# DirDat   <- file.path(DirPro, "data" )
# fichDat  <- "dat201412201509.rds" #fichDat  <- "dat201412201503.rds"
# fichAux  <- "tablas_aux.rds" 
# fichMod  <- "modelos.xlsx"
#   HojMod <- "Estudio modelos veh"
# fechIni  <- as.Date('2014-12-01')
# fechEnd  <- as.Date('2015-09-30')

col_sel <- c("FEC_MATRICULA", "MARCA_ITV", "MODELO_ITV"
             , "COD_PROCEDENCIA_ITV", "COD_TIPO", "COD_PROPULSION_ITV", "CILINDRADA_ITV"
             , "POTENCIA_ITV", "COD_PROVINCIA_MAT", "CODIGO_POSTAL"
             , "PERSONA_FISICA_JURIDIC", "KW_ITV", "NUM_PLAZAS", "CO2_ITV", "FABRICANTE_ITV"
             , "CATEGORIA_HOMOLOGACION_EUROPEA_ITV", "NIVEL_EMISIONES_EURO_ITV"
             , "CONSUMO.WH.KM_ITV", "CLASIFICACION_REGLAMENTO_VEHICULOS_ITV"
             , "modelo1"
)
colFech <- c("FEC_MATRICULA","FEC_TRAMITACION","FEC_TRAMITE","FEC_PRIM_MATRICULACION","FEC_PROCESO")


#### lee raw data
data_all <- 
    readRDS(file.path(DirDat, fichDatRaw))
setDT(data_all)


#### filtros
numReg0 <- nrow(data_all)

# 1 COD_CLASE_MAT=0 , matriculas ordinarias, quitamos turisticas, veh espaciales ciclomotores...
numReg <- nrow(data_all)
data_all <- data_all[COD_CLASE_MAT==0]
if (numReg != nrow(data_all) ){
  warning(cat("Eliminados", numReg - nrow(data_all) , "registros ("
              ,100*round((numReg - nrow(data_all)) /numReg,4)
              ,"%) debido a matriculas no ordinarias\n"))        
}

# 2 CLAVE_TRAMITE	IN (1,9) matriculaciones nuevas
numReg <- nrow(data_all)
data_all <- data_all[CLAVE_TRAMITE==1 |CLAVE_TRAMITE ==9]
if (numReg != nrow(data_all) ){
  warning(cat("Eliminados", numReg - nrow(data_all) , "registros ("
              ,100*round((numReg - nrow(data_all)) /numReg,4)
              ,"%) debido a tramite no matriculacion nueva\n"))        
}

# 3 COD_TIPO in (40,25) Turismos y todoterrenos
numReg <- nrow(data_all)
data_all <- data_all[COD_TIPO == "40" | COD_TIPO == "25"]
if (numReg != nrow(data_all) ){
  warning(cat("Eliminados", numReg - nrow(data_all) , "registros ("
              ,100*round((numReg - nrow(data_all)) /numReg,4)
              ,"%) debido a tramite no matriculacion nueva\n"))        
}

# 4 IND_NUEVO_USADO == "N" Solo vehiculos nuevos
numReg <- nrow(data_all)
data_all <- data_all[IND_NUEVO_USADO == "N"]
if (numReg != nrow(data_all) ){
  warning(cat("Eliminados", numReg - nrow(data_all) , "registros ("
              ,100*round((numReg - nrow(data_all)) /numReg,4)
              ,"%) debido a tramite no matriculacion nueva\n"))        
}

# 5 FEC_MATRICULA >= fechIni  & FEC_MATRICULA <= fechEnd Eliminacion de fechas anteriores a fechaIni y porsteriores a fechaEnd
numReg <- nrow(data_all)
data_all <- data_all[FEC_MATRICULA >= fechIni  & FEC_MATRICULA <= fechEnd]
if (numReg != nrow(data_all) ){
  warning(cat("Eliminados", numReg - nrow(data_all) , "registros ("
              ,100*round((numReg - nrow(data_all)) /numReg,4)
              ,"%) debido a fechas anteriores a ",as.character(fechIni)
              ," y porsteriores a ", as.character(fechEnd),"\n"))        
}

#6  eliminacion de bastidores que no tengan 17 caracteres
numReg <- nrow(data_all)
data_all[,BASTIDOR_ITV := as.character(BASTIDOR_ITV)]
bast_17 <- data_all[nchar(as.character(gsub("^\\s+|\\s+$", "",BASTIDOR_ITV)))==17,]
if (length(bast_17[[1]] ) != numReg ){ 
  warning(cat("Eliminados", numReg - length(bast_17[[1]]) , "registros ("
              ,100*round((numReg - length(bast_17[[1]]))/ numReg,4)
              ,"%) con num bastidor != 17 caracteres\n" ))
}
nrow(bast_17)

# eliminacion de bastidores repetidos
############################################################################################
# Esto no está bien estás pillando los bastidores que aparecen una vez
############################################################################################
# bast_17[,.N,by=BASTIDOR_ITV][,.N,by=N]
# bast_unico <- bast_17[,.N,by=BASTIDOR_ITV][order(N, decreasing = T)]
# data_set <- bast_17[BASTIDOR_ITV %in% bast_unico[N==1, BASTIDOR_ITV],]

# Hay un unique que hace esto que si no es un pollo
setkey(bast_17, BASTIDOR_ITV)
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


# Unificamos en los modelos de vehciculos
# 1 eliminamos espacios y caracteres raros
# 2 quitamos la marca del nombre del modelo

# data_set <- data_set0
# Para que las marcas de todos los ficheros tengan la misma longitud
data_set[, MARCA_ITV := substr(as.character(MARCA_ITV),1,23)] 

# eliminaos espacios del modelo
data_set[, MODELO_ITV := as.character(gsub("^\\s+|\\s+$", "",MODELO_ITV))]

# marca 1 = primera palabra de la marca 
data_set$marca1 <-   sapply(data_set$MARCA_ITV, strsplit, " ", simplify = T,fixed= T)
data_set$marca1 <-   sapply(data_set$marca1, f1, simplify = T)
f1 <- function(x){x[1]}

# modelo 1 = primera palabra de la marca 
data_set$modelo1 <- sapply(as.character(data_set$MODELO_ITV), strsplit, " ", simplify = T,fixed= T)
data_set$modelo1 <- sapply(data_set$modelo1, f1, simplify = T)


# marca 2 = marca sin espacios 
data_set[, marca2 := as.character(MARCA_ITV)]
data_set[, marca2 := gsub("^\\s+|\\s+$", "",marca2)]
#eliminamos del MODELO_ITV la marca
data_set[, MODELO_ITV :=  mapply(gsub, marca2, "", MODELO_ITV, fixed= T)]
data_set[, MODELO_ITV :=  mapply(gsub, marca1, "", MODELO_ITV, fixed= T)]

# eliminaos carcateres raros de MODELO_ITV
data_set[, MODELO_ITV := as.character(gsub("^\\s+|\\s+$", "",MODELO_ITV))]
data_set[, modelo2 := func.ToName(MODELO_ITV)]
data_set[, modelo2 :=  gsub(CTE_ToName_sep, "", modelo2, fixed = T)]


# eliminaos espacios y carcateres raros de MARCA
data_set[, marca2 := as.character(MARCA_ITV)]
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
tab <- data_set2[N == M, c("codItv2","MARCA_ITV","marca1","marca2"),with = F]
setkeyv(tab,c("codItv2"))
tab <- unique(tab)
data_set2[,MARCA_ITV := NULL]
data_set2[,marca1 := NULL]
data_set2[,marca2 := NULL]
data_set2[,M := NULL]
data_set2[,N := NULL]
# data_set2[,MARCA_ITV := NULL]
data_set2  <- merge(data_set2, tab, all.x = F,by.x = c("codItv2"), by.y = c("codItv2"))
#eliminamos del MODELO_ITV la marca
data_set2[, MODELO_ITV :=  mapply(gsub, marca2, "", MODELO_ITV, fixed= T)]
data_set2[, MODELO_ITV :=  mapply(gsub, marca1, "", MODELO_ITV, fixed= T)]
data_set2 <- rbind(data_set2,data_set[codItv2 == "        " | modelo2 == ""])

# 
# kk <-data_set2[marca2.x!=marca2.y]
# kk <- kk[,N:=.N,by ="codItv2,MODELO_ITV.x,modelo1.x,modelo2.x,MARCA_ITV.x,marca2.x,MODELO_ITV.y,modelo1.y,modelo2.y,MARCA_ITV.y,marca2.y"]
# kk <- kk[,c("codItv2","MODELO_ITV.x","modelo1.x","modelo2.x","MARCA_ITV.x","marca2.x","MODELO_ITV.y","modelo1.y","modelo2.y","MARCA_ITV.y","marca2.y","N"),with =F]
# kk <- kk[N !=1,]
# kk <- unique(kk)
# setkey(kk,"N")
# View(kk)       


# asignar el 'MODELO_ITV' más frecuente a cada codItv2
# data_set  <-  data_set[marca2 == "BMW"]
data_set2[,N:=.N, by = "codItv2,MODELO_ITV"] 
data_set2[,M:=max(N), by= "codItv2"] 
tab <- data_set2[N == M, c("MODELO_ITV","codItv2","modelo1","modelo2","MARCA_ITV","marca2"),with = F]
setkeyv(tab,c("codItv2"))
tab <- unique(tab)
data_set2[,MODELO_ITV := NULL]
data_set2[,modelo1 := NULL]
data_set2[,modelo2 := NULL]
data_set2[,MARCA_ITV := NULL]
data_set2[,marca2 := NULL]
data_set2[,M := NULL]
data_set2[,N := NULL]
# data_set2[,MARCA_ITV := NULL]
data_set2  <- merge(data_set2, tab, all.x = F,by.x = c("codItv2"), by.y = c("codItv2"))
data_set2 <- rbind(data_set2,data_set[codItv2 == "        " | modelo2 == ""])

# kk <- data_set_def[data_set_def$MODELO_ITV.x != data_set_def$MODELO_ITV.y, c("codItv2","MODELO_ITV.x","MODELO_ITV.y", "MARCA_ITV.x","MARCA_ITV.y","marca2.x","marca2.y","modelo2.x","modelo2.y"),with =F]
# View(kk)
# asignar el 'MODELO_ITV' más frecuente a cada modelo2
# data_set2  <-  data_set[marca2 == "BMW"]
data_set2_noMod  <-  data_set2[modelo2 == ""]
data_set2  <-  data_set2[modelo2 != ""]
setkey(data_set2,"marca2")
data_set2[,N:=.N, by = "marca2,MODELO_ITV"] 
data_set2[,M:=max(N), by= "marca2,modelo2"] 
# tab <- data_set2[N == M, c("modelo2", "MODELO_ITV", "MARCA_ITV","marca2"),with = F]
tab <- data_set2[N == M, c("modelo2", "MODELO_ITV", "marca2","modelo1"),with = F]
setkeyv(tab,c("modelo2", "marca2"))
tab <- unique(tab)
data_set2[,MODELO_ITV := NULL]
data_set2[,modelo1 := NULL]
data_set2[,M := NULL]
data_set2[,N := NULL]
data_set2  <- merge(data_set2, tab, all.x = F,by.x = c("modelo2", "marca2"), by.y = c("modelo2", "marca2"))
# kk <- head(data_set0, 100)
data_set2 <- rbind(data_set2,data_set2_noMod)
# seleccionamos las columnas que vamos a utilizar para los graficos
# data_set[,.N, by= CLASIFICACION_REGLAMENTO_VEHICULOS_ITV][order(N, decreasing = T)]
data_set2[,CODIGO_ITV := as.factor(codItv2)]
data_set2[,MARCA_ITV := as.factor(MARCA_ITV)]
data_set2[,MODELO_ITV:= as.factor(MODELO_ITV)]
data_set2[,modelo1:= as.factor(modelo1)]
data_set2 <- data_set2[,col_sel, with=F]


# filtraremos por marca/modelo

# Pasar las columnas apropiadas a factor


data_set_def <- data_set2
saveRDS(data_set2, file.path(DirDat, fichDatTur))

