
# All libraries used in book

# I grepped for library and made a libraries file:
# grep -hIr "library(" . > libraries.txt
# I then did a regexp of
# Search: .*library\(\W*([\w\._]*)\W*\).*
# Replace: $1
# in TextMate

packages <- c("tidyverse", "tidyverse", "tidyverse", "tidyverse", "tidyverse", "tidyverse", "tidyverse", "lme4", "lme4", "broom", "broom.mixed", "tidyverse", "tidyverse", "tidyverse", "mice", "scales", "scales", "scales", "tidyverse", "modelr", "nycflights13", "tidyverse", "gridExtra", "tidyverse", "tidyverse", "tidyverse", "ggplot2", "tidyverse", "tidyverse", "ggplot2", "nycflights13", "tidyverse", "gridExtra", "tidyverse", "glmnet", "caret", "dataedu", "glmnet", "caret", "tidyverse", "lme4", "lmerTest", "tidyverse", "mice", "scales", "scales", "scales", "tidyverse", "tidyverse", "tidyverse", "tidyverse", "tidyverse", "tidyverse", "tidyverse", "lme4", "lme4", "broom", "broom.mixed", "tidyverse", "tidyverse", "tidyverse", "mice", "scales", "scales", "scales", "tidyverse", "modelr", "nycflights13", "tidyverse", "gridExtra", "tidyverse", "tidyverse", "tidyverse", "ggplot2", "tidyverse", "tidyverse", "ggplot2", "nycflights13", "tidyverse", "gridExtra", "tidyverse", "glmnet", "caret", "dataedu", "glmnet", "caret", "tidyverse", "lme4", "lmerTest", "tidyverse", "mice", "scales", "scales", "scales", "MASS", "rattle", "glmnet", "tidyverse", "modelr", "broom", "caret", "ranger", "MASS", "rpart", "rattle", "scales", "caret", "gridExtra", "tidyverse", "ggplot2", "ggplot2", "scales", "scales", "gridExtra", "gridExtra", "MASS", "rattle", "glmnet", "tidyverse", "modelr", "broom", "caret", "ranger", "MASS", "rpart", "rattle", "scales", "caret", "gridExtra", "tidyverse", "ggplot2", "ggplot2", "scales", "scales", "gridExtra", "gridExtra") %>%
  unique()

# I finally pasted using datapasta into the following list, removing duplicates with a call to unique, and then re-pasting via:
# datapasta::vector_paste_vertical(sort( unique(packages)) )

packages <- c("broom",
              "broom.mixed",
              "caret",
              "dataedu",
              "ggplot2",
              "glmnet",
              "gridExtra",
              "lme4",
              "lmerTest",
              "MASS",
              "mice",
              "modelr",
              "nycflights13",
              "ranger",
              "rattle",
              "rpart",
              "scales",
              "tidyverse")

# Hand add some packages
pacakges = c( packages, "mosaic" )


for(p in packages) {
  tryCatch(test <- require(p,character.only=TRUE), 
           warning=function(w) return())
  if(!test)
  {
    print(paste("Package", p, "not found. Installing Package!"))
    install.packages(p)
    require(p)
  }
}


if ( FALSE ) {
  
  # some packages not on CRAN
  devtools::install_github("https://github.com/data-edu/dataedu")
  
}
