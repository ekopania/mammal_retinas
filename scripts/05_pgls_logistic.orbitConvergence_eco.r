#PURPOSE: Run PGLS logistic regression to test for correlations between binary and continuous traits (Garland and Ives 2010)
#https://rdrr.io/cran/phylolm/man/phyloglm.html

library(ape)
library(nlme)
library(phytools)
library(phylolm)
library(ggplot2)

#Read in data
my.tree0<-read.tree("mam241.tre")
mydata0<-read.csv("mam241.pheno.csv")
elton0<-read.csv("EltonTraits_mammals.csv")
#FOR LOOPING THROUGH MULTIPLE TRAITS TO TEST SEVERAL HYPOTHESES
#Need to figure out how to make foraging strategy binary
#eco<-c("arborealBin", "Activity.Nocturnal", "Activity.Crepuscular", "Activity.Diurnal", "predBin", "small_herb")
eco<-c("arborealBin", "Activity.Dark", "Activity.Light", "predBin", "small_herb")

#Establish which traits we are analyzing
#trait_bin<-"retinal_structure"
trait_cont<-"orbit_convergence"

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
#activity_certain<-elton$gen_spec[which(elton$Activity.Certainty=="ABC")]
#elton_forTree<-mydata0$Hub_Species[which(mydata0$Data_Species %in% activity_certain)]
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
nomissing<-orbit.convergence[which(orbit.convergence!="")]
keep<-Reduce(intersect, list(inall, names(nomissing)))
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

#Get arboreal as a binary trait
arborealBin<-c()
for(i in 1:nrow(elton.sort)){
	if(grepl("A", elton.sort$ForStrat.Certainty[i])){
		if(elton.sort$ForStrat.Value[i] == "Ar"){
			arborealBin<-c(arborealBin, 1)
		} else{
			arborealBin<-c(arborealBin, 0)
		}
	} else{
		arborealBin<-c(arborealBin, NA)
	}
}
elton.sort$arborealBin<-arborealBin

#Get activity as a binary trait (nocturnal or crepuscular or both is one category, diurnal is another; "0" if species is both nocturnal/crepuscular and diurnal)
Activity.Dark<-c()
Activity.Light<-c()
for(i in 1:nrow(elton.sort)){
	if(grepl("A", elton.sort$Activity.Certainty[i])){
		if( ((elton.sort$Activity.Nocturnal[i]==1) || (elton.sort$Activity.Crepuscular[i]==1)) && (elton.sort$Activity.Diurnal[i]==0)){
			Activity.Dark<-c(Activity.Dark, 1)
		} else{
			Activity.Dark<-c(Activity.Dark, 0)
		}
		if( (elton.sort$Activity.Nocturnal[i]==0) && (elton.sort$Activity.Crepuscular[i]==0) && (elton.sort$Activity.Diurnal[i]==1)){
			Activity.Light<-c(Activity.Light, 1)
		} else{
			Activity.Light<-c(Activity.Light, 0)
		}
	} else{
		Activity.Dark<-c(Activity.Dark, NA)
		Activity.Light<-c(Activity.Light, NA)
	}
}
elton.sort$Activity.Dark<-Activity.Dark
elton.sort$Activity.Light<-Activity.Light

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

pdf("ecological.vs.orbitConvergence.phylo_logistic_regression.pdf", onefile=TRUE)
#Loop through all retinal structures
for(e in eco){
	#Has retinal structure at all
        print(paste("Testing for association between", e, "and orbital convergence angle"))
	disc_binary<-elton.sort[,e]
	names(disc_binary)<-elton.sort$gen_spec
        names(disc_binary)<-sapply(names(disc_binary), function(x) mydata$Hub_Species[which(mydata$Data_Species==x)])
        disc_binary_unique<-disc_binary[which(!(duplicated(names(disc_binary))))]
        cont_dat<-orbit.convergence[which(names(orbit.convergence) %in% keep)]
        #names(cont_dat)<-mydata$Hub_Species
        cont_dat_unique<-cont_dat[which(!(duplicated(names(cont_dat))))]
	stopifnot(all.equal(names(disc_binary_unique), names(cont_dat_unique)))
	#Setup for phyloglm and run
	phyloglm_df<-as.data.frame(cbind(disc_binary_unique, cont_dat_unique))
	rownames(phyloglm_df)<-names(disc_binary_unique)
	colnames(phyloglm_df)<-c(e, trait_cont)
	print(head(phyloglm_df))
	fm<-as.formula(paste0(e,"~",trait_cont))
	gi_model<-phyloglm(fm, data=phyloglm_df, phy=my.tree, method="logistic_IG10", btol=30)
	print(summary(gi_model))
	pval<-summary(gi_model)$coefficients[trait_cont,4]

	#Plot
	p<-ggplot(phyloglm_df, aes(x=get(trait_cont), y=get(e))) + geom_point() + theme_minimal()
	#Logistic regression
        p<-p + stat_smooth(method = "glm", col = "red", method.args=list(family=binomial), fullrange=TRUE)
	p<-p + labs(title=paste(e, "vs", trait_cont), x=trait_cont, y=e)
	p<-p + geom_text(x=100, y=0.9, label=paste("P-value:", round(pval, 3)))
	print(p)

}

dev.off()
