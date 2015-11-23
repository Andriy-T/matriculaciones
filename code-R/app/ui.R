
library(shiny)
library(shinydashboard)
library(shinythemes)

shinyUI(
    dashboardPage(skin = "black",
                  dashboardHeader(
                      title = "Matriculaciones de vehículos"
                      , titleWidth = 350
                  ),
                  
                  dashboardSidebar(
                      sidebarMenu(
                          htmlOutput("selector_fechas"),
                          menuItem("Portada", tabName = "portada"),
                          menuItem("Resumen", tabName = "resumen", icon = icon("dashboard")),
                          menuItem("Indicadores", tabName = "indicadores"
                                   , icon = icon("area-chart")),
                          menuItem("Tablas", tabName = "tablas", icon = icon("database"))
                      )
                  ),
                  
                  dashboardBody(
                      tabItems(
                          # Pestaña portada
                          tabItem(tabName = "portada",
                                  h2("Esta es la página de bienvenida")
                          ),
                          tabItem(tabName = "resumen"
                                  , h3("Evolución mensual de las matriculaciones en España")
                                                  , hr()
#                                   , box(title = NULL
#                                         # , column(htmlOutput("selector_fechas"), width = 4)
#                                         , htmlOutput("selector_area")
#                                         , htmlOutput("selector_tienda")
#                                         , collapsible=TRUE
#                                         # , height =  150
#                                         , width = 3)
                                  # , hr()
           , textOutput("resumen_text_1")
           , textOutput("resumen_text_2")
           , textOutput("resumen_text_3")
, hr()
, fluidRow(
    column(width = 4
           # , valueBoxOutput("res_matric_mes", width = 12)
           # , h4("Top marcas")
           , showOutput("graf.topMarca", "highcharts")
           ),
    column(width = 8
           , showOutput('graf.ts_matric', 'highcharts')
    )
)

#                                   , valueBoxOutput("res_clientes", width = 3)
#                                   , valueBoxOutput("res_objetivo", width = 3)
                                  # , infoBoxOutput("res_visitas", width = 6)
                          ),
                          # Pestaña indicadires
                          tabItem(tabName = "indicadores"
                                  , h3("Detalle vehículos por marca")
                                  , fluidPage(
                                      column(3, htmlOutput("ind_btn_tot"))
                                      , column(3, h4("Selecciona la marca"))
                                      , column(3, htmlOutput("ind_sel_marca"))
                                  )
                                  , fluidPage(
                                  )
                                  , showOutput('my.hChart', 'highcharts')
                                  
                                  #                 , fluidRow(
                                  #                   box(title = "Histogram", 
                                  #                       showOutput('my.hChart', 'highcharts')
                                  #                       , collapsible=F,
                                  #                       background = "green", footer = "Notas",
                                  #                       width = 12)
                                  #                 )
                          ),
                          
                          tabItem(tabName = "tablas"
                                  , htmlOutput("selector_tabla")
                                  , span("Descargar la tabla completa:   "
                                         , downloadButton('downloadData', 'Download')),
                                  hr(),
                                  dataTableOutput(outputId="tabla"))
                          # ,
                          #         tabItem(tabName = "mapa"
                          #                 ,   leafletOutput("map", width = "100%", height = "100%")
                          # 
                          #       )
                      )
                  )
    ))