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

# Multiple plot function
# http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_(ggplot2)/
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}

library(tidyverse) # includes dplyr and ggplot
library(psych) # for describe function
library(car) # for scatterplots correlation matrices

# read expanded County Health Rankings data set
chr <- read.csv("https://raw.githubusercontent.com/tonmcg/us-presidential-election-results/master/public/data/chr.csv")

describe(chr)

newdata <- subset(chr,election_result != '')

describe(newdata)

# count of counties won by Clinton and Trump
newdata %>%
  count(election_result, State) %>%
  ggplot(mapping = aes(x = election_result, y = State)) +
  geom_tile(mapping = aes(fill = n))


# plot interesting patterns using boxplots
y <- newdata$Household.Income # median household income

# rate of drug overdose mortality per 100,000 residents
x <- newdata$Drug.Overdose.Mortality.Rate

p1 <- ggplot(newdata, aes(x=x, y=y, fill=election_result)) + 
  geom_boxplot(mapping = aes(group = cut_width(x, 15))) +
  facet_wrap(~election_result) +
  scale_y_continuous(breaks=c(25000, 50000, 75000, 100000, 125000),
                     labels=c("$25K", "$50K", "$75K", "$100K", "$125K")) +
  labs(title="Drug Overdose Deaths by Median Income per Candidate", x="Drug Overdose Mortality Rate", y="Median Household Income", fill="Candidate")

# degree of Black/White racial segregation (0 - 100)
x <- newdata$Black.White.Segregation.index

p2 <- ggplot(newdata, aes(x=x, y=y, fill=election_result)) + 
  geom_boxplot(mapping = aes(group = cut_width(x, 10))) +
  facet_wrap(~election_result) +
  scale_y_continuous(breaks=c(25000, 50000, 75000, 100000, 125000),
                     labels=c("$25K", "$50K", "$75K", "$100K", "$125K")) +
  labs(title="Degree of Racial Segregation by Median Income per Candidate", x="Black/White Residential Segregation Index", y="Median Household Index", fill="Candidate")

p3 <- ggplot(data = newdata, mapping = aes(x = y, y = x, fill=election_result)) +
  geom_boxplot(mapping = aes(group = cut_width(y, 15000))) + 
  facet_wrap(~election_result) + 
  scale_x_continuous(breaks=c(25000, 50000, 75000, 100000, 125000),
                     labels=c("$25K", "$50K", "$75K", "$100K", "$125K")) +
  labs(title="Median Income by Degree of Racial Segregation per Candidate", x="Median Household Income", y="Segregation Index", fill="Candidate")
p1
p3