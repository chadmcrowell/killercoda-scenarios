
<br>

# 🎉 Lab Complete!

You explored the `/etc/kubernetes/pki` directory, learned how Kubernetes uses these files for secure API communication, and saw first-hand what happens if the API server’s TLS key is missing — and how to fix it.

**Key takeaways:**
- `/etc/kubernetes/pki` contains the **crown jewels** of a kubeadm control plane’s security.
- Certificates and keys here allow the API server, controller-manager, scheduler, and kubelet to trust and talk to each other.
- The API server is a static Pod; kubelet continuously tries to restart it if something goes wrong.
- `admin.conf` references the CA and client cert/key, letting `kubectl` authenticate.

Next time you troubleshoot API server issues, remember:  
**Check PKI before you panic.**