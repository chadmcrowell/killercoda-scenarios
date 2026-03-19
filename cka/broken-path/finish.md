
<br>

### WELL DONE!

You successfully:

- Confirmed that pods were healthy by checking logs and curling `localhost:80` from inside the container
- Used `kubectl get endpoints` to rule out selector/label mismatches
- Identified the root cause: `targetPort: 8081` in the Service didn't match the port nginx actually listens on (`80`)
- Patched the Service to use the correct `targetPort` and verified connectivity from a test pod

On the CKA exam, Service connectivity failures often come down to a port mismatch rather than a broken app. Always verify the full path: pod health → selector → endpoints → targetPort.
