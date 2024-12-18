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
ret_certain<-rownames(just.retinal)[which(just.retinal$certainty=="A")]
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

#DO SOMETHING W/ CERTAINTY IN ELTON TRAITS?!

#Combine predation categories for one predation score (% of diet)
predCols<-elton.sort[,c("Diet.Inv","Diet.Vend","Diet.Vect","Diet.Vfish","Diet.Vunk")]
dim(predCols)
head(predCols)
predScore<-rowSums(predCols)
predBin<-unlist(sapply(predScore, function(x) if (x >= 70){1} else {0}))
elton.sort$predScore<-predScore
elton.sort$predBin<-predBin

#Make plant diet binary
herbCols<-elton.sort[,c("Diet.Fruit", "Diet.Nect", "Diet.Seed", "Diet.PlantO")]
herbScore<-rowSums(herbCols)
#plantBin<-unlist(sapply(elton.sort$Diet.PlantO, function(x) if(x==100){1} else{0}))
plantBin<-unlist(sapply(herbScore, function(x) if(x >= 70){1} else{0}))
elton.sort$plantBin<-plantBin

#Make size binary - using 100kg (100000g) as the cutoff for unlikely to be prey for now
sizeBin<-unlist(sapply(elton.sort$BodyMass.Value, function(x) if(as.numeric(x) < 100000){1} else{0}))
elton.sort$sizeBin<-sizeBin
print(elton.sort)

#Make tables and vectors for plotting
#phenos<-mydata[,c("retinal_structure","nocturnal", "horizonDominated", "complex", "predator", "prey")]
phenos<-as.data.frame(cbind(mydata$retinal_structure, elton.sort$ForStrat.Value, elton.sort$Activity.Nocturnal, elton.sort$Activity.Crepuscular, elton.sort$Activity.Diurnal))
dim(phenos)
my.species<-mydata$Hub_Species
rownames(phenos)<-my.species
colnames(phenos)<-c("retinal_structure", "ForStrat.Value", "Activity.Nocturnal", "Activity.Crepuscular", "Activity.Diurnal")
head(phenos)

retinal.traits<-c("fovea", "area centralis", "horizontal streak", "horizontal streak;area centralis", "horizontal streak;area centralis;anakatabatic area", "area centralis;anakatabatic area", "none")
retinal.colors<-c("deeppink4", "seagreen", "mediumorchid1", "darkgoldenrod1", "cadetblue", "navyblue", "grey50")
foraging.traits<-c("G", "M", "Ar", "A", "S", "F")
foraging.traits.fullname<-c("ground","marine","arboreal","aerial","scansorial","fossorial")
foraging.colors<-c("brown", "blue", "green", "lightblue", "grey50","black")
nocturnal.traits<-c(0,1)
nocturnal.colors<-c("lightgrey","black")
crepuscular.traits<-c(0,1)
crepuscular.colors<-c("lightgrey","black")
diurnal.traits<-c(0,1)
diurnal.colors<-c("lightgrey","black")
plant.traits<-c(0,1)
plant.colors<-c("lightgrey","black")
pred.traits<-c(0,1)
pred.colors<-c("lightgrey","black")
size.traits<-c(0,1)
size.colors<-c("lightgrey","black")
#horizon.dominated.traits<-c("0","1")
#horizon.dominated.colors<-c("darkslategrey","dodgerblue")
#complexity.traits<-c("0","1")
#complexity.colors<-c("lightblue","green")
#predator.traits<-c("0","1")
#predator.colors<-c("grey50","red")
#prey.traits<-c("0","1")
#prey.colors<-c("grey50","yellow")

#all.traits<-c("missing data", retinal.traits, nocturnal.traits, horizon.dominated.traits, complexity.traits, predator.traits, prey.traits)
#all.colors<-c("white", retinal.colors, nocturnal.colors, horizon.dominated.colors, complexity.colors, predator.colors, prey.colors)

all.traits<-c("missing data", retinal.traits, foraging.traits, nocturnal.traits, crepuscular.traits, diurnal.traits)
all.colors<-c("white", retinal.colors, foraging.colors, nocturnal.colors, crepuscular.colors, diurnal.colors)

#Plot
pdf("mammal_eyes_tree.withEltonPheno.pdf", width=17, height=22, useDingbats=FALSE, onefile=TRUE)

dotTree(my.tree, phenos, colors=setNames(all.colors,all.traits), fsize=1, ftype="i", legend=FALSE, length=1, labels=TRUE)
add.simmap.legend(colors=setNames("white","missing data"), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.9*par()$usr[4]) #Missing data
add.simmap.legend(colors=setNames(retinal.colors,retinal.traits), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.85*par()$usr[4]) #Retinal structures
add.simmap.legend(colors=setNames(foraging.colors, foraging.traits.fullname), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.5*par()$usr[4])
add.simmap.legend(colors=setNames(nocturnal.colors,nocturnal.traits), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.3*par()$usr[4])
add.simmap.legend(colors=setNames(crepuscular.colors,crepuscular.traits), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.2*par()$usr[4])
add.simmap.legend(colors=setNames(diurnal.colors,diurnal.traits), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.1*par()$usr[4])
#add.simmap.legend(colors=setNames(horizon.dominated.colors, horizon.dominated.traits), prompt=FALSE, shape="circle", x=0.9*par()$usr[1],y=0.3*par()$usr[4])
#add.simmap.legend(colors=setNames(complexity.colors,complexity.traits), prompt=FALSE, shape="circle", x=0.9*par()$usr[1],y=0.2*par()$usr[4])
#add.simmap.legend(colors=setNames(predator.colors,predator.traits), prompt=FALSE, shape="circle", x=0.9*par()$usr[1],y=0.1*par()$usr[4])
#add.simmap.legend(colors=setNames(prey.colors,prey.traits), prompt=FALSE, shape="circle", x=0.9*par()$usr[1],y=0.01*par()$usr[4])
title("All traits", line=-1)

phenos.max_rgc_density<-cbind(as.numeric(mydata$max_rgc_density)/1000, as.numeric(elton.sort$predScore))
rownames(phenos.max_rgc_density)<-my.species
colnames(phenos.max_rgc_density)<-c("max_rgc_density_e3","predation_percent")
head(phenos.max_rgc_density)
max_rgc_density.tree<-keep.tip(my.tree, rownames(phenos.max_rgc_density))
plotTree.barplot(max_rgc_density.tree, phenos.max_rgc_density, args.barplot=list(beside=TRUE, xlim=c(0,100), legend.text=TRUE), args.legend=list(x=100,y=1))

phenos.acuity_cyclePerDegree<-cbind(as.numeric(mydata$acuity_cyclePerDegree), as.numeric(elton.sort$predScore))
rownames(phenos.acuity_cyclePerDegree)<-my.species
colnames(phenos.acuity_cyclePerDegree)<-c("acuity_cyclePerDegree","predation_percent")
acuity_cyclePerDegree.tree<-keep.tip(my.tree, rownames(phenos.acuity_cyclePerDegree))
plotTree.barplot(acuity_cyclePerDegree.tree, phenos.acuity_cyclePerDegree, args.barplot=list(beside=TRUE, legend.text=TRUE), args.legend=list(x=100,y=1))

dev.off()

#Make separate plots/trees focusing on horizontal streak and grazer hypothesis
phenos.hz_grazer<-cbind(mydata$retinal_structure, elton.sort$ForStrat.Value, elton.sort$plantBin, elton.sort$sizeBin)
rownames(phenos.hz_grazer)<-my.species
colnames(phenos.hz_grazer)<-c("retinal_structure", "ForStrat.Value", "herbivore", "size")
hz_grazer_traits<-c("missing data", retinal.traits, foraging.traits, plant.traits, size.traits)
hz_grazer_colors<-c("white", retinal.colors, foraging.colors, plant.colors, size.colors)


pdf("mammal_eyes_tree.hz_grazer.pdf", width=17, height=22, useDingbats=FALSE, onefile=TRUE)

dotTree(my.tree, phenos.hz_grazer, colors=setNames(hz_grazer_colors,hz_grazer_traits), fsize=1, ftype="i", legend=FALSE, length=1, labels=TRUE)
add.simmap.legend(colors=setNames("white","missing data"), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.9*par()$usr[4]) #Missing data
add.simmap.legend(colors=setNames(retinal.colors,retinal.traits), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.85*par()$usr[4]) #Retinal structures
add.simmap.legend(colors=setNames(foraging.colors, foraging.traits.fullname), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.5*par()$usr[4])
add.simmap.legend(colors=setNames(plant.colors,plant.traits), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.3*par()$usr[4])
add.simmap.legend(colors=setNames(size.colors,size.traits), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.2*par()$usr[4])
title("Horizontal streak and grazer", line=-1)

#Redo for any horizontal streak and horizontal streak only as binary traits
hz_any<-unlist(sapply(mydata$retinal_structure, function(x) if(grepl("horizontal streak", x)==1){1} else{0}))
mydata$hz_any<-hz_any
hz_any_traits<-c("0","1")
hz_any_colors<-c("lightgrey", "black")
phenos.hz_any_grazer<-cbind(mydata$hz_any, elton.sort$ForStrat.Value, elton.sort$plantBin, elton.sort$sizeBin)
rownames(phenos.hz_any_grazer)<-my.species
colnames(phenos.hz_any_grazer)<-c("hz_any", "ForStrat.Value", "herbivore", "size")
hzAny_grazer_traits<-c("missing data", hz_any_traits, foraging.traits, plant.traits, size.traits)
hzAny_grazer_colors<-c("white", hz_any_colors, foraging.colors, plant.colors, size.colors)
dotTree(my.tree, phenos.hz_any_grazer, colors=setNames(hzAny_grazer_colors,hzAny_grazer_traits), fsize=1, ftype="i", legend=FALSE, length=1, labels=TRUE)
add.simmap.legend(colors=setNames("white","missing data"), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.9*par()$usr[4]) #Missing data
add.simmap.legend(colors=setNames(hz_any_colors,hz_any_traits), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.85*par()$usr[4]) #Retinal structures
add.simmap.legend(colors=setNames(foraging.colors, foraging.traits.fullname), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.5*par()$usr[4])
add.simmap.legend(colors=setNames(plant.colors,plant.traits), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.3*par()$usr[4])
add.simmap.legend(colors=setNames(size.colors,size.traits), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.2*par()$usr[4])
title("Horizontal streak - any", line=-1)


hz_only<-unlist(sapply(mydata$retinal_structure, function(x) if(x=="horizontal streak"){1} else{0}))
mydata$hz_only<-hz_only
hz_only_traits<-c("0","1")
hz_only_colors<-c("lightgrey","black")
phenos.hz_only_grazer<-cbind(mydata$hz_only, elton.sort$ForStrat.Value, elton.sort$plantBin, elton.sort$sizeBin)
rownames(phenos.hz_only_grazer)<-my.species
colnames(phenos.hz_only_grazer)<-c("hz_only", "ForStrat.Value", "herbivore", "size")
hzOnly_grazer_traits<-c("missing data", hz_only_traits, foraging.traits, plant.traits, size.traits)
hzOnly_grazer_colors<-c("white", hz_only_colors, foraging.colors, plant.colors, size.colors)
dotTree(my.tree, phenos.hz_only_grazer, colors=setNames(hzOnly_grazer_colors,hzOnly_grazer_traits), fsize=1, ftype="i", legend=FALSE, length=1, labels=TRUE)
add.simmap.legend(colors=setNames("white","missing data"), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.9*par()$usr[4]) #Missing data
add.simmap.legend(colors=setNames(hz_only_colors,hz_only_traits), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.85*par()$usr[4]) #Retinal structures
add.simmap.legend(colors=setNames(foraging.colors, foraging.traits.fullname), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.5*par()$usr[4])
add.simmap.legend(colors=setNames(plant.colors,plant.traits), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.3*par()$usr[4])
add.simmap.legend(colors=setNames(size.colors,size.traits), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.2*par()$usr[4])
title("Horizontal streak - only", line=-1)

dev.off()


#Make separate plots/trees focusing on area centralis and predator hypotheses
phenos.ac_predator<-cbind(mydata$retinal_structure, elton.sort$ForStrat.Value, elton.sort$predBin)
rownames(phenos.ac_predator)<-my.species
colnames(phenos.ac_predator)<-c("retinal_structure", "ForStrat.Value", "predator")
ac_predator_traits<-c("missing data", retinal.traits, foraging.traits, pred.traits)
ac_predator_colors<-c("white", retinal.colors, foraging.colors, pred.colors)


pdf("mammal_eyes_tree.ac_predator.pdf", width=17, height=22, useDingbats=FALSE, onefile=TRUE)

dotTree(my.tree, phenos.ac_predator, colors=setNames(ac_predator_colors,ac_predator_traits), fsize=1, ftype="i", legend=FALSE, length=1, labels=TRUE)
add.simmap.legend(colors=setNames("white","missing data"), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.9*par()$usr[4]) #Missing data
add.simmap.legend(colors=setNames(retinal.colors,retinal.traits), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.85*par()$usr[4]) #Retinal structures
add.simmap.legend(colors=setNames(foraging.colors, foraging.traits.fullname), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.5*par()$usr[4])
add.simmap.legend(colors=setNames(pred.colors,pred.traits), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.3*par()$usr[4])
title("Area centralis and predator", line=-1)

#Redo for any area centralis and area centralis only as binary traits
ac_any<-unlist(sapply(mydata$retinal_structure, function(x) if(grepl("area centralis", x)==1){1} else{0}))
mydata$ac_any<-ac_any
ac_any_traits<-c("0","1")
ac_any_colors<-c("lightgrey", "black")
phenos.ac_any_predator<-cbind(mydata$ac_any, elton.sort$ForStrat.Value, elton.sort$predBin)
rownames(phenos.ac_any_predator)<-my.species
colnames(phenos.ac_any_predator)<-c("ac_any", "ForStrat.Value", "predator")
acAny_predator_traits<-c("missing data", ac_any_traits, foraging.traits, pred.traits, size.traits)
acAny_predator_colors<-c("white", ac_any_colors, foraging.colors, pred.colors, size.colors)
dotTree(my.tree, phenos.ac_any_predator, colors=setNames(acAny_predator_colors,acAny_predator_traits), fsize=1, ftype="i", legend=FALSE, length=1, labels=TRUE)
add.simmap.legend(colors=setNames("white","missing data"), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.9*par()$usr[4]) #Missing data
add.simmap.legend(colors=setNames(ac_any_colors,ac_any_traits), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.85*par()$usr[4]) #Retinal structures
add.simmap.legend(colors=setNames(foraging.colors, foraging.traits.fullname), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.5*par()$usr[4])
add.simmap.legend(colors=setNames(pred.colors,pred.traits), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.3*par()$usr[4])
title("Area centralis - any", line=-1)

#Redo for only area centralis and area centralis only as binary traits
ac_only<-unlist(sapply(mydata$retinal_structure, function(x) if(x=="area centralis"){1} else{0}))
mydata$ac_only<-ac_only
ac_only_traits<-c("0","1")
ac_only_colors<-c("lightgrey", "black")
phenos.ac_only_predator<-cbind(mydata$ac_only, elton.sort$ForStrat.Value, elton.sort$predBin)
rownames(phenos.ac_only_predator)<-my.species
colnames(phenos.ac_only_predator)<-c("ac_only", "ForStrat.Value", "predator")
acOnly_predator_traits<-c("missing data", ac_only_traits, foraging.traits, pred.traits, size.traits)
acOnly_predator_colors<-c("white", ac_only_colors, foraging.colors, pred.colors, size.colors)
dotTree(my.tree, phenos.ac_only_predator, colors=setNames(acOnly_predator_colors,acOnly_predator_traits), fsize=1, ftype="i", legend=FALSE, length=1, labels=TRUE)
add.simmap.legend(colors=setNames("white","missing data"), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.9*par()$usr[4]) #Missing data
add.simmap.legend(colors=setNames(ac_only_colors,ac_only_traits), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.85*par()$usr[4]) #Retinal structures
add.simmap.legend(colors=setNames(foraging.colors, foraging.traits.fullname), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.5*par()$usr[4])
add.simmap.legend(colors=setNames(pred.colors,pred.traits), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.3*par()$usr[4])
title("Area centralis - only", line=-1)

dev.off()
