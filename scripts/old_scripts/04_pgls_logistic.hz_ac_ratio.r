#PURPOSE: Run PGLS logistic regression to test for correlations between binary and continuous traits (Garland and Ives 2010)
#https://rdrr.io/cran/phylolm/man/phyloglm.html

library(ape)
library(nlme)
library(phytools)
library(phylolm)
library(ggplot2)

#Read in data
myTree<-read.tree("mam241.tre")
all_retina<-read.csv("mam241.pheno.thresholds.csv")
all_eco<-read.csv("EltonTraits_mammals.subset.csv")

#Establish which traits we are analyzing
trait_bin<-"predScore"
trait_cont<-"hz_to_ac_ratio"

gen_spec<-unlist(sapply(all_eco$Scientific, function(x) gsub(" ", "_", x)))
all_eco$gen_spec<-gen_spec

#Make plant diet binary
#Combine predation categories for one predation score (% of diet)
predCols<-all_eco[,c("Diet.Inv","Diet.Vend","Diet.Vect","Diet.Vfish","Diet.Vunk")]
predScore<-rowSums(predCols)
all_eco$predScore<-predScore

#Get species w/ no missing data for retinal category and ecological category
retina_noMissing<-all_retina$Hub_Species[which(all_retina[,trait_cont]!="")]
eco_noMissing<-all_eco$gen_spec[which(all_eco[,trait_bin]!="")]
#Only use Elton eco trait w/ high certainty (i.e., A not B for ForStrat or ABC not D1 or D2 for Activity)
cert_binary<-unlist(sapply(all_eco[,"Diet.Certainty"], function(x) if(length(grep("A",x)==1)){TRUE} else{FALSE}))
eco_certain<-all_eco$gen_spec[which(cert_binary)]
eco_terrestrial<-all_eco$gen_spec[which(all_eco$ForStrat.Value!="M")]
eco_keep<-all_retina$Hub_Species[which(all_retina$Data_Species %in% Reduce(intersect, list(eco_noMissing, eco_certain, eco_terrestrial)))]

keep<-Reduce(intersect, list(retina_noMissing, eco_keep, myTree$tip.label))
print(keep)
retina_keep<-all_retina[which(all_retina$Hub_Species %in% keep),]
tree_keep<-keep.tip(myTree, keep)
print("TREE:")
print(tree_keep)

#keep_data<-retina_keep$Data_Species
keep_data<-retina_keep$Data_Species
eco_keep<-all_eco[which(all_eco$gen_spec %in% keep_data),]
eco_sort<-eco_keep[match(retina_keep$Data_Species, eco_keep$gen_spec),]

disc_binary<-unlist(sapply(eco_sort[,trait_bin], function(x) if(x>=70){1}else if(x==""){NA}else{0}))
names(disc_binary)<-eco_sort$gen_spec
disc_binary_unique<-disc_binary[which(!(duplicated(names(disc_binary))))]
cont_dat<-retina_keep[,trait_cont]
names(cont_dat)<-retina_keep$Data_Species
cont_dat_unique<-cont_dat[which(!(duplicated(names(cont_dat))))]
stopifnot(all.equal(names(disc_binary_unique), names(cont_dat_unique)))

#Setup for phyloglm and run
phyloglm_df<-as.data.frame(cbind(disc_binary_unique, cont_dat_unique))
rownames(phyloglm_df)<-unlist(sapply(names(disc_binary_unique), function(x) retina_keep$Hub_Species[which(retina_keep$Data_Species==x)]))
colnames(phyloglm_df)<-c(trait_bin, trait_cont)
phyloglm_df[,trait_bin]<-as.numeric(phyloglm_df[,trait_bin])
phyloglm_df[,trait_cont]<-as.numeric(phyloglm_df[,trait_cont])
print(phyloglm_df)
fm<-as.formula(paste0(trait_bin,"~",trait_cont))
gi_model<-phyloglm(fm, data=phyloglm_df, phy=tree_keep, method="logistic_IG10", btol=20)
print(summary(gi_model))
pval<-summary(gi_model)$coefficients[trait_cont,4]

#Plot
pdf(paste(trait_bin, "vs", trait_cont, "phylo_logistic_regression.terrestrial.pdf", sep="."))
p<-ggplot(phyloglm_df, aes(x=get(trait_cont), y=get(trait_bin))) + geom_text(label=rownames(phyloglm_df), position=position_jitter(width=0.1, height=0.1)) + theme_minimal() #+ geom_point()
#Logistic regression
p<-p + stat_smooth(method = "glm", col = "red", method.args=list(family=binomial), fullrange=TRUE)
p<-p + labs(title=paste("Horizontal streak to area centralis\nRGC density ratio vs", trait_cont), x=trait_cont, y=trait_bin)
p<-p + geom_text(x=100, y=0.9, label=paste("P-value:", round(pval, 3)))
print(p)

dev.off()
