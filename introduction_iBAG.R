introduction_iBAG_page <- tabItem(
  
  # Name of this tab
  tabName = "introduction_iBAG",
  
  # #HTML formatting adds gap between top of page
  # br(),
  # br(),
  
  # Markdown document of Introductory contents
  #includeMarkdown("iBAG/markdown/introduction_markdown.Rmd")
  includeMarkdown("markdown/Linear_ibag_help_markdown.Rmd"),
  
  # Image below the Introduction Markdown content
  column(
    width = 6, 
    offset = 1,
    shiny::img(src = "ibag_updated.png",
               width = 7*111,
               height = 7*65)
  )
  
)