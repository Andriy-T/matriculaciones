########################################################+
# Grafico temporal de matriculaciones
########################################################+

# transformamos la tabla para visualizar bien las fechas
tmp_df_2 <- transform(matric_tot_mes
                      , Date = as.numeric(as.POSIXct(mes0))*1000)

# -------------------------------------------------------+
# Grafico -----
# -------------------------------------------------------+

# Definicion del grafico y los datos
graf.ts_matric <- hPlot(matric ~ Date, data = tmp_df_2, 
               type = "area"
)
# Titulo
graf.ts_matric$title(text = 'Evolución mensual')

# Opciones del grafico
# graf.ts_matric$chart(zoomType = "x")
graf.ts_matric$params$width ="100%"
graf.ts_matric$params$height = 360
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
# graf.ts_matric$show("inline", include_assets = FALSE)

# graf.ts_matric

########################################################+
# Graficos descriptivos
########################################################+

# ------------------------------------------------------+
# top marcas en matric el último mes --------------
# ------------------------------------------------------+

graf.topMarca <- hPlot(Matriculaciones ~ Marca, data = matric_topMarca
                     , type = "bar"
)

graf.topMarca$params$width ="100%"
graf.topMarca$params$height = 360

# Titulo
graf.topMarca$title(text = 'Top marcas', align = "left")

graf.topMarca$plotOptions(
    bar = list(
        colorByPoint = F
        , dataLabels = list(
            enabled = T
        )
        , pointPadding = 0
        , groupPadding = 0.05
        , dataLabels = list(
            enabled = TRUE
            , color = '#FFFFFF'
            , x = -70 #10 pixels down from the top
            , style = list(
                fontSize = '14px'
                , fontWeight = "bold"
                , fontFamily = 'Verdana, sans-serif'
            )
        )
        , showInLegend = TRUE
    )
)


graf.topMarca$yAxis(
    list(list(title = list(text = ''), min = 0
              , gridLineWidth = 0, labels = list(enabled = F)
    )
    )
)
graf.topMarca$xAxis(
    categories = matric_topMarca$Marca
    , lineWidth = 0
    , tickWidth = 0
    , title = list(text = '')
)

# graf.topMarca

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

graf.dsc.prop$params$width ="100%"
graf.dsc.prop$params$height = 720

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

# graf.dsc.prop

# ------------------------------------------------------+
# Cilindrada (ejemplo de bar chart) --------------
# ------------------------------------------------------+

matric_cilin_tot

tmp_ylim <- matric_cilin_tot[,max(matric)*1.25]

graf.dsc.cilin <- hPlot(matric ~ cilin, data = matric_cilin_tot
                       , type = "column"
                       # , options = list(innerSize = "20%")
                       )

graf.dsc.cilin$params$width ="100%"
graf.dsc.cilin$params$height = 240

graf.dsc.cilin$title(
    text = 'Matriculaciones por tramo de cilindrada',
    align = 'center'
)

graf.dsc.cilin$plotOptions(
    column = list(
        colorByPoint = T
        , dataLabels = list(
            enabled = T
        )
        , allowPointSelect = TRUE
        , cursor = 'pointer'
        , dataLabels = list(
            enabled = TRUE
            # , rotation = -90
            # , color = '#FFFFFF'
            # , align = 'right'
            # , format = '{point.y:.1f}'
            # , y = -20 #10 pixels down from the top
            , style = list(
                fontSize = '14px'
                , fontWeight = "bold"
                , fontFamily = 'Verdana, sans-serif'
            )
        )
        , showInLegend = TRUE
        )
)


graf.dsc.cilin$yAxis(
    list(list(title = list(text = ''), min = 0, opposite = F
              , gridLineWidth = .8, gridLineColor = 'rgba(242,242,242,1)'
              , startOnTick = F, endOnTick = F
              , max = tmp_ylim
              # , gridLineDashStyle = "Dot"
    )
    )
)

# graf.dsc.cilin


# ------------------------------------------------------+
# Potencia en cv (ejemplo de bar chart) --------------
# ------------------------------------------------------+

matric_powerKW_ITV_tot

tmp_ylim <- matric_powerKW_ITV_tot[,max(matric)*1.25]

graf.dsc.cv <- hPlot(matric ~ cv, data = matric_powerKW_ITV_tot
                       , type = "column"
                       # , options = list(innerSize = "20%")
                       )


graf.dsc.cv$params$width ="100%"
graf.dsc.cv$params$height = 240


graf.dsc.cv$title(
    text = 'Matriculaciones por tramo de potencia (cv)',
    align = 'center'
)

graf.dsc.cv$plotOptions(
    column = list(
        colorByPoint = T
        , dataLabels = list(
            enabled = T
        )
        , allowPointSelect = TRUE
        , cursor = 'pointer'
        , dataLabels = list(
            enabled = TRUE
            # , rotation = -90
            # , color = '#FFFFFF'
            # , align = 'right'
            # , format = '{point.y:.1f}'
            # , y = -20 #10 pixels down from the top
            , style = list(
                fontSize = '14px'
                , fontWeight = "bold"
                , fontFamily = 'Verdana, sans-serif'
            )
        )
        , showInLegend = TRUE
        )
)


graf.dsc.cv$yAxis(
    list(list(title = list(text = ''), min = 0, opposite = F
              , gridLineWidth = .8, gridLineColor = 'rgba(242,242,242,1)'
              , startOnTick = F, endOnTick = F
              , max = tmp_ylim
              # , gridLineDashStyle = "Dot"
    )
    )
)

# graf.dsc.cv



## Borrador -----

# tooltip: {
#     headerFormat: '<span style="font-size:11px">{series.name}</span><br>',
#     pointFormat: '<span style="color:{point.color}">{point.name}</span>: <b>{point.y:.2f}%</b> of total<br/>'
# }
