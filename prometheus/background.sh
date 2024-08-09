helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo update

helm install prometheus prometheus-community/prometheus -f https://raw.githubusercontent.com/chadmcrowell/k8s/main/prometheus/values.yaml

# helm install node-exporter prometheus-community/prometheus-node-exporter
# helm install node-exporter prometheus-community/prometheus-node-exporter --set service.targetPort=9101 --set service.port=9101

# sleep 30

# kubectl patch svc prometheus-server -p '{"spec": {"type": "NodePort", "ports": [{"port": 80, "nodePort": 30000}]}}'


# cat <<EOF | kubectl apply -f -
# apiVersion: v1
# kind: Service
# metadata:
#   annotations:
#     meta.helm.sh/release-name: prometheus
#     meta.helm.sh/release-namespace: default
#   labels:
#     app.kubernetes.io/component: server
#     app.kubernetes.io/instance: prometheus
#     app.kubernetes.io/managed-by: Helm
#     app.kubernetes.io/name: prometheus
#     app.kubernetes.io/part-of: prometheus
#     app.kubernetes.io/version: v2.53.1
#     helm.sh/chart: prometheus-25.25.0
#   name: prometheus-server
#   namespace: default
# spec:
#   ipFamilies:
#   - IPv4
#   ipFamilyPolicy: SingleStack
#   ports:
#   - name: http
#     nodePort: 30000
#     port: 80
#     protocol: TCP
#     targetPort: 9090
#   selector:
#     app.kubernetes.io/component: server
#     app.kubernetes.io/instance: prometheus
#     app.kubernetes.io/name: prometheus
#   sessionAffinity: None
#   type: NodePort
# EOF