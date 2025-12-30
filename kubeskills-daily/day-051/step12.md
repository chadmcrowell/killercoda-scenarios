## Step 12: Simulate webhook overload

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingWebhookConfiguration
metadata:
  name: load-test-webhook
webhooks:
- name: load.test.com
  clientConfig:
    url: "https://nonexistent-webhook.example.com/validate"
  rules:
  - operations: ["CREATE"]
    apiGroups: [""]
    apiVersions: ["v1"]
    resources: ["pods"]
  failurePolicy: Ignore
  admissionReviewVersions: ["v1"]
  sideEffects: None
  timeoutSeconds: 1
EOF

for i in $(seq 1 10); do
  kubectl run webhook-test-$i --image=nginx 2>&1 &
done

kubectl get events --sort-by='.lastTimestamp' | grep webhook
```{{exec}}

Slow/unreachable webhooks delay requests; short timeouts and failurePolicy=Ignore reduce impact.
