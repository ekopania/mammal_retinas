#PURPOSE: Remove duplicate tips and get tree in nexus format for bayestraits

library(ape)
mytree<-read.tree("../mam241.tre")
print(mytree)
newtree<-drop.tip(mytree, which(duplicated(mytree$tip.label)))
write.nexus(newtree, file="mam241.nexus")
