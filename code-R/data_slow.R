###################################################################################+
###  Proyecto Automovil
###  data_slow.r
###  Carga los datos de matriculaciones y filtra registros incorrectos
###  NO carga los datos auxiliares
###################################################################################+

# Parametros
# lee raw data
# filtros
# cambios en los modelos
# convertir en factores
# filtraremos por marca/modelo

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
             , "MUNICIPIO", "COD_PROVINCIA_VEH"
             , "SERVICIO"
             , "modeloCorto"
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
              ,"%) debido a tramite vehiculo no turismo o todoterreno\n"))        
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

#### cambios en los modelos

# Unificamos en los modelos de vehciculos
# 1 eliminamos espacios y caracteres raros
# 2 quitamos la marca del nombre del modelo

# data_set <- data_set0
# Para que las marcas de todos los ficheros tengan la misma longitud
data_set[, MARCA_ITV := substr(as.character(MARCA_ITV),1,23)] 

# eliminamos espacios del modelo al principio y al final
data_set[, MODELO_ITV := as.character(gsub("^\\s+|\\s+$", "",MODELO_ITV))]

# marca 1 = primera palabra de la marca 
f1 <- function(x){x[1]}
f2 <- function(x){if (length(x)>1) x[2] else x[1]}
data_set$marca1 <-   sapply(data_set$MARCA_ITV, strsplit, " ", simplify = T,fixed= T)
data_set$marca1 <-   sapply(data_set$marca1, f1, simplify = T)

# marca 2 = marca sin espacios 
data_set[, marca2 := as.character(MARCA_ITV)]
data_set[, marca2 := gsub("^\\s+|\\s+$", "", marca2)]
#eliminamos del MODELO_ITV la marca
data_set[, MODELO_ITV :=  mapply(gsub, marca2, "", MODELO_ITV, fixed= T)]
data_set[, MODELO_ITV :=  mapply(gsub, marca1, "", MODELO_ITV, fixed= T)]

# eliminaos espacios y carcateres raros de MARCA
data_set[, marca2 := as.character(MARCA_ITV)]
data_set[, marca2 := func.ToName(marca2)]
data_set[, marca2 :=  gsub(CTE_ToName_sep, "", marca2, fixed = T)]

data_set[, codItv2 :=  substr(as.character(CODIGO_ITV),1,8)]

# eliminaMos espacios al final y al principio de MODELO_ITV
data_set[, MODELO_ITV := gsub("^\\s+|\\s+$", "", as.character(MODELO_ITV))]

data_set2 <- copy(data_set)

setkeyv(data_set2,c("marca2") )


#### Modificaciones en MARCA_ITV y MODELO_ITV 
#data_set2[ ,modelo0 := modelo1]
#prefijos a separar
preMod <- c("SERIE", "", "AMG", "AMG", "GRAND ","GRAN", "GR ","GRAN", "GRAN","GRAN")
dim(preMod) <- c(2,length(preMod)/2) 
#sufijos a separar
sufMod <- c("CONNECT","COURIER","CUSTOM","CABRIO","SPORTSVAN","MAX")
# data_set2[,pre:= lapply(gregexpr("[0-9]",MODELO_ITV), getthepos)]

# Separamos los prefijos
data_set2[, MODELO_ITV2 :=MODELO_ITV]
for (j in 1:dim(preMod)[2]){
  data_set2[ grepl(paste("^",preMod[1,j],sep =""), MODELO_ITV2), pre := preMod[2,j] ]
  data_set2[ grepl(paste("^",preMod[1,j],sep =""), MODELO_ITV2), MODELO_ITV2 := sub(preMod[1,j], "",MODELO_ITV2)]
}
data_set2[!is.na(pre), MODELO_ITV2 := gsub("^\\s+", "", MODELO_ITV2)]



# Separamos los sufijos
for (c in sufMod){
  data_set2[ grepl(paste(c,sep =""), MODELO_ITV2), suf := c ]
  data_set2[ grepl(paste(c,sep =""), MODELO_ITV2),  MODELO_ITV2 :=substr(MODELO_ITV2, 1, regexpr(c,MODELO_ITV2)-1)]
  data_set2[!is.na(suf), MODELO_ITV2 := gsub("\\s+$", "", MODELO_ITV2)]
}

# modelo 1 = primera palabra del modelo
# modelo 2 = segunda palabra del modelo
data_set2$modelo1 <- sapply(data_set2$MODELO_ITV2, strsplit, " ", simplify = T,fixed= T)
data_set2$modelo2 <- sapply(data_set2$modelo1, f2, simplify = T)
data_set2$modelo1 <- sapply(data_set2$modelo1, f1, simplify = T)
# modeloNoEsp es MODELO_ITV sin espacios ni carcateres raros 
data_set2[, modeloNoEsp := func.ToName(MODELO_ITV2)]
data_set2[, modeloNoEsp :=  gsub(CTE_ToName_sep, "", modeloNoEsp, fixed = T)]


# si la primera palabra de modelo tiene más de cuatro caracteres nos la quedamos en MODELO_ITV2 y eliminamos el resto 
data_set2[nchar(modelo1)>3, MODELO_ITV2:= modelo1]

# modeloCorto modelo hasta que acaba el primer número por la izquierda
# Ej AUDI A100d -> AUDI A100
getthepos <- function (x)
{
  max(x[x==x[1]+c(1:length(x))-1])
}
data_set2[,modeloCorto:= MODELO_ITV2]
data_set2[,aux:= lapply(gregexpr("[0-9]",MODELO_ITV2), getthepos)]
data_set2[aux!=-1, modeloCorto:=substr(MODELO_ITV2,1,aux)]
data_set2[aux!=-1, modeloCorto:=sub(" ","",modeloCorto)]
data_set2[aux!=-1, modeloCorto:=sub("-","",modeloCorto)]


# Cambiar 'JAGUARLANDROVERLIMIT'por 'JAGUAR'
data_set2[marca2 == "JAGUARLANDROVERLIMIT", MARCA_ITV:= "LAND ROVER"]
data_set2[marca2 == "JAGUARLANDROVERLIMIT", marca1:= "LAND ROVER"]
data_set2[marca2 == "JAGUARLANDROVERLIMIT", marca2:= "LANDROVER"]

# Cambiar 'MERCEDESBENZ' y MERCEDESAMG por 'MERCEDES
# data_set2[marca2 == "MERCEDESAMG" & is.na(pre), pre:= "AMG"]
data_set2[marca2 == "MERCEDESAMG", MARCA_ITV:= "MERCEDES"]
data_set2[marca2 == "MERCEDESAMG", marca1:= "MERCEDES"]
data_set2[marca2 == "MERCEDESAMG", marca2:= "MERCEDES"]
data_set2[marca2 == "MERCEDESBENZ", MARCA_ITV:= "MERCEDES"]
data_set2[marca2 == "MERCEDESBENZ", marca1:= "MERCEDES"]
data_set2[marca2 == "MERCEDESBENZ", marca2:= "MERCEDES"]

# Cambiar 'BMWI' por 'BMWI'
data_set2[marca2 == "BMWI", MARCA_ITV:= "BMW"]
data_set2[marca2 == "BMWI", marca1:= "BMW"] 
data_set2[marca2 == "BMWI", marca2:= "BMW"]
#En BMW , si el modelo empieza por num lo pasamos a serie más num	BMW
data_set2[marca2 == "BMW" & modeloNoEsp <"9Z" & modeloNoEsp >"1", modeloCorto:= paste("SERIE ", substr(modeloNoEsp,1,1),sep="")]
## En BMW , si el modelo empieza por "Serie" lo pasamos a serie más 2 caracteres BMW
# data_set2[marca2 == "BMW" & modeloNoEsp =="SERIE", modeloCorto:= paste("SERIE ", substr(modeloNoEsp,6,6),sep="")]
#En BMW , quitamos el espacio si modelo empieza por X' '*
data_set2[marca2 == "BMW" & substr(modeloCorto,1,2) =="X ", modeloCorto:= paste("X", substr(modeloCorto,3,nchar(modeloCorto)) ,sep="")]
          
#en PEUGEOT si modelo empieza por N la quitamos
data_set2[marca2 == "PEUGEOT" & substr(modeloNoEsp,1,1) =="N", modeloNoEsp:= substr(modeloNoEsp,2,nchar(modeloNoEsp))]
data_set2[marca2 == "PEUGEOT" & substr(modelo1,1,1) =="N", modelo1:= substr(modelo1,2,nchar(modelo1))]
data_set2[marca2 == "PEUGEOT" & substr(modeloCorto,1,1) =="N", modeloCorto:= substr(modeloCorto,2,nchar(modeloCorto))]
data_set2[marca2 == "PEUGEOT" & substr(MODELO_ITV2,1,1) =="N", MODELO_ITV2:= substr(MODELO_ITV2,2,nchar(MODELO_ITV2))]

##en PEUGEOT si empieza por 3085 a 308
data_set2[marca2 == "PEUGEOT" & substr(MODELO_ITV2,1,4) =="3085", MODELO_ITV2:= "308"]

#en CITROEN si modelo empieza por N la quitamos
data_set2[marca2 == "CITROEN" & substr(modeloNoEsp,1,1) =="N" & substr(modeloNoEsp,1,4) !="NEMO", modeloNoEsp:= substr(modeloNoEsp,2,nchar(modeloNoEsp))]
data_set2[marca2 == "CITROEN" & substr(modeloNoEsp,1,1) =="N" & substr(modeloNoEsp,1,4) !="NEMO", modelo1:= substr(modelo1,2,nchar(modelo1))]
data_set2[marca2 == "CITROEN" & substr(modeloCorto,1,1) =="N"& substr(modeloNoEsp,1,4) !="NEMO", modeloCorto:= substr(modeloCorto,2,nchar(modeloCorto))]
data_set2[marca2 == "CITROEN" & substr(MODELO_ITV2,1,1) =="N" & substr(modeloNoEsp,1,4) !="NEMO", MODELO_ITV2:= substr(MODELO_ITV2,2,nchar(MODELO_ITV2))]

#en CITROEN C+' ' por c
data_set2[marca2 == "CITROEN" & substr(modeloCorto,1,2) =="C ", modeloCorto:= paste("C", substr(modeloCorto,3,nchar(modeloCorto)) ,sep="")]

#en CITROEN DS+' ' por DS
data_set2[marca2 == "CITROEN" & substr(modeloCorto,1,3) =="DS ", modeloCorto:= paste("DS", substr(modeloCorto,4,nchar(modeloCorto)) ,sep="")]

#en CITROEN BERL  por BELINGO
data_set2[marca2 == "CITROEN" & substr(modeloCorto,1,4) =="BERL", modeloCorto:= "BERLINGO"]

#en CITROEN lo que contega ELYS es C-ELYSSE
data_set2[marca2 == "CITROEN" & grepl("ELYS",modeloCorto), modeloCorto:= "C-ELYSEE"]

#en CITROEN lo que contega GC4 es GRAND C4
data_set2[marca2 == "CITROEN" & modeloCorto == "GC4", pre:= "GRAN"]
data_set2[marca2 == "CITROEN" & modeloCorto == "G4", pre:= "GRAN"]
data_set2[marca2 == "CITROEN" & modeloCorto == "GC 4", pre:= "GRAN"]

data_set2[marca2 == "CITROEN" & modeloCorto == "GC4", modeloCorto:= "C4"]
data_set2[marca2 == "CITROEN" & modeloCorto == "G4", modeloCorto:= "C4"]
data_set2[marca2 == "CITROEN" & modeloCorto == "GC 4", modeloCorto:= "C4"]

# kk <- data_set2[marca2=="CITROEN" & modeloCorto == "CELYS BHDI100"]


#EN FORD _MAX y ' MAX' a '-MAX'
data_set2[marca2 == "FORD" & nchar(modeloCorto)<3 & suf == "MAX", modeloCorto:= paste(substr(modeloCorto,1,1),"-",sep="")]
kk <- data_set2[marca2 == "FORD" & suf == "MAX" &  nchar(modeloCorto)<3]
kk <- data_set2[marca2 == "FORD" & suf == "MAX" &  nchar(modeloCorto)>=3]
#  en KIA CEE a CEED
data_set2[marca2 == "KIA" & substr(modeloNoEsp,1,3) =="CEE", modeloCorto:= "CEED"]

# en VOLKSWAGEN UP a UP!
data_set2[marca2 == "VOLKSWAGEN" & substr(modeloNoEsp,1,2) =="UP", modeloCorto:= "UP!"]

# En NISSAN E ' a 'E-'
data_set2[marca2 == "NISSAN" & substr(MODELO_ITV2,1,2) =="E ", modeloCorto:= paste("E-", substr(modeloCorto,3,nchar(modeloCorto)) ,sep="")]
data_set2[marca2 == "NISSAN" & substr(MODELO_ITV2,1,2) =="E ", modeloCorto:= paste("E_", substr(modeloCorto,3,nchar(modeloCorto)) ,sep="")]

# En OPEL INSIGINIA a INSIGNIA
data_set2[marca2 == "OPEL" & substr(modeloCorto,1,9) =="INSIGINIA", modeloCorto:= "INSIGNIA"]

# LAND ROVER XE a JAGUAR XE	
data_set2[marca2 == "LANDROVER" & substr(MODELO_ITV2,1,2)=="XE", marca1:= "JAGUAR"]
data_set2[marca2 == "LANDROVER" & substr(MODELO_ITV2,1,2) =="XE", MARCA_ITV:= "JAGUAR"]
data_set2[marca2 == "LANDROVER" & substr(MODELO_ITV2,1,2) =="XE", marca2:= "JAGUAR"]

# GUILIETTA a GIULIETTA
data_set2[marca2 == "ALFAROMEO" & modeloCorto =="GUILIETTA", modeloCorto:= "GIULIETTA"]


# nos quedamos sólo del modelo hasta que acaba el primer numero

setkey(data_set2,"codItv2")

# asignar la marca más frecuente a cada codItv2
data_set2 <- data_set2[codItv2 != "        "]
data_set2_blancos <- data_set2[codItv2 == "        "]
data_set2[,N:=.N, by = "codItv2,marca2"] 
data_set2[,M:=max(N), by= "codItv2"] 
tab <- data_set2[N == M, c("codItv2","MARCA_ITV","marca1","marca2"),with = F]
setkeyv(tab,c("codItv2"))
tab <- unique(tab)
data_set2[,M := NULL]
data_set2[,N := NULL]
data_set2[,MARCA_ITV := NULL]
data_set2[,marca1 := NULL]
data_set2[,marca2 := NULL]
# data_set2[,MARCA_ITV := NULL]
data_set2  <- merge(data_set2, tab, all.x = F,by.x = c("codItv2"), by.y = c("codItv2"))
data_set2 <- rbind(data_set2,data_set2_blancos)

#eliminamos del MODELO_ITV2 la marca  XXX creo que se puede elimina
data_set2[, MODELO_ITV2 :=  mapply(gsub, marca2, "", MODELO_ITV2, fixed= T)]
data_set2[, MODELO_ITV2 :=  mapply(gsub, marca1, "", MODELO_ITV2, fixed= T)]

# 
# kk <-data_set2[marca2.x!=marca2.y]
# kk <- kk[,N:=.N,by ="codItv2,MODELO_ITV2.x,modelo1.x,modeloNoEsp.x,MARCA_ITV.x,marca2.x,MODELO_ITV2.y,modelo1.y,modeloNoEsp.y,MARCA_ITV.y,marca2.y"]
# kk <- kk[,c("codItv2","MODELO_ITV2.x","modelo1.x","modeloNoEsp.x","MARCA_ITV.x","marca2.x","MODELO_ITV2.y","modelo1.y","modeloNoEsp.y","MARCA_ITV.y","marca2.y","N"),with =F]
# kk <- kk[N !=1,]
# kk <- unique(kk)
# setkey(kk,"N")
# View(kk)       


# asignar el 'MODELO_ITV2' más frecuente a cada codItv2
# XXX habría que quitar los modelos en blanco por si son el más frecuente
# data_set  <-  data_set[marca2 == "BMW"]
data_set2_blancos <- data_set2[codItv2 == "        "]
data_set2 <- data_set2[codItv2 != "        "]
data_set2[,N:=.N, by = "codItv2,MODELO_ITV2"] 
data_set2[,M:=max(N), by= "codItv2"] 
tab <- data_set2[N == M, c("MODELO_ITV2","codItv2","modelo1","modeloNoEsp","MARCA_ITV","marca2"),with = F]
setkeyv(tab,c("codItv2"))
tab <- unique(tab)
data_set2[,M := NULL]
data_set2[,N := NULL]
data_set2[,MODELO_ITV2 := NULL]
data_set2[,modelo1 := NULL]
data_set2[,modeloNoEsp := NULL]
data_set2[,MARCA_ITV := NULL]
data_set2[,marca2 := NULL]
# data_set2[,MARCA_ITV := NULL]
data_set2  <- merge(data_set2, tab, all.x = F,by.x = c("codItv2"), by.y = c("codItv2"))
data_set2 <- rbind(data_set2,data_set2_blancos)

# kk <- data_set_def[data_set_def$MODELO_ITV2.x != data_set_def$MODELO_ITV2.y, c("codItv2","MODELO_ITV2.x","MODELO_ITV2.y", "MARCA_ITV.x","MARCA_ITV.y","marca2.x","marca2.y","modeloNoEsp.x","modeloNoEsp.y"),with =F]
# View(kk)

# asignar el 'MODELO_ITV2' más frecuente a cada modeloNoEsp
# data_set2  <-  data_set[marca2 == "BMW"]
data_set2_blancos  <-  data_set2[modeloNoEsp == ""]
data_set2  <-  data_set2[modeloNoEsp != ""]
setkey(data_set2,"marca2")
data_set2[,N:=.N, by = "marca2,MODELO_ITV2"] 
data_set2[,M:=max(N), by= "marca2,modeloNoEsp"] 
# tab <- data_set2[N == M, c("modeloNoEsp", "MODELO_ITV2", "MARCA_ITV","marca2"),with = F]
tab <- data_set2[N == M, c("modeloNoEsp", "MODELO_ITV2", "marca2","modelo1"),with = F]
setkeyv(tab,c("modeloNoEsp", "marca2"))
tab <- unique(tab)
data_set2[,M := NULL]
data_set2[,N := NULL]
data_set2[,MODELO_ITV2 := NULL]
data_set2[,modelo1 := NULL]
data_set2  <- merge(data_set2, tab, all.x = F,by.x = c("modeloNoEsp", "marca2"), by.y = c("modeloNoEsp", "marca2"))
# kk <- head(data_set0, 100)
data_set2 <- rbind(data_set2,data_set2_blancos)


# Volvemos a poner los sufijos y prefijos
data_set2[!is.na(pre), modeloCorto := paste(pre, modeloCorto)]
data_set2[!is.na(suf), modeloCorto := paste(modeloCorto, suf)]
data_set2[!is.na(suf), modeloCorto := gsub("\\s+-","-",modeloCorto)]
data_set2[!is.na(suf), modeloCorto := gsub("-\\s+","-",modeloCorto)]

#### Quitamos espacio delrpincipio y del final del municipio
data_set2$MUNICIPIO <- gsub("^\\s+|\\s+$", "",as.character(data_set2$MUNICIPIO))
data_set2$COD_PROVINCIA_VEH <- gsub("^\\s+|\\s+$", "",as.character(data_set2$COD_PROVINCIA_VEH))



# seleccionamos las columnas que vamos a utilizar para los graficos
# data_set[,.N, by= CLASIFICACION_REGLAMENTO_VEHICULOS_ITV][order(N, decreasing = T)]
data_set_def <- data_set2
data_set_def <- data_set_def[,col_sel, with=F]


#### convertir en factores

for (c in col_sel) {data_set2[[c]] <- as.factor(data_set2[[c]])}
saveRDS(data_set2, file.path(DirDat, fichDatTur))
