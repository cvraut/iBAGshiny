#' Intro UI module 
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#'
#' @return a \code{shiny::\link[shiny]{tagList}} containing UI elements
#' @export
ibagIntroUi <- function(id) {
  ns <- shiny::NS(id)
  uiOutput(ns("ibagIntro"))
}




#' Server module generating the pokemon interface
#'
#' @param input Shiny inputs.
#' @param output Shiny outputs.
#' @param session Shiny session.
#'
#' @import shinyWidgets
#'
#' @export
ibagIntro <- function(input, output, session) {
  ns <- session$ns
  output$ibagIntro <- renderUI({
    tabItem(
      
      # Name of this tab
      tabName = "introduction",
      
      # #HTML formatting adds gap between top of page
      # br(),
      # br(),
      
      # Markdown document of Introductory contents
      #includeMarkdown("iBAG/markdown/introduction_markdown.Rmd")
      includeMarkdown("markdown/introduction_markdown.Rmd"),
      
      # Image below the Introduction Markdown content
      column(
        width = 6, 
        offset = 1,
        shiny::img(src = "iBAG_intro_pic.PNG",
                   width = 3*242,
                   height = 3*117)
      )
      
    )
  })
  return(NULL)
}