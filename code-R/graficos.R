# Gráfico temporal de linea
# Gráfico

tmp_df <- toJSONArray2(matric_tot_dia, json = F, name = F)
tmp_df <- toJSONArray(matric_tot_dia, json = F)
tmp_df <- matric_tot_dia

# libreria jsonlite
tmp_df_json <- toJSON(matric_tot_dia)

# con libreria rCharts
tmp_df_rch <- make_dataset("fecha", "matric", tmp_df)

tmp_df_2 <- matric_tot_dia
tmp_df_2 <- transform(tmp_df_2, Date = as.numeric(as.POSIXct(fecha))*1000)

h1 <- hPlot(matric ~ Date, data = tmp_df_2, 
               # group = 'Type', 
               type = "area"
               # radius=5
)
h1$xAxis(type = 'datetime', labels = list(
    format = '{value:%d/%m/%Y}'  
))
h1$chart(zoomType = "x")
h1

graf.ts_matric <- Highcharts$new()
# graf.ts_matric$chart(type = "area")
graf.ts_matric$xAxis(type = 'datetime', labels = list(
    format = '{value:%d/%m/%Y}'  
))
graf.ts_matric$chart(zoomType = "x")

graf.ts_matric$series(name ="matric", type = "area",
                      data = 
                          tmp_df_2[, matric]
#                           toJSONArray(tmp_df_2[, .(Date, matric)]
#                                          , json = F)
                      , yAxis = 0)
# graf.ts_matric$plotOptions(type="area")

graf.ts_matric

# devolver codigo html del objeto
graf.ts_matric$show("inline", include_assets = FALSE)
