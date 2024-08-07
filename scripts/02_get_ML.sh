#!/bin/bash
#PURPOSE: Get maximum likelihoods from BayesTraits runs
#
#SBATCH --job-name=get_maximumLikelihoods
#SBATCH --output=get_maximumLikelihoods-%j.log
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

echo "Getting Maximum Likelihood values"
echo "Sample	Run	Independent	Dependent" > maximum_likelihoods.txt
#ls *mam241.noMissingData.independent.ML.?.Log.txt | while read file; do#
ls ac*predScore*_mam241.noMissingData.independent.ML.?.Log.txt h*G*_mam241.noMissingData.independent.ML.?.Log.txt h*_unobstructed_hz_mam241.noMissingData.independent.ML.?.Log.txt | while read file; do
#ls ac*predScore*_mam241.noMissingData.certainOnly.independent.ML.?.Log.txt h*G*_mam241.noMissingData.certainOnly.independent.ML.?.Log.txt h*_unobstructed_hz_mam241.noMissingData.certainOnly.independent.ML.?.Log.txt | while read file; do
#ls ac*predScore*_mam241.noMissingData.certainOnly.terrestrial.independent.ML.?.Log.txt h*G*_mam241.noMissingData.certainOnly.terrestrial.independent.ML.?.Log.txt h*_unobstructed_hz_mam241.noMissingData.certainOnly.terrestrial.independent.ML.?.Log.txt | while read file; do
#ls ac*predScore*_mam241.noMissingData.threshold.independent.ML.?.Log.txt h*G*_mam241.noMissingData.threshold.independent.ML.?.Log.txt h*_unobstructed_hz_mam241.noMissingData.threshold.independent.ML.?.Log.txt | while read file; do
#ls *_circular_*noMissingData.independent.ML.?.Log.txt *_subcircular_*noMissingData.independent.ML.?.Log.txt *_horizontal_*noMissingData.independent.ML.?.Log.txt *_vertical_*noMissingData.independent.ML.?.Log.txt *_u-shape_*noMissingData.independent.ML.?.Log.txt | while read file; do
	#file_start=$(echo "${file}" | cut -d "." -f 1)
	file_start=$(echo "${file}" | rev | cut -d "." -f 7- | rev)
	#samp=$(echo "${file}" | cut -d "_" -f 1-2)
	samp=$(echo "${file}" | rev | cut -d "_" -f 2- | rev)
	#run=$(echo "${file}" | cut -d "." -f 5)
	run=$(echo "${file}" | rev | cut -d "." -f 3 | rev)
	ind=$(tail -1 "${file}" | cut -f 2)
	#echo ${file_start} $samp $run $ind
	dep=$(tail -1 "${file_start}.noMissingData.dependent.ML.${run}.Log.txt" | cut -f 2)
	echo "${samp}	${run}	${ind}	${dep}" >> maximum_likelihoods.txt
done

echo "Calculating LRT result"
Rscript 03_LRT.r

echo "Done!"
