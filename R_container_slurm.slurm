#!/bin/bash
#SBATCH --nodes=1 # Number of nodes requested. Please always request 1 node, unless you are using a protocol or software that takes advantages of distributing computing.
# This means MPI or Gnu parallel or Sparkcluster or Dask

#SBATCH --time=00:00:05 # The walltime requested. Here we are requesting only 5 seconds because the R script we are launching is not very computationally complex.
#SBATCH --qos=normal # This means that we are requesting for a quality of service of a walltime up to 24 hours. 
#For a walltime > 24 hours one will have to request "--qos=long" and to acess the memory partition, one will request "--qos=mem": https://curc.readthedocs.io/en/latest/running-jobs/job-resources.html

#SBATCH --partition=amilan # CPU partition, also known as the General purpose partition.

#SBATCH --ntasks=1 # Number of CPU cores requested. For this run, there is no parallelism at all so I am just requesting 1 core. I get 3.8G memory per core on a CPU partition: https://curc.readthedocs.io/en/latest/clusters/alpine/alpine-hardware.html#alpine-hardware

#SBATCH --account=amc-general # The account name for a CU Anschutz user on Alpine
#SBATCH --job-name=R_job # Name of the job, if I wish to monitor it or study its efficiency later on. 
#For more infor on job efficiency please refer to here -> https://curc.readthedocs.io/en/latest/compute/monitoring-resources.html

#SBATCH --output=Rjob.%j.out # Name of the file where all the benign outputs and logs related to the run will be redirected. %j is the variable that will capture the jobID
#SBATCH --error=Rjob.%j.err # Name of the file where all the errors related to the run will be redirected. 
#SBATCH --mail-user=foo@cuanschutz.edu # My email address where I wish to get all the notifications.
#SBATCH --mail-type=BEGIN,END,FAIL # I get the Slurm notification in my email inbox when it begins, ends and fails.


# /tmp filesystem is very small so we need to redirect tmp and cache related files to 
# the scratch filesystem.
export ALPINE_SCRATCH=/gpfs/alpine1/scratch/$USER
export APPTAINER_TMPDIR=$ALPINE_SCRATCH/apptainer/tmp
export APPTAINER_CACHEDIR=$ALPINE_SCRATCH/apptainer/cache
mkdir -pv $APPTAINER_CACHEDIR $APPTAINER_TMPDIR

# Current R version is 4.4.1. However, if you've used Rstudio legacy version 4.2.2, please feel free to use it here.
export r_app_version="4.4.1"

# Calling the Rstudio container to run my Rscript with Slurm
# The key here is to call the container image (.img) as a read-only (:ro). That is the major difference compared to when we were tryign to install the library dependencies 
# following this guide: https://github.com/kf-cuanschutz/CU-Anschutz-HPC-documentation/tree/main/Rstudio_related_scripts
#
apptainer exec --bind /projects,/scratch/alpine,$CURC_CONTAINER_DIR_OOD --fakeroot --overlay /projects/$USER/.rstudioserver/rstudio-${r_app_version}/rstudio-server-${r_app_version}_overlay.img:ro /curc/sw/containers/open_ondemand/rstudio-server-${r_app_version}.sif Rscript R_test.R
