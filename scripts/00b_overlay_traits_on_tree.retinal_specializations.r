library(phytools)

#Function to plot traits on circular tree
#From phytools blog http://blog.phytools.org/2024/03/a-function-to-graph-discrete-and.html
plotFanTree.wTraits<-function(tree,X,type=c("arc","fan"), ...){
  X<-if(is.vector(X)) as.matrix(X[tree$tip.label]) else X[tree$tip.label,]
  h<-max(nodeHeights(tree))
  d<-min(ncol(X)*0.07*h,h)
  type<-type[1]
  if(!(type%in%c("arc","fan"))) type<-"fan"
  ftype<-if(hasArg(ftype)) list(...)$ftype else "i"
  fsize<-if(hasArg(fsize)) list(...)$fsize else 0.5
  part<-if(hasArg(part)) list(...)$part else 0.99
  arc_height<-if(hasArg(arc_height)) list(...)$arc_height else 0.7
  lwd<-if(hasArg(lwd)) list(...)$lwd else 4
  if(length(lwd)<ncol(X)) lwd<-rep(lwd,ncol(X))
  if(hasArg(colors)) colors<-list(...)$colors
  else {
    colors<-list()
    for(i in 1:ncol(X)){
      if(is.numeric(X[,i])){
        colors[[i]]<-setNames(hcl.colors(n=100),1:100)
      } else {
        if(!is.factor(X[,i])) X[,i]<-as.factor(X[,i])
        colors[[i]]<-setNames(
          palette.colors(n=length(levels(X[,i]))),
          levels(X[,i]))
      }
    }
  }
  tt<-tree
  tt$edge.length[which(tt$edge[,2]<=Ntip(tt))]<-tt$edge.length[which(tt$edge[,2]<=Ntip(tt))]+d
  plotTree(tt, type=type, ftype=ftype, fsize=fsize, part=part, color="transparent", arc_height=arc_height*h/max(nodeHeights(tt)))
  pp<-get("last_plot.phylo",envir=.PlotPhyloEnv)
  plotTree(tree, type=type, ftype="off", part=part, lwd=1, add=TRUE, xlim=pp$x.lim, ylim=pp$y.lim, arc_height=arc_height,ftype="off")
  pp<-get("last_plot.phylo",envir=.PlotPhyloEnv)
  par(lend=3)
  for(i in 1:ncol(X)){
    if(is.numeric(X[,i])){
      x_seq<-seq(min(X[,i]),max(X[,i]),length.out=100)
      x_ind<-sapply(X[,i], function(x,y) which.min((x-y)^2), y=x_seq)
      colors[[i]]<-colorRampPalette(colors[[i]])(n=100)
      cols<-colors[[i]][x_ind]
    } else {
      cols<-colors[[i]][X[tree$tip.label,i]]  
    }
    for(j in 1:Ntip(tree)){
      start<-if(pp$xx[j]>0) 
        (i-1)*(d/ncol(X))+(2/7)*(d/ncol(X)) else 
          -((i-1)*(d/ncol(X))+(2/7)*(d/ncol(X)))
      end<-if(pp$xx[j]>0) i*d/ncol(X) else -i*d/ncol(X)
      th<-atan(pp$yy[j]/pp$xx[j])
      segments(pp$xx[j]+start*cos(th),
        pp$yy[j]+start*sin(th),
        pp$xx[j]+end*cos(th),
        pp$yy[j]+end*sin(th),
        lwd=lwd[i],
        col=cols[j])
    }
  }
  invisible(colors)
}

#Read in data
my.tree0<-read.tree("mam241.tre")
mydata0<-read.csv("mam241.pheno.csv")

#Get species present in tree, eye data file, eco trait data file
my.species0<-mydata0$Hub_Species
my.species.data<-unlist(sapply(mydata0$Data_Species, function(x) gsub("_"," ",x)))
my.species.space<-unlist(sapply(my.species0, function(x) gsub("_"," ",x)))
head(my.species0)

inall<-intersect(my.species0,my.tree0$tip.label)
just.retinal<-mydata0[,c("retinal_structure","certainty")]
rownames(just.retinal)<-my.species0
nomissing<-just.retinal[which(just.retinal$retinal_structure!=""),]
keep<-Reduce(intersect, list(inall, rownames(nomissing)))
rm_spec<-my.tree0$tip.label[my.tree0$tip.label %in% keep == FALSE]
my.tree<-drop.tip(my.tree0, rm_spec)
#Make ultrumatric cladogram for better visualization
#my.tree<-force.ultrametric(my.tree)
#print(my.tree)

mydata<-mydata0[which(my.species0 %in% keep),]
dim(mydata)
head(mydata)

#Separate each retinal specialization
#fovea<-unlist(sapply(mydata$retinal_structure, function(x) if(grepl("fovea",x)){"f"}else{"nf"}))
ac<-unlist(sapply(mydata$retinal_structure, function(x) if(is.null(x)){NA}else if(grepl("area centralis",x)){"area centralis"}else{"no area centralis"}))
hs<-unlist(sapply(mydata$retinal_structure, function(x) if(is.null(x)){NA}else if(grepl("horizontal streak",x)){"horizontal streak"}else{"no horizontal streak"}))
#aa<-unlist(sapply(mydata$retinal_structure, function(x) if(grepl("anakatabatic area",x)){"aa"}else{"naa"}))

#Make tables and vectors for plotting
phenos<-as.data.frame(cbind(ac, hs)) #fovea, aa
dim(phenos)
my.species<-mydata$Hub_Species
rownames(phenos)<-my.species
colnames(phenos)<-c("area centralis", "horizontal streak") #"fovea", "anakatabatic area"
print(phenos)

#Plot
pdf("mammal_eyes_tree.specializationsSeparate.circle.pdf", width=20, height=20, useDingbats=FALSE)
#plotFanTree.wTraits(my.tree, phenos, lwd=10)
colors<-list(setNames(c("#332288","gray90"),c("area centralis","no area centralis")), setNames(c("#D55E00","gray90"),c("horizontal streak","no horizontal streak")))
plotFanTree.wTraits(my.tree, phenos, lwd=25, colors=colors, fsize=1.5)
legend(x=0,y=0.4*max(nodeHeights(my.tree)), names(colors[[1]]), lwd=8, col=colors[[1]], title="area centralis", bty="n", xjust=0.5, yjust=0.5, cex=1.5)
legend(x=0,y=0.05*max(nodeHeights(my.tree)), names(colors[[2]]), lwd=8, col=colors[[2]], title="horizontal streak", bty="n", xjust=0.5, yjust=0.5, cex=1.5)
dev.off()

#Add eco data
elton<-read.csv("EltonTraits_mammals.subset.csv")
#Get Elton eco traits for species we got retinal data from
keep_elton<-mydata$Elton_Species[which(mydata$Hub_Species %in% keep)]
elton.subset<-elton[which(elton$gen_spec %in% keep_elton),]
print(dim(elton.subset))
elton.sort<-elton.subset[match(mydata$Elton_Species, elton.subset$gen_spec),]
print((elton.sort))

#Combine predation categories for one predation score (% of diet)
predCols<-elton.sort[,c("Diet.Inv","Diet.Vend","Diet.Vect","Diet.Vfish","Diet.Vunk")]
dim(predCols)
head(predCols)
predScore<-rowSums(predCols)
predBin<-c()
for(i in 1:nrow(elton.sort)){
        #Only include eco data with high certainty (NOT inferred from closely related species)
	#if(grepl("A", elton.sort$Diet.Certainty[i])){
                if(predScore[i] >= 70){
                        predBin<-c(predBin, "predator")
                } else{
                        predBin<-c(predBin, "not predator")
                }
        #} else{
                #predBin<-c(predBin, NA)
        #}
}
elton.sort$predScore<-predScore
elton.sort$predBin<-predBin

#Make separate plots/trees focusing on area centralis and predator hypotheses
phenos.ac_predator<-cbind(ac, elton.sort$predBin)
rownames(phenos.ac_predator)<-my.species
colnames(phenos.ac_predator)<-c("area_centralis", "predator")

#Plot
pdf("mammal_eyes_tree.specializationsSeparate.ac_predator.circle.pdf", width=20, height=20, useDingbats=FALSE)
#Using colors from Tol pallette (colorblind friendly) https://davidmathlogic.com/colorblind/
colors<-list(setNames(c("#332288","gray90"),c("area centralis","no area centralis")), setNames(c("black","gray90"),c("predator","not predator")))
plotFanTree.wTraits(my.tree, phenos.ac_predator, lwd=25, colors=colors, fsize=1.5)
legend(x=0,y=0.4*max(nodeHeights(my.tree)), names(colors[[1]]), lwd=8, col=colors[[1]], title="area centralis", bty="n", xjust=0.5, yjust=0.5, cex=1.5)
legend(x=0,y=0.05*max(nodeHeights(my.tree)), names(colors[[2]]), lwd=8, col=colors[[2]], title="predation", bty="n", xjust=0.5, yjust=0.5, cex=1.5)
dev.off()

#Make separate plots/trees focusing on horizontal streak and ground forager hypotheses
phenos.hs_ground<-cbind(hs, elton.sort$ForStrat.Value)
rownames(phenos.hs_ground)<-my.species
colnames(phenos.hs_ground)<-c("horizontal_streak", "ForStrat.Value")

#Plot
pdf("mammal_eyes_tree.specializationsSeparate.hs_ground.circle.pdf", width=20, height=20, useDingbats=FALSE)
#Using colors from Wong pallette (colorblind friendly) https://davidmathlogic.com/colorblind/
colors<-list(setNames(c("#D55E00","gray90"),c("horizontal streak","no horizontal streak")), setNames(c("#CC79A7", "#0072B2", "#009E73", "#56B4E9", "#F0E442","black"), c("G", "M", "Ar", "A", "S", "F")))
foraging.traits.fullname<-c("ground","marine","arboreal","aerial","scansorial","fossorial")
plotFanTree.wTraits(my.tree, phenos.hs_ground, lwd=25, colors=colors, fsize=1.5)
legend(x=0,y=0.4*max(nodeHeights(my.tree)), names(colors[[1]]), lwd=8, col=colors[[1]], title="horizontal streak", bty="n", xjust=0.5, yjust=0.5, cex=1.5)
legend(x=0,y=0.01*max(nodeHeights(my.tree)), foraging.traits.fullname, lwd=8, col=colors[[2]], title="foraging strategy", bty="n", xjust=0.5, yjust=0.5, cex=1.5)
dev.off()

#Make a tree with all four - area centralis, horizontal streak, predation, foraging strategy
print(length(ac))
print(length(hs))
print(length(elton.sort$predBin))
print(length(elton.sort$ForStrat.Value))
phenos.all<-cbind(ac, hs, elton.sort$predBin, elton.sort$ForStrat.Value)
rownames(phenos.all)<-my.species
colnames(phenos.all)<-c("area_centralis", "horizontal_streak", "predator", "ForStrat.Value")
print(head(phenos.all))

#Plot
pdf("mammal_eyes_tree.specializationsSeparate.all.circle.pdf",  width=20, height=20, useDingbats=FALSE)
colors<-list(setNames(c("#332288","gray90"),c("area centralis","no area centralis")), setNames(c("#D55E00","gray90"),c("horizontal streak","no horizontal streak")), setNames(c("black","gray90"),c("predator","not predator")), setNames(c("#CC79A7", "#0072B2", "#009E73", "#56B4E9", "#F0E442","black"), c("G", "M", "Ar", "A", "S", "F")))
plotFanTree.wTraits(my.tree, phenos.all, lwd=25, colors=colors, fsize=1.5)
legend(x=0,y=0.4*max(nodeHeights(my.tree)), names(colors[[1]]), lwd=8, col=colors[[1]], title="area centralis", bty="n", xjust=0.5, yjust=0.5, cex=1.5)
legend(x=0,y=0.2*max(nodeHeights(my.tree)), names(colors[[2]]), lwd=8, col=colors[[2]], title="horizontal streak", bty="n", xjust=0.5, yjust=0.5, cex=1.5)
legend(x=0,y=0.05*max(nodeHeights(my.tree)), names(colors[[3]]), lwd=8, col=colors[[3]], title="predation", bty="n", xjust=0.5, yjust=0.5, cex=1.5)
legend(x=0,y=0.01*max(nodeHeights(my.tree)), foraging.traits.fullname, lwd=8, col=colors[[4]], title="foraging strategy", bty="n", xjust=0.5, yjust=0.5, cex=1.5)
dev.off()

#Plot as a vertical tree, not circle - Used in Figure 3 of the paper
pdf("mammal_eyes_tree.specializationsSeparate.all.pdf", width=20, height=20, useDingbats=FALSE)
all.traits<-c("area centralis","no area centralis", "horizontal streak","no horizontal streak", "predator","not predator", "G", "M", "Ar", "A", "S", "F")
all.colors<-c("#907CF7","gray90", "#D55E00","gray90", "black","gray90", "#CC79A7", "#0072B2", "#009E73", "#56B4E9", "#F0E442","black")
dotTree(my.tree, phenos.all, colors=setNames(all.colors, all.traits), fsize=1, ftype="i", legend=FALSE, length=1, labels=TRUE)
#add.simmap.legend(colors=setNames("white","missing data"), prompt=FALSE, shape="rectangle", x=0.99*par()$usr[1],y=0.9*par()$usr[4]) #Missing data
add.simmap.legend(colors=colors[[1]], prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.85*par()$usr[4]) #Retinal structures
add.simmap.legend(colors=colors[[2]], prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.5*par()$usr[4])
add.simmap.legend(colors=colors[[3]], prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.3*par()$usr[4])
add.simmap.legend(colors=colors[[4]], prompt=FALSE, shape="circle", x=0.99*par()$usr[1],y=0.2*par()$usr[4])
dev.off()
