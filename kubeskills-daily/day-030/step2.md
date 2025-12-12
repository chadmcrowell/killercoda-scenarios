## Step 2: Create simple reconciliation script (Python)

```bash
cat > /tmp/operator.py << 'PY'
#!/usr/bin/env python3
import time
import json
from kubernetes import client, config, watch

# Try in-cluster first, fall back to local kubeconfig
try:
    config.load_incluster_config()
except Exception:
    config.load_kube_config()

v1 = client.CoreV1Api()
custom_api = client.CustomObjectsApi()

GROUP = "apps.example.com"
VERSION = "v1"
PLURAL = "webapps"

def reconcile_forever():
    w = watch.Watch()
    print("Starting operator watch loop...")
    for event in w.stream(custom_api.list_cluster_custom_object, GROUP, VERSION, PLURAL):
        obj = event['object']
        event_type = event['type']
        name = obj['metadata']['name']
        namespace = obj['metadata'].get('namespace', 'default')
        spec = obj.get('spec', {})
        print(f"Event: {event_type} - {namespace}/{name}")
        if event_type in ['ADDED', 'MODIFIED']:
            reconcile(namespace, name, spec, obj)

def reconcile(namespace, name, spec, obj):
    message = spec.get('message', 'default')
    cm_name = f"{name}-config"

    # BUG: Creating ConfigMap without checking if it exists
    # This causes infinite reconciliation!
    try:
        configmap = client.V1ConfigMap(
            metadata=client.V1ObjectMeta(
                name=cm_name,
                namespace=namespace,
                owner_references=[{
                    'apiVersion': f'{GROUP}/{VERSION}',
                    'kind': 'WebApp',
                    'name': name,
                    'uid': obj['metadata']['uid'],
                    'controller': True
                }]
            ),
            data={'message': message}
        )
        v1.create_namespaced_config_map(namespace, configmap)
        print(f"Created ConfigMap: {cm_name}")

        # Update status (causes another MODIFIED event!)
        status_body = {
            'status': {
                'configMapName': cm_name,
                'phase': 'Ready'
            }
        }
        custom_api.patch_namespaced_custom_object_status(
            GROUP, VERSION, namespace, PLURAL, name, status_body
        )
    except client.exceptions.ApiException as e:
        if e.status == 409:
            print(f"ConfigMap {cm_name} already exists")
        else:
            print(f"Error: {e}")

if __name__ == '__main__':
    reconcile_forever()
PY

chmod +x /tmp/operator.py
```{{exec}}

Buggy operator writes ConfigMaps and status every event, causing self-triggered loops.
