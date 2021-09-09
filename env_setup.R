# list of commands to duplicate the environment & run the shiny app

# use renv to manage stuffs
install.packages("renv")
library(renv)

# to initialize and save the environment:
renv::init()

# call save_world from R shell
save_world <- function(lockfile_name = "renv.lock"){
  renv::settings$snapshot.type("all")
  renv::snapshot(lockfile = lockfile_name)
}

# call load_world from R shell
load_world <- function(lockfile_name = "renv.lock"){
  renv::restore(lockfile = lockfile_name)
}
