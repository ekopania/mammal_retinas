#!/bin/bash
#PURPOSE: Run Rscripts for phylogenetic analyses
#
#SBATCH --job-name=phylo_rscripts
#SBATCH --output=phylo_rscripts-%j.log
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cluster=htc
##SBATCH --partition=<partition>
##SBATCH --mail-user=emk270@pitt.edu
##SBATCH --mail-type=ALL
#SBATCH --time=1-00:00:00 #Time limit 1 day
#SBATCH --qos=normal
##SBATCH --mem-per-cpu=2G
#
## Command(s) to run:

#Comparisons to Elton Trait eco data
#Rscript 02a_phytools_threshBayes.r

#Comparisons to orbital convergence
#Rscript 02b_phytools_threshBayes.orbital_convergence.r

#Phylo logistic regression for continuous vs binary trait across phylo
#Rscript 03_pgls_logistic.r

#PGLS (ANOVA and ANCOVA) for testing association between orbit convergence and ecological conditions
#Rscript 06_pgls_orbitConvergence.all.r

#PGLS (ANOVA and ANCOVA) for testing association between orbit convergence and retinal specialization
Rscript 07_pgls_orbitConvergence.retinal_structure.r

echo "Done!"
