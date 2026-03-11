
<br>

### WELL DONE!

You successfully:

- Identified that a PVC was stuck in `Pending` due to an **access mode mismatch** with the available PV
- Deleted and recreated the PVC with the correct `ReadWriteOnce` access mode
- Confirmed the PVC reached `Bound` state and the Pod reached `Running`

On the CKA exam, PVC binding failures are a common troubleshooting topic. Always check that the PVC's **access modes**, **storage request**, and **StorageClass** are compatible with an available PV.
