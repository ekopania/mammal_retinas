#Tutorial: http://www.phytools.org/Cordoba2017/ex/15/Plotting-methods.html

library(phytools)

#Read in data
my.tree0<-read.tree("mam241.tre")
mydata0<-read.csv("mam241.pheno.csv")

#Get species present in tree, eye data file, eco trait data file
my.species0<-mydata0$Hub_Species
my.species.data<-unlist(sapply(mydata0$Data_Species, function(x) gsub("_"," ",x)))
my.species.space<-unlist(sapply(my.species0, function(x) gsub("_"," ",x)))
head(my.species0)

inall<-intersect(my.species0,my.tree0$tip.label)
just.retinal<-mydata0[,c("retinal_structure","certainty")]
rownames(just.retinal)<-my.species0
nomissing<-just.retinal[which(just.retinal$retinal_structure!=""),]
ret_certain<-rownames(just.retinal)[which(just.retinal$certainty=="A")]
keep<-Reduce(intersect, list(inall, rownames(nomissing))) #ret_certain
rm_spec<-my.tree0$tip.label[my.tree0$tip.label %in% keep == FALSE]
my.tree<-drop.tip(my.tree0, rm_spec)
print(my.tree)

mydata<-mydata0[which(my.species0 %in% keep),]
dim(mydata)
head(mydata)

#Separate each retinal specialization
fovea<-unlist(sapply(mydata$retinal_structure, function(x) if(grepl("fovea",x)){"f"}else{"nf"}))
ac<-unlist(sapply(mydata$retinal_structure, function(x) if(grepl("area centralis",x)){"ac"}else{"nac"}))
hs<-unlist(sapply(mydata$retinal_structure, function(x) if(grepl("horizontal streak",x)){"hs"}else{"nhs"}))
aa<-unlist(sapply(mydata$retinal_structure, function(x) if(grepl("anakatabatic area",x)){"aa"}else{"naa"}))

#Make tables and vectors for plotting
phenos<-as.data.frame(cbind(fovea, ac, hs, aa))
dim(phenos)
my.species<-mydata$Hub_Species
rownames(phenos)<-my.species
colnames(phenos)<-c("fovea", "area centralis", "horizontal streak", "anakatabatic area")
head(phenos)

fovea.traits<-c("f","nf")
fovea.colors<-c("deeppink4", "gray50")
ac.traits<-c("ac","nac")
ac.colors<-c("seagreen", "gray50")
hs.traits<-c("hs","nhs")
hs.colors<-c("darkgoldenrod1", "gray50")
aa.traits<-c("aa","naa")
aa.colors<-c("cadetblue", "gray50")

all.traits<-c("missing data", fovea.traits, ac.traits, hs.traits, aa.traits)
all.colors<-c("white", fovea.colors, ac.colors, hs.colors, aa.colors)

#Plot
pdf("mammal_eyes_tree.specializationsSeparate.pdf", width=17, height=22, useDingbats=FALSE, onefile=TRUE)

dotTree(my.tree, phenos, colors=setNames(all.colors,all.traits), fsize=1, ftype="i", legend=FALSE, length=1, labels=TRUE)
add.simmap.legend(colors=setNames("white","missing data"), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.9*par()$usr[4]) #Missing data
add.simmap.legend(colors=setNames(fovea.colors,fovea.traits), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.85*par()$usr[4])
add.simmap.legend(colors=setNames(ac.colors, ac.traits), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.5*par()$usr[4])
add.simmap.legend(colors=setNames(hs.colors,hs.traits), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.3*par()$usr[4])
add.simmap.legend(colors=setNames(aa.colors,aa.traits), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.2*par()$usr[4])
title("All traits", line=-1)

dev.off()


#Add eco data
elton0<-read.csv("EltonTraits_mammals.subset.csv")
#Get Elton eco traits for species we got retinal data from
elton<-elton0[which(elton0$Scientific %in% my.species.data),]
print(dim(elton))
gen_spec<-unlist(sapply(elton$Scientific, function(x) gsub(" ", "_", x)))
elton$gen_spec<-gen_spec
elton.keep<-elton[which(elton$gen_spec %in% mydata$Data_Species),]
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
print(elton.sort)

#Set up eco traits for phytools
foraging.traits<-c("G", "M", "Ar", "A", "S", "F")
foraging.traits.fullname<-c("ground","marine","arboreal","aerial","scansorial","fossorial")
foraging.colors<-c("brown", "blue", "green", "lightblue", "grey50","black")
plant.traits<-c(0,1)
plant.colors<-c("lightgrey","black")
pred.traits<-c(0,1)
pred.colors<-c("lightgrey","black")
size.traits<-c(0,1)
size.colors<-c("lightgrey","black")
unobstructed.traits<-c(FALSE, TRUE)
unobstructed.colors<-c("lightgrey", "black")

#Make separate plots/trees focusing on horizontal streak and grazer hypothesis
phenos.hz_grazer<-cbind(hs, elton.sort$ForStrat.Value, elton.sort$plantBin, elton.sort$sizeBin, mydata$unobstructed)
rownames(phenos.hz_grazer)<-my.species
colnames(phenos.hz_grazer)<-c("horizontal_streak", "ForStrat.Value", "herbivore", "size", "unobstructed")
hz_grazer_traits<-c("missing data", hs.traits, foraging.traits, plant.traits, size.traits, unobstructed.traits)
hz_grazer_colors<-c("white", hs.colors, foraging.colors, plant.colors, size.colors, unobstructed.colors)

pdf("mammal_eyes_tree.specializationsSeparate.hz_grazer.pdf", width=17, height=22, useDingbats=FALSE, onefile=TRUE)
dotTree(my.tree, phenos.hz_grazer, colors=setNames(hz_grazer_colors,hz_grazer_traits), fsize=1, ftype="i", legend=FALSE, length=1, labels=TRUE)
add.simmap.legend(colors=setNames("white","missing data"), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.9*par()$usr[4]) #Missing data
add.simmap.legend(colors=setNames(hs.colors,hs.traits), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.85*par()$usr[4]) #Retinal structures
add.simmap.legend(colors=setNames(foraging.colors, foraging.traits.fullname), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.5*par()$usr[4])
add.simmap.legend(colors=setNames(plant.colors,plant.traits), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.3*par()$usr[4])
add.simmap.legend(colors=setNames(size.colors,size.traits), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.2*par()$usr[4])
add.simmap.legend(colors=setNames(unobstructed.colors,unobstructed.traits), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.1*par()$usr[4])
title("Horizontal streak and grazer", line=-1)
dev.off()

#Make separate plots/trees focusing on area centralis and predator hypotheses
phenos.ac_predator<-cbind(ac, elton.sort$predBin)
rownames(phenos.ac_predator)<-my.species
colnames(phenos.ac_predator)<-c("area_centralis", "predator")
ac_predator_traits<-c("missing data", ac.traits, pred.traits)
ac_predator_colors<-c("white", ac.colors, pred.colors)

pdf("mammal_eyes_tree.specializationsSeparate.ac_predator.pdf", width=17, height=22, useDingbats=FALSE, onefile=TRUE)
dotTree(my.tree, phenos.ac_predator, colors=setNames(ac_predator_colors,ac_predator_traits), fsize=1, ftype="i", legend=FALSE, length=1, labels=TRUE)
add.simmap.legend(colors=setNames("white","missing data"), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.9*par()$usr[4]) #Missing data
add.simmap.legend(colors=setNames(ac.colors,ac.traits), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.85*par()$usr[4]) #Retinal structures
add.simmap.legend(colors=setNames(pred.colors,pred.traits), prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.3*par()$usr[4])
title("Area centralis and predator", line=-1)
dev.off()
