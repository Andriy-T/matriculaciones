# contruccion de tablas a partir del dataset
# construido en el codigo data.R

# df <- data_set_def

# print(object.size(df), units = "MB")
# str(df)
# df[, DESCRIPCION_LARGA:=as.character(DESCRIPCION_LARGA)]

########################################################################################+
# total matriculaciones por dia ----
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
# Propulsion ----
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

# Cambio de nombres a las columnas
setnames(matric_prop_tot, names(matric_prop_tot), c("prop", "matric"))

# Eliminacion de NA
matric_prop_tot <- na.omit(matric_prop_tot)

# Ordenamos
matric_prop_tot <- matric_prop_tot[order(matric, decreasing = T)]

########################################################################################+
# Cilindrada ----
########################################################################################+

# claves primarias para poder unir las tablas
matric_cilin_tot <- data_set_def[, .N, by = CILINDRADA]
# setkey(matric_cilin_tot, CILINDRADA)
setnames(matric_cilin_tot, 
         names(matric_cilin_tot), c("cilin", "matric"))

# Construccion de tramos
str(matric_cilin_tot)
matric_cilin_tot[, cilin:=as.integer(as.character(cilin))]

hist(matric_cilin_tot$cilin)
matric_cilin_tot[,tramos := 
    cut(matric_cilin_tot$cilin, breaks = c(0, 1000, 1500, 2000, 5000))
    ]

# Eliminacion de NA
matric_cilin_tot <- na.omit(matric_cilin_tot)

# Agrupamos los tramos
matric_cilin_tot <- matric_cilin_tot[, sum(matric), by = tramos]

# Ordenamos
matric_cilin_tot <- matric_cilin_tot[order(tramos, decreasing = F)]

setnames(matric_cilin_tot, 
         names(matric_cilin_tot), c("cilin", "matric"))

