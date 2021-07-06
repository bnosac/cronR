#' @title Verify RscriptRespository path.
#' @description Verify that the supplied RscriptRepository path exists and that the user
#' has write access.
#' @param RscriptRepository Value of input$rscript_repository.
#' @return A warning if RscriptRepository path doesn't exist, or if the user
#' doesn't have write access; else, no return value.
verify_rscript_path <- function(RscriptRepository) {
  # first check whether path exists; if it does, then check whether you have write permission.
  if(is.na(file.info(RscriptRepository)$isdir)){
    warning(sprintf("The specified Rscript repository path %s does not exist, make sure this is an existing directory without spaces.", RscriptRepository))
  } else if (as.logical(file.access(RscriptRepository, mode = 2))) {
    warning(sprintf("You do not have write access to the specified Rscript repository path, %s.", RscriptRepository))
  }
}
