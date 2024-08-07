#PURPOSE: Read in phylo and phenotype data; generate subsets that only include species in both

library(phytools)

#CHANGE THESE based on dataset and tree
tree<-"mam241" #mam241 (zoonomia)
eco_cat<-"ForStrat.Value" #Options: ForStrat.Value
cert<-"ForStrat.Certainty" #Options: ForStrat.Certainty
#FOR JUST ONE TRAIT AT A TIME
#ret<-"fovea"
#eco_trait<-"G" #G=ground
#FOR LOOPING THROUGH MULTIPLE TRAITS TO TEST SEVERAL HYPOTHESES
#rets<-c("fovea","area centralis","horizontal streak","none","vertical streak")
rets<-c("horizontal streak")
#Options for ForStrat.Value
#eco_traits<-c("G","M","Ar","A","S","F")
eco_traits<-c("G")

#Read in tree
mytree<-read.nexus(paste(tree, "no_label.nexus", sep="."))

#Get species w/ no missing data for retinal category and ecological category
all_retina<-read.csv("../mam241.pheno.csv")
#all_eco<-read.csv("../EltonTraits_mammals.csv")
all_eco<-read.csv("../EltonTraits_mammals.subset.csv")

#gen_spec<-unlist(sapply(all_eco$Scientific, function(x) gsub(" ", "_", x)))
#all_eco$gen_spec<-gen_spec
#eco_forTree<-all_retina$Hub_Species[which(all_retina$Data_Species %in% gen_spec)]

retina_noMissing<-all_retina$Hub_Species[which(all_retina$retinal_structure!="")]
ret_certain<-all_retina$Hub_Species[which(all_retina$certainty=="A")]
eco_noMissing<-all_eco$gen_spec[which(all_eco[,eco_cat]!="")]
#Only use Elton eco trait w/ high certainty (i.e., A not B for ForStrat or ABC not D1 or D2 for Activity)
cert_binary<-unlist(sapply(all_eco[,cert], function(x) if(length(grep("A",x)==1)){TRUE} else{FALSE}))
eco_certain<-all_eco$gen_spec[which(cert_binary)]
#print(head(retina_noMissing))
#print(head(eco_noMissing))
#print(head(mytree$tip.label))
#For data with high certainty only, include eco_certain, ret_certain
eco_keep<-Reduce(intersect, list(eco_noMissing))
keep<-Reduce(intersect, list(retina_noMissing, all_retina$Hub_Species[which(all_retina$Elton_Species %in% eco_keep)],  mytree$tip.label))

retina_keep<-all_retina[which(all_retina$Hub_Species %in% keep),]
tree_keep<-keep.tip(mytree, keep)

keep_data<-retina_keep$Elton_Species
eco_keep<-all_eco[which(all_eco$gen_spec %in% keep_data),]
eco_sort<-eco_keep[match(retina_keep$Elton_Species, eco_keep$gen_spec),]

#print(tree_keep)
#print(head(retina_keep))
#print(head(eco_sort))

#Loop through all traits
for(ret in rets){
	for(eco_trait in eco_traits){
		print(paste("Getting data for", ret, "(any)"))
		retina_binary<-unlist(sapply(retina_keep$retinal_structure, function(x) if(length(grep(ret,x)==1)){1} else{0}))
		eco_binary<-unlist(sapply(eco_sort[,eco_cat], function(x) if(eco_trait==x){1} else{0}))

		newdata<-as.data.frame(cbind(retina_binary, eco_binary))
		rownames(newdata)<-retina_keep$Hub_Species
		#colnames(newdata)<-c("retinal_structure", "eco_trait")

		#clean up retinal structure names to have no spaces
		retname<-gsub(" ","",ret)

		#CHANGE THESE based on desired output file names
		#This will overwrite several times, but it's okay because should be the same tree for all combinations of same eco_cat
		#End with ".certainOnly.nexus" if filtering on data certainty
		write.nexus(tree_keep, file=paste0(tree,"_retinalStructure_",eco_cat,".nexus"))
		write.table(newdata, file=paste0(retname,"Any_",eco_trait,"_",tree,".noMissingData.txt"), col.names=FALSE, row.names=TRUE, quote=FALSE, sep="\t")

		print(paste("Getting data for", ret, "(only)"))
                retina_binary<-unlist(sapply(retina_keep$retinal_structure, function(x) if(ret==x){1} else{0}))
                eco_binary<-unlist(sapply(eco_sort[,eco_cat], function(x) if(eco_trait==x){1} else{0}))

                newdata<-as.data.frame(cbind(retina_binary, eco_binary))
                rownames(newdata)<-retina_keep$Hub_Species

                #clean up retinal structure names to have no spaces
                retname<-gsub(" ","",ret)

                #CHANGE THESE based on desired output file names
                #This will overwrite several times, but it's okay because should be the same tree for all combinations of same eco_cat
		#End with ".certainOnly.nexus" if filtering on data certainty
                write.nexus(tree_keep, file=paste0(tree,"_retinalStructure_",eco_cat,".nexus"))
                write.table(newdata, file=paste0(retname,"Only_",eco_trait,"_",tree,".noMissingData.txt"), col.names=FALSE, row.names=TRUE, quote=FALSE, sep="\t")
	}
}
