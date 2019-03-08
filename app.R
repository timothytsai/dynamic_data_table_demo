library(shiny)
library(dplyr)
library(DT)

ui <- fluidPage(
  titlePanel("Dynamic DataTable Demo"),
  mainPanel(
    h3("column selection"),
    uiOutput("dynamic_select"),
    h3("DataTable"),
    dataTableOutput("table")
  )
)

server <- function(input, output) {
  
  dynamic_select_preset <- c("name", "gender", "species", "homeworld", "films")
  
  table_data <- dplyr::starwars
  
  data_colnames <- colnames(table_data)
  
  output$dynamic_select <- renderUI({
    selectizeInput(
      "dynamic_select", "selectizeInput",
      choices = data_colnames,
      selected = dynamic_select_preset,
      multiple = TRUE
    )
  })
  
  output$table <- DT::renderDataTable({
    req(input$dynamic_select)
    
    visible_columns <- data_colnames[which(data_colnames %in% input$dynamic_select)]
    not_visible_targets <- which(!data_colnames %in% visible_columns) - 1
    
    DT::datatable(
      table_data,
      rownames = FALSE,
      filter = "top",
      options = list(
        columnDefs = list(
          list(
            visible = FALSE, 
            targets = not_visible_targets
          )
        ),
        dom = "Blfrtip",
        searchHighlight = TRUE
      )
    )
  })
}

shinyApp(ui, server)