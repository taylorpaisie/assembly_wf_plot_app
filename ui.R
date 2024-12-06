library(shiny)
library(ggplot2)
library(DT)
library(readxl)

# Define the UI
fluidPage(
  titlePanel("Excel File Analysis with Graphs"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload an Excel File",
                accept = c(".xlsx", ".xls")),
      uiOutput("sheet_selector"),  # Dropdown for sheet selection
      uiOutput("x_var_selector"),  # Dropdown for x-variable
      uiOutput("y_var_selector"),  # Dropdown for y-variable
      selectInput("plot_type", "Select Plot Type:",
                  choices = c("Scatter Plot", "Bar Chart", "Line Plot")),
      helpText("Upload an Excel file and select a sheet to create visualizations.")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Data Table", DTOutput("dataTable")),  # Display data
        tabPanel("Graph", plotOutput("plot"))           # Display plot
      )
    )
  )
)

