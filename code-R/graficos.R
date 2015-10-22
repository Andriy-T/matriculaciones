########################################################+
# Grafico temporal de matriculaciones
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

########################################################+
# Graficos descriptivos
########################################################+

# ------------------------------------------------------+
# Propulsion --------------
# ------------------------------------------------------+

# Highcharts.setOptions({
#     lang: {
#         decimalPoint: ',',
#         thousandsSep: ' '
#     }
# });

# Highcharts$global(lang=list(decimalPoint =",")) # no funciona

matric_prop_tot

graf.dsc.prop <- hPlot(matric ~ prop, data = matric_prop_tot
                       , type = "pie"
                       # , options = list(innerSize = "20%")
                       )

graf.dsc.prop$title(
    text = 'Matric. por <br>propulsion</br>',
    align = 'center',
    verticalAlign = 'middle'
    , y = -20
)

graf.dsc.prop$plotOptions(
    pie = list(
        dataLabels = list(
            enabled = T
            # , distance = -50
        )
#         , startAngle = -90
#         , endAngle = 90
        # , center = list('50%', '75%')
        , innerSize = '50%'
        , allowPointSelect = TRUE
        , cursor = 'pointer'
        , dataLabels = list(
            enabled = TRUE
        )
        , showInLegend = TRUE
        )
)

graf.dsc.prop$tooltip(
    pointFormat = paste0("<span style='color:{point.color}'>\u25CF</span>",
                    "<b>{point.percentage:.1f}%</b><br/>{point.y:,.0f}")
    # pointFormat = '<span style="color:{point.color}">\u25CF</span> {series.name}: <b>{point.y}</b><br/>'
    # pointFormat = "<b>{point.y}</b>"
)

graf.dsc.prop$legend(enabled = T)

graf.dsc.prop
