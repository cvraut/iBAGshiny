#' Linear module 
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#'
#' @return a \code{shiny::\link[shiny]{tagList}} containing UI elements
#' @export
ibagLinearUi <- function(id) {
  ns <- shiny::NS(id)
  uiOutput(ns("ibagLinear"))
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
ibagLinear <- function(input, output, session) {
  
  ns <- session$ns
  sliderInput("obs",
              "Number of observations:",
              min = 0,
              max = 1000,
              value = 500)
}