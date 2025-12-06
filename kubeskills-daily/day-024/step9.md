## Step 9: Test NodePort service

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: web-nodeport
spec:
  type: NodePort
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 8080
    nodePort: 30080
EOF
```{{exec}}

```bash
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
echo "Node IP: $NODE_IP"
```{{exec}}

```bash
kubectl run external-test --rm -it --restart=Never --image=curlimages/curl -- curl -m 5 http://$NODE_IP:30080
```{{exec}}

NodePort exposes service via node IP and static port.
