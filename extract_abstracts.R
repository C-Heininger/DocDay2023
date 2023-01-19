
# Load tidyverse ####

library(tidyverse)

# Read tab delimited file containing all abstracts (converted from .xlsx in Excel) ####

all_abstracts <- read_delim("abstracts_onecell.txt", 
                            delim = "\t",
                            col_names = TRUE,
                            locale = locale(encoding = "latin1"))               # file contains Umlaute, locale specification necessary

all_abstracts[22, "Surname"] <- "Krivic"                                        # name contained special character, changed to simplify

all_abstracts$Author <- gsub(";", "; ", all_abstracts$Author)                   # introducing spaces after each semicolon for nicer formating

# Use apply function to generate one PDF per row of input file (per abstract) ####

apply(all_abstracts, 1, function(x){
  # print(x)
  
  if(!is.na(x["CONSENS"])){                                                     # if CONSENSE is empty, submission will not get reviewed
                                                                                # no PDF necessary
    fname <- paste0(x["Record ID"], "_", x["Surname"], "_abstract.pdf")         # generate name based on abstract ID and Surname
    rmarkdown::render(input = "template.Rmd",                                   # use template.Rmd as RMarkdown template file
                      output_file = fname,
                      output_dir = "./PDFs/",
                      output_format = "pdf_document",
                      params = list(id=x["Record ID"],                          # take cell values and store as parameters for RMarkdown 
                                    surname=x["Surname"],                       # to use in template
                                    firstname=x["FirstName"],
                                    authors=x[["Author"]],
                                    programme=x["PhDProgramme"],
                                    aor=x["CONSENS"],
                                    title=x["AbstractTitle"],
                                    semester=x["Semester"],
                                    text=x["Abstract text"]))
  }
})


abstracts_list <- vector(mode = "list", length = nrow(all_abstracts))

for (i in 1:nrow(all_abstracts)) {
  
  abstracts_list[[i]] <- as.data.frame(all_abstracts[i,])
  
}

names(abstracts_list) <- paste0(all_abstracts$`Record ID`, "_", all_abstracts$Surname)








