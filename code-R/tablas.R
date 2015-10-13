# contruccion de tablas a partir del dataset
# construido en el codigo data.R

# df <- data_set_def

# print(object.size(df), units = "MB")
# str(df)
# df[, DESCRIPCION_LARGA:=as.character(DESCRIPCION_LARGA)]

########################################################################################+
# total matriculaciones por día ----
########################################################################################+

matric_tot_dia <- data_set_def[,.N, by = FEC_MATRICULA]

# reconocer formato de fecha
matric_tot_dia[, fecha := as.Date(FEC_MATRICULA, format = "%d%m%Y")]

matric_tot_dia <- matric_tot_dia[,.(fecha, N)][order(fecha)]
setnames(matric_tot_dia, names(matric_tot_dia), c("fecha", "matric"))

matric_tot_dia[, range(fecha)]
matric_tot_dia <- matric_tot_dia[fecha >= '2014-12-01' &
                                     fecha <= '2015-06-30']

########################################################################################+
# Propulsión ----
########################################################################################+

# claves primarias para poder unir las tablas
matric_prop_tot <- data_set_def[, .N, by = COD_PROPULSION]
setkey(matric_prop_tot, COD_PROPULSION)

# claves primarias para poder unir las tablas
tmp_aux <- data_aux$COD_PROPULSION
setDT(tmp_aux)
setkey(tmp_aux, COD_PROPULSION)

# agrupación por falta de volúmen
# Buscar agrupaciones
tmp_aux[, agrup:=c("Gasolina", "Diesel", "Eléctrico", "Resto"
                      , "Gas", "Resto", "Gas", "Gas"
                      , "Gas", "Resto", "Resto", "Resto", "Resto"
                      )]

# union
matric_prop_tot <- tmp_aux[matric_prop_tot][, .(DESCRIPCION, N)]

# agrupación
matric_prop_tot

setnames(matric_prop_tot, names(matric_prop_tot), c("prop", "matric"))
