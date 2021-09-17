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

# add Biocmanager to the repos list
options(repos = BiocManager::repositories())


# link the shinyapps.io account with the dev app
rsconnect::setAccountInfo(name='cvraut', token='1988AC5A45258075C8612E7ADD0236D9', secret='AMOGUS')
# push the app to the env
rsconnect::deployApp('C:\\Users\\craut\\Documents\\wip\\iBAGshiny')