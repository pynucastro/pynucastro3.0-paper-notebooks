#!/bin/bash
#SBATCH -A AST106
#SBATCH -J testing
#SBATCH -o scaling-%j.out
#SBATCH -t 00:20:00
#SBATCH -p batch
# here N is the number of compute nodes
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=9

export OMP_NUM_THREADS=8

EXEC=./main3d.gnu.x86-trento.OMP.ex
INPUTS=inputs_benchmark

module load cpe
module load PrgEnv-gnu
module load cray-mpich
module load craype-accel-amd-gfx90a
module load rocm/6.3.1

export LD_LIBRARY_PATH=$CRAY_LD_LIBRARY_PATH:$LD_LIBRARY_PATH

export NMPI_PER_NODE=1
export TOTAL_NMPI=$(( ${SLURM_JOB_NUM_NODES} * ${NMPI_PER_NODE} ))

srun -n${TOTAL_NMPI} -N${SLURM_JOB_NUM_NODES} --ntasks-per-node=1 $EXEC $INPUTS

