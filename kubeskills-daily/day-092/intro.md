# Day 92 — Service Selector Mismatch Traffic Debugging

Three services are down. All pods are `Running` and `Ready`. No error events. No resource issues. But users can't reach any of the three applications — and the dashboards show everything is green.

This is one of the most dangerous failure modes in Kubernetes: the kind where every component *looks* healthy while traffic is being silently dropped.

In this scenario you will:

- Learn how Kubernetes Services route traffic through the Endpoints object
- Deploy three services each broken in a different way and prove traffic is not flowing
- Diagnose an empty-endpoints label mismatch, a populated-endpoints port mismatch, and a multi-label partial match failure
- Fix all three and verify real traffic reaches the pods after each fix

Click **Start** to begin.
