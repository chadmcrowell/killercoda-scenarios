## Step 3: Simulate typosquatting attack

```bash
# Common typos in image names
cat > /tmp/typosquatting-examples.txt << 'EOF'
Legitimate vs Typosquatted:

nginx        → nginix (typo)
redis        → reddis
postgres     → postgress
mysql        → mysq1 (number instead of letter)
python       → pythn
ubuntu       → ubunut
alpine       → alpline

Attack vectors:
- Developer makes typo
- Image exists on Docker Hub
- Malicious code executes
- Credentials stolen
EOF

cat /tmp/typosquatting-examples.txt

# Example typosquatted deployment
cat <<EOF > /tmp/typosquatted-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: typo-victim
spec:
  containers:
  - name: web
    image: nginix:latest  # Typo! Should be nginx
    # If this image exists, it could be malicious
EOF

cat /tmp/typosquatted-pod.yaml
```{{exec}}

Typosquatting exploits common typos in image names - attackers publish malicious images with similar names.
