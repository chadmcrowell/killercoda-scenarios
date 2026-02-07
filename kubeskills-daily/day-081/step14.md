## Step 14: Chaos experiment framework

```bash
cat > /tmp/chaos-experiment-template.yaml << 'EOF'
# Chaos Experiment Template

name: "Pod Failure Test"
description: "Test resilience to random pod failures"

hypothesis: |
  When random pods are killed, the system should:
  - Automatically recover
  - Maintain service availability
  - Not cascade failures to other services

steady_state:
  - metric: deployment_ready_replicas
    comparison: equals
    value: 3
  - metric: service_response_time
    comparison: less_than
    value: 500ms
  - metric: error_rate
    comparison: less_than
    value: 0.01

experiment:
  - step: baseline
    action: measure_steady_state
    duration: 1m

  - step: inject_chaos
    action: random_pod_kill
    target:
      selector:
        app: chaos-target
    parameters:
      interval: 30s
    duration: 5m

  - step: recovery
    action: measure_steady_state
    duration: 2m

success_criteria:
  - steady_state_maintained: true
  - recovery_time: < 30s
  - error_spike: < 5%

rollback_on:
  - error_rate > 10%
  - service_unavailable > 30s

observations:
  - pods_killed: count
  - recovery_time: duration
  - error_count: count
  - user_impact: boolean
EOF

cat /tmp/chaos-experiment-template.yaml

echo ""
echo "Chaos experiment structure:"
echo "1. Define hypothesis"
echo "2. Establish steady state"
echo "3. Inject failure"
echo "4. Validate steady state maintained"
echo "5. Analyze results"
```{{exec}}

A structured chaos experiment template with hypothesis, steady state definition, injection steps, and success criteria.
