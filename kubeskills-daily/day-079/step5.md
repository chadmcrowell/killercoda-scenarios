## Step 5: Test dependency confusion

```bash
# Simulated package.json with malicious dependency
cat > /tmp/package.json << 'EOF'
{
  "name": "myapp",
  "dependencies": {
    "express": "^4.18.0",
    "lodash": "^4.17.21",
    "company-internal-lib": "^1.0.0"
  }
}
EOF

cat /tmp/package.json

echo ""
echo "Dependency confusion attack:"
echo "1. Company uses internal package 'company-internal-lib'"
echo "2. Attacker publishes package with same name to npm"
echo "3. npm install prefers public registry (higher version)"
echo "4. Malicious package installed instead of internal"
echo "5. Runs arbitrary code during install"
```{{exec}}

Dependency confusion tricks package managers into installing a malicious public package instead of the intended private one.
