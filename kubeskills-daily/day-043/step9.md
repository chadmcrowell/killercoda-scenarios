## Step 9: Trace context formats

- W3C Trace Context: `traceparent: 00-<trace-id>-<span-id>-<flags>`
- Jaeger format: `uber-trace-id: <trace-id>:<span-id>:<parent-span-id>:<flags>`
- B3 format: `X-B3-TraceId: <trace-id>`, `X-B3-SpanId: <span-id>`

Mismatched formats can break cross-service propagation.
