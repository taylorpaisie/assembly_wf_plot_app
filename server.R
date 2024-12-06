library(shiny)
library(ggplot2)
library(DT)
library(readxl)


function(input, output, session) {
  
  # Reactive to store sheet names
  sheet_names <- reactive({
    req(input$file)
    excel_sheets(input$file$datapath)
  })
  
  # Dynamic UI for sheet selection
  output$sheet_selector <- renderUI({
    req(sheet_names())
    selectInput("sheet", "Select Sheet:", choices = sheet_names())
  })
  
  # Reactive to read data from the selected sheet
  data <- reactive({
    req(input$file, input$sheet)
    read_excel(input$file$datapath, sheet = input$sheet)
  })
  
  # Dynamic UI for x-variable selection
  output$x_var_selector <- renderUI({
    req(data())
    selectInput("x_var", "Select X Variable:", choices = names(data()))
  })
  
  # Dynamic UI for y-variable selection
  output$y_var_selector <- renderUI({
    req(data())
    selectInput("y_var", "Select Y Variable:", choices = names(data()))
  })
  
  # Render the data table
  output$dataTable <- renderDT({
    req(data())
    datatable(data())
  })
  
  # Render the plot
  output$plot <- renderPlot({
    req(data(), input$x_var, input$y_var, input$plot_type)
    
    # Prepare the data
    plot_data <- data()
    
    # Create the plot based on the selected type
    p <- ggplot(plot_data, aes_string(x = input$x_var, y = input$y_var))
    
    if (input$plot_type == "Scatter Plot") {
      p <- p + geom_point()
    } else if (input$plot_type == "Bar Chart") {
      p <- p + geom_bar(stat = "identity")
    } else if (input$plot_type == "Line Plot") {
      p <- p + geom_line()
    }
    
    # Customize plot
    p + theme_minimal() +
      labs(title = paste(input$plot_type, "of", input$y_var, "vs", input$x_var),
           x = input$x_var,
           y = input$y_var)
  })
}
