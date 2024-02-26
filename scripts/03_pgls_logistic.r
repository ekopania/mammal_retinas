#PURPOSE: Run PGLS logistic regression to test for correlations between binary and continuous traits (Garland and Ives 2010)
#https://rdrr.io/cran/phylolm/man/phyloglm.html

library(caper)
library(ape)
library(nlme)
library(phytools)
library(phylolm)
library(ggplot2)

#Read in data
myTree<-read.tree("mam241.tre")
#FOR JUST ONE TRAIT AT A TIME
#ret<-"fovea"
#FOR LOOPING THROUGH MULTIPLE TRAITS TO TEST SEVERAL HYPOTHESES
rets<-c("fovea|area centralis","horizontal streak")
all_retina<-read.csv("mam241.pheno.csv")
elton<-read.csv("EltonTraits_mammals.csv")
gen_spec<-unlist(sapply(elton$Scientific, function(x) gsub(" ", "_", x)))
elton$gen_spec<-gen_spec

#Establish which traits we are analyzing
trait_bin<-"retinal_structure"
trait_cont<-"orbit_convergence_merged"

orbit.convergence<-c()
size<-c()
for(i in 1:nrow(all_retina)){
        if(is.na(all_retina$orbit_convergence_myMeasurement[i])){
                orbit.convergence<-c(orbit.convergence, all_retina$orbit_convergence[i])
        } else if(all_retina$orbit_convergence_myMeasurement[i]!=""){
                orbit.convergence<-c(orbit.convergence, all_retina$orbit_convergence_myMeasurement[i])
        } else{
                orbit.convergence<-c(orbit.convergence, all_retina$orbit_convergence[i])
        }
	if(all_retina$Data_Species[i] %in% elton$gen_spec){
		elton_line<-elton[which(elton$gen_spec == all_retina$Data_Species[i]),]
		if(elton_line$BodyMass.SpecLevel == 1){
                        size<-c(size, log(elton_line$BodyMass.Value))
                }else{
                        size<-c(size, NA)
                }
	} else{
		size<-c(size, NA)
	}
}
all_retina$orbit_convergence_merged<-orbit.convergence
all_retina$size<-size

#Get species w/ no missing data for retinal category and ecological category
retina_noMissing<-all_retina$Hub_Species[which(all_retina[,trait_bin]!="")]
retina_certain<-all_retina$Hub_Species[which(all_retina[,"certainty"]=="A")]
cont_noMissing<-all_retina$Hub_Species[which(all_retina[,trait_cont]!="")]
keep<-Reduce(intersect, list(retina_noMissing, cont_noMissing, myTree$tip.label, retina_certain))
#Remove Gorilla outlier
#keep<-keep[-which(keep=="Gorilla_gorilla")]
retina_keep<-all_retina[which(all_retina$Hub_Species %in% keep),]
retina_keep$orbit_convergence<-as.numeric(retina_keep$orbit_convergence)
retina_keep$size<-as.numeric(retina_keep$size)
print(retina_keep)
tree_keep<-keep.tip(myTree, keep)
print("TREE:")
print(tree_keep)

pdf(paste(trait_bin, "vs", trait_cont, "phylo_logistic_regression.certainOnly.pdf", sep="."))
#Loop through all retinal structures
for(one in rets){
	#Has retinal structure at all
        print(paste("Testing for association between", one, "(any) and", trait_cont))
	disc_binary<-unlist(sapply(retina_keep[,trait_bin], function(x) if(grepl(one,x)){1}else if(x==""){NA}else{0}))
        names(disc_binary)<-retina_keep$Hub_Species
        disc_binary_unique<-disc_binary[which(!(duplicated(names(disc_binary))))]
        cont_dat<-retina_keep[,trait_cont]
        names(cont_dat)<-retina_keep$Hub_Species
        cont_dat_unique<-cont_dat[which(!(duplicated(names(cont_dat))))]
	size_dat<-retina_keep$size
	names(size_dat)<-retina_keep$Hub_Species
	size_dat_unique<-size_dat[which(!(duplicated(names(size_dat))))]
	stopifnot(all.equal(names(disc_binary_unique), names(cont_dat_unique)))
	stopifnot(all.equal(names(disc_binary_unique), names(size_dat_unique)))
	#Setup for phyloglm and run
	phyloglm_df<-as.data.frame(cbind(disc_binary_unique, cont_dat_unique, size_dat_unique))
	rownames(phyloglm_df)<-names(disc_binary_unique)
	colnames(phyloglm_df)<-c(trait_bin, trait_cont, "size")
	print(head(phyloglm_df))
	fm<-as.formula(paste0(trait_bin,"~",trait_cont))
	gi_model<-phyloglm(fm, data=phyloglm_df, phy=tree_keep, method="logistic_IG10", btol=30)
	print(summary(gi_model))
	pval<-summary(gi_model)$coefficients[trait_cont,4]
	#pgls with size as covariate
	pgls_df<-as.data.frame(cbind(phyloglm_df, species=names(disc_binary_unique)))
	pgls_df$retinal_structure<-as.factor(pgls_df$retinal_structure)
	comp.data<-comparative.data(tree_keep, pgls_df, names.col="species", vcv.dim=2, warn.dropped=TRUE)
	print(comp.data)
	res<-pgls(orbit_convergence_merged~retinal_structure*size, data=comp.data)
	print(summary(res))
	anova(res)

	#Plot
	p<-ggplot(phyloglm_df, aes(x=get(trait_cont), y=get(trait_bin))) + geom_point() + theme_minimal()
	#Logistic regression
        p<-p + stat_smooth(method = "glm", col = "red", method.args=list(family=binomial), fullrange=TRUE)
	p<-p + labs(title=paste(one, "(any) vs", trait_cont), x=trait_cont, y=one)
	p<-p + geom_text(x=max(cont_dat, na.rm=TRUE)-10, y=0.9, label=paste("Phylogenetic Logistic Regression\nP-value:", round(pval, 3)))
	print(p)

	#Has ONLY that retinal structure
	print(paste("Testing for association between", one, "(only) and", trait_cont))
        disc_binary<-unlist(sapply(retina_keep[,trait_bin], function(x) if(x %in% unlist(strsplit(one,"\\|"))){1}else if(x==""){NA}else{0}))
        names(disc_binary)<-retina_keep$Hub_Species
        disc_binary_unique<-disc_binary[which(!(duplicated(names(disc_binary))))]
        cont_dat<-retina_keep[,trait_cont]
        names(cont_dat)<-retina_keep$Hub_Species
        cont_dat_unique<-cont_dat[which(!(duplicated(names(cont_dat))))]
	size_dat<-retina_keep$size
        names(size_dat)<-retina_keep$Hub_Species
        size_dat_unique<-size_dat[which(!(duplicated(names(size_dat))))]
        stopifnot(all.equal(names(disc_binary_unique), names(cont_dat_unique)))
        stopifnot(all.equal(names(disc_binary_unique), names(size_dat_unique)))
        #Setup for phyloglm and run
        phyloglm_df<-as.data.frame(cbind(disc_binary_unique, cont_dat_unique, size_dat_unique))
        rownames(phyloglm_df)<-names(disc_binary_unique)
        colnames(phyloglm_df)<-c(trait_bin, trait_cont, "size")
        print(head(phyloglm_df))
	fm<-as.formula(paste0(trait_bin,"~",trait_cont))
        gi_model<-phyloglm(fm, data=phyloglm_df, phy=tree_keep, method="logistic_IG10", btol=30)
        print(summary(gi_model))
	pval<-summary(gi_model)$coefficients[trait_cont,4]
	#pgls with size as covariate
        pgls_df<-as.data.frame(cbind(phyloglm_df, species=names(disc_binary_unique)))
        pgls_df$retinal_structure<-as.factor(pgls_df$retinal_structure)
	comp.data<-comparative.data(tree_keep, pgls_df, names.col="species", vcv.dim=2, warn.dropped=TRUE)
        print(comp.data)
        res<-pgls(orbit_convergence_merged~retinal_structure*size, data=comp.data)
        print(summary(res))
        anova(res)

        #Plot
        p<-ggplot(phyloglm_df, aes(x=get(trait_cont), y=get(trait_bin))) + geom_point() + theme_minimal()
        #Logistic regression
        p<-p + stat_smooth(method = "glm", col = "red", method.args=list(family=binomial), fullrange=TRUE)
        p<-p + labs(title=paste(one, "(only) vs", trait_cont), x=trait_cont, y=one)
	p<-p + geom_text(x=max(cont_dat, na.rm=TRUE)-10, y=0.9, label=paste("Phylogenetic logistic regression\nP-value:", round(pval, 3)))
        print(p)
}

dev.off()
