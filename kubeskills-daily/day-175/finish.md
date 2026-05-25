## Lab Complete 🎉

**Verification:** Confirm that the audit log file contains entries for secret read operations showing the full request and response metadata, that exec operations appear in the log with at least request-level detail, and that the events include the user identity, timestamp, and resource name for each recorded action.

### What You Learned

Audit policies define which requests are logged and at what level of detail ranging from None to RequestResponse
Without a policy file configured the API server logs nothing by default
Audit stages include RequestReceived, ResponseStarted, ResponseComplete, and Panic
Overly broad None rules at the top of a policy can silently suppress all logging below them
Audit logs should capture at minimum all secret access, all authentication failures, and all privileged operations

### Why It Matters

When a security incident occurs, audit logs are often the only source of truth for understanding what happened, who did it, and when. Discovering during an investigation that your audit policy was not capturing secret reads or pod exec operations means you may never be able to determine the scope of a breach or satisfy compliance requirements.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
