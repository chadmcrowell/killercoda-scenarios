## Step 15: Chaos engineering best practices

```bash
cat > /tmp/chaos-engineering-guide.md << 'OUTER'
# Chaos Engineering Best Practices

## Getting Started

### 1. Start Small
- Begin in dev/staging
- Single service, single failure mode
- Short duration experiments
- Manual execution first

### 2. Define Hypothesis
Before each experiment, state:
- What you're testing
- Expected behavior
- Success criteria
- Rollback triggers

### 3. Establish Steady State
Measure baseline metrics:
- Request latency (P50, P95, P99)
- Error rate
- Throughput
- Resource utilization

### 4. Minimize Blast Radius
- Use namespace isolation
- Target subset of pods
- Limit duration
- Have kill switch ready

## Common Experiments

- Pod Failures: Random pod termination, 10% of pods
- Network Issues: Latency injection, 500ms delay
- Resource Exhaustion: CPU stress at 90% utilization
- Dependency Failures: Service unavailable for 2 minutes

## Safety Measures

### Pre-flight Checks
- Hypothesis documented
- Steady state defined
- Blast radius limited
- Rollback plan ready
- Team notified
- Monitoring active

### During Experiment
- Watch dashboards
- Monitor alerts
- Track customer impact
- Ready to abort

### Post-experiment
- Validate steady state
- Document findings
- Create action items
- Share learnings

## Tools
- Chaos Mesh: Pod, network, stress, IO chaos
- Litmus: CRD-based experiments with workflows
- PowerfulSeal: Pod killing, node failures
- Gremlin: Commercial platform with safety controls

## Progression Path
1. Manual, scheduled experiments (monthly, dev/staging)
2. Automated, scheduled experiments (weekly, staging)
3. Continuous chaos (random, production off-peak)
4. Always-on chaos (constant low-level, production)

## Cultural Aspects
- Blameless: Failures are learning opportunities
- Collaborative: Include engineering and operations
- Transparent: Share results openly
- Proactive: Find issues before customers do
- Iterative: Start small, build confidence
OUTER

cat /tmp/chaos-engineering-guide.md
```{{exec}}

Complete chaos engineering guide covering getting started, common experiments, safety measures, tools, and cultural practices.
