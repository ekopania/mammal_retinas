#Tutorial: http://www.phytools.org/Cordoba2017/ex/15/Plotting-methods.html

library(phytools)

#Read in data
my.tree0<-read.tree("mam241.tre")
mydata0<-read.csv("mam241.pheno.csv")
#elton0<-read.csv("EltonTraits_mammals.csv")
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
#If I measured orbit convergence, use this value; otherwise use orbit convergence value from literature
orbit.convergence<-c()
for(i in 1:nrow(mydata0)){
	if(is.na(mydata0$orbit_convergence_myMeasurement[i])){
		orbit.convergence<-c(orbit.convergence, mydata0$orbit_convergence[i])
	} else if(mydata0$orbit_convergence_myMeasurement[i]!=""){
		orbit.convergence<-c(orbit.convergence, mydata0$orbit_convergence_myMeasurement[i])
	} else{
		orbit.convergence<-c(orbit.convergence, mydata0$orbit_convergence[i])
	}
}
names(orbit.convergence)<-my.species0

#Plot whether species has orbit convergence data or not on  zoonomia tree
hasOC<-unlist(sapply(orbit.convergence, function(x) if(is.na(x)){"n"}else if(x==""){"n"}else{"y"}))
names(hasOC)<-mydata0$Hub_Species
print(paste("Orbit convergence data for", length(which(hasOC=="y"))))
q()
pdf("zoonomia_orbit_convergence_data.pdf", width=17, height=30, useDingbats=FALSE)
dotTree(my.tree0, hasOC, colors=setNames(c("white","black"), c("n","y")), ftype="i")
dev.off()

#Remove species with missing orbit convergence data
nomissing<-orbit.convergence[which(orbit.convergence!="")]
#ret_certain<-rownames(orbit.convergence)[which(orbit.convergence$certainty=="A")]
keep<-Reduce(intersect, list(inall, names(nomissing))) #ret_certain
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

#Combine predation categories for one predation score (% of diet)
predCols<-elton.sort[,c("Diet.Inv","Diet.Vend","Diet.Vect","Diet.Vfish","Diet.Vunk")]
dim(predCols)
head(predCols)
predScore<-rowSums(predCols)
predBin<-c()
for(i in 1:nrow(elton.sort)){
        if(grepl("A", elton.sort$Diet.Certainty[i])){
                if(predScore[i] >= 70){
                        predBin<-c(predBin, 1)
                } else{
                        predBin<-c(predBin, 0)
                }
        } else{
                predBin<-c(predBin, NA)
        }
}
elton.sort$predScore<-predScore
elton.sort$predBin<-predBin

#Make plant diet binary
herbCols<-elton.sort[,c("Diet.Fruit", "Diet.Nect", "Diet.Seed", "Diet.PlantO")]
herbScore<-rowSums(herbCols)
plantBin<-c()
for(i in 1:nrow(elton.sort)){
        if(grepl("A", elton.sort$Diet.Certainty[i])){
                if(herbScore[i] >= 70){
                        plantBin<-c(plantBin, 1)
                } else{
                        plantBin<-c(plantBin, 0)
                }
        } else{
                plantBin<-c(plantBin, NA)
        }
}
elton.sort$plantBin<-plantBin

#Make size binary - using 100kg (100000g) as the cutoff for unlikely to be prey for now
sizeBin<-c()
for(i in 1:nrow(elton.sort)){
        if(!(is.na(elton.sort$BodyMass.SpecLevel[i]))){
                if(elton.sort$BodyMass.SpecLevel[i]==1){
                        if(as.numeric(elton.sort$BodyMass.Value[i]) < 100000){
                                sizeBin<-c(sizeBin, 1)
                        } else{
                                sizeBin<-c(sizeBin, 0)
                        }
                } else{
                        sizeBin<-c(sizeBin, NA)
                }
        } else{
                sizeBin<-c(sizeBin, NA)
        }
}
elton.sort$sizeBin<-sizeBin

#Get small herbivores
small_herb<-c()
for(i in 1:nrow(elton.sort)){
	if( is.na(elton.sort$plantBin[i]) || is.na(elton.sort$sizeBin[i]) ){
		small_herb<-c(small_herb, NA)
	} else if( (elton.sort$plantBin[i]==1) && (elton.sort$sizeBin[i]==1) ){
		small_herb<-c(small_herb, 1)
	} else{
		small_herb<-c(small_herb, 0)
	}
}
elton.sort$small_herb<-small_herb
print(elton.sort)

#Make tables and vectors for plotting

#Continues values
oc<-orbit.convergence[which(names(orbit.convergence) %in% keep)]
stopifnot(all.equal(names(oc), mydata$Hub_Species))
obj<-contMap(my.tree, oc, plot=FALSE)
obj<-setMap(obj,invert=TRUE) #warmer colors for higher numbers

#Phylogenetic signal for continuous trait
psk<-phylosig(my.tree, oc, method="K", test=TRUE, nsim=1000)
print(psk)
psl<-phylosig(my.tree, oc, method="lambda", test=TRUE, nsim=1000)
print(psl)
q()
#Binary values
phenos<-as.data.frame(cbind(elton.sort$ForStrat.Value, elton.sort$Activity.Nocturnal, elton.sort$Activity.Crepuscular, elton.sort$Activity.Diurnal, elton.sort$predBin, elton.sort$small_herb))
dim(phenos)
my.species<-mydata$Hub_Species
rownames(phenos)<-my.species
colnames(phenos)<-c("ForStrat.Value", "Activity.Nocturnal", "Activity.Crepuscular", "Activity.Diurnal", "Predator", "Small_herbivore")
head(phenos)

foraging.traits<-c("G", "M", "Ar", "A", "S", "F")
foraging.traits.fullname<-c("ground","marine","arboreal","aerial","scansorial","fossorial")
foraging.colors<-c("brown", "blue", "green", "lightblue", "grey50","black")
nocturnal.traits<-c(0,1)
nocturnal.colors<-c("lightgrey","black")
crepuscular.traits<-c(0,1)
crepuscular.colors<-c("lightgrey","black")
diurnal.traits<-c(0,1)
diurnal.colors<-c("lightgrey","black")
pred.traits<-c(0,1)
pred.colors<-c("lightgrey","black")
smallHerb.traits<-c(0,1)
smallHerb.colors<-c("lightgrey","black")

all.traits<-list(foraging.traits, nocturnal.traits, crepuscular.traits, diurnal.traits, pred.traits, smallHerb.traits)
all.colors<-list(foraging.colors, nocturnal.colors, crepuscular.colors, diurnal.colors, pred.colors, smallHerb.colors)

#Plot
pdf("mammal_eyes_tree.orbitConvergence.withEltonPheno.pdf", width=17, height=22, useDingbats=FALSE, onefile=TRUE)
for(i in 1:ncol(phenos)){
	pheno<-as.factor(setNames(phenos[,i],rownames(phenos)))
	dotTree(my.tree, pheno, colors=setNames(all.colors[[i]],all.traits[[i]]), ftype="i")
	add.simmap.legend(colors=setNames("white","missing data"), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.9*par()$usr[4])
	#Overlay orbit convergence tree (colored by value)
	plot(obj$tree,colors=obj$cols, add=TRUE, ftype="off",lwd=5, xlim=get("last_plot.phylo", envir=.PlotPhyloEnv)$x.lim, ylim=get("last_plot.phylo",envir=.PlotPhyloEnv)$y.lim)
	add.color.bar(leg=0.2, cols=obj$cols, title="Orbit Convergence Angle", prompt=FALSE, lims=c(min(oc), max(oc)))
	title(paste("Orbit Convergence and",colnames(phenos)[i]), line=-1)
}
dev.off()
