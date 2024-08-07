#PURPOSE: Make contingency table and run Fisher's exact test - NOT phylogenetically corrected, this is just for looking at the data


infile<-"horizontalstreakOnly_unobstructed_hz_mam241.noMissingData.txt"
print(paste("Making continegnecy table and running Fisher's exact test for", infile))

mydata<-read.table(infile)
print(dim(mydata))

both<-length(intersect(which(mydata$V2==1), which(mydata$V3==1)))
ret<-length(intersect(which(mydata$V2==1), which(mydata$V3==0)))
eco<-length(intersect(which(mydata$V2==0), which(mydata$V3==1)))
none<-length(intersect(which(mydata$V2==0), which(mydata$V3==0)))

cont_tab<-cbind(c(both,ret), c(eco,none))
colnames(cont_tab)<-c("specialization","no_specialization")
rownames(cont_tab)<-c("eco", "not_eco")
print(cont_tab)
fisher.test(cont_tab)
