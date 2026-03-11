
<br>

### WELL DONE!

You successfully:

- Created a custom `StorageClass` with a `Retain` reclaim policy
- Promoted it as the cluster's default StorageClass
- Deployed a PVC and Pod using dynamic provisioning
- Observed that the `Retain` policy preserves the PersistentVolume after PVC deletion

Understanding reclaim policies is critical for the CKA exam — `Delete` removes the PV automatically, while `Retain` keeps it for manual recovery.
