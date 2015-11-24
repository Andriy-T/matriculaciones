###################################################################################+
###  Program tools
###  actualiza nombres.r
###  Cambia palabras en los ficheros .R presentes en un dir
###################################################################################+

# Parametros  de carga
# Calculo de lista de ficheros a cambiar
# Lee ficheros
# Sustirucion
# Escribe

#### Parametros  de carga ####
dirIn <- "C:/Alfonso/cosas/software/R/matriculaciones" #DirCode
dirOut <-"C:/Alfonso" # DirCode
fich <- "" # Si fich ="" se actualizan todos los ficheros del directorio (de la extension adecuada)
extension <- ".R" # Si extension = F se actualizan todas las extensiones


NomCampos0 <- c(
  "DESCRIPCION_LARGA","MODELO","COD_PROCEDENCIA","BASTIDOR","COD_PROPULSION","CILINDRADA","POTENCIA","IND_EMBARGO Indicador de vehIculo embargado Valores: SI /BLANCO","SEXO","KW"
  ,"CO2","MASA_ORDEN_MARCHA","MASA_MAXIMA_TECNICA_ADMISIBLE","CATEGORIA_HOMOLOGACION_EUROPEA","NIVEL_EMISIONES_EURO","CONSUMO","CLASIFICACION_REGLAMENTO_VEHICULOS","CATEGORIA_VEHICULO_ELECTRICO","AUTONOMIA_VEHICULO_ELECTRICO","MARCA_VEHICULO_BASE","FABRICANTE_VEHICULO_BASE","TIPO_VEHICULO_BASE","VARIANTE_VEHICULO_BASE","VERSION_VEHICULO_BASEVersion","DISTANCIA_EJES_12","FEC_DESCONOCIDA"
)
NomCampos <- func.ToName(NomCampos0)
NomCampos0 <- c(
  "MARCA_ITV","MODELO_ITV","COD_PROCEDENCIA_ITV","BASTIDOR_ITV","COD_PROPULSION_ITV","CILINDRADA_ITV","POTENCIA_ITV","IND_EMBARGO","PERSONA_FISICA_JURIDIC","KW_ITV","CO2_ITV","MASA_ORDEN_MARCHA_ITV"
,"MASA_MÁXIMA_TECNICA_ADMISIBLE_ITV","CATEGORÍA_HOMOLOGACIÓN_EUROPEA_ITV","NIVEL_EMISIONES_EURO_ITV","CONSUMO WH/KM_ITV","CLASIFICACIÓN_REGLAMENTO_VEHICULOS_ITV","CATEGORÍA_VEHÍCULO_ELÉCTRICO","AUTONOMÍA_VEHÍCULO_ELÉCTRICO","MARCA_VEHÍCULO_BASE","FABRICANTE_ITV","TIPO_VEHÍCULO_BASE","VARIANTE_VEHÍCULO_BASE","VERSIÓN_VEHÍCULO_BASE","DISTANCIA_EJES_12_ITV","FEC_PROCESO"
)
NomCampos2 <-func.ToName(NomCampos0)

NomCampos <- c(NomCampos, NomCampos2)
tabNom <- split(NomCampos, c(1:length(NomCampos2),1:length(NomCampos2)))

#### Calculo de lista de ficheros a cambiar
extension <- gsub(".", "",extension,fixed =TRUE)

if (fich =="") {  lFiles <- list.files(path = dirIn)
} else {  lFiles <- file.path(dirIn, fich) }


lFiles <- as.character(lFiles)
# if (extension != F) lFiles <- lFiles[strsplit(lFiles, ".", fixed = T )[2] [[1]] == extension ]
lFiles <- lFiles[ as.character(lapply(strsplit(lFiles, ".", fixed = T ), "[", 2 )) == extension ]
lFiles <- lFiles[!is.na(lFiles)]
lFilesIn <- file.path(dirIn, lFiles)
  
#### Lee ficheros
dim(lFilesIn) <- c(1,length(lFilesIn))
t <- apply(lFilesIn,2, scan, what = "", sep ="\n", blank.lines.skip= F)

#### Sustirucion

t2 <- lapply(t, func.ToName, tabNom , dup = "")


# Escribe
mapply(writeLines,t2, file.path(dirOut, lFiles) )


# data_all <-  readRDS(file.path(DirDat, fichDatRaw))
# 
# NomCampos0 <- c('FEC_MATRICULA','COD_CLASE_MAT','FEC_TRAMITACION','MARCA_ITV','MODELO_ITV','COD_PROCEDENCIA_ITV','BASTIDOR_ITV','COD_SERVICIO','COD_TIPO','COD_PROPULSION_ITV','CILINDRADA_ITV','POTENCIA_ITV','TARA','PESO_MAX','NUM_PLAZAS','IND_PRECINTO','IND_EMBARGO','NUM_TRANSMISIONES','NUM_TITULARES','LOCALIDAD_VEHICULO','COD_PROVINCIA_VEH','COD_PROVINCIA_MAT','CLAVE_TRAMITE','FEC_TRAMITE','CODIGO_POSTAL','FEC_PRIM_MATRICULACION','IND_NUEVO_USADO','PERSONA_FISICA_JURIDIC','CODIGO_ITV','SERVICIO','COD_MUNICIPIO_INE_VEH','MUNICIPIO','COD_MUNICIPIO_INE_PROP','KW_ITV','NUM_PLAZAS_MAX','CO2_ITV','RENTING','COD_TUTELA','COD_POSESION','IND_BAJA_DEF','IND_BAJA_TEMP','IND_SUSTRACCION','BAJA_TELEMATICA','TIPO_ITV','VARIANTE_ITV','VERSION_ITV','FABRICANTE_ITV','MASA_ORDEN_MARCHA_ITV','MASA_MÁXIMA_TECNICA_ADMISIBLE_ITV','CATEGORÍA_HOMOLOGACIÓN_EUROPEA_ITV','CARROCERIA','PLAZAS_PIE','NIVEL_EMISIONES_EURO_ITV','CONSUMO WH/KM_ITV','CLASIFICACIÓN_REGLAMENTO_VEHICULOS_ITV','CATEGORÍA_VEHÍCULO_ELÉCTRICO','AUTONOMÍA_VEHÍCULO_ELÉCTRICO','MARCA_VEHÍCULO_BASE','FABRICANTE_VEHÍCULO_BASE','TIPO_VEHÍCULO_BASE','VARIANTE_VEHÍCULO_BASE','VERSIÓN_VEHÍCULO_BASE','DISTANCIA_EJES_12_ITV','VIA_ANTERIOR_ITV','VIA_POSTERIOR_ITV','TIPO_ALIMENTACION_ITV','CONTRASEÑA_HOMOLOGACION_ITV','ECO_INNOVACION_ITV','REDUCCION_ECO_ITV','CODIGO_ECO_ITV','FEC_PROCESO')
# NomCampos <-func.ToName(NomCampos0)
# setnames(data_all, names(data_all),NomCampos)
# saveRDS(data_set2, file.path(DirDat, fichDatTur))




# writeLines(t, file.path("C:","Alfonso" ,"kk.R"))

# 
# t <- scan("C:/Alfonso/kk",what = "", sep ="\n", blank.lines.skip= F)
# 
# 
# t2 <- Reduce(paste,t)
# t2 <- gsub(" ","",t2,fixed =TRUE)
# writeLines(t2, file.path("C:","Alfonso" ,"kk.txt"))

# writeLines(t, file.path("C:","Alfonso" ,"kk.R"))
