#PURPOSE: Use phytools threshBayes to test for an association between a discrete and continuous trait with phylogenetic correction
#Tutorial: http://blog.phytools.org/search?q=binary+continuous

library(phytools)

#Read in data
myTree<-read.tree("mam241.tre")
#FOR JUST ONE TRAIT AT A TIME
#ret<-"fovea"
#FOR LOOPING THROUGH MULTIPLE TRAITS TO TEST SEVERAL HYPOTHESES
rets<-c(c("fovea","area centralis"), "horizontal streak")

#Get species w/ no missing data for retinal category and ecological category
all_retina<-read.csv("mam241.pheno.csv")

#Assign which variables we are looking at
disc<-"retinal_structure" #binary trait
#one<-"horizontal streak" #foreground trait (i.e., trait to be assigned "1"; other values will be assigned "0")
cont<-"orbit_convergence" #"predScore" #continuous trait

retina_noMissing<-all_retina$Hub_Species[which(all_retina$retinal_structure!="")]
eco_noMissing<-all_retina$Hub_Species[which(all_retina[,cont]!="")]
#print(head(retina_noMissing))
#print(head(eco_noMissing))
#print(head(eco_certain))
#keep<-Reduce(intersect, list(retina_noMissing, eco_noMissing, eco_certain, myTree$tip.label))
keep<-Reduce(intersect, list(retina_noMissing, eco_noMissing, myTree$tip.label))

retina_keep<-all_retina[which(all_retina$Hub_Species %in% keep),]
tree_keep<-keep.tip(myTree, keep)

print("TREE:")
print(tree_keep)

#Set up data and run ThreshBayes
pdf(paste("threshBayes_mcmc_output.retinal_structure", cont, "pdf", sep="."))

print(paste("Testing for association between horizontal streak (any) and", cont))
#Get variables into a format phytools likes
disc_binary<-unlist(sapply(retina_keep[,disc], function(x) if(grepl("horizontal streak",x)){1}else if(x==""){NA}else{0}))
names(disc_binary)<-retina_keep$Hub_Species
disc_binary_unique<-disc_binary[which(!(duplicated(names(disc_binary))))]
#print(dim(retina_keep))
#print(retina_keep[1:20,disc])
#print(length(disc_binary_unique))
#print(disc_binary_unique[1:20])

cont_dat<-retina_keep[,cont]
names(cont_dat)<-retina_keep$Hub_Species
cont_dat_unique<-cont_dat[which(!(duplicated(names(cont_dat))))]

datForPhytools<-data.frame(cont_dat_unique, disc_binary_unique)
rownames(datForPhytools)<-names(disc_binary_unique)
print("PHENOTYPE DATA:")
print(head(datForPhytools))
#datForPhytools_keep<-datForPhytools[which(rownames(datForPhytools) %in% keep),]
#print(datForPhytools_keep)
#print(dim(datForPhytools_keep))

print("Horizontal streak (any) median:")
print(median(datForPhytools$cont_dat[which(datForPhytools$disc_binary==1)]))
print("Other median:")
print(median(datForPhytools$cont_dat[which(datForPhytools$disc_binary==0)]))
#Run threshBayes; print and save results
mcmc<-threshBayes(tree_keep, datForPhytools, ngen=100000, plot=FALSE, control=list(print.interval=10000))
print(mcmc)
plot(mcmc)

#Calculate density distribution
d<-density(mcmc,bw=0.1)
print(d)
plot(d)
title(main=paste("posterior density of correlation coefficient, r,\nfrom threshold model horizontal streak (any) vs", cont), font.main=3)



print(paste("Testing for association between horizontal streak (only) and", cont))
#Get variables into a format phytools likes
disc_binary<-unlist(sapply(retina_keep[,disc], function(x) if(x=="horizontal streak"){1}else if(x==""){NA}else{0}))
names(disc_binary)<-retina_keep$Hub_Species
disc_binary_unique<-disc_binary[which(!(duplicated(names(disc_binary))))]

cont_dat<-retina_keep[,cont]
names(cont_dat)<-retina_keep$Hub_Species
cont_dat_unique<-cont_dat[which(!(duplicated(names(cont_dat))))]

datForPhytools<-data.frame(cont_dat_unique, disc_binary_unique)
rownames(datForPhytools)<-names(disc_binary_unique)
print("PHENOTYPE DATA:")
print(head(datForPhytools))

print("Horizontal streak (only) median:")
print(median(datForPhytools$cont_dat[which(datForPhytools$disc_binary==1)]))
print("Other median:")
print(median(datForPhytools$cont_dat[which(datForPhytools$disc_binary==0)]))
#Run threshBayes; print and save results
mcmc<-threshBayes(tree_keep, datForPhytools, ngen=100000, plot=FALSE, control=list(print.interval=10000))
print(mcmc)
plot(mcmc)

#Calculate density distribution
d<-density(mcmc,bw=0.1)
print(d)
plot(d)
title(main=paste("posterior density of correlation coefficient, r,\nfrom threshold model horizontal streak (only) vs", cont), font.main=3)


print(paste("Testing for association between area centralis or fovea (any) and", cont))
#Get variables into a format phytools likes
disc_binary<-unlist(sapply(retina_keep[,disc], function(x) if(grepl("area centralis",x)){1}else if(grepl("fovea",x)){1}else if(x==""){NA}else{0}))
names(disc_binary)<-retina_keep$Hub_Species
disc_binary_unique<-disc_binary[which(!(duplicated(names(disc_binary))))]

cont_dat<-retina_keep[,cont]
names(cont_dat)<-retina_keep$Hub_Species
cont_dat_unique<-cont_dat[which(!(duplicated(names(cont_dat))))]

datForPhytools<-data.frame(cont_dat_unique, disc_binary_unique)
rownames(datForPhytools)<-names(disc_binary_unique)
print("PHENOTYPE DATA:")
print(head(datForPhytools))

print("Area centralis or fovea (any) median:")
print(median(datForPhytools$cont_dat[which(datForPhytools$disc_binary==1)]))
print("Other median:")
print(median(datForPhytools$cont_dat[which(datForPhytools$disc_binary==0)]))
#Run threshBayes; print and save results
mcmc<-threshBayes(tree_keep, datForPhytools, ngen=100000, plot=FALSE, control=list(print.interval=10000))
print(mcmc)
plot(mcmc)

#Calculate density distribution
d<-density(mcmc,bw=0.1)
print(d)
plot(d)
title(main=paste("posterior density of correlation coefficient, r,\nfrom threshold model area centralis or fovea (any) vs", cont), font.main=3)


print(paste("Testing for association between area centralis or fovea (only) and", cont))
#Get variables into a format phytools likes
disc_binary<-unlist(sapply(retina_keep[,disc], function(x) if(x=="area centralis"){1}else if(x=="fovea"){1}else if(x==""){NA}else{0}))
names(disc_binary)<-retina_keep$Hub_Species
disc_binary_unique<-disc_binary[which(!(duplicated(names(disc_binary))))]

cont_dat<-retina_keep[,cont]
names(cont_dat)<-retina_keep$Hub_Species
cont_dat_unique<-cont_dat[which(!(duplicated(names(cont_dat))))]

datForPhytools<-data.frame(cont_dat_unique, disc_binary_unique)
rownames(datForPhytools)<-names(disc_binary_unique)
print("PHENOTYPE DATA:")
print(head(datForPhytools))

print("Area centralis or fovea (only) median:")
print(median(datForPhytools$cont_dat[which(datForPhytools$disc_binary==1)]))
print("Other median:")
print(median(datForPhytools$cont_dat[which(datForPhytools$disc_binary==0)]))
#Run threshBayes; print and save results
mcmc<-threshBayes(tree_keep, datForPhytools, ngen=100000, plot=FALSE, control=list(print.interval=10000))
print(mcmc)
plot(mcmc)

#Calculate density distribution
d<-density(mcmc,bw=0.1)
print(d)
plot(d)
title(main=paste("posterior density of correlation coefficient, r,\nfrom threshold model area centralis or fovea (only) vs", cont), font.main=3)


dev.off()
