## Step 11: Check trace sampling strategies

- Probabilistic: `OTEL_TRACES_SAMPLER=traceidratio`, `OTEL_TRACES_SAMPLER_ARG=0.01`
- Parent-based rate: `OTEL_TRACES_SAMPLER=parentbased_traceidratio`
- Error-focused: custom samplers to always keep error traces

Sampling choices decide which spans are retained.
