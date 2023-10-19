Create a pod that will have two containers, one main container and another sidecar container that will collect the main containers logs

`k create -f pod-logging-sidecar.yaml`{{exec}}

Using kubectl, view the logs from the container named "sidecar"