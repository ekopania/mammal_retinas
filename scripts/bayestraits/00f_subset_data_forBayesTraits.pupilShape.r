#PURPOSE: Read in phylo and phenotype data; generate subsets that only include species in both

library(phytools)

#CHANGE THESE based on dataset and tree
tree<-"mam241" #mam241 (zoonomia)
eco_cat<-"pupil_shape" 
#FOR JUST ONE TRAIT AT A TIME
#ret<-"fovea"
#eco_trait<-"G" #G=ground
#FOR LOOPING THROUGH MULTIPLE TRAITS TO TEST SEVERAL HYPOTHESES
rets<-c("fovea","area centralis","horizontal streak","none","anakatabatic area")
#Options for pupil_shape
eco_traits<-c("circular", "subcircular", "vertical", "horizontal", "u-shape")

#Read in tree
mytree<-read.nexus(paste(tree, "no_label.nexus", sep="."))

#Get species w/ no missing data for retinal category and ecological category
all_retina<-read.csv("../mam241.pheno.csv")

retina_noMissing<-all_retina$Hub_Species[which(all_retina$retinal_structure!="")]
ret_certain<-all_retina$Hub_Species[which(all_retina$certainty=="A")]
eco_noMissing<-all_retina$Hub_Species[which(all_retina[,eco_cat]!="")]
#print(head(retina_noMissing))
#print(head(eco_noMissing))
#print(head(mytree$tip.label))
keep<-Reduce(intersect, list(retina_noMissing, eco_noMissing, mytree$tip.label)) #ret_certain

retina_keep<-all_retina[which(all_retina$Hub_Species %in% keep),]
tree_keep<-keep.tip(mytree, keep)

#print(tree_keep)
#print(head(retina_keep))

#Loop through all traits
for(ret in rets){
	for(eco_trait in eco_traits){
		print(paste("Getting data for", ret, "(any)"))
		retina_binary<-unlist(sapply(retina_keep$retinal_structure, function(x) if(length(grep(ret,x)==1)){1} else{0}))
		eco_binary<-unlist(sapply(retina_keep[,eco_cat], function(x) if(eco_trait==x){1} else{0}))

		newdata<-as.data.frame(cbind(retina_binary, eco_binary))
		rownames(newdata)<-retina_keep$Hub_Species
		#colnames(newdata)<-c("retinal_structure", "eco_trait")

		#clean up retinal structure names to have no spaces
		retname<-gsub(" ","",ret)

		#CHANGE THESE based on desired output file names
		#This will overwrite several times, but it's okay because should be the same tree for all combinations of same eco_cat
		write.nexus(tree_keep, file=paste0(tree,"_retinalStructure_",eco_cat,".nexus"))
		write.table(newdata, file=paste0(retname,"Any_",eco_trait,"_",tree,".noMissingData.txt"), col.names=FALSE, row.names=TRUE, quote=FALSE, sep="\t")

		print(paste("Getting data for", ret, "(only)"))
                retina_binary<-unlist(sapply(retina_keep$retinal_structure, function(x) if(ret==x){1} else{0}))
                eco_binary<-unlist(sapply(retina_keep[,eco_cat], function(x) if(eco_trait==x){1} else{0}))

                newdata<-as.data.frame(cbind(retina_binary, eco_binary))
                rownames(newdata)<-retina_keep$Hub_Species

                #clean up retinal structure names to have no spaces
                retname<-gsub(" ","",ret)

                #CHANGE THESE based on desired output file names
                #This will overwrite several times, but it's okay because should be the same tree for all combinations of same eco_cat
                write.nexus(tree_keep, file=paste0(tree,"_retinalStructure_",eco_cat,".nexus"))
                write.table(newdata, file=paste0(retname,"Only_",eco_trait,"_",tree,".noMissingData.txt"), col.names=FALSE, row.names=TRUE, quote=FALSE, sep="\t")
	}
}
