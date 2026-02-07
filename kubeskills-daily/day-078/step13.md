## Step 13: Test AppArmor/SELinux bypass

```bash
# Pod without AppArmor
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: no-apparmor-pod
  annotations:
    container.apparmor.security.beta.kubernetes.io/app: unconfined
spec:
  containers:
  - name: app
    image: ubuntu
    command: ['sleep', '3600']
EOF

echo "Without AppArmor/SELinux:"
echo "- No mandatory access control"
echo "- Can access files normally restricted"
echo "- Weaker security boundary"
```{{exec}}

Disabling AppArmor or SELinux removes mandatory access control, weakening the container security boundary.
