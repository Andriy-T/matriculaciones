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
matric_tot_dia <- matric_tot_dia[fecha >= fechIni &
                                     fecha <= fechEnd]

########################################################################################+
# total matriculaciones por mes ----
########################################################################################+

tmp_df <- data_set_def[,.N, by = FEC_MATRICULA]

# reconocer formato de fecha
tmp_df[, fecha := as.Date(FEC_MATRICULA, format = "%d%m%Y")]

# Ordenacion cronologica
tmp_df2 <- tmp_df[,.(fecha, N)][order(fecha)]

# Agregacion mensual de datos
# pendiente aviso: mes incompleto

tmp_df2[, mes0 := fecha - as.numeric(strftime(fecha, format = "%d"))+1]

# filtro fechas y agrupando por mes en formato fecha
tmp_df3 <- tmp_df2[fecha >= fechIni & fecha <= fechEnd
                   , .(matric = sum(N)), by = mes0]

# columnas personalizadas para analisis
tmp_df3[, ':=' (mes = func.simpleCap(strftime(mes0, "%B"))
            , anio = strftime(mes0, "%Y")
            , mes_anio = func.simpleCap(strftime(mes0, "%B'%y")))]

# guardando resultados en una tabla
matric_tot_mes <- tmp_df3

########################################################################################+
# top n marcas ultimo mes ----
########################################################################################+

n <- 5

tmp_df <- data_set_def[as.Date(FEC_MATRICULA, format = "%d%m%Y")
                       %in% seq.Date(matric_tot_mes[.N,mes0], fechEnd, 1)
                       ,.N, by = DESCRIPCION_LARGA]

# seleccion de los campos
tmp_df2 <- tmp_df[order(N, decreasing = T)][1:n,]

setnames(tmp_df2, names(tmp_df2), c("Marca", "Matriculaciones"))

as.numeric(tmp_df2$Marca)

tmp_df2[, Marca := factor(Marca, levels = Marca)]

matric_topMarca <- tmp_df2

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

########################################################################################+
# Potencia ----
########################################################################################+

# por  lo visto tenemos la potencia fiscal
# hay que contrastarla contra la potencia medida en KW
# a partir de los KW se consiguen los CV

# Con la potencia fiscal se podr�a calcular valor de impuestos

# claves primarias para poder unir las tablas
matric_power_tot <- data_set_def[, .N, by = POTENCIA]
# setkey(matric_power_tot, CILINDRADA)
setnames(matric_power_tot, 
         names(matric_power_tot), c("potencia", "matric"))

# Construccion de tramos
str(matric_power_tot)
matric_power_tot[, potencia:=as.numeric(as.character(potencia))]

print(paste0("NA encontrados: ", matric_power_tot[is.na(potencia), matric]))
# Eliminacion de NA
matric_power_tot <- na.omit(matric_power_tot)

hist(matric_power_tot$potencia)

########################################################################################+
# Potencia (KW) ----
########################################################################################+

# claves primarias para poder unir las tablas
matric_powerKW_tot <- data_set_def[, .N, by = KW]
setnames(matric_powerKW_tot, 
         names(matric_powerKW_tot), c("kw", "matric"))

# Construccion de tramos
str(matric_powerKW_tot)
matric_powerKW_tot[, kw:=as.numeric(as.character(kw))]
matric_powerKW_tot[, cv:=kw*1.36]

hist(matric_powerKW_tot$kw)
hist(matric_powerKW_tot$cv)
matric_powerKW_tot[,tramos := 
    cut(matric_powerKW_tot$cv
        , breaks = c(0, 60, 90, 115, 140, 170, 210, 300, 450, 10000))
    ]

# Eliminacion de NA
matric_powerKW_tot <- na.omit(matric_powerKW_tot)

# Agrupamos los tramos
matric_powerKW_tot <- matric_powerKW_tot[, sum(matric), by = tramos]

# Ordenamos
matric_powerKW_tot <- matric_powerKW_tot[order(tramos, decreasing = F)]

setnames(matric_powerKW_tot, 
         names(matric_powerKW_tot), c("cv", "matric"))



########################################################################################+
# limpiar objetos temporales ----
########################################################################################+

rm(list = ls(pattern = "tmp_"))
