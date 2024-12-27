
# This script grabs all the packages listed in the set of qmd files
# and installs any that are not currently installed.  Good to run
# before trying to render the book on a local machine.



# List all qmd files
qmd_files <- list.files(path = ".", pattern = "\\.qmd$", recursive = TRUE)


# extra packages
ex_pack = c( "mosaic", "TeachingDemos" )

# Initialize an empty vector to store packages
packages <- c()

# Loop through each file and extract library calls
for (file in qmd_files) {
  content <- readLines(file)
  libs <- grep("^\\s*library\\(([^)]+)\\)", content, value = TRUE)
  if (length(libs) > 0) {
    pkgs <- sub("^\\s*library\\(([^)]+)\\).*", "\\1", libs)
    packages <- c(packages, pkgs)
  }
  
  # Extract double colon references (e.g., pkg::function)
  double_colon_refs <- grep("([a-zA-Z0-9.]+)::", content, value = TRUE)
  if (length(double_colon_refs) > 0) {
    pkgs_double_colon <- unique(sub(".*?([a-zA-Z0-9.]+)::.*", "\\1", double_colon_refs))
    packages <- c(packages, pkgs_double_colon)
  }  
}

# Get unique packages
unique_packages <- unique( c( str_trim(packages), ex_pack ) )

# Print the list of unique packages
cat("Packages used in the project:\n")
print(unique_packages)

not_installed <- unique_packages[!unique_packages %in% installed.packages()[,"Package"]]
if (length(not_installed) > 0) {
  cat("\nPackages not installed:\n")
  print(not_installed)
  cat("\nInstalling packages...\n")
  install.packages(not_installed)
} else {
  cat("\nAll packages are installed.\n")
}
