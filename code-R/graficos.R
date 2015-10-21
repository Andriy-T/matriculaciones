########################################################+
# Gráfico temporal de matriculaciones
########################################################+

# transformamos la tabla para visualizar bien las fechas
tmp_df_2 <- transform(matric_tot_dia
                      , Date = as.numeric(as.POSIXct(fecha))*1000)

# -------------------------------------------------------+
# Grafico -----
# -------------------------------------------------------+

# Definicion del grafico y los datos
graf.ts_matric <- hPlot(matric ~ Date, data = tmp_df_2, 
               type = "area"
)
# Titulo
graf.ts_matric$title(text = 'Matricualciones diarias')

# Opciones del grafico
graf.ts_matric$chart(zoomType = "x")
graf.ts_matric$params$width ="100%"
# graf.ts_matric$exporting(enabled=T)

graf.ts_matric$plotOptions(
    area = list(marker = list(enabled = F), stacking = "normal"
                  , fillOpacity = .3, lineWidth = 1
                , allowPointSelect = T, color = 'rgba(67,162,202,1)')
)

graf.ts_matric$tooltip(shared = T, crosshairs = list(T, T))
# graf.ts_matric$colors()

# Ejes
graf.ts_matric$xAxis(type = 'datetime'
         # , labels = list(format = '{value:%d/%m/%Y}')
         )

graf.ts_matric$yAxis(
    list(list(title = list(text = ''), min = 0, opposite = F
              , gridLineWidth = .8, gridLineColor = 'rgba(242,242,242,1)'
              , startOnTick = F, endOnTick = F
                  # , gridLineDashStyle = "Dot"
                  )
)
)

# devolver codigo html del objeto
graf.ts_matric$show("inline", include_assets = FALSE)

graf.ts_matric
