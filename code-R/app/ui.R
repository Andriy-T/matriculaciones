
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
                          # menuItem("Portada", tabName = "portada"),
                          menuItem("Resumen", tabName = "resumen", icon = icon("dashboard")),
                          menuItem("Indicadores", tabName = "indicadores"
                                   , icon = icon("area-chart")),
                          menuItem("Mapa", tabName = "mapa"
                                   , icon = icon("map-marker")),
                          menuItem("Tablas", tabName = "tablas", icon = icon("database"))
                      )
                  ),
                  
                  dashboardBody(
                      tabItems(
#                           # Pestaña portada
#                           tabItem(tabName = "portada",
#                                   h2("Esta es la página de bienvenida")
#                           ),
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
                                  , h3("Especificaciones de vehículos")
                                  , fluidRow(
                                      box(showOutput("graf.dsc.prop", "highcharts")
                                          , width = 6, height = 360),
                                      box(
                                          # "Selecciona el indicador", 
                                          br(),
                                          # sliderInput("slider", "Slider input:", 1, 100, 50),
                                          radioButtons("ind_rad_btn", "Selecciona el indicador"
                                                       , c("Cilindrada", "Potencia"),
                                                       inline = T)
                                          , showOutput("graf.ind_rad", "highcharts")
                                          , width = 6, height = 360)
                                  )
                          ),
                          tabItem(tabName = "mapa"
                                  , h3("Matriculaciones por comunidad autónoma")
                                  , fluidRow(
                                      box(leafletOutput("map"
                                                        , width = "100%"
                                                        , height = 500
                                                        )
                                          , width = 8, height = 520
                                      ),  
                                      box(
                                          dataTableOutput("tabla_mapa")
                                          , h3(
                                              paste("Pendiente reescalar tamaños de las bolas",
                                               "manteniendo distancias en volumen", 
                                               "entre las provincias")
                                          )
                                          , width = 4, height = 520
                                  )
                          )),
                          
                          tabItem(tabName = "tablas"
                                  , htmlOutput("selector_tabla")
                                  , span("Descargar la tabla completa:   "
                                         , downloadButton('downloadData', 'Download')),
                                  hr(),
                                  dataTableOutput(outputId="tabla"))
                      )
                  )
    ))