#PURPOSE: Calculate temporal lateral distance of retinal specialization from center of retina

mydata<-read.csv("mam241.pheno.quantitative.lateral_distance.averages.csv", header=TRUE)

#Notes on trig functions:
	#Results are same if you normalize by radius before or after doing trig 
	#ImageJ outputs angle measurements in DEGREES but trig functions require RADIANS
	#radians = degrees * ( pi / 180.0 )
	#Trig functions will have negative output for angles between 90 and 270 (i.e., going "left"), but I want these to be positive (i.e., temporally shifted specializations are positive and nasal shifted is negative)

temporal_shift<-c()
for(i in 1:nrow(mydata)){
	angle<-mydata$specialization_angle[i]
	rel_dist<-mydata$relative_distance[i]
	ts<-(-cos(angle * pi/180))*rel_dist
	temporal_shift<-c(temporal_shift, ts)
}

newdata<-as.data.frame(cbind(mydata, temporal_shift))
write.csv(newdata, "mam241.pheno.quantitative.temporal_shift.csv", row.names=FALSE, quote=FALSE)
