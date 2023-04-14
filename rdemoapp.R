library(shiny)
library(ggplot2)

# Define the user interface
ui <- fluidPage(
  titlePanel("Data Viewer"),
  sidebarLayout(
    sidebarPanel(
      selectInput("dataset", "Select a dataset:", choices = c("genre", "playlist")),
      selectInput("xvar", "Select x variable:", choices = NULL),
      selectInput("yvar", "Select y variable:", choices = NULL),
    ),
    mainPanel(
      tableOutput("data"),
      plotOutput("graph")
    )
  )
)

# Define the server
server <- function(input, output, session) {
  # Load the data frames
  genre <- read.csv("genres_v2.csv", header = TRUE)
  playlist <- read.csv("playlists.csv", header = TRUE)
  # Define the reactive function for selecting the dataset
  data <- reactive({
    switch(input$dataset,
           "genre" = genre,
           "playlist" = playlist)
  })
  # Update the x and y variable choices based on the selected dataset
  observe({
    updateSelectInput(session, "xvar", choices = names(data()))
    updateSelectInput(session, "yvar", choices = names(data()))
  })
  # Render the table output
  output$data <- renderTable({
    head(data())
  })
  # Render the plot output
  output$graph <- renderPlot({
    ggplot(data(), aes_string(x = input$xvar, y = input$yvar)) + geom_point()
  })
}

# Run the Shiny app
shinyApp(ui = ui, server = server)
