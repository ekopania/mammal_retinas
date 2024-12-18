#!/bin/bash
#PURPOSE: Run BayesTraits
#
#SBATCH --job-name=BayesTraits
#SBATCH --output=BayesTraits-%j.log
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cluster=htc
##SBATCH --partition=<partition>
##SBATCH --mail-user=<user_ID>@pitt.edu
##SBATCH --mail-type=END,FAIL
#SBATCH --time=1-00:00:00 #Time limit 1 day
#SBATCH --qos=normal
##SBATCH --mem-per-cpu=2G
#
## Command(s) to run:

#NOTE: Tree cannot have bootstrap labels; run remove_bootstraps.r before running BayesTraits to remove!!!
btpath="/ihome/nclark/emk270/software/BayesTraitsV4.0.1-Linux/BayesTraitsV4"
tree="mam241_acOnly_predScore.70.nexus"
#Options: "mam241_acOnly_predScore.70_ForStrat.Value.MandAr.nexus" "mam241_acOnly_predScore.70.nexus"  "mam241_retinalStructure_ForStrat.Value.nexus" #mam241_hzOnly_ForStrat.Value.G_herbScore.70_BodyMass.Value.1e+05.nexus #mam241_retinalStructure_unobstructed_hz.nexus
rets=("acAny" "acOnly")
#Options: ("acAny" "acOnly") ("hzAny" "hzOnly")

#For foraging strategy traits
#eco_traits=("G" "M" "Ar" "A" "S")
#eco_traits=("G")
#tree="mam241_retinalStructure_ForStrat.Value.threshold.nexus"

#For specifically testing the grazer hypothesis (ground foraging, 100% plant diet)
eco_traits=("predScore.70")
#Options: "G_herbScore.70_BodyMass.Value.1e+05", "unobstructed_hz", "G", "predScore.70_ForStrat.Value.MandAr", "predScore.70"

ctl="dependent.ML.ctl" #dependent or independent
numit=3

for ret in ${rets[@]}; do
	for eco_trait in ${eco_traits[@]}; do
		dat="${ret}_${eco_trait}_mam241.noMissingData.txt"
		if [ ${tree} == "" ]; then
			tree="mam241_retinalStructure_${eco_trait}.nexus"
		fi

		echo "Running BayesTraits"
		echo "Tree file: ${tree}"
		echo "Data file: ${dat}"
		echo "Control file: ${ctl}"
		echo "Number of iterations: ${numit}"
		
		for (( i=1; i<=$numit; i++ )); do
			inname=$(echo "${dat}" | rev | cut -d "." -f 2- | rev)
			#ctltype=$(echo "${ctl}" | cut -d "." -f 1)
			ctltype=$(echo "${ctl}" | awk -F'.' '{for (i=1; i<NF; i++) printf("%s.", $i)}')
			outname=${inname}.${ctltype}${i}
			echo "${outname}"
			cat ${ctl} > temp.ctl
			echo "lf ${outname}" >> temp.ctl
			echo "Run" >> temp.ctl
			#BayesTraitsV3 ${tree} ${dat} < ${ctl}
			${btpath} ${tree} ${dat} < temp.ctl
			rm temp.ctl
		done
	done
done

echo "Done!"
