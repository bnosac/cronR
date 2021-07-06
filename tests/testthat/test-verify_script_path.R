test_that("verify_rscript_path shows warning messages correctly", {

  expect_warning(
    verify_rscript_path("/opt"),
    "You do not have write access to the specified Rscript repository path, /opt."
  )
  
  expect_warning(
    verify_rscript_path("/DirClearlyDoesNotExist"),
    "The specified Rscript repository path /DirClearlyDoesNotExist does not exist, make sure this is an existing directory without spaces."
  )
  
})
