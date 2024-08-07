3
1
#Res q12 q13 q24 q34 0 #Wynn did this to restrict directions of gene loss
#Trait 1 is retina; restrict transitions dependent on trait 1 value such that trait 2 has equal probability of 0->1 and 1->0 regardless of trait 1 value (i.e., we do not expect retina structure to select for ecological traits, only the other way around)
Res q12 q34
Res q21 q43
MLT 100
#Run
