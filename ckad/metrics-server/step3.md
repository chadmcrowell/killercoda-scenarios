If you are running a lot of pods, and want to quickly determine which pods are consuming the most CPU, run the command `k top po --sort-by=cpu`{{exec}}

If you'd like to determine which pods are consuming the most memory, run the command `k top po --sort-by=memory`{{exec}}