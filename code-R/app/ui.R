
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
                          menuItem("Dashboard", tabName = "dashboard", icon = icon("area-chart")),
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
                                  , h3("Evolución de las matriculaciones en España")
                                                  , hr()
#                                   , box(title = NULL
#                                         # , column(htmlOutput("selector_fechas"), width = 4)
#                                         , htmlOutput("selector_area")
#                                         , htmlOutput("selector_tienda")
#                                         , collapsible=TRUE
#                                         # , height =  150
#                                         , width = 3)
                                  # , hr()
                                  , valueBoxOutput("res_matric_mes", width = 3)
                                    , showOutput('graf.ts_matric', 'highcharts')

#                                   , valueBoxOutput("res_clientes", width = 3)
#                                   , valueBoxOutput("res_objetivo", width = 3)
                                  # , infoBoxOutput("res_visitas", width = 6)
                          ),
                          # Pestaña dashboard
                          tabItem(tabName = "dashboard"
                                  , h3("Evolución temporal")
                                  , fluidPage(
                                      column(3, htmlOutput("selector_kpi_1"))
                                      , column(3, htmlOutput("selector_kpi_2"))
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