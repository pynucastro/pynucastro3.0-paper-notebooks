#!/bin/bash
#SBATCH -A AST106
#SBATCH -J testing
#SBATCH -o scaling-%j.out
#SBATCH -t 00:15:00
#SBATCH -p batch
# here N is the number of compute nodes
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=7
#SBATCH --gpus-per-task=1
#SBATCH --gpu-bind=closest

EXEC=./main3d.hip.x86-trento.HIP.ex
INPUTS=inputs_benchmark

module load cpe
module load PrgEnv-gnu
module load cray-mpich
module load craype-accel-amd-gfx90a
module load rocm/7.2.0

export LD_LIBRARY_PATH=$CRAY_LD_LIBRARY_PATH:$LD_LIBRARY_PATH

export OMP_NUM_THREADS=1
export NMPI_PER_NODE=1
export TOTAL_NMPI=$(( ${SLURM_JOB_NUM_NODES} * ${NMPI_PER_NODE} ))

srun -n${TOTAL_NMPI} -N${SLURM_JOB_NUM_NODES} --ntasks-per-node=1 --gpus-per-task=1 $EXEC $INPUTS

