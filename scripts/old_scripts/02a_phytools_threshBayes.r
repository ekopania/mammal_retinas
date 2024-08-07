#PURPOSE: Use phytools threshBayes to test for an association between a discrete and continuous trait with phylogenetic correction
#Tutorial: http://blog.phytools.org/search?q=binary+continuous

library(phytools)

#Read in data
myTree<-read.tree("mam241.tre")
#FOR JUST ONE TRAIT AT A TIME
#ret<-"fovea"
#FOR LOOPING THROUGH MULTIPLE TRAITS TO TEST SEVERAL HYPOTHESES
rets<-c("fovea","area centralis","horizontal streak","none","vertical streak")

#Get species w/ no missing data for retinal category and ecological category
all_retina<-read.csv("mam241.pheno.csv")
all_eco<-read.csv("EltonTraits_mammals.csv")

#Assign which variables we are looking at
disc<-"retinal_structure" #binary trait
one<-"fovea" #foreground trait (i.e., trait to be assigned "1"; other values will be assigned "0")
cont<-"predScore" #continuous trait
cert<-"Diet.Certainty" #column name for trait certainty

#Combine predation categories for one predation score (% of diet)
predCols<-all_eco[,c("Diet.Inv","Diet.Vend","Diet.Vect","Diet.Vfish","Diet.Vunk")]
#dim(predCols)
#head(predCols)
predScore<-rowSums(predCols)
all_eco$predScore<-predScore

#Get species w/ no missing data for retinal category and ecological category
gen_spec<-unlist(sapply(all_eco$Scientific, function(x) gsub(" ", "_", x)))
all_eco$gen_spec<-gen_spec

retina_noMissing<-all_retina$Hub_Species[which(all_retina$retinal_structure!="")]
eco_noMissing<-all_eco$gen_spec[which(all_eco[,cont]!="")]
#Only use Elton eco trait w/ high certainty (i.e., ABC not D1 or D2)
cert_binary<-unlist(sapply(all_eco[,cert], function(x) if(length(grep("D",x)==1)){FALSE} else{TRUE}))
eco_certain<-all_eco$gen_spec[which(cert_binary)]
#print(head(retina_noMissing))
#print(head(eco_noMissing))
#print(head(eco_certain))
keep<-Reduce(intersect, list(retina_noMissing, eco_noMissing, eco_certain, myTree$tip.label))

retina_keep<-all_retina[which(all_retina$Hub_Species %in% keep),]
eco_keep<-all_eco[which(all_eco$gen_spec %in% keep),]
tree_keep<-keep.tip(myTree, keep)

eco_sort<-eco_keep[match(retina_keep$Hub_Species, eco_keep$gen_spec),]

#Loop through all retinal structures
for(one in rets){
	print(paste("Testing for association between", one, "and", cont))
	#Get variables into a format phytools likes
	disc_binary<-unlist(sapply(retina_keep[,disc], function(x) if(grepl(one,x)){1}else if(x==""){NA}else{0}))
	names(disc_binary)<-retina_keep$Hub_Species
	disc_binary_unique<-disc_binary[which(!(duplicated(names(disc_binary))))]
	#print(dim(retina_keep))
	#print(retina_keep[1:20,disc])
	#print(length(disc_binary_unique))
	#print(disc_binary_unique[1:20])
	
	cont_dat<-eco_sort[,cont]
	names(cont_dat)<-eco_sort$gen_spec
	cont_dat_unique<-cont_dat[which(!(duplicated(names(cont_dat))))]
	
	#keep<-Reduce(intersect, list(myTree$tip.label, names(disc_binary_unique)[which(!(is.na(disc_binary_unique)))], names(cont_dat_unique[which(!(is.null(cont_dat_unique)))])))
	
	#newTree<-drop.tip(myTree, myTree$tip.label[which(!(myTree$tip.label %in% keep))])
	print("TREE:")
	print(tree_keep)
	
	#cont_dat_keep<-cont_dat_unique[which(names(cont_dat_unique) %in% keep)]
	#disc_binary_keep<-disc_binary_unique[which(names(disc_binary_unique) %in% keep)]
	
	stopifnot(all.equal(names(cont_dat_unique), names(disc_binary_unique)))
	datForPhytools<-data.frame(cont_dat_unique, disc_binary_unique)
	rownames(datForPhytools)<-names(disc_binary_unique)
	print("PHENOTYPE DATA:")
	print(head(datForPhytools))
	#datForPhytools_keep<-datForPhytools[which(rownames(datForPhytools) %in% keep),]
	#print(datForPhytools_keep)
	#print(dim(datForPhytools_keep))
	
	print("One median:")
	print(median(datForPhytools$cont_dat[which(datForPhytools$disc_binary==1)]))
	print("Zero median:")
	print(median(datForPhytools$cont_dat[which(datForPhytools$disc_binary==0)]))
	#Run threshBayes; print and save results
	mcmc<-threshBayes(tree_keep, datForPhytools, ngen=1000000, plot=FALSE, control=list(print.interval=100000))
	
	print(mcmc)
	
	pdf(paste("threshBayes_mcmc_output", gsub(" ","",one), cont, "pdf", sep="."))
	plot(mcmc)
	
	#Calculate density distribution
	d<-density(mcmc,bw=0.1)
	print(d)
	
	plot(d)
	title(main=paste("posterior density of correlation coefficient, r,\nfrom threshold model", one, "vs", cont), font.main=3)
	
	dev.off()
}
