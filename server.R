library(shiny)
library(readxl)
library(ggplot2)
library(DT)
library(janitor) # Optional: For cleaning column names

server <- function(input, output, session) {
  
  # Reactive: Load Excel file
  excel_data <- reactive({
    req(input$file)
    validate(
      need(tools::file_ext(input$file$name) %in% c("xls", "xlsx"), 
           "Please upload a valid Excel file.")
    )
    # Read the first sheet by default
    readxl::read_excel(input$file$datapath, sheet = 1)
  })
  
  # Dynamically update sheet names if Excel contains multiple sheets
  output$sheet_selector <- renderUI({
    req(input$file)
    sheets <- readxl::excel_sheets(input$file$datapath)
    selectInput("sheet", "Select Sheet:", choices = sheets)
  })
  
  # Reactive: Get data for the selected sheet
  sheet_data <- reactive({
    req(input$file, input$sheet)
    data <- readxl::read_excel(input$file$datapath, sheet = input$sheet)
    # Optional: Clean column names for easier handling
    janitor::clean_names(data)
  })
  
  # Dynamically update column names for X-axis and Y-axis selection
  output$x_axis_selector <- renderUI({
    req(sheet_data())
    selectInput("x_col", "Select X-Axis (categorical):", choices = names(sheet_data()))
  })
  
  output$y_axis_selector <- renderUI({
    req(sheet_data())
    selectInput("y_col", "Select Y-Axis (numeric):", choices = names(sheet_data()))
  })
  
  # Display the data table preview
  output$data_table <- renderDataTable({
    req(sheet_data())
    datatable(sheet_data(), options = list(pageLength = 5))
  })
  
  # Plot the data as a colorful bar plot
  output$data_plot <- renderPlot({
    req(sheet_data(), input$x_col, input$y_col, input$plot)
    
    # Get the data
    data <- sheet_data()
    
    # Use backticks for column names to handle special characters
    ggplot(data, aes_string(x = paste0("`", input$x_col, "`"), 
                            y = paste0("`", input$y_col, "`"), 
                            fill = paste0("`", input$x_col, "`"))) +
      geom_bar(stat = "identity") +
      scale_fill_brewer(palette = "Dark2") + # Use a pre-defined colorful palette
      labs(title = "Colorful Bar Plot", x = input$x_col, y = input$y_col) +
      theme_minimal() +
      theme(legend.position = "none") # Hide the legend for simplicity
  })
}
