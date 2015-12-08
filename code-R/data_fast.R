
# Data Turismos (procesado)
# Carga y procesamiento

data_set_def <-
    readRDS(file.path(DirDat, fichDatTur))

setDT(data_set_def) 

# Reconocer campo fecha
data_set_def[, FEC_MATRICULA := as.Date(FEC_MATRICULA ,"%Y-%m-%d")]


# Transformacion numerica de los campos que por defecto son factor
colToNum <- c("CILINDRADA_ITV", "KW_ITV", "POTENCIA_ITV"
                  , "NUM_PLAZAS", "CO2_ITV", "CONSUMO.WH.KM_ITV")

for (j in colToNum)
    set(data_set_def, i = NULL, j = j
        , value = as.numeric(as.character(data_set_def[[j]]))
    )
rm(j)
