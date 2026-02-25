The file `pod-data-processor.yaml`{{copy}} has been downloaded to your home directory. A pod named `data-processor`{{copy}} in the `production`{{copy}} namespace must be scheduled **only** on nodes that have the label `disk=ssd`{{copy}}.

Additionally, the pod should **prefer** to run on nodes in `zone=west`{{copy}}, but this is not a hard requirement.

Open `pod-data-processor.yaml` and update the pod spec to meet both scheduling requirements using node affinity.

> NOTE: The container should use the image `nginx:1.25`{{copy}} and the pod must remain in a `Running` state when you are done.
