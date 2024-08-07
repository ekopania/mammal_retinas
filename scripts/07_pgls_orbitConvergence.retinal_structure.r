#PURPOSE: Use pgls with size as a coviarate to test for associations between retinal specialization type and orbit convergence

#Some helpful relevant tutorials: 
#http://www.phytools.org/Cordoba2017/ex/4/PGLS.html
#http://blog.phytools.org/2022/12/post-hoc-tests-for-generalized.html
#https://cran.r-project.org/web/packages/caper/vignettes/caper.pdf
#https://cran.r-project.org/web/packages/caper/caper.pdf

library(caper)
library(nlme)
library(multcomp)
library(phytools)
library(ggplot2)

#Read in data
myTree<-read.tree("mam241.tre")
#FOR JUST ONE TRAIT AT A TIME
#ret<-"fovea"
#FOR LOOPING THROUGH MULTIPLE TRAITS TO TEST SEVERAL HYPOTHESES
rets<-c("fovea|area centralis","horizontal streak")
#all_retina<-read.csv("mam241.pheno.csv")
all_retina<-read.csv("mam241.pheno.trimmedPrimates.csv")
elton<-read.csv("EltonTraits_mammals.csv")
gen_spec<-unlist(sapply(elton$Scientific, function(x) gsub(" ", "_", x)))
elton$gen_spec<-gen_spec

#Get orbit convergence and log size values for all taxa
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
                if(elton_line$BodyMass.SpecLevel == 1){ #High certainty only
                        size<-c(size, log10(elton_line$BodyMass.Value))
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
retina_noMissing<-all_retina$Hub_Species[which(all_retina$retinal_structure!="")]
retina_certain<-all_retina$Hub_Species[which(all_retina$certainty=="A")]
cont_noMissing<-all_retina$Hub_Species[which(all_retina$orbit_convergence_merged!="")]
keep<-Reduce(intersect, list(retina_noMissing, cont_noMissing, myTree$tip.label)) #, retina_certain))
#Remove Gorilla outlier
#keep<-keep[-which(keep=="Gorilla_gorilla")]
#Remove all primates
#primates<-c("Aotus_nancymaae", "Alouatta_palliata", "Cebus_albifrons", "Macaca_mulatta", "Macaca_nemestrina", "Cheirogaleus_medius", "Microcebus_murinus", "Gorilla_gorilla")
#keep<-keep[-which(keep %in% primates)]
retina_keep<-all_retina[which(all_retina$Hub_Species %in% keep),]

#Make retinal specialization categorical
#Options: horizontal streak only, fovea or area centralis only, no data/NA, mix of specialization types
#cat_trait<-unlist(sapply(retina_keep$retinal_structure, function(x) if(x=="horizontal streak"){"hs"}else if(x %in% c("fovea","area centralis")){"f_ac"}else if(x==""){NA}else{"mix"}))
#Make retinal specialization binary
cat_trait<-unlist(sapply(retina_keep$retinal_structure, function(x) if(x=="horizontal streak"){"hs"}else if(x %in% c("fovea","area centralis")){"f_ac"}else{NA}))

#Make df for pgls
pgls_df<-as.data.frame(cbind(retina_keep$orbit_convergence_merged, cat_trait, retina_keep$size, retina_keep$Hub_Species))
rownames(pgls_df)<-retina_keep$Hub_Species
colnames(pgls_df)<-c("orbit_convergence_merged", "retinal_structure", "size", "species")
pgls_df<-pgls_df[which(!(is.na(pgls_df$retinal_structure))),]
pgls_df$orbit_convergence_merged<-as.numeric(pgls_df$orbit_convergence_merged)
pgls_df$retinal_structure<-as.factor(pgls_df$retinal_structure)
pgls_df$size<-as.numeric(pgls_df$size)
pgls_df<-pgls_df[which(!(is.na(pgls_df$size))),]

print(pgls_df)

#Prune tree to only include species in analysis
tree_keep<-keep.tip(myTree, pgls_df$species)
print("TREE:")
print(tree_keep)


#Get size residuals for orbit convergence
#model<-lm(orbit_convergence_merged ~ size, data=pgls_df)
#summary(model)
#oc_sizeRes<-resid(model)
#print(oc_sizeRes)
#pdf("test_plots.pdf", onefile=TRUE)
#plot(pgls_df$size, pgls_df$orbit_convergence_merged)
#plot(pgls_df$size, oc_sizeRes)
#dev.off()
#pgls_df$oc_sizeRes<-as.numeric(oc_sizeRes)

##Run PGLS (ANOVA and ANCOVA) with caper
#pdf("orbit_convergence_by_specialization_caperPGLSplots.pdf", onefile=TRUE)
##Set up comparative data object for pgls
#comp.data<-comparative.data(tree_keep, pgls_df, names.col="species", vcv.dim=3, warn.dropped=TRUE)
#print(comp.data)
#print("size only, caper BM:")
#res_size<-pgls(orbit_convergence_merged~size, data=comp.data)
#print(summary(res_size))
#print("retinal specialization only, caper BM:")
#resBM<-pgls(orbit_convergence_merged~retinal_structure, data=comp.data)
#print(summary(resBM))
#plot(resBM)
#print("retinal specialization only, caper lambda ML:")
#res_lambdaML<-pgls(orbit_convergence_merged~retinal_structure, data=comp.data, lambda="ML")
#print(summary(res_lambdaML))
#plot(res_lambdaML)
#lm.lk<-pgls.profile(res_lambdaML, which="lambda")
#plot(lm.lk)
#print("Orbit convergence by specialization, with size as a covariate, caper BM:")
#resBM_COVsize<-pgls(orbit_convergence_merged~size+retinal_structure, data=comp.data)
#print(summary(resBM_COVsize))
#plot(resBM_COVsize)
#print("Orbit convergence by specialization, with size as a covariate, caper lambda ML:")
#res_lambdaML_COVsize<-pgls(orbit_convergence_merged~size+retinal_structure, data=comp.data, lambda="ML")
#print(summary(res_lambdaML_COVsize))
#plot(res_lambdaML_COVsize)
#lm.lk<-pgls.profile(res_lambdaML_COVsize, which="lambda")
#plot(lm.lk)
##print("Residuals of orbit convergence vs size compared to retinal specialization")
##res<-pgls(oc_sizeRes~retinal_structure-1, data=comp.data)
##print(summary(res))
##plot(res)
#
#print("compare caper models:")
#AIC(resBM, res_lambdaML, resBM_COVsize, res_lambdaML_COVsize)
#logLik(resBM)
#logLik(res_lambdaML)
#logLik(resBM_COVsize)
#logLik(res_lambdaML_COVsize)
#
#dev.off()
#
#phylo_residualsBM<-resid(resBM)
#phylo_residualsBM_sort<-phylo_residualsBM[match(pgls_df$species, rownames(phylo_residualsBM)),]
#print(head(phylo_residualsBM_sort))
#stopifnot(all.equal(names(phylo_residualsBM_sort), pgls_df$species))
#pgls_df$phylo_residualsBM<-phylo_residualsBM_sort
#phylo_residualsP<-resid(res_lambdaML)
#phylo_residualsP_sort<-phylo_residualsP[match(pgls_df$species, rownames(phylo_residualsP)),]
#print(head(phylo_residualsP_sort))
#stopifnot(all.equal(names(phylo_residualsP_sort), pgls_df$species))
#pgls_df$phylo_residualsP<-phylo_residualsP_sort
#write.table(pgls_df, file="orbit_convergence_by_specialization_data.txt", row.names=FALSE, col.names=TRUE, sep="\t", quote=FALSE)


##Run PGLS (ANOVA and ANCOVA) with nlme
#Posthoc  Tukey tests to compare group means with multcomp: https://cran.r-project.org/web/packages/multcomp/vignettes/multcomp-examples.pdf
spp<-pgls_df$species
corBM<-corBrownian(phy=tree_keep,form=~spp)
corPagel<-corPagel(1, phy=tree_keep,form=~spp)

print("size only, nlme BM:")
res_size<-gls(orbit_convergence_merged~size, data=pgls_df, correlation=corBM)
print(summary(res_size))
print("retinal specialization only, nlme BM:")
resBM<-gls(orbit_convergence_merged~retinal_structure, data=pgls_df, correlation=corBM)
summary(resBM)
post.hoc<-glht(resBM, linfct=mcp(retinal_structure="Tukey"))
summary(post.hoc)
print("retinal specialization only, nlme pagel model:")
resP<-gls(orbit_convergence_merged~retinal_structure, data=pgls_df, correlation=corPagel)
summary(resP)
print(resP)
post.hoc<-glht(resP, linfct=mcp(retinal_structure="Tukey"))
summary(post.hoc)
print("test if size and retinal structure are independent from each other (nlme)")
nlme_size_res<-gls(size~retinal_structure, data=pgls_df, correlation=corBM)
print(summary(nlme_size_res))
print("Orbit convergence by specialization, with size as a covariate, nlme BM:")
resBM_COVsize<-gls(orbit_convergence_merged~size+retinal_structure, data=pgls_df, correlation=corBM)
print(summary(resBM_COVsize))
post.hoc<-glht(resBM_COVsize, linfct=mcp(retinal_structure="Tukey"))
summary(post.hoc)
print("Orbit convergence by specialization, with size as a covariate, nlme pagel model:")
resP_COVsize<-gls(orbit_convergence_merged~size+retinal_structure, data=pgls_df, correlation=corPagel)
print(summary(resP_COVsize))
post.hoc<-glht(resP_COVsize, linfct=mcp(retinal_structure="Tukey"))
summary(post.hoc)

#Likelihood ratio test function from phytools blog: http://blog.phytools.org/2014/08/comparing-models-fit-using-gls-with.html
lrtest<-function(model1,model2){
        lik1<-logLik(model1)
        lik2<-logLik(model2)
        LR<--2*(lik1-lik2)
        degf<-attr(lik2,"df")-attr(lik1,"df")
        P<-pchisq(LR,df=degf,lower.tail=FALSE)
        cat(paste("Likelihood ratio = ",
                signif(LR,5),"(df=",degf,") P = ",
                signif(P,4),"\n",sep=""))
        invisible(list(likelihood.ratio=LR,p=P))
}
print("BM vs Pagel:")
lrtest(resBM, resP)
print("BM vs BM with size as covariate:")
lrtest(resBM, resBM_COVsize)
print("Pagel vs Pagel with size as covariate:")
lrtest(resP, resP_COVsize)
print("BM vs Pagel, both with size as covariate:")
lrtest(resBM_COVsize, resP_COVsize)

##Run phylANOVA with phytools phylANOVA (simulation based)
#See http://blog.phytools.org/2017/11/print-method-for-phylanova-phylogenetic.html
print("Orbit convergence by specialization, phylANOVA (simulation) version:")
anova_retina<-pgls_df$retinal_structure
names(anova_retina)<-pgls_df$species
anova_oc<-pgls_df$orbit_convergence_merged
names(anova_oc)<-pgls_df$species
res_phylANOVA<-phylANOVA(tree_keep, anova_retina, anova_oc, nsim=10000)
print(res_phylANOVA)

#Plot oc by retinal structure as violin plots
pdf("orbit_convergence_by_specialization.violins.trimmedPrimates.pdf")

p<-ggplot(pgls_df, aes(x=retinal_structure, y=orbit_convergence_merged)) + geom_violin() + geom_boxplot(width=0.1) + geom_jitter(shape=16, position=position_jitter(0.2))
p<-p + labs(title="Orbit convergence by retinal specialization", x="Retinal specialization", y="Orbit convergence (degrees)") + theme_minimal()
print(p)

#p<-ggplot(pgls_df, aes(x=retinal_structure, y=phylo_residualsBM)) + geom_violin() + geom_boxplot(width=0.1) + geom_jitter(shape=16, position=position_jitter(0.2))
#p<-p + labs(title="Orbit convergence residuals (BM phylo correction) by retinal specialization", x="Retinal specialization", y="Orbit convergence residuals (BM phylo corrected)") + theme_minimal()
#print(p)
#
#p<-ggplot(pgls_df, aes(x=retinal_structure, y=phylo_residualsP)) + geom_violin() + geom_boxplot(width=0.1) + geom_jitter(shape=16, position=position_jitter(0.2))
#p<-p + labs(title="Orbit convergence residuals (P phylo correction) by retinal specialization", x="Retinal specialization", y="Orbit convergence residuals (P phylo corrected)") + theme_minimal()
#print(p)

dev.off()

#OLD
#print("Orbit convergence by specialization, with size as a covariate (interaction term)")
#res<-pgls(orbit_convergence_merged~retinal_structure*size-1, data=comp.data)
#print(summary(res))
#plot(res)
#print("nlme version:")
#nlme_res<-gls(orbit_convergence_merged~size*retinal_structure-1, data=pgls_df, correlation=corBM)
#print(nlme_res)
#summary(nlme_res)
#post.hoc<-glht(nlme_res, linfct=mcp(retinal_structure="Tukey"))
#summary(post.hoc) 
