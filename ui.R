library(shiny)
library(DT)

ui <- fluidPage(
  titlePanel("Excel File Upload and Plotting"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload Excel File", 
                accept = c(".xlsx", ".xls")),
      uiOutput("sheet_selector"),    # For selecting the sheet
      uiOutput("x_axis_selector"),   # Dropdown for X axis
      uiOutput("y_axis_selector"),   # Dropdown for Y axis
      actionButton("plot", "Generate Plot")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Table Preview", dataTableOutput("data_table")),
        tabPanel("Plot", plotOutput("data_plot"))
      )
    )
  )
)