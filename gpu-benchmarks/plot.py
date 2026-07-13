import numpy as np
import matplotlib.pyplot as plt
from pathlib import Path

# we'll create a dict keyed by the name of the run that stores the
# directory where the data is and average run time.

network = "ase"

chips = ["NVIDIA A100 GPU", "AMD MI250X GPU", "AMD EPYC 7763 CPU (8 OpenMP threads)"]
sizes = ["$32^3$", "$64^3$"]

runs = {r"NVIDIA A100 GPU $32^3$": [Path(f"{network}/perlmutter/gpu"), -1],
        r"NVIDIA A100 GPU $64^3$": [Path(f"{network}/perlmutter/gpu-64"), -1],
        r"AMD MI250X GPU $32^3$": [Path(f"{network}/frontier/gpu"), -1],
        r"AMD MI250X GPU $64^3$": [Path(f"{network}/frontier/gpu-64"), -1],
        r"AMD EPYC 7763 CPU (8 OpenMP threads) $32^3$": [Path(f"{network}/frontier/cpu"), -1],
        r"AMD EPYC 7763 CPU (8 OpenMP threads) $64^3$": [Path(f"{network}/frontier/cpu-64"), -1]}


# for each run, find all the *.out files, look for the "Run time = "
# line, and store the time

for r in runs:
    rsum = 0.0
    count = 0.0
    for output in runs[r][0].glob("*.out"):
        with open(output) as of:
            for line in of.readlines():
                if line.startswith("Run time ="):
                    rsum += float(line.split("=")[-1])
                    count += 1
    avg = rsum / count
    runs[r][-1] = avg

# now plot as a bar chart

fig, ax = plt.subplots()

# we'll group by problem size
data = {}

for chip in chips:
    vals = []
    for s in sizes:
        vals.append(runs[f"{chip} {s}"][-1])

    data[chip] = vals


res = ax.grouped_bar(data, tick_labels=sizes, group_spacing=1)

for container in res.bar_containers:
    ax.bar_label(container, padding=3)

ax.set_xlabel("box size")
ax.set_ylabel("wallclock time (s)")

ax.legend()

ax.grid(ls=":", axis="y")
ax.set_ylim(0, 140)

fig.tight_layout()
fig.savefig("gpu-performance.pdf", bbox_inches="tight")
