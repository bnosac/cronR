#' @title Create a command to execute an R script which can be scheduled with cron_add
#' @description Create a command to execute an R script which can be scheduled with cron_add where the stdin and stderr will be passed on to a log
#' @param rscript character string with the path to an R script with .r or .R extension
#' @param rscript_log where to put the log, defaults in the same directory and with the same filename as \code{rscript} but with  extension .log.
#' @param rscript_args a character string with extra arguments to be passed on to Rscript
#' @param cmd path to Rscript. Defaults to R_HOME/bin/Rscript
#' @param log_append logical, append to the log or overwrite
#' @param log_timestamp logical, indicating to append a timestamp to the script log filename in the default argument of \code{rscript_log}. 
#' This will only work if the path to the log folder does not contain spaces.
#' @param workdir If provided, Rscript will be run from this working directory.
#' @param trailing_arg If provided, this is added to the end of the command
#' @return a character string with a command which can e.g. be put as a cronjob for running a simple R script at specific timepoints
#' @export
#' @examples
#' f <- system.file(package = "cronR", "extdata", "helloworld.R")
#' cron_rscript(f)
#' cron_rscript(f, rscript_args = "more arguments passed on to the call")
#' cron_rscript(f, rscript_args = c("more", "arguments", "passed", "on", "to", "the", "call"))
#' 
#' cron_rscript(f, log_append = FALSE)
#' cron_rscript(f, log_append = TRUE)
#' cron_rscript(f, log_append = FALSE, log_timestamp = TRUE)
#' 
#' ## run from home directory
#' cron_rscript(f, workdir = normalizePath("~"))
#' 
cron_rscript <- function(rscript,
                         rscript_log = sprintf("%s%s.log", tools::file_path_sans_ext(rscript), ifelse(log_timestamp, "-`date+\\%Y-\\%m-\\%d_\\%H:\\%M:\\%S`", "")),
                         rscript_args = "",
                         cmd = file.path(Sys.getenv("R_HOME"), "bin", "Rscript"),
                         log_append = TRUE,
                         log_timestamp = FALSE,
                         workdir = NULL,
                         trailing_arg = NULL) {
  stopifnot(file.exists(rscript))
  if(length(rscript_args) > 0){
    rscript_args <- paste(rscript_args, collapse = " ")
  }
  if(basename(rscript) == rscript){
    rscript <- file.path(getwd(), rscript)
  }
  if(log_append){
    cmd <- sprintf('%s %s %s >> %s 2>&1', cmd, shQuote(rscript), rscript_args, shQuote(rscript_log))  
  }else{
    cmd <- sprintf('%s %s %s > %s 2>&1', cmd, shQuote(rscript), rscript_args, shQuote(rscript_log))  
  }
  if(!is.null(workdir)){
    cmd <- sprintf("%s %s %s %s",  "cd", shQuote(workdir), "&&", cmd)
  }
  
  if(!is.null(trailing_arg)){
    cmd <- sprintf("%s %s %s %s", cmd, "&&", shQuote(trailing_arg))
   }
  
  cmd
}
