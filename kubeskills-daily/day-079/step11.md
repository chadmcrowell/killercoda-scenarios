## Step 11: Test build-time injection

```bash
# Simulated Dockerfile with build arg injection
cat > /tmp/build-injection-dockerfile << 'EOF'
FROM node:16

ARG NPM_TOKEN
# Token exposed in image layers!

RUN echo "//registry.npmjs.org/:_authToken=${NPM_TOKEN}" > ~/.npmrc
RUN npm install

# Token now in image history
EOF

cat /tmp/build-injection-dockerfile

echo ""
echo "Build secrets exposure:"
echo "docker history myimage | grep NPM_TOKEN"
echo "Anyone with image access can extract token"
echo ""
echo "Solution: Use BuildKit secrets"
echo "RUN --mount=type=secret,id=npm_token"
```{{exec}}

Build arguments are stored in image layers and visible via docker history - never pass secrets as build args.
