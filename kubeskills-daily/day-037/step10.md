## Step 10: Test projected volume

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: projected-volume
spec:
  securityContext:
    runAsUser: 1000
    fsGroup: 2000
  containers:
  - name: app
    image: busybox
    command: ['sh', '-c', 'ls -la /projected; cat /projected/*; sleep 3600']
    volumeMounts:
    - name: all-in-one
      mountPath: /projected
  volumes:
  - name: all-in-one
    projected:
      defaultMode: 0444
      sources:
      - secret:
          name: secret-test
      - configMap:
          name: readonly-cm
      - downwardAPI:
          items:
          - path: "labels"
            fieldRef:
              fieldPath: metadata.labels
EOF
```{{exec}}

**Check combined volume:**
```bash
kubectl logs projected-volume
kubectl exec projected-volume -- ls -la /projected
```{{exec}}
