# Three things you almost always need in R to examine data
require(ggplot2)
require(data.table)
require(dplyr)
setwd("~/local/kaggle/DukeLiberty")

# Load the data
dataset = data.table(read.csv("data/train.csv"))
depVar = "Hazard"
indVars = setdiff(names(trainFile), c("Hazard", "Id"))

# Create a function to build formula from names
buildFormula <- function(depVar, indVars) {
  formula = paste(c(depVar, "~", paste(indVars, collapse = " + ")), collapse = " ")
  return(as.formula(formula, env = parent.frame()))
}

# Set up cross-validation and test a model
index = ceiling(runif(nrow(trainFile), 0, 5))
predicted = rep(NA, nrow(trainFile))
for(i in unique(index)) {
  train = dataset[index != i]
  test = dataset[index == i]
  model = glm(buildFormula(depVar, indVars), train, family = poisson(link = "log"))
  predicted[index == i] =  predict(model, test, type = "response")
}
cor(dataset[[depVar]], predicted, method = "spearman")

