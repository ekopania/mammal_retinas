#PURPOSE: Read in phylo and phenotype data; generate subsets that only include species in both

library(ape)

#CHANGE THESE based on dataset and tree
tree<-"mam241" #mam241 (zoonomia)
eco_cat<-"predScore"
cert<-"Diet.Certainty"
#FOR JUST ONE TRAIT AT A TIME
#ret<-"fovea"
#eco_trait<-"G" #G=ground
#FOR LOOPING THROUGH MULTIPLE TRAITS TO TEST SEVERAL HYPOTHESES
#rets<-c("fovea","area centralis","horizontal streak","none","vertical streak")
#Options for ForStrat.Value
eco_trait<-70

#Read in tree
mytree<-read.nexus(paste(tree, "no_label.nexus", sep="."))

#Get species w/ no missing data for retinal category and ecological category
all_retina<-read.csv("../mam241.pheno.terrestrial.csv")
#all_eco<-read.csv("../EltonTraits_mammals.csv")
all_eco<-read.csv("../EltonTraits_mammals.subset.csv")
#my.species.data<-unlist(sapply(mydata0$Data_Species, function(x) gsub("_"," ",x)))

gen_spec<-unlist(sapply(all_eco$Scientific, function(x) gsub(" ", "_", x)))
all_eco$gen_spec<-gen_spec

#Make plant diet binary
#Combine predation categories for one predation score (% of diet)
predCols<-all_eco[,c("Diet.Inv","Diet.Vend","Diet.Vect","Diet.Vfish","Diet.Vunk")]
predScore<-rowSums(predCols)
all_eco$predScore<-predScore

retina_noMissing<-all_retina$Hub_Species[which(all_retina$retinal_structure!="")]
ret_certain<-all_retina$Hub_Species[which(all_retina$certainty=="A")]
eco_noMissing<-all_eco$gen_spec[which(all_eco[,eco_cat]!="")]
#Only use Elton eco trait w/ high certainty (i.e., A not B for ForStrat or ABC not D1 or D2 for Activity)
cert_binary<-unlist(sapply(all_eco[,cert], function(x) if(length(grep("A",x)==1)){TRUE} else{FALSE}))
eco_certain<-all_eco$gen_spec[which(cert_binary)]
#Get the eco data species names
eco_noMissing_sp<-all_retina$Hub_Species[which(all_retina$Data_Species %in% eco_noMissing)]
eco_certain_sp<-all_retina$Hub_Species[which(all_retina$Data_Species %in% eco_certain)]
#print(head(retina_noMissing))
#print(head(eco_noMissing))
#print(head(mytree$tip.label))

keep<-Reduce(intersect, list(retina_noMissing, eco_noMissing_sp, eco_certain_sp, mytree$tip.label, ret_certain)) #ret_certain
retina_keep<-all_retina[which(all_retina$Hub_Species %in% keep),]
tree_keep<-keep.tip(mytree, keep)

keep_data<-retina_keep$Data_Species
#print(keep_data)
eco_keep<-all_eco[which(all_eco$gen_spec %in% keep_data),]
eco_sort<-eco_keep[match(retina_keep$Data_Species, eco_keep$gen_spec),]

print(tree_keep)

#Any area centralis (can be in combination w/ other specializations)
retina_binary<-unlist(sapply(retina_keep$retinal_structure, function(x) if(length(grep("area centralis",x)==1)){1} else{0}))
eco_binary<-c()
for(i in 1:nrow(eco_sort)){
	if(as.numeric(eco_sort[i, eco_cat]) >= eco_trait){
		eco_binary<-c(eco_binary, 1)
	} else{
		eco_binary<-c(eco_binary, 0)
	}
}
newdata<-as.data.frame(cbind(retina_binary, eco_binary))
rownames(newdata)<-retina_keep$Hub_Species
#clean up retinal structure names to have no spaces
write.nexus(tree_keep, file=paste0(tree,"_acAny_",eco_cat,".",eco_trait,".certainOnly.terrrestrial.nexus"))
write.table(newdata, file=paste0("acAny_",eco_cat,".",eco_trait,"_",tree,".noMissingData.certainOnly.terrestrial.txt"), col.names=FALSE, row.names=TRUE, quote=FALSE, sep="\t")


#ONLY area centralis
retina_binary<-unlist(sapply(retina_keep$retinal_structure, function(x) if(x=="area centralis"){1} else{0}))
newdata<-as.data.frame(cbind(retina_binary, eco_binary))
rownames(newdata)<-retina_keep$Hub_Species
#clean up retinal structure names to have no spaces
write.nexus(tree_keep, file=paste0(tree,"_acOnly_",eco_cat,".",eco_trait,".certainOnly.terrestrial.nexus"))
write.table(newdata, file=paste0("acOnly_",eco_cat,".",eco_trait,"_",tree,".noMissingData.certainOnly.terrestrial.txt"), col.names=FALSE, row.names=TRUE, quote=FALSE, sep="\t")
