#!/bin/bash

#SBATCH -A m3018_g
#SBATCH -q regular
#SBATCH -J Castro
#SBATCH -o xrb_%j.out
#SBATCH -t 0:05:00
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --constraint=gpu
#SBATCH --gpus-per-task=1
#SBATCH --gpu-bind=none

export CASTRO_EXEC=./main3d.gnu.CUDA.ex
export INPUTS=inputs_benchmark

module load PrgEnv-gnu


# execute srun in the background then use the builtin wait so the shell can
# handle the signal
srun -n $((SLURM_NTASKS_PER_NODE * SLURM_NNODES)) ${CASTRO_EXEC} ${INPUTS}


