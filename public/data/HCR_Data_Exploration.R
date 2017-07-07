# baseline clean up functions by Timo Grossenbacher
# https://timogrossenbacher.ch/2016/12/beautiful-thematic-maps-with-ggplot2-only/

remove(list = ls(all.names = TRUE))

detachAllPackages <- function() {
  basic.packages.blank <-  c("stats", 
                             "graphics", 
                             "grDevices", 
                             "utils", 
                             "datasets", 
                             "methods", 
                             "base")
  basic.packages <- paste("package:", basic.packages.blank, sep = "")
  
  package.list <- search()[ifelse(unlist(gregexpr("package:", search())) == 1, 
                                  TRUE, 
                                  FALSE)]
  
  package.list <- setdiff(package.list, basic.packages)
  
  if (length(package.list) > 0)  for (package in package.list) {
    detach(package, character.only = TRUE)
    print(paste("package ", package, " detached", sep = ""))
  }
}

detachAllPackages()

library(psych) # for describe function
library(ggplot2) # for beautiful graphs
library(car) # for scatterplots correlation matrices

# read expanded County Health Rankings data set
chr <- read.csv("https://raw.githubusercontent.com/tonmcg/us-presidential-election-results/master/public/data/chr.csv")

describe(chr)

newdata <- subset(chr,election_result != '')

describe(newdata)

ggplot(newdata, aes(x=election_result, y=Black.White.Segregation.index)) + geom_boxplot(fill="skyblue")
