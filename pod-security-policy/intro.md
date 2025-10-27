
<br>

### Welcome !

In this scenario, we'll learn how to apply Pod Security Standards (PSS) to Kubernetes pods.

Pod Security Standards define a set of security best practices for Pods in Kubernetes. They provide guidelines for running workloads safely by setting boundaries for what capabilities and configurations are permitted or disallowed. Kubernetes classifies these standards into three profiles 1.) `Privileged`, 2.) `Baseline`, and 3.) `Restricted` which progressively limit the permissions and capabilities of Pods to enhance security.

You configure Pod Security Standards through Pod Security Admission Controller, which has three enforcement modes:
1. `Enforce` Mode: Rejects Pods that violate the configured standard.
2. `Audit` Mode: Allows Pods but logs any violations for monitoring.
3. `Warn` Mode: Allows Pods but provides warnings to users about policy violations.

**ENJOY!**
