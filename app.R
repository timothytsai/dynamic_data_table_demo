library(shiny)
library(tidyverse)
library(DT)

ui <- fluidPage(
  titlePanel("Dynamic DataTable Demo"),
  sidebarLayout(
    sidebarPanel(
      "column select styles",
      uiOutput("checkbox_select"),
      uiOutput("dynamic_select")
    ),
    mainPanel(
      "data",
      dataTableOutput("table")
    )
  )
)

server <- function(input, output) {
  
  dynamic_select_preset <- c("name", "gender", "species", "homeworld", "films")
  
  output$checkbox_select <- renderUI({
    checkboxGroupInput(
      "checkbox_select", 
      label = "one option, checkboxes",
      choices = colnames(dplyr::starwars)
    )
  })
  
  output$dynamic_select <- renderUI({
    selectizeInput(
      "dynamic_select", "second option, selectizeInput",
      choices = colnames(dplyr::starwars),
      selected = dynamic_select_preset,
      multiple = TRUE)
  })
  
  reactive_table_data <- reactive({
    req(input$dynamic_select)
    
    tmp <- dplyr::starwars
    
    return(tmp)
  })
  
  output$table <- DT::renderDataTable({
    req(
      reactive_table_data(),
      input$dynamic_select
      )
    
    visible_columns <- colnames(reactive_table_data())[which(colnames(reactive_table_data()) %in% input$dynamic_select)]
    not_visible_targets <- which(!colnames(reactive_table_data()) %in% visible_columns) - 1
    
    DT::datatable(
      reactive_table_data(),
      options = list(
        columnDefs = list(
          list(
            visible = FALSE, 
            targets = not_visible_targets
          )
        )
      )
    )
  })
}

shinyApp(ui, server)