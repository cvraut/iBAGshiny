#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

require(shiny)
require(ggplot2)
require(shinydashboard)
require(shinythemes)
require(rmarkdown)
#require(d3heatmap)
require(bslib)

source("func.R")
source("introduction.R")
source("introduction_iBAG.R")

library(bslib)

# library(charpente)
# html_2_R('<div class="divclass" id = "someid"></div>')

library(htmltools)
tablers_deps <- htmlDependency(
    name = "tabler",
    version = "1.0.7", # we take that of tabler,
    src = c(href = "https://cdn.jsdelivr.net/npm/tabler@1.0.0-alpha.7/dist/"),
    script = "js/tabler.min.js",
    stylesheet = "css/tabler.min.css"
)

bs4_deps <- htmlDependency(
    name = "Bootstrap",
    version = "4.3.1",
    src = c(href = "https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/"),
    script = "bootstrap.bundle.min.js"
)

jQuery_deps <- htmlDependency(
    name = "jquery",
    version = "3.6.0",
    src = c(href = "https://code.jquery.com/"),
    script = "jquery-3.6.0.slim.min.js"
)

# add all dependencies to a tag. Don't forget to set append to TRUE to preserve any existing dependency
add_tabler_deps <- function(tag) {
    # below, the order is of critical importance!
    deps <- list(bs4_deps, tablers_deps)
    attachDependencies(tag, deps, append = TRUE)
}


tabler_page <- function(..., dark = FALSE, title = NULL, favicon = NULL){
    
    # head
    head_tag <- tags$head(
        tags$meta(charset = "utf-8"),
        tags$meta(
            name = "viewport", 
            content = "
        width=device-width, 
        initial-scale=1, 
        viewport-fit=cover"
        ),
        tags$meta(`http-equiv` = "X-UA-Compatible", content = "ie=edge"),
        tags$title(title),
        tags$link(
            rel = "preconnect", 
            href = "https://fonts.gstatic.com/", 
            crossorigin = NA
        ),
        tags$meta(name = "msapplication-TileColor", content = "#dce2e7"),
        tags$meta(name = "theme-color", content = "#dce2e7"),
        tags$meta(name = "apple-mobile-web-app-status-bar-style", content = "black-translucent"),
        tags$meta(name = "apple-mobile-web-app-capable", content = "yes"),
        tags$meta(name = "mobile-web-app-capable", content = "yes"),
        tags$meta(name = "HandheldFriendly", content = "True"),
        tags$meta(name = "MobileOptimized", content = "320"),
        tags$meta(name = "robots", content = "noindex,nofollow,noarchive"),
        tags$link(rel = "icon", href = favicon, type = "image/x-icon"),
        tags$link(rel = "shortcut icon", href = favicon, type="image/x-icon")
    )
    
    # body
    body_tag <- tags$body(
        tags$div(
            class = paste0("antialiased ", if(dark) "theme-dark", if(!dark) "theme-light"),
            style = "display: block;",
            tags$div(class = "page", ...)
        )
    ) %>% add_tabler_deps()
    
    tagList(head_tag, body_tag)
}


library(shiny)
library(thematic)

thematic_shiny()

tabler_body <- function(..., footer = NULL) {
    div(
        class = "content",
        div(class = "container-xl", ...),
        tags$footer(class = "footer footer-transparent", footer)
    )
}

tabler_footer <- function(left = NULL, right = NULL) {
    div(
        class = "container",
        div(
            class = "row text-center align-items-center flex-row-reverse",
            div(class = "col-lg-auto ml-lg-auto", right),
            div(class = "col-12 col-lg-auto mt-3 mt-lg-0", left)
        )
    )
}

tabler_navbar <- function(..., brand_url = NULL, brand_image = NULL, 
                          nav_menu, nav_right = NULL) {
    
    header_tag <- tags$header(class = "navbar navbar-expand-md")
    container_tag <- tags$div(class = "container-xl")
    
    # toggler for small devices (must not be removed)
    toggler_tag <- tags$button(
        class = "navbar-toggler", 
        type = "button", 
        `data-toggle` = "collapse", 
        `data-target` = "#navbar-menu",
        span(class = "navbar-toggler-icon")
    )
    
    # brand elements
    brand_tag <- if (!is.null(brand_url) || !is.null(brand_image)) {
        a(
            href = if (!is.null(brand_url)) {
                brand_url
            } else {
                "#"
            },
            class = "navbar-brand navbar-brand-autodark 
      d-none-navbar-horizontal pr-0 pr-md-3",
            if(!is.null(brand_image)) {
                img(
                    src = brand_image, 
                    alt = "brand Image",
                    class = "navbar-brand-image"
                )
            }
        )
    }
    
    dropdown_tag <- if (!is.null(nav_right)) {
        div(class = "navbar-nav flex-row order-md-last", nav_right)
    }
    
    navmenu_tag <- div(
        class = "collapse navbar-collapse", 
        id = "navbar-menu",
        div(
            class = "d-flex flex-column flex-md-row flex-fill 
      align-items-stretch align-items-md-center",
            nav_menu
        ),
        if (length(list(...)) > 0) {
            div(
                class = "ml-md-auto pl-md-4 py-2 py-md-0 mr-md-4 
        order-first order-md-last flex-grow-1 flex-md-grow-0", 
                ...
            )
        }
    )
    
    container_tag <- container_tag %>% tagAppendChildren(
        toggler_tag,
        brand_tag,
        dropdown_tag,
        navmenu_tag
    )
    
    header_tag %>% tagAppendChild(container_tag)
    
}

tabler_navbar_menu <- function(...) {
    tags$ul(class = "nav nav-pills navbar-nav", ...)
}

tabler_navbar_menu_item <- function(text, tabName, icon = NULL, 
                                    selected = FALSE) {
    
    item_cl <- paste0("nav-link", if(selected) " active")
    
    tags$li(
        class = "nav-item",
        a(
            class = item_cl,
            `data-target` = paste0("#", tabName),
            `data-toggle` = "pill",
            `data-value` = tabName,
            role = "tab",
            span(class = "nav-link-icon d-md-none d-lg-inline-block", icon),
            span(class = "nav-link-title", text)
        )
    )
}

tabler_tab_items <- function(...) {
    div(class = "tab-content", ...)
}

tabler_tab_item <- function(tabName = NULL, ...) {
    div(
        role = "tabpanel",
        class = "tab-pane fade container-fluid",
        id = tabName,
        ...
    )
}

ui <- tabler_page(
    tags$head(tags$script(src = "tabler_tabs_init.js")),
    tabler_navbar(
        brand_url = "https://bayesrx.github.io/", 
        brand_image = "https://preview-dev.tabler.io/static/logo.svg", 
        nav_menu = tabler_navbar_menu(
            tabler_navbar_menu_item(
                text = "iBAG",
                icon = NULL,
                tabName = "tab1",
                selected = TRUE
            ),
            tabler_navbar_menu_item(
                text = "Linear",
                icon = NULL,
                tabName = "tab2"
            )
        )
    ),
    tabler_body(
        tabler_tab_items(
            tabler_tab_item(
                tabName = "tab1",
                introduction_page
            ),
            tabler_tab_item(
                tabName = "tab2",
                tabler_page(
                    tags$head(tags$script(src = "tabler_tabs_init.js")),
                    tabler_navbar(
                        nav_menu = tabler_navbar_menu(
                            tabler_navbar_menu_item(
                                text = "intro",
                                icon = NULL,
                                tabName = "lin1",
                                selected = TRUE
                            ),
                            tabler_navbar_menu_item(
                                text = "data",
                                icon = NULL,
                                tabName = "lin2"
                            )
                        )
                    ),
                    tabler_body(
                        tabler_tab_items(
                            tabler_tab_item(
                                tabName = "lin1",
                                introduction_iBAG_page
                            )
                        ),
                        tabler_tab_items(
                            tabler_tab_item(
                                tabName = "lin2",
                                introduction_iBAG_page
                            )
                        )
                    )
                )
            )
        ),
        footer = tabler_footer(
            left = "Bayesrx, 2021", 
            right = a(href = "https://bayesrx.github.io/")
        )
    )
)
server <- function(input, output) {}
shinyApp(ui, server)


