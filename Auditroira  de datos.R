###################################################################################+
###  Auditoria de datos
###################################################################################+

# Parámetros
# Carga datos
# Contar nulos y valores únicos
# Chequear tipo de dato
# Valores máximos y mínimos
# Repetir para los unos
# Establecer filtros

#### Parametros ####
cat("#### Parametros #### \n")

cargaDat  <- F # TRUE para ir a disco y leer los datos (tarda)
UmbNul  <- 0.7 # Umbral de nulos a partir del cual se desecha una varable
UmbUni  <- 0.97 # Umbral de un único valor a partir del cual se desecha una varable
UmbNulUnos <- 0.7 # Umbral de nulos en los unos a partir del cual se desecha una varable

# ColNumPos  <- c('DIAS_HASTA_APER','EDAD_ASEG','DIAS_GARAN_99','DIAS_GARAN_38','DIAS_GARAN_27','DIAS_GARAN_26','DIAS_GARAN_14','DIAS_GARAN_13','DIAS_GARAN_12','DIAS_GARAN_11','DIAS_GARAN_10','DIAS_GARAN_08','DIAS_GARAN_07','DIAS_GARAN_06','DIAS_GARAN_05','DIAS_GARAN_04','DIAS_GARAN_03','DIAS_GARAN_02','DIAS_GARAN_01','DIAS_INI_SUPL','DIAS_SOLIC_POL','GARAN_99','GARAN_38','GARAN_27','GARAN_26','GARAN_14','GARAN_13','GARAN_12','GARAN_11','GARAN_10','GARAN_08','GARAN_07','GARAN_06','GARAN_05','GARAN_04','GARAN_03','GARAN_02','GARAN_01','VALOR_VEHICULO','IMPORTE_FRANQUICIA','NUM_SUPL','NUM_POL','PROFESIONAL_CONTADOR_PAGOS','PROFESIONAL_PAGO','PROFESIONAL_NUM_PAGO','PERJUDICADO_CONTADOR_PAGOS','PERJUDICADO_PAGO','PERJUDICADO_NUM_PAGO','TERCEROS_CONTADOR_PAGOS','TERCEROS_PAGO','TERCEROS_NUM_PAGO','DANOS_VEH_CONTR_CONTADOR_PAGOS','DANOS_VEH_CONTR_PAGO','DANOS_VEH_CONTR_NUM_PAGO','DEMANDANTE_CONTADOR_PAGOS','DEMANDANTE_PAGO','DEMANDANTE_NUM_PAGO','GARANTIA_PROVISION','GARANTIA_RECOBRO','GARANTIA_PAGO','SINIESTRO_CONTADOR_PAGOS','SINIESTRO_PAGO','SINIESTRO_NUM_PAGO','SINIESTRO_KM_OCUR_SIN','SINIESTRO_NUM_CONTRA','SINIESTRO_NUM_PERJ','SINIESTRO_NUM_TESTIGOS','SINIESTRO_NUM_VEHI_CONTRA')
# ColFact  <- c('SINIESTRO_NUM_CONTRA_CAT','TIPOLOGIA_VEH_CAT','SINIESTRO_CULPA_CAT','SINIESTRO_CAUSA_CAT','DIAS_SEMANA_SIN_CAT','FRANQUICIA_CAT','GARANTIA_CAT','DAÑOS_VEH_ASEG_CAT','SINIESTRO_PROVINCIA_CAT','SINIESTRO_TIPO_CAT','CAT_Provincia','CAT_SIN_HORA_OCUR_SIN','DIA_SEMANA_SINIESTRO','CATEG_VEHICULO','TIPOLOGIA_VEHICULO','TIPO_VEHICULO','TIPO_FRANQUICIA','TESTIGOS_PAIS','TESTIGOS_TIPO_VIA_DOMIC','TESTIGOS_INDIC_FMTO_DOMIC','TESTIGOS_TIPO_PERS','BENFICIARIO_PAIS','BENFICIARIO_PROVIN','BENFICIARIO_POBLA','BENFICIARIO_COD_POSTAL','BENFICIARIO_TIPO_VIA_DOMIC','BENFICIARIO_INDIC_FMTO_DOMIC','BENFICIARIO_TIPO_PERS','BENFICIARIO_TIPO_ID','PROFESIONAL_MOTIVO_PAGO','PROFESIONAL_PAIS','PROFESIONAL_PROVIN','PROFESIONAL_POBLA','PROFESIONAL_COD_POSTAL','PROFESIONAL_TIPO_VIA_DOMIC','PROFESIONAL_INDIC_FMTO_DOMIC','PROFESIONAL_TIPO_PROFES','PROFESIONAL_TIPO_PERS','PROFESIONAL_TIPO_ID','PERJUDICADO_MOTIVO_PAGO','PERJUDICADO_TIPO_ID','PERJUDICADO_SEXO','PERJUDICADO_ESCALERA','PERJUDICADO_PROVIN','PERJUDICADO_POBLA','PERJUDICADO_COD_POSTAL','PERJUDICADO_PAIS','PERJUDICADO_TIPO_VIA_DOMIC','PERJUDICADO_INDIC_FMTO_DOMIC','PERJUDICADO_TIPO_PERJ','PERJUDICADO_TIPO_PERS','TERCEROS_MOTIVO_PAGO','TERCEROS_PAIS','TERCEROS_PROVIN','TERCEROS_POBLA','TERCEROS_COD_POSTAL','TERCEROS_TIPO_VIA_DOMIC','TERCEROS_INDIC_FMTO_DOMIC','TERCEROS_TIPO_PERS','TERCEROS_TIPO_ID','TERCEROS_TIPO','DANOS_VEH_CONTR_MOTIVO_PAGO','DANOS_VEH_CONTR_COLOR','DANOS_VEH_CONTR_N_COD_ZONA','DANOS_VEH_CONTR_CODIGO','CONTRARIO_COND_TIPO_ID','CONTRARIO_COND_PROVIN','CONTRARIO_COND_POBLA','CONTRARIO_COND_COD_POSTAL','CONTRARIO_COND_PAIS','CONTRARIO_COND_TIPO_VIA_DOMIC','CONTRARIO_COND_INDIC_FMTO_DOMIC','CONTRARIO_DGS','CONTRARIO_TIPO','CONTRARIO_MODELO','CONTRARIO_MARCA','CONTRARIO_TIPO_MATRI','CONDU_VEH_ASEG_PAIS','CONDU_VEH_ASEG_PROVIN','CONDU_VEH_ASEG_POBLA','CONDU_VEH_ASEG_COD_POSTAL','CONDU_VEH_ASEG_INDIC_FMTO_DOMIC','CONDU_VEH_ASEG_SEXO','CONDU_VEH_ASEG_TIPO_ID','CONDU_VEH_ASEG_TIPO_PERS','DEMANDANTE_MOTIVO_PAGO','DEMANDANTE_PAIS','DEMANDANTE_PROVIN','DEMANDANTE_POBLA','DEMANDANTE_COD_POSTAL','DEMANDANTE_TIPO_VIA_DOMIC','DEMANDANTE_INDIC_FMTO_DOMIC','DEMANDANTE_ECIVIL','DEMANDANTE_TIPO_ID','DEMANDANTE_TIPO_PERS','DEMANDANTE_TIPO','DANOS_VEH_ASEG_N_COD_ZONA','DANOS_VEH_ASEG_CODIGO','GARANTIA_CODE','SINIESTRO_MOTIVO_PAGO','SINIESTRO_RECH','SINIESTRO_LUGAR_OCUR_SIN','SINIESTRO_CANAL_CAPTURA','SINIESTRO_REPARTO','SINIESTRO_PAIS','SINIESTRO_PROVIN','SINIESTRO_POBLA','SINIESTRO_COD_POSTAL','SINIESTRO_TIPO_VIA_DOMIC','SINIESTRO_INDIC_FMTO_DOMIC','SINIESTRO_CAUSA','SINIESTRO_TIPO','MOV_SITU_SIN','MOV_TIPO','MOV_DGS')
# ColFech  <- c('FEC_SOLIC_SUPL','FEC_SOLIC_POL','FEC_INI_SUPL','BENFICIARIO_FEC_INDEM','CONDU_VEH_ASEG_FEC_NACIM','DEMANDANTE_FEC_EXP_PERM','DEMANDANTE_FEC_NACIM','SINIESTRO_FEC_REAPER','SINIESTRO_FEC_TERM','SINIESTRO_FEC_APER','SINIESTRO_FEC_OCUR2','SINIESTRO_FEC_OCUR')
ColId  <- c('BASTIDOR_ITV')
# ColBool   <- c('SINIESTRO_ENVIAR','SINIESTRO_REHUSADO_SENTENCIA','SINIESTRO_REHUSADO_LOCALIZADO','SINIESTRO_REHUSADO_COBERTURA','SINIESTRO_RESTOS','SINIESTRO_DANOS_CONTRARIO','SINIESTRO_DANOS_PROPIOS','SINIESTRO_ROBO_TOTAL','SINIESTRO_TOTAL','SINIESTRO_ATESTADO','SINIESTRO_CULPA','SINIESTRO_INDIC_RECH')
ColIgn0  <- c('FEC_PROCESO')
ColIgn  <- c(ColIgn0, ColId)
for (c in ColIgn0){    cat( c,";", " No relevante \n")}
for (c in ColId){    cat( c,";", "Variable Id \n")}


#### Carga datos ####
cat("#### Carga datos #### \n")
if (cargaDat | !exists("data_all")) data_all <-  readRDS(file.path(DirDat, fichDatRaw))
total  <- data_all


#### Contar nulos y valores únicos ####
cat("#### Contar nulos y valores únicos #### \n")
# Habría que guardar todo esto en bbdd

# Nulos
# c <- "COD_CLASE_MAT"
long  <- nrow(total)
colIgn2  <- colnames(total) %in% ColIgn
ColNul  <- c()
for (c in setdiff(colnames(total), colIgn2)) {
  l <-  sum(is.na(total[[c]]))
  if (l/long > UmbNul){
    ColNul  <- c(ColNul, c)
    cat( c,";", round(100*l/long,1),"% de nulos \n")
  }
}
ColIgn <- c(ColIgn, ColNul)
colIgn2  <- colnames(total) %in% ColIgn

# Variables con un único valor
ColUni  <- c()
for (c in setdiff(colnames(total), colIgn2)) {
  aux <-  table(total[[c]])/long
  aux <- aux[ aux > UmbUni]
  if (length(aux) >0) {
    ColUni  <- c(ColUni, c)
    cat( c,";", round(aux[1]*100,1),"% del valor", names(aux)[1], " \n")
  }
}

ColIgn <- c(ColIgn, ColUni)

# # Nulos en los unos
# colIgn2  <- colnames(total) %in% ColIgn
# ColNulUnos  <- c()
# long  <- length(total_1[,1])
# for (c in colnames(total[,!colIgn2])) {
#   l <-  length(total_1[is.na(total_1[,c]),c])
#   if (l/long > UmbNulUnos){
#     ColNulUnos  <- c(ColNulUnos, c)
#     cat( c,";", round(100*l/long,1),"% de nulos los frudes\n")
#   }
# }
# ColIgn <- c(ColIgn, ColNulUnos)


#### Chequear tipo de dato ####
cat("#### Chequear tipo de dato #### \n")

# colFact en Factores 
colFact2  <- ColFact[!(ColFact %in% ColIgn)]
for (c in colFact2) {
  if (!is.factor(total[,c])) {
    cat("#### Convertir columna ", c, " en factor\n")
    table(c)
    total[,c]  <- factor(total[,c])
  }  
}  

# ColNumPos en Numeric
ColNumPos2  <- ColNumPos[!(ColNumPos %in% ColIgn)]
for (c in ColNumPos2) {
  if (!is.numeric(total[,c])) {
    cat("#### Convertir columna ", c, " en número\n")
    table(c)
    total[,c]  <- as.numeric(total[,c])
  }  
}

# ColFech en Fecha
ColFech2  <- ColFech[!(ColFech %in% ColIgn)]
for (c in ColFech2) {
  if (!is.numeric.Date(total[,c])) {
    cat("#### Convertir columna ", c, " en fecha\n")
    table(c)
    total[,c]  <- as.Date(total[,c], "%d/%m/%Y")
  }  
}


# ColChar  <- c()
# # Buscar valores que sean de caracter
# colIgn2  <- colnames(total) %in% ColIgn
# for (c in setdiff(colnames(total), colIgn2)) {
#   if(is.character(total[[c]])){
#       cat("#### columna ", c, " es CARACTER")
#     ColChar <- c(ColChar, c)
#   }
# }
# ColIgn  <- c(ColIgn, ColChar)

# cat("#### Ignoramos fechas a partir de aqui #### \n")
# ColIgn  <- c(ColIgn, ColFech)
# 
#### Chequeos ad-hoc ####
# cat("#### Chequeos ad-hoc #### \n")
# cat("##  Trazar cada chequeo  ## \n")
# 
# ColByPatt <- function (pattern, colIgn){
#   colPatt  <- c()
#   colIgn2  <- colnames(total) %in% colIgn
#   for (c in colnames(total[,!colIgn2])) {
#     if(length(grep(pattern, c, fixed = TRUE))>0 ){
#     cat("#### Ignorar col ", c, "\n")
#     colPatt <- c(colPatt, c)
#     }
#   }
#   colPatt
# }

# Patt2Ign <- c("DOMIC","PROFESIONAL","COD_POSTAL","TIPO_VIA",
#              "POBLA","PAIS","PROVIN")
# ColPatt  <- c()
# for (patt in Patt2Ign) {
#   ColPatt  <- c(ColPatt, ColByPatt(patt, ColIgn))  
# }
# ColIgn <- c(ColIgn, ColPatt)
# 
# colIgn2  <- colnames(total) %in% ColIgn

cat("############# Quedan\n", paste(colnames(total[,!colIgn2]),collapse = "\n"))






