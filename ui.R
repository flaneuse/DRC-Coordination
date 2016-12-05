# DRC Partner Coordination tool
#
# UI FILE -------------------------------------------------------------
#
# Laura Hughes, lhughes@usaid.gov, 5 December 2016
# copyright 2016 via MIT License


# Header ------------------------------------------------------------------
header <- dashboardHeader(
  title = "USAID/DRCPartner Activities" 
)



# Define sidebar for filtering -----------------------------------------------
sidebar <- dashboardSidebar(
  # -- Select results --
  
  # -- Select mechanisms --
  # checkboxGroupInput('filterMech',label = 'mechanism', inline = FALSE,
  #                    choices = mechanisms,
  #                    selected = mechanisms),
  # -- Select IPs --
)




# Body --------------------------------------------------------------------
body <- dashboardBody(
  
  tags$head(
    # -- Import custom CSS --
    tags$link(rel = "stylesheet", type = "text/css", href = "leaflet.css"),
    # -- Include Google Analytics file -- 
    # Reference on how to include GA: http://shiny.rstudio.com/articles/google-analytics.html
    includeScript("google-analytics.js")), 
  
  # -- Each tab --
  tabsetPanel(
    
    
    tabPanel('by district',
             
             # -- plot maps --
             column(7, fluidRow(h3('Number of Partners by District')),
                    fluidRow(leafletOutput('main', height = heightMap,
                                           width = widthMap))),
             column(5, fluidRow(h3('Number of Unique Mechanisms by Province')),
                    fluidRow(ggvisOutput('numByProv')))
    )
    
    
    # -- Individual region plots --
    
  )
)

# Dashboard definition (main call) ----------------------------------------

dashboardPage(
  title = "USAID/DRC Partner Activities",  
  header,
  sidebar,
  body
)