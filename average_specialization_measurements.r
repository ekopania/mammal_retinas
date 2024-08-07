#PURPOSE: Average specialization measurements for species that have multiple retinal topo maps available

#Functions for getting average angle; copied from this website:
#https://rosettacode.org/wiki/Averages/Mean_angle#R

deg2rad<-function(x){x*pi/180}
rad2deg<-function(x){x*180/pi}
deg2vec<-function(x){c(sin(deg2rad(x)), cos(deg2rad(x)))}

vec2deg<-function(x){
	res<-rad2deg(atan2(x[1], x[2]))
	if(res < 0){
		360 + res
	} else {
		res
	}
}

mean_vec<-function(x){
	y<-lapply(x, deg2vec)
	Reduce(`+`, y)/length(y)
}

mean_deg<-function(x){
	vec2deg(mean_vec(x))
}

#Read in retinal specialization measurements
ret_data<-read.csv("mam241.pheno.quantitative.lateral_distance.csv", header=TRUE)

#Loop through all data
avg_data<-c()
species<-c()
for(i in 1:nrow(ret_data)){
	#Check if we've already done this species
	if(ret_data$Common_Name[i] %in% species){
		next
	#Remove species that do not have orbit convergence data
	} else if(is.na(ret_data$orbit_convergence[i])){
		next
	#New species - get averages
	} else{
		sp<-ret_data[which(ret_data$Common_Name==ret_data$Common_Name[i]),]
		print(paste("Getting average for", nrow(sp), ret_data$Common_Name[i], "samples"))
		print(sp$orbit_convergence)
		print(is.na(ret_data$orbit_convergence[i]))
		maxRGC<-mean(sp$max_RGC, na.rm=TRUE)
		spec_dist<-mean(sp$specialization_distance, na.rm=TRUE)
		diam<-mean(sp$diameter, na.rm=TRUE)
		rad<-mean(sp$radius, na.rm=TRUE)
		#NOTE: Taking mean angle will change the value for some species that only have one sample
		#Do not be alarmed
		#It is just making it positive (e.g., -155.3 becomes 204.7 for Ovis aries)
		#They are the same thing in a 360 circle and will give the same cos values
		angle<-mean_deg(sp$specialization_angle)
		rel_dist<-mean(sp$relative_distance)
		oc<-mean(sp$orbit_convergence)
		#Sanity check
		print("Relative distance avg and (avg distance/avg radius); these should be roughly the same:")
		print(rel_dist)
		print(spec_dist/rad)
		#Append
		newrow<-c(ret_data$Species[i], ret_data$Hub_Species[i], ret_data$Data_Species[i], ret_data$Common_Name[i], ret_data$retinal_structure[i], maxRGC, spec_dist, diam, rad, angle, rel_dist, oc)
		avg_data<-rbind(avg_data, newrow)
		species<-c(species, ret_data$Common_Name[i])
	}
}

colnames(avg_data)<-c("Species", "Hub_Species", "Data_Species", "Common_Name", "retinal_structure", "max_RGC", "specialization_distance", "diameter", "radius", "specialization_angle", "relative_distance", "orbit_convergence")
print(avg_data)
write.csv(avg_data, file="mam241.pheno.quantitative.lateral_distance.averages.csv", quote=FALSE, row.names=FALSE)
