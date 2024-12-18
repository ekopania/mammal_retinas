#PURPOSE: Calculate Bayes Factors from maximum likelihoods

degf<-2

myData<-read.table("maximum_likelihoods.txt", header=TRUE)

LRT<-2*(myData$Dependent - myData$Independent)
pval<-pchisq(LRT, df=degf, lower.tail=FALSE)
corp<-p.adjust(pval, method="BH")

newData<-as.data.frame(cbind(myData, LRT, pval, corp))
colnames(newData)<-c("Sample", "Run",	"Independent", "Dependent", "LRT", paste0("raw_P_df",degf), "BH_p")

write.table(newData, file="LRTs_output.txt", sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)

