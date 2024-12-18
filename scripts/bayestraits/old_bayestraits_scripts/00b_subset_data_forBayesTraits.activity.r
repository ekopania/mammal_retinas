#PURPOSE: Read in phylo and phenotype data; generate subsets that only include species in both

library(ape)

#CHANGE THESE based on dataset and tree
tree<-"mam241" #mam241 (zoonomia)
eco_cat<-"Activity.Diurnal" #Options: Activity.Nocturnal, Activity.Crepuscular, Activity.Diurnal
cat_name<-strsplit(eco_cat,"\\.")[[1]][2]
cert<-"Activity.Certainty" #Options: Activity.Certainty
#FOR JUST ONE TRAIT AT A TIME
#ret<-"fovea"
#FOR LOOPING THROUGH MULTIPLE TRAITS TO TEST SEVERAL HYPOTHESES
rets<-c("fovea","area centralis","horizontal streak","none","vertical streak")
#Options for any of the Activity categories

#Read in tree
mytree<-read.nexus(paste(tree, "no_label.nexus", sep="."))

#Get species w/ no missing data for retinal category and ecological category
all_retina<-read.csv("../mam241.pheno.csv")
all_eco<-read.csv("../EltonTraits_mammals.csv")

gen_spec<-unlist(sapply(all_eco$Scientific, function(x) gsub(" ", "_", x)))
all_eco$gen_spec<-gen_spec

retina_noMissing<-all_retina$Hub_Species[which(all_retina$retinal_structure!="")]
eco_noMissing<-all_eco$gen_spec[which(all_eco[,eco_cat]!="")]
#Only use Elton eco trait w/ high certainty (i.e., A not B for ForStrat or ABC not D1 or D2 for Activity)
cert_binary<-unlist(sapply(all_eco[,cert], function(x) if(length(grep("A",x)==1)){TRUE} else{FALSE}))
eco_certain<-all_eco$gen_spec[which(cert_binary)]
#print(head(retina_noMissing))
#print(head(eco_noMissing))
#print(head(mytree$tip.label))
keep<-Reduce(intersect, list(retina_noMissing, eco_noMissing, eco_certain, mytree$tip.label))

retina_keep<-all_retina[which(all_retina$Hub_Species %in% keep),]
eco_keep<-all_eco[which(all_eco$gen_spec %in% keep),]
tree_keep<-keep.tip(mytree, keep)

eco_sort<-eco_keep[match(retina_keep$Hub_Species, eco_keep$gen_spec),]

#Loop through all traits
for(ret in rets){
	retina_binary<-unlist(sapply(retina_keep$retinal_structure, function(x) if(length(grep(ret,x)==1)){1} else{0}))
	eco_binary<-eco_sort[,eco_cat]

	newdata<-as.data.frame(cbind(retina_binary, eco_binary))
	rownames(newdata)<-retina_keep$Hub_Species

	#clean up retinal structure names to have no spaces
	retname<-gsub(" ","",ret)

	#CHANGE THESE based on desired output file names
	#This will overwrite several times, but it's okay because should be the same tree for all combinations of same eco_cat
	write.nexus(tree_keep, file=paste0(tree,"_retinalStructure_",cat_name,".nexus"))
	write.table(newdata, file=paste0(retname,"_",cat_name,"_",tree,".noMissingData.txt"), col.names=FALSE, row.names=TRUE, quote=FALSE, sep="\t")
}
