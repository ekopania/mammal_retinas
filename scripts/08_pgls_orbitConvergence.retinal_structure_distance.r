#PURPOSE: Use pgls with size as a coviarate to test for associations between retinal specialization type and orbit convergence

#Some helpful relevant tutorials: 
#http://www.phytools.org/Cordoba2017/ex/4/PGLS.html
#http://blog.phytools.org/2022/12/post-hoc-tests-for-generalized.html
#https://cran.r-project.org/web/packages/caper/vignettes/caper.pdf
#https://cran.r-project.org/web/packages/caper/caper.pdf

library(nlme)
library(phytools)
library(ggplot2)

#Read in data
myTree<-read.tree("mam241.tre")
all_retina<-read.csv("mam241.pheno.quantitative.temporal_shift.csv")
elton<-read.csv("EltonTraits_mammals.csv")
gen_spec<-unlist(sapply(elton$Scientific, function(x) gsub(" ", "_", x)))
elton$gen_spec<-gen_spec

#PDF file for output plots
pdf("orbitConvergence_specializationDistance.pdf", onefile=TRUE, height=8.5, width=11)

#Get body size data from elton traits as log10 of body mass
size<-c()
for(i in all_retina$Data_Species){
	size<-c(size, log10(elton$BodyMass.Value[which(elton$gen_spec==i)]))
}

#Set up df for pgls
pgls_df<-as.data.frame(cbind(all_retina$orbit_convergence, all_retina$relative_distance, all_retina$temporal_shift, all_retina$specialization_angle, size, all_retina$Hub_Species))
rownames(pgls_df)<-all_retina$Hub_Species
colnames(pgls_df)<-c("orbit_convergence", "relative_distance", "temporal_shift", "specialization_angle", "body_mass", "species")
pgls_df$orbit_convergence<-as.numeric(pgls_df$orbit_converge)
pgls_df$relative_distance<-as.numeric(pgls_df$relative_distance)
pgls_df$temporal_shift<-as.numeric(pgls_df$temporal_shift)
pgls_df$specialization_angle<-as.numeric(pgls_df$specialization_angle)
pgls_df$body_mass<-as.numeric(pgls_df$body_mass)
print(pgls_df)

#Prune tree to only include species in analysis
tree_keep<-keep.tip(myTree, pgls_df$species)
print("TREE:")
print(tree_keep)

#Set up correlation strugure and run pgls
spp<-pgls_df$species
print(paste("Total number of species in analysis:", length(spp)))
corPagel<-corPagel(1, phy=tree_keep,form=~spp)

print("Orbit convergence vs relative distance, nlme Pagel:")
res_dist<-gls(relative_distance~orbit_convergence, data=pgls_df, correlation=corPagel)
print(summary(res_dist))

print("Orbit convergence vs relative TEMPORAL distance, nlme Pagel:")
res_temporal<-gls(temporal_shift~orbit_convergence, data=pgls_df, correlation=corPagel)
print(summary(res_temporal))

print("Orbit convergence vs relative distance, size as covariate, nlme Pagel:")
res_dist_size<-gls(relative_distance~orbit_convergence + body_mass, data=pgls_df, correlation=corPagel)
print(summary(res_dist_size))

print("Orbit convergence vs relative TEMPORAL distance, size as covariate, nlme Pagel:")
res_temporal_size<-gls(temporal_shift~orbit_convergence + body_mass, data=pgls_df, correlation=corPagel)
print(summary(res_temporal_size))

#Get predicted values based on pgls and use to setup phylogenetically corrected line for plot
print("Predicted temporal shifts for orbit convergence values of 0 and 90:")
print(predict(res_temporal, newdata=data.frame(orbit_convergence=c(0,90))))
oc_seq<-seq(0, 90, length.out=100)
predicted_temporal<-predict(res_temporal, newdata=data.frame(orbit_convergence=oc_seq))
pred_df<-data.frame(oc_seq, predicted_temporal)
print(head(pred_df))

#Plot
#pgls_df$phylo_corrected<-phylores
rd_p<-round(summary(res_dist)$tTable["orbit_convergence","p-value"], 4)
ts_p<-round(summary(res_temporal)$tTable["orbit_convergence","p-value"], 4)

p<-ggplot(pgls_df, aes(x=orbit_convergence, y=relative_distance, color=specialization_angle)) + geom_point(size=10) #color=specialization_angle in aes if coloring by angle
p<-p + labs(x="Orbit convergence angle", y="Specialization relative distance", title="Orbit convergence vs specialization relative distance", colour="Specialization angle")
#Add a color scale gradient based on angle of specialization placement
#p<-p + scale_colour_gradientn(colours = c("orange","gray50","purple4","gray50","orange"), values = c(0,0.25,0.5,0.75, 1), limits=c(0,360), labels=c(0, 90, 180, 270, 360))
p<-p + theme_minimal() + geom_text(x=75, y=0.75, label=paste("PGLS P =",rd_p)) + xlim(0,90)
p<-p + stat_smooth(method="glm", geom="smooth", se=FALSE, fullrange=TRUE)
print(p)

p<-ggplot(pgls_df, aes(x=orbit_convergence, y=temporal_shift, color=specialization_angle)) + geom_point(size=10) #color=specialization_angle in aes if coloring by angle
p<-p + labs(x="Orbit convergence angle", y="Specialization relative temporal distance", title="Orbit convergence vs specialization relative temporal distance", colour="Specialization angle")
#Add a color scale gradient based on angle of specialization placement
#p<-p + scale_colour_gradientn(colours = c("orange","gray50","purple4","gray50","orange"), values = c(0,0.25,0.5,0.75, 1), limits=c(0,360), labels=c(0, 90, 180, 270, 360))
p<-p + theme_minimal() + geom_text(x=75, y=0.75, label=paste("PGLS P =",ts_p)) + xlim(0,90)
p<-p + stat_smooth(method="glm", geom="smooth", se=FALSE, fullrange=TRUE)
p<-p + stat_smooth(method="glm", data=pred_df, aes(x=oc_seq, y=predicted_temporal), formula=y~x, geom="smooth", color="black", linetype="dashed", se=FALSE, fullrange=TRUE)
print(p)

#Plot species labels instead of points
plot(x=pgls_df$orbit_convergence, y=pgls_df$relative_distance, xlab="Orbit convergence angle", ylab="Specialization relative distance", main="Orbit convergence vs specialization relative distance", type="n")
text(x=pgls_df$orbit_convergence, y=pgls_df$relative_distance, pgls_df$species)
text(x=75, y=0.75, paste("PGLS P =",rd_p))
plot(x=pgls_df$orbit_convergence, y=pgls_df$temporal_shift, xlab="Orbit convergence angle", ylab="Specialization relative temporal distance", main="Orbit convergence vs specialization relative temporal distance", type="n")
text(x=pgls_df$orbit_convergence, y=pgls_df$temporal_shift, pgls_df$species)
text(x=75, y=0.75, paste("PGLS P =",ts_p))

#REPEAT WITHOUT MARINE (remove sea otter, walrus, elephant seal; leaving hippo for now)
pgls_df_nomarine<-pgls_df[-(which(pgls_df$species %in% c("Enhydra_lutris", "Odobenus_rosmarus", "Mirounga_angustirostris"))),]
tree_keep<-keep.tip(myTree, pgls_df$species)
print("TREE:")
print(tree_keep)

#Set up correlation strugure and run pgls
spp<-pgls_df_nomarine$species
corPagel<-corPagel(1, phy=tree_keep,form=~spp)

print("Orbit convergence vs relative distance, nlme Pagel, exclude marine species:")
res_dist<-gls(orbit_convergence~relative_distance, data=pgls_df_nomarine, correlation=corPagel)
print(summary(res_dist))

print("Orbit convergence vs relative TEMPORAL distance, nlme Pagel, exclude marine species:")
res_temporal<-gls(orbit_convergence~temporal_shift, data=pgls_df_nomarine, correlation=corPagel)
print(summary(res_temporal))
phylores<-residuals(res_temporal)

print("Orbit convergence vs relative distance, size as covariate, nlme Pagel, exclude marine species:")
res_dist<-gls(orbit_convergence~relative_distance + body_mass, data=pgls_df_nomarine, correlation=corPagel)
print(summary(res_dist))

print("Orbit convergence vs relative TEMPORAL distance, size as covariate, nlme Pagel, exclude marine species:")
res_temporal<-gls(orbit_convergence~temporal_shift + body_mass, data=pgls_df_nomarine, correlation=corPagel)
print(summary(res_temporal))

#Plot
rd_p<-round(summary(res_dist)$tTable["relative_distance","p-value"], 4)
ts_p<-round(summary(res_temporal)$tTable["temporal_shift","p-value"], 4)

p<-ggplot(pgls_df_nomarine, aes(x=orbit_convergence, y=relative_distance, color=specialization_angle)) + geom_point(size=10)
p<-p + labs(x="Orbit convergence angle", y="Specialization relative distance", title="Orbit convergence vs specialization relative distance - exclude marine species", colour="Specialization angle")
#Add a color scale gradient based on angle of specialization placement
#p<-p + scale_colour_gradientn(colours = c("orange","gray50","purple4","gray50","orange"), values = c(0,0.25,0.5,0.75, 1), limits=c(0,360), labels=c(0, 90, 180, 270, 360))
p<-p + theme_minimal() + geom_text(x=75, y=0.75, label=paste("PGLS P =",rd_p))
p<-p + stat_smooth(method="glm", geom="smooth")
print(p)

p<-ggplot(pgls_df_nomarine, aes(x=orbit_convergence, y=temporal_shift, color=specialization_angle)) + geom_point(size=4)
p<-p + labs(x="Orbit convergence angle", y="Specialization relative temporal distance", title="Orbit convergence vs specialization relative temporal distance - exclude marine species", colour="Specialization angle")
#Add a color scale gradient based on angle of specialization placement
p<-p + scale_colour_gradientn(colours = c("orange","gray50","purple4","gray50","orange"), values = c(0,0.25,0.5,0.75, 1), limits=c(0,360), labels=c(0, 90, 180, 270, 360))
p<-p + theme_minimal() + geom_text(x=75, y=0.75, label=paste("PGLS P =",ts_p))
print(p)

#Plot species labels instead of points
plot(x=pgls_df_nomarine$orbit_convergence, y=pgls_df_nomarine$relative_distance, xlab="Orbit convergence angle", ylab="Specialization relative distance", main="Orbit convergence vs specialization relative distance - exclude marine species", type="n")
text(x=pgls_df_nomarine$orbit_convergence, y=pgls_df_nomarine$relative_distance, pgls_df_nomarine$species)
text(x=75, y=0.75, paste("PGLS P =",rd_p))
plot(x=pgls_df_nomarine$orbit_convergence, y=pgls_df_nomarine$temporal_shift, xlab="Orbit convergence angle", ylab="Specialization relative temporal distance", main="Orbit convergence vs specialization relative temporal distance - exclude marine species", type="n")
text(x=pgls_df_nomarine$orbit_convergence, y=pgls_df_nomarine$temporal_shift, pgls_df_nomarine$species)
text(x=75, y=0.75, paste("PGLS P =",ts_p))

dev.off()

