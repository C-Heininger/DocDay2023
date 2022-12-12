
library(tidyverse)


all_abstracts <- read_delim("abstracts_onecell.txt", 
                            delim = "\t",
                            col_names = TRUE,
                            locale = locale(encoding = "latin1"))

all_abstracts[22, "Surname"] <- "Krivic"

all_abstracts$Author <- gsub(";", "; ", all_abstracts$Author)



apply(all_abstracts, 1, function(x){
  # print(x)
  
  if(!is.na(x["CONSENS"])){
    
    fname <- paste0(x["Record ID"], "_", x["Surname"], "_abstract.pdf")
    rmarkdown::render(input = "template.Rmd", 
                      output_file = fname,
                      output_dir = "./PDFs/",
                      output_format = "pdf_document",
                      params = list(id=x["Record ID"],
                                    surname=x["Surname"],
                                    firstname=x["FirstName"],
                                    authors=x[["Author"]],
                                    programme=x["PhDProgramme"],
                                    aor=x["CONSENS"],
                                    title=x["AbstractTitle"],
                                    semester=x["Semester"],
                                    text=x["Abstract text"]))
  }
})













