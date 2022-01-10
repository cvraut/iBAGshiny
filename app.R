# shiny deps
library(shiny)
library(tablerDash)
library(shinyWidgets)
library(shinyEffects)
library(pushbar)
library(markdown)

# this 'pkg'
library(ibagshiny)

# read the main data (GBR)



# shiny app code
shiny::shinyApp(
    ui = tablerDashPage(
        enable_preloader = TRUE,
        loading_duration = 4,
        navbar = tablerDashNav(
            id = "mymenu",
            src = "bayesrx.svg",
            navMenu = tablerNavMenu(
                tablerNavMenuItem(
                    tabName = "Intro",
                    icon = "home",
                    "Introduction"
                ),
                tablerNavMenuItem(
                    tabName = "Linear",
                    icon = "box",
                    "Linear"
                )
            ),
            
            # Title of Webpage should go here
            
            tablerDropdown(
                tablerDropdownItem(
                    title = NULL,
                    href = "https://rinterface.github.io/tablerDash/", # link for the comment to point to
                    url = "https://avatars.githubusercontent.com/u/10603882?v=4",
                    status = "success",
                    date = NULL,
                    "This app uses the tablerDash api to look pretty."
                )
            )
        ),
        footer = tablerDashFooter(
            copyrights = "Disclaimer: this app is provided as is. @Chinmay Raut, 2021"
        ),
        title = "iBAG",
        body = tablerDashBody(
            
            # load pushbar dependencies
            pushbar_deps(),
            
            # custom jquery to hide some inputs based on the selected tag
            # actually tablerDash would need a custom input/output binding
            # to solve this issue once for all
            tags$head(
                # test whether mobile or not
                tags$script(
                    "$(document).on('shiny:connected', function(event) {
            var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
            Shiny.onInputChange('isMobile', isMobile);
          });
          "
                )
            ),
            
            # custom shinyWidgets skins
            chooseSliderSkin("Round"),
            
            # use shinyEffects
            setShadow(class = "galleryCard"),
            setZoom(class = "galleryCard"),
            
            tablerTabItems(
                tablerTabItem(
                    tabName = "Intro",
                    ibagIntroUi(id = "Intro")
                ),
                tablerTabItem(
                    tabName = "Linear",
                    ibagLinearUi(id = "Linear")
                )
            )
        )
    ),
    server = function(input, output, session) {
        # determine whether we are on mobile or not
        # relies on a simple Shiny.onInputChange
        isMobile <- reactive(input$isMobile)
        
        # main module (data)
        main <- callModule(module = ibagInput, id = "input")
        
        # Intro module
        callModule(
            module = ibagIntro,
            id = "Intro"
        )
        
        # Linear module
        callModule(
            module = ibagLinear,
            id = "Linear"
        )
    }
)