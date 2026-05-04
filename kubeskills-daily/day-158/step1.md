## Step 1 — Investigate the Problem

Observe the current deployment rollout for the image-heavy application and measure how long each pod takes to move from Pending to Running. Examine the image pull policy set on the container and the events on the pod to see how much time is spent in the image pull phase versus actual container startup.
