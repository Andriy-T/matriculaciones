# Gráfico temporal de linea
# Gráfico

tmp_df <- toJSONArray2(matric_tot_dia, json = F, name = F)
tmp_df <- toJSONArray(matric_tot_dia, json = F)
tmp_df <- matric_tot_dia

graf.ts_matric <- Highcharts$new()
# graf.ts_matric$chart(type = "area")

graf.ts_matric$series(name ="matric", type = "area",
                      data = tmp_df[["matric"]], yAxis = 0)

graf.ts_matric

# devolver codigo html del objeto
graf.ts_matric$show("inline", include_assets = FALSE)
