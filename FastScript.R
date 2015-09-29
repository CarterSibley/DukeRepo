# Three things you almost always need in R to examine data
require(ggplot2)
require(data.table)
require(dplyr)
setwd("~/local/kaggle/DukeLiberty")

# Load the data
trainFile = data.table(read.csv("data/train.csv"))
names(trainFile)

# What is my target?
targetVar = "Hazard"

# What does the distribution look like?
p <- ggplot(trainFile)
p <- p + geom_histogram(aes(x=Hazard))
p

# Narrow the bins
p <- ggplot(trainFile)
p <- p + geom_histogram(aes(x=Hazard), binwidth = 1)
p

# Is there something with every third value?
p <- ggplot(trainFile %>% mutate(group = Hazard %% 3))
p <- p + geom_histogram(aes(x=Hazard), binwidth = 1)
p <- p + facet_wrap(~ group)
p

# Let's start to look at one-way plots
p <- ggplot(trainFile)
p <- p + geom_bar(aes(x = T1_V6, y = Hazard), stat = "summary", fun.y = mean)
p

# Let's look at all of our one-way plots
indVars = setdiff(names(trainFile), c("Hazard", "Id"))
dir.create(file.path("report"), showWarnings = FALSE)

for(v in indVars) {
  p <- ggplot(trainFile)
  p <- p + geom_bar(aes_string(x = v, y = targetVar), stat = "summary", fun.y = mean)
  ggsave(file.path("report", paste0(indVars, ".png")), p)
}


