
SSH into the worker node:
```bash
ssh node01
```{{exec}}

Once inside, check the kubelet status:
```bash
sudo systemctl status kubelet -n 20
```{{exec}}

👉 You’ll see that kubelet is inactive (dead).