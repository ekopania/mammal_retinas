#Tutorial: http://www.phytools.org/Cordoba2017/ex/15/Plotting-methods.html

library(phytools)

#Read in data
my.tree0<-read.tree("mam241.tre")
mydata0<-read.csv("mam241.pheno.csv")
#elton0<-read.csv("EltonTraits_mammals.csv")
elton0<-read.csv("EltonTraits_mammals.subset.csv")

#Get species present in tree, eye data file, eco trait data file
my.species0<-mydata0$Hub_Species
my.species.data<-unlist(sapply(mydata0$Data_Species, function(x) gsub("_"," ",x)))
my.species.space<-unlist(sapply(my.species0, function(x) gsub("_"," ",x)))
head(my.species0)

just.retinal<-mydata0[,c("retinal_structure","certainty","max_rgc_density","acuity_cyclePerDegree")]
rownames(just.retinal)<-my.species0
nomissing<-just.retinal[rowSums(just.retinal=="") < 3,]
ret_certain<-rownames(just.retinal)[which(just.retinal$certainty=="A")]
pupil_noMissing<-mydata0$Hub_Species[which(mydata0$pupil_shape!="")]
inall<-Reduce(intersect, list(my.species0,my.tree0$tip.label,pupil_noMissing))
keep<-Reduce(intersect, list(inall, rownames(nomissing))) #ret_certain
rm_spec<-my.tree0$tip.label[my.tree0$tip.label %in% keep == FALSE]
my.tree<-drop.tip(my.tree0, rm_spec)
print(my.tree)

mydata<-mydata0[which(my.species0 %in% keep),]
dim(mydata)
head(mydata)

#Make tables and vectors for plotting
#phenos<-mydata[,c("retinal_structure","nocturnal", "horizonDominated", "complex", "predator", "prey")]
phenos<-as.data.frame(cbind(mydata$retinal_structure, mydata$pupil_shape))
dim(phenos)
my.species<-mydata$Hub_Species
rownames(phenos)<-my.species
colnames(phenos)<-c("retinal_structure", "pupil_shape")
head(phenos)

retinal.traits<-c("fovea", "area centralis", "horizontal streak", "horizontal streak;area centralis", "horizontal streak;area centralis;anakatabatic area", "area centralis;anakatabatic area", "none")
retinal.colors<-c("deeppink4", "seagreen", "mediumorchid1", "darkgoldenrod1", "cadetblue", "navyblue", "grey50")
pupil.traits<-c("circular", "subcircular", "horizontal", "vertical", "u-shape")
pupil.colors<-c("black", "gray20", "gray40", "gray60", "gray80")

all.traits<-c("missing data", retinal.traits, pupil.traits)
all.colors<-c("white", retinal.colors, pupil.colors)

#Plot
pdf("mammal_eyes_tree.withPupilShape.pdf", width=17, height=22, useDingbats=FALSE, onefile=TRUE)

dotTree(my.tree, phenos, colors=setNames(all.colors,all.traits), fsize=1, ftype="i", legend=FALSE, length=1, labels=TRUE)
add.simmap.legend(colors=setNames("white","missing data"), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.9*par()$usr[4]) #Missing data
add.simmap.legend(colors=setNames(retinal.colors,retinal.traits), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.85*par()$usr[4]) #Retinal structures
add.simmap.legend(colors=setNames(pupil.colors, pupil.traits), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.5*par()$usr[4])
title("Retinal Specialization vs Pupil Shape", line=-1)

dev.off()
