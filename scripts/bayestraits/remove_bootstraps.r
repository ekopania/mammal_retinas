#PURPOSE: Use APE to remove bootstrap values from nexus formatted tree

library(ape)
mytree<-read.nexus("mam241.nexus")
print(mytree)
mytree$node.label<-NULL
print(mytree)
write.nexus(mytree, file="mam241.no_label.nexus")
