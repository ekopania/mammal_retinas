#PURPOSE: Get Elton Traits eco data for species in dataset only

library(ape)

#Read in data
my.tree0<-read.tree("mam241.tre")
mydata0<-read.csv("mam241.pheno.csv")
elton0<-read.csv("EltonTraits_mammals.csv")

#Get species present in tree, eye data file, eco trait data file
my.species0<-mydata0$Hub_Species
my.species.data<-unlist(sapply(mydata0$Data_Species, function(x) gsub("_"," ",x)))
my.species.space<-unlist(sapply(my.species0, function(x) gsub("_"," ",x)))
head(my.species0)

#Get Elton eco traits for species we got retinal data from
elton<-elton0[which(elton0$Scientific %in% my.species.data),]
print(dim(elton))
gen_spec<-unlist(sapply(elton$Scientific, function(x) gsub(" ", "_", x)))
elton$gen_spec<-gen_spec
elton_forTree<-mydata0$Hub_Species[which(mydata0$Data_Species %in% gen_spec)]

inall<-Reduce(intersect, list(my.species0,my.tree0$tip.label,elton_forTree))
just.retinal<-mydata0[,c("retinal_structure","certainty","max_rgc_density","acuity_cyclePerDegree")]
rownames(just.retinal)<-my.species0
nomissing<-just.retinal[rowSums(just.retinal=="") < 3,]
#ret_certain<-rownames(just.retinal)[which(just.retinal$certainty=="A")]
keep<-Reduce(intersect, list(inall, rownames(nomissing))) #ret_certain
rm_spec<-my.tree0$tip.label[my.tree0$tip.label %in% keep == FALSE]
my.tree<-drop.tip(my.tree0, rm_spec)
print(my.tree)

mydata<-mydata0[which(my.species0 %in% keep),]
dim(mydata)
head(mydata)

keep_data<-mydata$Data_Species
elton.keep<-elton[which(elton$gen_spec %in% keep_data),]
print(dim(elton.keep))
elton.sort<-elton.keep[match(mydata$Data_Species, elton.keep$gen_spec),]
print(head(elton.sort))
write.csv(elton.sort, file="EltonTraits_mammals.subset.csv", row.names=FALSE, quote=FALSE)
