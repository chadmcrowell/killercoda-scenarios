## Step 15: Document partition detection

```bash
cat > /tmp/partition-detection.md << 'EOF'
# Network Partition Detection

## Symptoms
- Pods appear healthy but can't communicate
- Timeouts instead of connection refused
- DNS works but connections fail
- Some nodes/pods unreachable

## Detection Methods
1. Active probing: periodic health checks between nodes
2. Heartbeat monitoring: missing heartbeats indicate partition
3. Quorum loss: systems become read-only
4. Metrics gaps: missing metrics from partitioned nodes

## Mitigation Strategies
1. Quorum-based systems: prevent split-brain (etcd, Raft)
2. Fencing: isolate partitioned nodes (STONITH)
3. Conflict resolution: CRDTs, vector clocks, last-write-wins
4. Idempotency: safe to retry operations
5. Circuit breakers: fail fast on partition

## Kubernetes Resilience
- etcd uses Raft (quorum-based)
- Controllers retry on failure
- StatefulSets risk duplicate pods
- Services route only to reachable endpoints
EOF

cat /tmp/partition-detection.md
```{{exec}}

Create guidance for detecting and mitigating partitions.
