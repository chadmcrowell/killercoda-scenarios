## Step 13: Supply chain security tools

```bash
cat > /tmp/supply-chain-security.md << 'OUTER'
# Supply Chain Security Best Practices

## Image Scanning
- Trivy: trivy image nginx:1.21
- Grype: grype nginx:1.21 --fail-on high
- Clair: clairctl analyze nginx:1.21

## Image Signing
- Cosign (Sigstore): cosign sign/verify
- Notary (Docker Content Trust): DOCKER_CONTENT_TRUST=1

## SBOM Generation
- Syft: syft packages nginx:1.21 -o cyclonedx-json

## Admission Control
- OPA Gatekeeper: Restrict allowed registries, block latest tag
- Kyverno: Enforce image signatures on pod creation

## Dependency Scanning
- npm audit / npm audit fix
- Snyk: snyk test / snyk container test
- Dependabot: Automated dependency update PRs

## Registry Security
- Harbor: scanning, signing, RBAC, content trust
- Private registry with imagePullSecrets

## Build Security
- Multi-stage builds: Smaller images, fewer vulnerabilities
- Distroless images: No shell, no package manager
- BuildKit secrets: RUN --mount=type=secret

## Runtime Monitoring
- Falco: Detect package managers, suspicious connections
- Alert on unexpected outbound traffic

## Best Practices Summary
1. Use specific image tags or digests
2. Scan images for vulnerabilities
3. Sign and verify images
4. Use private registries with authentication
5. Implement admission control policies
6. Generate and track SBOMs
7. Scan dependencies regularly
8. Use multi-stage and distroless builds
9. Never include secrets in images
10. Monitor runtime behavior with Falco
OUTER

cat /tmp/supply-chain-security.md
```{{exec}}

Complete overview of supply chain security tools covering scanning, signing, SBOM, admission control, and runtime monitoring.
