# GPU vs. CPU performance

To measure GPU performance, we run on OLCF Frontier and NERSC
Perlmutter using Microphysics `test_react`, the `inputs_benchmark`
inputs file and the `ase` network.

We do a 32^3 and 64^3 box, and on Frontier we also run on CPU (with 8
OpenMP threads).

The directories here contain the submission scripts.

## Frontier

On Frontier, we use ROCm 7.2 -- it gives much better performance thant ROCm 6.3.

### GPU

We build as:

```
make USE_HIP=TRUE NETWORK_DIR=ase -j 4 USE_JACOBIAN_CACHING=TRUE
```

Note that Jacobian caching is enabled.

### CPU

We build as:

```
make NETWORK_DIR=ase USE_OMP=TRUE -j 4
```

and run with 8 OpenMP threads.


## NERSC

CUDA 12.9 was used (via `cudatoolkit`)

Build as:

```
make USE_CUDA=TRUE NETWORK_DIR=ase USE_JACOBIAN_CACHING=TRUE
```

