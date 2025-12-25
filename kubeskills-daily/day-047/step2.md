## Step 2: Write data to PVCs

```bash
for i in {0..2}; do
  kubectl exec web-$i -- sh -c "echo 'Data from pod $i' > /usr/share/nginx/html/index.html"
done

kubectl exec web-0 -- cat /usr/share/nginx/html/index.html
```{{exec}}

Each pod writes unique data to its PVC.
