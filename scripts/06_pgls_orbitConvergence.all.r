#PURPOSE: Perform PGLS tests for orbital convergence associated with combinations of ecological traits

#SEE SCRIPT 7!!!
#May also need to test for multicorrelation among independent variables? https://cran.r-project.org/web/packages/car/car.pdf; also see Esteban's papers where they did this

library(caper)
library(nlme)
library(multcomp)
library(phytools)
library(ggplot2)

#Read in data
my.tree<-read.tree("mam241.tre")
#mydata<-read.csv("mam241.pheno.csv")
mydata<-read.csv("mam241.pheno.trimmedPrimates.csv")
elton<-read.csv("EltonTraits_mammals.csv")
gen_spec<-unlist(sapply(elton$Scientific, function(x) gsub(" ", "_", x)))
elton$gen_spec<-gen_spec

#Merge into one dataframe for caper formatting
oc<-c()
forstrat<-c()
activity<-c()
pred<-c()
herb<-c()
size<-c()
for(i in my.tree$tip.label){
	print(i)
	#Check if species is in ecological dataset
	eco_spec<-mydata$Data_Species[which(mydata$Hub_Species==i)]
	print(eco_spec)
	if(eco_spec %in% elton$gen_spec){
		#Orbit convergence; my measurements if we took them, otherwise literature data
		if(!(is.na(mydata$orbit_convergence_myMeasurement[which(mydata$Hub_Species==i)]))){
			if(mydata$orbit_convergence_myMeasurement[which(mydata$Hub_Species==i)] != ""){
				oc<-c(oc, mydata$orbit_convergence_myMeasurement[which(mydata$Hub_Species==i)])
			} else{
				oc<-c(oc, mydata$orbit_convergence[which(mydata$Hub_Species==i)])
			}
		} else{
			oc<-c(oc, mydata$orbit_convergence[which(mydata$Hub_Species==i)])
		}
		elton_line<-elton[which(elton$gen_spec == mydata$Data_Species[which(mydata$Hub_Species==i)]),]
		names(elton_line)<-colnames(elton)
		#print(elton_line)
		#Foraging strategy (arboreal, ground, marine, aerial, scansorial)
		if(elton_line$ForStrat.Certainty=="A"){
			if((elton_line$ForStrat.Value!="M") & (elton_line$ForStrat.Value!="A")){ #Remove marine and aerial species
				if(elton_line$ForStrat.Value=="S"){ #Combine scansorial with arboreal
					 forstrat<-c(forstrat, "Ar")
				} else{
					forstrat<-c(forstrat, elton_line$ForStrat.Value)
				}
			} else{
				forstrat<-c(forstrat, NA)
			}
		} else{
			forstrat<-c(forstrat, NA)
		}
		#Activity level; low power and doesn't make biological sense to consider all 7 possible combintations of nocturnal, crepuscular, diurnal
		#Grouping into dark (nocturnal only, nocturnal and crepuscular); light (diurnal only); complex (any other combination)
		if(elton_line$Activity.Certainty=="ABC"){
			if(elton_line$Activity.Nocturnal==1){
				if(elton_line$Activity.Crepuscular==1){
					if(elton_line$Activity.Diurnal==1){
						activity<-c(activity, "complex")
					} else{
						activity<-c(activity, "dark")
					}
				} else{
					if(elton_line$Activity.Diurnal==1){
	                                        activity<-c(activity, "complex")
					} else{
						activity<-c(activity, "dark")
					}
				}
			} else{
				if(elton_line$Activity.Crepuscular==1){
					if(elton_line$Activity.Diurnal==1){
						activity<-c(activity, "complex")
					} else{
						activity<-c(activity, "complex")
					}
				} else{
					if(elton_line$Activity.Diurnal==1){
						activity<-c(activity, "light")
					}
				}
			}
	        } else{
			activity<-c(activity, NA)
		}
		#Predator (>70% diet animal, not scavenger) or herbivore (>70% diet plant); need to have these as two separate binary trait because not enough variance within a third "omnivore" category to run pgls, and I don't have any specific hypotheses for omnivores
		if(elton_line$Diet.Certainty=="ABC"){
			predScore<-sum(elton_line[c("Diet.Inv","Diet.Vend","Diet.Vect","Diet.Vfish","Diet.Vunk")])
			herbScore<-sum(elton_line[c("Diet.Fruit", "Diet.Nect", "Diet.Seed", "Diet.PlantO")])
			if(predScore >= 70){
				pred<-c(pred, "yes")
			} else{
				pred<-c(pred, "no")
			}
			if(herbScore >= 70){
				herb<-c(herb, "yes")
			} else{
				herb<-c(herb, "no")
			}
		} else{
			pred<-c(pred, NA)
			herb<-c(herb, NA)
		}
		#Body mass - check for certain; take the log
		if(elton_line$BodyMass.SpecLevel == 1){
			size<-c(size, log10(elton_line$BodyMass.Value))
		}else{
			size<-c(size, NA)
		}
	} else{
		oc<-c(oc, NA)
		forstrat<-c(forstrat, NA)
		activity<-c(activity, NA)
		pred<-c(pred, NA)
		herb<-c(herb, NA)
		size<-c(size, NA)
	}
}

pgls_df<-as.data.frame(cbind(oc, forstrat, activity, pred, herb, size))
pgls_df$species<-my.tree$tip.label
pgls_df$oc<-as.numeric(pgls_df$oc)
pgls_df$size<-as.numeric(pgls_df$size)
pgls_df$forstrat<-as.factor(forstrat)
pgls_df$activity<-as.factor(activity)
pgls_df$pred<-as.factor(pred)
pgls_df$herb<-as.factor(herb)
print(pgls_df)
write.table(pgls_df, file="orbit_convergence.eco_traits.trimmedPrimates.txt", sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)

noctPred_keep<-Reduce(intersect, list(which(!(is.na(pgls_df$oc))), which(!(is.na(pgls_df$size))), which(!(is.na(pgls_df$pred))), which(!(is.na(pgls_df$act)))))
noctPred_df<-pgls_df[noctPred_keep,]

##Run PGLS (ANOVA and ANCOVA) with nlme
#Posthoc  Tukey tests to compare group means with multcomp: https://cran.r-project.org/web/packages/multcomp/vignettes/multcomp-examples.pdf
spp<-noctPred_df$species
corBM<-corBrownian(phy=my.tree,form=~spp)
corPagel<-corPagel(1, phy=my.tree,form=~spp)

print("size only, nlme BM:")
res_size_BM<-gls(oc~size, data=subset(noctPred_df, !(is.na(noctPred_df$size))), correlation=corBM)
print(summary(res_size_BM))
print("size only, nlme Pagel:")
res_size_P<-gls(oc~size, data=noctPred_df, correlation=corPagel)
print(summary(res_size_P))

print("Predator hypothesis, nlme BM:")
res_pred_BM<-gls(oc~pred, data=noctPred_df, correlation=corBM)
print(summary(res_pred_BM))
post.hoc<-glht(res_pred_BM, linfct=mcp(pred="Tukey"))
summary(post.hoc)
print("Predator hypothesis, nlme Pagel:")
res_pred_P<-gls(oc~pred, data=noctPred_df, correlation=corPagel)
print(summary(res_pred_P))
post.hoc<-glht(res_pred_P, linfct=mcp(pred="Tukey"))
summary(post.hoc)

print("Predator hypothesis, with size as covariate, nlme BM:")
res_predSize_BM<-gls(oc~size+pred, data=noctPred_df, correlation=corBM)
print(summary(res_predSize_BM))
post.hoc<-glht(res_predSize_BM, linfct=mcp(pred="Tukey"))
summary(post.hoc)
print("Predator hypothesis, with size as covariate, nlme Pagel:")
res_predSize_P<-gls(oc~size+pred, data=noctPred_df, correlation=corPagel)
print(summary(res_predSize_P))
post.hoc<-glht(res_predSize_P, linfct=mcp(pred="Tukey"))
summary(post.hoc)

print("Nocturnal hypothesis, nlme BM:")
res_act_BM<-gls(oc~activity, data=noctPred_df, correlation=corBM)
print(summary(res_act_BM))
post.hoc<-glht(res_act_BM, linfct=mcp(activity="Tukey"))
summary(post.hoc)
print("Nocturnal hypothesis, nlme Pagel:")
res_act_P<-gls(oc~activity, data=noctPred_df, correlation=corPagel)
print(summary(res_act_P))
post.hoc<-glht(res_act_P, linfct=mcp(activity="Tukey"))
summary(post.hoc)

print("Nocturnal hypothesis, with size as covariate, nlme BM:")
res_actSize_BM<-gls(oc~size+activity, data=noctPred_df, correlation=corBM)
print(summary(res_actSize_BM))
post.hoc<-glht(res_actSize_BM, linfct=mcp(activity="Tukey"))
summary(post.hoc)
print("Nocturnal hypothesis, with size as covariate, nlme Pagel:")
res_actSize_P<-gls(oc~size+activity, data=noctPred_df, correlation=corPagel)
print(summary(res_actSize_P))
post.hoc<-glht(res_actSize_P, linfct=mcp(activity="Tukey"))
summary(post.hoc)

print("Nocturnal predation hypothesis, nlme BM:")
res_predAct_BM<-gls(oc~pred+activity+pred:activity, data=noctPred_df, correlation=corBM)
print(summary(res_predAct_BM))
print("Nocturnal predation hypothesis, nlme Pagel:")
res_predAct_P<-gls(oc~pred+activity+pred:activity, data=noctPred_df, correlation=corPagel)
print(summary(res_predAct_P))

print("Nocturnal predation hypothesis, with size as covariate, nlme BM:")
res_predActSize_BM<-gls(oc~size+pred+activity+pred:activity, data=noctPred_df, correlation=corBM)
print(summary(res_predActSize_BM))
print("Nocturnal predation hypothesis, with size as covariate, nlme Pagel:")
res_predActSize_P<-gls(oc~size+pred+activity+pred:activity, data=noctPred_df, correlation=corPagel)
print(summary(res_predActSize_P))

smallHerb_keep<-Reduce(intersect, list(which(!(is.na(pgls_df$oc))), which(!(is.na(pgls_df$size))), which(!(is.na(pgls_df$herb))), which(!(is.na(pgls_df$forstrat)))))
smallHerb_df<-pgls_df[smallHerb_keep,]

##Run PGLS (ANOVA and ANCOVA) with nlme
#Posthoc  Tukey tests to compare group means with multcomp: https://cran.r-project.org/web/packages/multcomp/vignettes/multcomp-examples.pdf
spp<-smallHerb_df$species
corBM<-corBrownian(phy=my.tree,form=~spp)
corPagel<-corPagel(1, phy=my.tree,form=~spp)

print("Arboreal hypothesis, nlme BM:")
res_arb_BM<-gls(oc~forstrat, data=smallHerb_df, correlation=corBM)
print(summary(res_arb_BM))
post.hoc<-glht(res_arb_BM, linfct=mcp(forstrat="Tukey"))
summary(post.hoc)
print("Arboreal hypothesis, nlme Pagel:")
res_arb_P<-gls(oc~forstrat, data=smallHerb_df, correlation=corPagel)
print(summary(res_arb_P))
post.hoc<-glht(res_arb_P, linfct=mcp(forstrat="Tukey"))
summary(post.hoc)

print("Arboreal hypothesis, with size as covariate, nlme BM:")
res_arbSize_BM<-gls(oc~size+forstrat, data=smallHerb_df, correlation=corBM)
print(summary(res_arbSize_BM))
post.hoc<-glht(res_arbSize_BM, linfct=mcp(forstrat="Tukey"))
summary(post.hoc)
print("Arboreal hypothesis, with size as covariate, nlme Pagel:")
res_arbSize_P<-gls(oc~size+forstrat, data=smallHerb_df, correlation=corPagel)
print(summary(res_arbSize_P))
post.hoc<-glht(res_arbSize_P, linfct=mcp(forstrat="Tukey"))
summary(post.hoc)

print("Herbivore hypothesis, no interaction, nlme BM:")
res_herb_BM<-gls(oc~herb, data=smallHerb_df, correlation=corBM)
print(summary(res_herb_BM))
print("Herbivore hypothesis, no interaction, nlme Pagel:")
res_herb_P<-gls(oc~herb, data=smallHerb_df, correlation=corPagel)
print(summary(res_herb_P))

print("Herbivore hypothesis, with size as covariate, no interaction, nlme BM:")
res_herbSize_BM<-gls(oc~size+herb, data=smallHerb_df, correlation=corBM)
print(summary(res_herbSize_BM))
print("Herbivore hypothesis, with size as covariate, no interaction, nlme Pagel:")
res_herbSize_P<-gls(oc~size+herb, data=smallHerb_df, correlation=corPagel)
print(summary(res_herbSize_P))

print("Small herbivore (prey) hypothesis, no interaction, nlme BM:")
res_preySize_BM<-gls(oc~size+forstrat+herb, data=smallHerb_df, correlation=corBM)
print(summary(res_preySize_BM))
print("Small herbivore (prey) hypothesis, no interaction, nlme Pagel:")
res_preySize_P<-gls(oc~size+forstrat+herb, data=smallHerb_df, correlation=corPagel)
print(summary(res_preySize_P))

print("Small herbivore (prey) hypothesis, with forstrat:herb interaction, nlme BM:")
res_forstratHerbIntxn_BM<-gls(oc~size+forstrat+herb+forstrat:herb, data=smallHerb_df, correlation=corBM)
print(summary(res_forstratHerbIntxn_BM))
print("Small herbivore (prey) hypothesis, with forstrat:herb interaction, nlme Pagel:")
res_forstratHerbIntxn_P<-gls(oc~size+forstrat+herb+forstrat:herb, data=smallHerb_df, correlation=corPagel)
print(summary(res_forstratHerbIntxn_P))

print("Small herbivore (prey) hypothesis, with size:herb interaction, nlme BM:")
res_sizeHerbIntxn_BM<-gls(oc~size+forstrat+herb+size:herb, data=smallHerb_df, correlation=corBM)
print(summary(res_sizeHerbIntxn_BM))
print("Small herbivore (prey) hypothesis, with interaction, nlme Pagel:")
res_sizeHerbIntxn_P<-gls(oc~size+forstrat+herb+size:herb, data=smallHerb_df, correlation=corPagel)
print(summary(res_sizeHerbIntxn_P))

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

print("BM vs Pagel")
BMfits<-c("res_size_BM", "res_pred_BM", "res_predSize_BM", "res_act_BM", "res_actSize_BM", "res_predAct_BM", "res_predActSize_BM", "res_arb_BM", "res_arbSize_BM", "res_herb_BM", "res_herbSize_BM", "res_preySize_BM", "res_forstratHerbIntxn_BM", "res_sizeHerbIntxn_BM")
Pagelfits<-c("res_size_P", "res_pred_P", "res_predSize_P", "res_act_P", "res_actSize_P", "res_predAct_P", "res_predActSize_P", "res_arb_P", "res_arbSize_P", "res_herb_P", "res_herbSize_P", "res_preySize_P", "res_forstratHerbIntxn_P", "res_sizeHerbIntxn_P")
for(i in 1:length(BMfits)){
	print(paste(BMfits[i], "vs", Pagelfits[i]))
	lrtest(get(BMfits[i]), get(Pagelfits[i]))
}
print("Compare BM models, nocturnal predation:")
print("Size only vs predation w/ size as covariate:")
lrtest(res_size_BM, res_predSize_BM)
print("Predation only vs predation w/ size as covariate:")
lrtest(res_pred_BM, res_predSize_BM)
print("Size only vs activity pattern w/ size as covariate:")
lrtest(res_size_BM, res_actSize_BM)
print("Activity patterns only vs activity pattern w/ size as covariate:")
lrtest(res_act_BM, res_actSize_BM)
print("Predation only vs predation and activity pattern:")
lrtest(res_pred_BM, res_predAct_BM)
print("Activity only vs predation and activity pattern:")
lrtest(res_act_BM, res_predAct_BM)
print("Predation w/ size as covariate vs predation and activity pattern w/ size as covariate:")
lrtest(res_predSize_BM, res_predActSize_BM)
print("Activity w/ size as covariate vs predation and activity pattern w/ size as covariate:")
lrtest(res_actSize_BM, res_predActSize_BM)
print("Compare Pagel models, nocturnal predation:")
print("Size only vs predation w/ size as covariate:")
lrtest(res_size_P, res_predSize_P)
print("Predation only vs predation w/ size as covariate:")
lrtest(res_pred_P, res_predSize_P)
print("Size only vs activity pattern w/ size as covariate:")
lrtest(res_size_P, res_actSize_P)
print("Activity patterns only vs activity pattern w/ size as covariate:")
lrtest(res_act_P, res_actSize_P)
print("Predation only vs predation and activity pattern:")
lrtest(res_pred_P, res_predAct_P)
print("Activity only vs predation and activity pattern:")
lrtest(res_act_P, res_predAct_P)
print("Predation w/ size as covariate vs predation and activity pattern w/ size as covariate:")
lrtest(res_predSize_P, res_predActSize_P)
print("Activity w/ size as covariate vs predation and activity pattern w/ size as covariate:")
lrtest(res_actSize_P, res_predActSize_P)
print("Compare BM models, arboreal and small herbivores:")
print("Size only vs foraging strategy w/ size as covariate:")
lrtest(res_size_BM, res_arbSize_BM)
print("Foraging strategy only vs foraging strategy w/ size as covariate:")
lrtest(res_arb_BM, res_arbSize_BM)
print("Herbivory only vs herbivory w/ size as covariate:")
lrtest(res_herb_BM, res_herbSize_BM)
print("Foraging strategy only vs herbivory and foraging strategy w/ size as covariate:")
lrtest(res_arbSize_BM, res_preySize_BM)
print("herbivory and foraging strategy w/ size as covariate vs interaction between foraging strat and herb:")
lrtest(res_preySize_BM, res_forstratHerbIntxn_BM)
print("herbivory and foraging strategy w/ size as covariate vs interaction between size and herb:")
lrtest(res_preySize_BM, res_sizeHerbIntxn_BM)
print("Compare Pagel models, arboreal and small herbivores:")
print("Size only vs foraging strategy w/ size as covariate:")
lrtest(res_size_P, res_arbSize_P)
print("Foraging strategy only vs foraging strategy w/ size as covariate:")
lrtest(res_arb_P, res_arbSize_P)
print("Herbivory only vs herbivory w/ size as covariate:")
lrtest(res_herb_P, res_herbSize_P)
print("Foraging strategy only vs herbivory and foraging strategy w/ size as covariate:")
lrtest(res_arbSize_P, res_preySize_P)
print("herbivory and foraging strategy w/ size as covariate vs interaction between foraging strat and herb:")
lrtest(res_preySize_P, res_forstratHerbIntxn_P)
print("herbivory and foraging strategy w/ size as covariate vs interaction between size and herb:")
lrtest(res_preySize_P, res_sizeHerbIntxn_P)

#Plot oc by each variable separate (boxplots)
pdf("orbit_convergence_by_eco.boxplots.trimmedPrimates.pdf", onefile=TRUE)

pgls_df_size<-pgls_df[intersect(which(!(is.na(pgls_df$size))), which(!(is.na(pgls_df$oc)))), ]
p<-ggplot(pgls_df_size, aes(x=size, y=oc)) + geom_point() + geom_smooth(method="lm")
p<-p + labs(title="Orbit convergency by body mass", x="log10(Body mass (g))", y="Orbit convergence (degrees)") + theme_minimal()
print(p)

p<-ggplot(subset(pgls_df, !(is.na(activity))), aes(x=activity, y=oc)) + geom_violin() + geom_boxplot(width=0.1) + geom_jitter(shape=16, position=position_jitter(0.2))
p<-p + labs(title="Orbit convergency by activity pattern", x="Activity pattern", y="Orbit convergence (degrees)") + theme_minimal()
print(p)

p<-ggplot(subset(pgls_df, !(is.na(pred))), aes(x=pred, y=oc)) + geom_violin() + geom_boxplot(width=0.1) + geom_jitter(shape=16, position=position_jitter(0.2))
p<-p + labs(title="Orbit convergency by predation", x="Predation", y="Orbit convergence (degrees)") + theme_minimal()
print(p)

p<-ggplot(subset(pgls_df, !(is.na(forstrat))), aes(x=forstrat, y=oc)) + geom_violin() + geom_boxplot(width=0.1) + geom_jitter(shape=16, position=position_jitter(0.2))
p<-p + labs(title="Orbit convergency by foraging strategy", x="Foraging strategy", y="Orbit convergence (degrees)") + theme_minimal()
print(p)

p<-ggplot(subset(pgls_df, !(is.na(herb))), aes(x=herb, y=oc)) + geom_violin() + geom_boxplot(width=0.1) + geom_jitter(shape=16, position=position_jitter(0.2))
p<-p + labs(title="Orbit convergency by herbivory", x="Herbivory", y="Orbit convergence (degrees)") + theme_minimal()
print(p)

dev.off()
