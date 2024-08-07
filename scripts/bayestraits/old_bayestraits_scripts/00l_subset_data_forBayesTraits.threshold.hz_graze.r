#PURPOSE: Read in phylo and phenotype data; generate subsets that only include species in both

library(ape)

#CHANGE THESE based on dataset and tree
tree<-"mam241" #mam241 (zoonomia)
eco_cat<-"ForStrat.Value" #Options: ForStrat.Value
cert<-"ForStrat.Certainty" #Options: ForStrat.Certainty
eco_cat2<-"herbScore"
cert2<-"Diet.Certainty"
eco_cat3<-"BodyMass.Value"
cert3<-"BodyMass.SpecLevel"
#FOR JUST ONE TRAIT AT A TIME
#ret<-"fovea"
#eco_trait<-"G" #G=ground
#FOR LOOPING THROUGH MULTIPLE TRAITS TO TEST SEVERAL HYPOTHESES
#rets<-c("fovea","area centralis","horizontal streak","none","vertical streak")
#Options for ForStrat.Value
eco_trait<-"G"
eco_trait2<-70
eco_trait3<-100000

#Read in tree
mytree<-read.nexus(paste(tree, "no_label.nexus", sep="."))

#Get species w/ no missing data for retinal category and ecological category
all_retina<-read.csv("../mam241.pheno.thresholds.csv")
#all_eco<-read.csv("../EltonTraits_mammals.csv")
all_eco<-read.csv("../EltonTraits_mammals.subset.csv")

gen_spec<-unlist(sapply(all_eco$Scientific, function(x) gsub(" ", "_", x)))
all_eco$gen_spec<-gen_spec

#Make plant diet binary
herbCols<-all_eco[,c("Diet.Fruit", "Diet.Nect", "Diet.Seed", "Diet.PlantO")]
herbScore<-rowSums(herbCols)
all_eco$herbScore<-herbScore

retina_noMissing<-all_retina$Hub_Species[which(all_retina$retinal_structure!="")]
ret_certain<-all_retina$Hub_Species[which(all_retina$certainty=="A")]
eco_noMissing<-all_eco$gen_spec[which(all_eco[,eco_cat]!="")]
eco_noMissing2<-all_eco$gen_spec[which(all_eco[,eco_cat2]!="")]
eco_noMissing3<-all_eco$gen_spec[which(all_eco[,eco_cat3]!="")]
#Only use Elton eco trait w/ high certainty (i.e., A not B for ForStrat or ABC not D1 or D2 for Activity)
cert_binary<-unlist(sapply(all_eco[,cert], function(x) if(length(grep("A",x)==1)){TRUE} else{FALSE}))
eco_certain<-all_eco$gen_spec[which(cert_binary)]
cert_binary2<-unlist(sapply(all_eco[,cert2], function(x) if(length(grep("A",x)==1)){TRUE} else{FALSE}))
eco_certain2<-all_eco$gen_spec[which(cert_binary2)]
cert_binary3<-unlist(sapply(all_eco[,cert3], function(x) if(x==1){TRUE} else{FALSE}))
eco_certain3<-all_eco$gen_spec[which(cert_binary3)]
#Get the eco data species names
eco_noMissing_sp<-all_retina$Hub_Species[which(all_retina$Data_Species %in% eco_noMissing)]
eco_noMissing2_sp<-all_retina$Hub_Species[which(all_retina$Data_Species %in% eco_noMissing2)]
eco_noMissing3_sp<-all_retina$Hub_Species[which(all_retina$Data_Species %in% eco_noMissing3)]
eco_certain_sp<-all_retina$Hub_Species[which(all_retina$Data_Species %in% eco_certain)]
eco_certain2_sp<-all_retina$Hub_Species[which(all_retina$Data_Species %in% eco_certain2)]
eco_certain3_sp<-all_retina$Hub_Species[which(all_retina$Data_Species %in% eco_certain3)]
#print(head(retina_noMissing))
#print(head(eco_noMissing))
#print(head(mytree$tip.label))
keep<-Reduce(intersect, list(retina_noMissing, eco_noMissing_sp, eco_certain_sp, eco_noMissing2_sp, eco_certain2_sp, eco_noMissing3_sp, eco_certain3_sp, mytree$tip.label)) #ret_certain

retina_keep<-all_retina[which(all_retina$Hub_Species %in% keep),]
tree_keep<-keep.tip(mytree, keep)

keep_data<-retina_keep$Data_Species
eco_keep<-all_eco[which(all_eco$gen_spec %in% keep_data),]
eco_sort<-eco_keep[match(retina_keep$Data_Species, eco_keep$gen_spec),]

print(tree_keep)
#print(eco_sort)

#Any horizontal streak (can be in combination w/ other specializations)
retina_binary<-unlist(sapply(retina_keep$retinal_structure, function(x) if(length(grep("horizontal streak",x)==1)){1} else{0}))
eco_binary<-c()
for(i in 1:nrow(eco_sort)){
	if(eco_sort[i, eco_cat]==eco_trait){
		if(as.numeric(eco_sort[i, eco_cat2]) >= eco_trait2){
			if(as.numeric(eco_sort[i, eco_cat3]) <= eco_trait3){
				eco_binary<-c(eco_binary, 1)
			} else{
				eco_binary<-c(eco_binary, 0)			
			}
		} else{
			eco_binary<-c(eco_binary, 0)
		}
	} else{
		eco_binary<-c(eco_binary, 0)
	}
}
newdata<-as.data.frame(cbind(retina_binary, eco_binary))
rownames(newdata)<-retina_keep$Hub_Species
#clean up retinal structure names to have no spaces
write.nexus(tree_keep, file=paste0(tree,"_hzAny_",eco_cat,".",eco_trait,"_",eco_cat2,".",eco_trait2,"_",eco_cat3,".",eco_trait3,".threshold.nexus"))
write.table(newdata, file=paste0("hzAny_",eco_trait,"_",eco_cat2,".",eco_trait2,"_",eco_cat3,".",eco_trait3,"_",tree,".noMissingData.threshold.txt"), col.names=FALSE, row.names=TRUE, quote=FALSE, sep="\t")


#ONLY horizontal streak
retina_binary<-unlist(sapply(retina_keep$retinal_structure, function(x) if(x=="horizontal streak"){1} else{0}))
newdata<-as.data.frame(cbind(retina_binary, eco_binary))
rownames(newdata)<-retina_keep$Hub_Species
#clean up retinal structure names to have no spaces
write.nexus(tree_keep, file=paste0(tree,"_hzOnly_",eco_cat,".",eco_trait,"_",eco_cat2,".",eco_trait2,"_",eco_cat3,".",eco_trait3,".threshold.nexus"))
write.table(newdata, file=paste0("hzOnly_",eco_trait,"_",eco_cat2,".",eco_trait2,"_",eco_cat3,".",eco_trait3,"_",tree,".noMissingData.threshold.txt"), col.names=FALSE, row.names=TRUE, quote=FALSE, sep="\t")
